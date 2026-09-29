import re, zipfile, collections, sys

z=zipfile.ZipFile('/mnt/user-data/uploads/rthunder.zip')
ROM={'cpu1':z.read('rt3_1b.9c'),'cpu2':z.read('rt3_2b.12c')}
def rd16(cpu,a):
    if not (0x8000<=a<=0xFFFE): return None
    b=ROM[cpu]; o=a-0x8000; return (b[o]<<8)|b[o+1]

INSN=re.compile(r'^([0-9A-F]{4}): ((?:[0-9A-F]{2} )+)\s*(\S+)\s*(.*?)(?:\s*[;|].*)?$')
IMM =re.compile(r'^#\$([0-9A-Fa-f]{4})$')
IMMLBL=re.compile(r'^#([A-Za-z_][A-Za-z0-9_]*_([0-9a-fA-F]{4}))$')
def imm_val(op):
    op=op.strip()
    m=IMM.match(op)
    if m: return int(m.group(1),16)
    m=IMMLBL.match(op)
    if m: return int(m.group(2),16)
    return None
DISP=re.compile(r'^\[([ABD]),([UXYS])\]$')
BR={'BRA','BRN','BHI','BLS','BCC','BHS','BCS','BLO','BNE','BEQ','BVC','BVS','BPL','BMI','BGE','BLT','BGT','BLE'}
BR|={'L'+x for x in BR}
BREAK={'RTS','RTI','JMP','BRA','LBRA'}

def tgt(op):
    if not op: return None
    m=re.fullmatch(r'\$([0-9A-Fa-f]{4})',op.strip())
    if m: return int(m.group(1),16)
    m=re.fullmatch(r'[A-Za-z_][A-Za-z0-9_]*_([0-9a-fA-F]{4})',op.strip())
    if m: return int(m.group(1),16)
    return None

def parse(fn):
    lines=open(fn).read().split('\n'); insn={}; order=[]
    tl={}
    for i,l in enumerate(lines):
        m=re.match(r'^(jump_table_([0-9a-fA-F]{4}))\s*:',l)
        if m: tl[int(m.group(2),16)]=m.group(1)
        m=INSN.match(l)
        if m:
            a=int(m.group(1),16)
            insn[a]=dict(addr=a,mnem=m.group(3).upper(),oper=m.group(4).strip(),raw=l)
            order.append(a)
    order.sort()
    return lines,insn,order,tl

def analyse(cpu,fn):
    lines,insn,order,tl=parse(fn)
    codeaddr=set(order)
    nxt={order[i]:order[i+1] for i in range(len(order)-1)}
    preds=collections.defaultdict(set)
    for a in order:
        d=insn[a]; mn=d['mnem']
        if mn not in BREAK and a in nxt: preds[nxt[a]].add(a)
        t=tgt(d['oper'])
        if t is not None and (mn in BR or mn in ('JMP','JSR','BSR','LBSR')):
            if t in codeaddr: preds[t].add(a)

    def writes(d,reg):
        mn=d['mnem']
        if mn=='LD'+reg or mn=='LEA'+reg: return True
        if mn=='PUL' and reg in d['oper']: return True
        if mn=='TFR' and d['oper'].endswith(','+reg): return True
        if mn=='EXG' and reg in d['oper']: return True
        return False

    def reaching(site,reg,cap=400):
        seen=set(); out=set(); unknown=False
        stack=list(preds[site]); depth=0
        while stack and len(seen)<cap:
            a=stack.pop()
            if a in seen: continue
            seen.add(a)
            d=insn[a]
            if d['mnem']=='LD'+reg:
                v=imm_val(d['oper'])
                if v is not None: out.add(v); continue
                out.add(None); continue          # non-immediate load
            if writes(d,reg): out.add(None); continue
            stack.extend(preds[a])
        if len(seen)>=cap: unknown=True
        return out,unknown

    def score(t):
        s=w=0
        for k in range(24):
            v=rd16(cpu,t+2*k)
            if v is None: break
            if v in codeaddr: s+=1; w+=1
            elif 0x8000<=v<=0xFFFF: w+=1
            else: break
        return s,w

    findings=[]
    for a in order:
        d=insn[a]
        if d['mnem'] not in ('JMP','JSR'): continue
        m=DISP.match(d['oper'])
        if not m: continue
        idx,reg=m.group(1),m.group(2)
        tabs,trunc=reaching(a,reg)
        known=[t for t in tabs if t is not None]
        unl=[t for t in known if t not in tl]
        nb=re.search(r'nb_entries=(\d+)',d['raw'])
        findings.append(dict(site=a,reg=reg,idx=idx,tabs=sorted(known),
                             unlabelled=sorted(unl),none=(None in tabs),
                             trunc=trunc,nb=int(nb.group(1)) if nb else None,
                             scores={t:score(t) for t in known}))
    return findings,tl,insn

for cpu,fn in (('cpu1','cpu1.asm'),('cpu2','cpu2.asm')):
    F,tl,insn=analyse(cpu,fn)
    multi=[f for f in F if len(f['tabs'])>1]
    bad  =[f for f in F if f['unlabelled']]
    nodef=[f for f in F if not f['tabs']]
    print(f'================ {cpu}: {len(F)} indirect dispatch sites ================')
    print(f'  sites with >1 reaching table : {len(multi)}')
    print(f'  sites with an UNLABELLED table: {len(bad)}   <-- these break the post-processor')
    print(f'  sites with no immediate table found: {len(nodef)}')
    if bad:
        print('  --- UNLABELLED ---')
        for f in bad:
            print(f"    dispatch ${f['site']:04X} [{f['idx']},{f['reg']}] nb_entries={f['nb']}")
            for t in f['tabs']:
                s,w=f['scores'][t]
                tag='LABELLED' if t in tl else '*** MISSING LABEL ***'
                print(f"        ${t:04X}  strong={s:2d} weak={w:2d}  {tag}")
    if nodef:
        print('  --- no statically-resolvable table (base reg loaded indirectly) ---')
        for f in nodef:
            print(f"    ${f['site']:04X} [{f['idx']},{f['reg']}] nb_entries={f['nb']}  {insn[f['site']]['raw'].strip()}")
    if multi:
        print('  --- sites fed by more than one table (all labelled unless flagged above) ---')
        for f in multi:
            ts=' '.join(('${:04X}{}'.format(t,'' if t in tl else '!')) for t in f['tabs'])
            print(f"    ${f['site']:04X} <- {ts}" + ("  (+non-immediate)" if f['none'] else ""))
