import re,pathlib



# post-conversion automatic patches, allowing not to change the asm file by hand


def subt(m):
    tn = m.group(1)
    rn = m.group(2)
    offset = tn.split("_")[-1]
    rval = f"""
\t.ifndef\tRELEASE
\tmove.w\t#0x{offset},d{rn}
\t.endif
\tlea\t{tn},a{rn}"""
    return rval

equates = []

this_dir = pathlib.Path(__file__).absolute().parent

source_dir = this_dir / "../src"

class SourceChanger:
    def __init__(self):
        self.single_line_to_cc_protect = set()
        self.remove_error_in_next_line = set()
        self.remove_error_in_prev_line =set()
        self.line_to_push_cc_protect = set() | self.single_line_to_cc_protect
        self.line_to_pull_cc_protect = set() | self.single_line_to_cc_protect
        self.line_to_pull_cc_prev_protect = set()

sc_cpu1 = SourceChanger()
sc_cpu1.remove_error_in_next_line = {0x9730,0x9756}


def game_specific_cpu1(address,lines,i):
    line = lines[i]
    if address in [0x9728,0x974e]:
        lines[i+1]=""
    elif address in [0x972b,0x9751]:
        line = change_instruction("add.b\t#0x20,(a0)",lines,i)
    elif address in [0x972D,0x9753]:
        line = remove_instruction(lines,i)
    elif address == 0xC663:
        # replace stack pull by direct read of B/D1
        line = change_instruction("move.w\t(4,a7),d4",lines,i)
    elif address in [0x8592,0x85a1]:
        line = change_instruction("rts",lines,i)  # rti => rts
    elif address == 0x821d:
        line = change_instruction("rts",lines,i)  # TEMP disable scrolling routine

    return line

sc_cpu2 = SourceChanger()

def game_specific_cpu2(address,lines,i):
    line = lines[i]
    if address in [0x8194,0x81ac]:
        line = change_instruction("rts",lines,i)  # rti => rts
    return line

dreg_dict = {'a':'d0','b':'d1'}
areg_dict = {'x':'a2','y':'a3','u':'a4'}

jtre = re.compile("#jump_table_(\w+)")

def process_jump_table(line):
    m = jtre.search(line)
    if m:
        # move.w  #jump_table...,dX => lea jump_table...,aX works as X ranges from 2 to 4
        # in debug mode, leave register address
        line2 = line.replace("jump_table_","0x")

        line = f"""\t.ifndef\tRELEASE
{line2}\t.endif
""" + line.replace("move.w\t#","lea\t").replace(",d",",a")

    if "indirect_j" in line:
        # grab original code in comments, dirty but works as long as converter
        # presents it like this
        comment = line.split('|')[1]
        nb_entries = ""
        m = re.search("\[nb_entries=(\d+)",comment)
        if m:
            nb_entries = m.group(1)

        orig_inst = line.split(":")[1].split("]")[0].replace('[','')
        # parse code: Jxx [R1,R2], R1 = A or B, R2 = X,Y,U
        toks = orig_inst.split()

        dreg,areg = toks[1].split(",")

        areg = areg_dict[areg]
        line = remove_error(line)
        macro = f"{toks[0].upper()}_{dreg.upper()}_INDEXED"
        line = f"""\t{macro}\t{areg},{nb_entries}  |{comment}
"""
    return line


def remove_continuing_lines(lines,i):
    for j in range(i+1,i+4):
        if "[...]" in lines[j]:
            lines[j] = ""
        else:
            break


def get_line_address(line):
    try:
        toks = line.split("|")
        address = toks[1].strip(" [$").split(":")[0]
        return int(address,16)
    except (ValueError,IndexError):
        return None

def remove_continuing_lines(lines,i):
    for j in range(i+1,i+4):
        if "[...]" in lines[j]:
            lines[j] = ""
        else:
            break


def change_instruction(code,lines,i,continuing_lines=True):
    line = lines[i]
    toks = line.split("|")
    if len(toks)==2:
        toks[0] = f"\t{code}"
        if continuing_lines:
            remove_continuing_lines(lines,i)
        return " | ".join(toks)
    return line

def remove_error(line,ignore=False):
    if "ERROR" in line:
        return ""
    elif not ignore:
        raise Exception(f"No ERROR to remove in {line}")
    else:
        return line
def remove_instruction(lines,i,continuing_lines=True):
    return change_instruction("",lines,i,continuing_lines=continuing_lines)

def remove_continuing_lines(lines,i):
    for j in range(i+1,i+4):
        if "[...]" in lines[j]:
            lines[j] = ""
        else:
            break


def check_stack_usage(lines,i):
    line = lines[i]
    if any(x in line for x in ("[alloc_locals]","[free_locals]","[local]","[pushed_parameter]")):
        for j in range(1,4):
            if "ERROR" in lines[i-j] and " S " in lines[i-j]:
               lines[i-j]=remove_error(lines[i-j],True)


    if "[manual_stack_push]" in line:
        # native/target word D, or byte A,B stack mix goes crashy crashy
        arg = line.split()[1].lower()
        param = arg.split(",")[0]
        if param == "d0/d1":
            line = "\tsubq.w\t#2,d5\n"+change_instruction("GET_REG_ADDRESS\t0,d5",lines,i) + "\tMAKE_D\n\tMOVE_W_FROM_REG\td1,a0\n"
        else:
            # native/target byte A/B stack mix goes crashy crashy
            line = "\tsubq.w\t#1,d5\n" + change_instruction("GET_REG_ADDRESS\t0,d5",lines,i) + f"\tmove.b\t{param},(a0)\n"

    elif "[manual_stack_pull]" in line:
        # native/target word D, or byte A,B stack mix goes crashy crashy
        arg = line.split()[1].lower()
        param = arg.split(",")[1]
        line = change_instruction("GET_REG_ADDRESS\t0,d5",lines,i)
        if param == "d0/d1":
             line += "\taddq.w\t#2,d5\n\tMOVE_W_TO_REG\ta0,d1\n"
        else:
            # native/target byte A/B stack mix goes crashy crashy
            line += f"\taddq.w\t#1,d5\n\tmove.b\t(a0),{param}\n"
        if ",pc" in lines[i].lower():  # puls ...,pc
            line += "\trts\n"

    return line

def handle_special_addresses(input_dict,lines,i):
    line = lines[i]
    if "GET_ADDRESS" in line:
        val = line.split()[1]
        is_stb = ": stb" in line

        osd_call = input_dict.get(val)
        if osd_call is not None:
            if osd_call:
                line = change_instruction(f"jbsr\tosd_{osd_call}",lines,i)
                if is_stb:
                    line = f"\texg\td0,d1\n{line}\texg\td0,d1\n"
            else:
                line = remove_instruction(lines,i)
            lines[i+1] = remove_instruction(lines,i+1)

    if "[unchecked_address" in line:
        # give me the original instruction
        line = line.replace("_ADDRESS","_UNCHECKED_ADDRESS")
    elif "[select_address" in line:
        # slower but rarely fails
        line = line.replace("_ADDRESS","_SELECT_ADDRESS")
    elif "[video_address" in line:
        # give me the original instruction
        line = line.replace("_ADDRESS","_UNCHECKED_ADDRESS")
        # if it's a write, insert a "VIDEO_DIRTY" macro after the write
        for j in range(i+1,len(lines)):
            next_line = lines[j]
            if "[...]" not in next_line:
                break
            if ",(a0)" in next_line or "clr" in next_line or "MOVE_W_FROM_REG" in next_line:
                if any(x in next_line for x in ["address_word","MOVE_W_FROM_REG"]):
                    lines[j] = next_line+"\tVIDEO_WORD_DIRTY | [...]\n"
                else:
                    lines[j] = next_line+"\tVIDEO_BYTE_DIRTY | [...]\n"
                break
    return line


def doit(cpu):
    global_symbols = []
    # game_specific: replace or remove I/O addresses
    input_dict = {
    "watchdog_8000":"",
    "unknown_6E00":"",
    "unknown_6200":"",
    "unknown_6600":"",
    "unknown_6C00":"",
    "irq_ack_8400":"",
    "back_color_a000":"set_back_color",
    "bankswitch_6800":"set_cpu1_bank",
    } if cpu==1 else  {
    "watchdog_8000":"",
    "bankswitch2_d803":"set_cpu2_bank",
    }
    sc = sc_cpu1 if cpu==1 else sc_cpu2


    game_specific = game_specific_cpu1 if cpu==1 else game_specific_cpu2
    # various dirty but at least automatic patches applying on the converted code
    with open(source_dir / f"conv_cpu{cpu}.s") as f:
        lines = list(f)

    for i,line in enumerate(lines):
        address = get_line_address(line)

        line = handle_special_addresses(input_dict,lines,i)
        lines[i] = line
        line = check_stack_usage(lines,i)
        ###############################################
        # game_specific
        line = process_jump_table(line)
        lines[i] = line

        line = game_specific(address,lines,i)

    ##    if "addx mix" in line:
    ##        # errors have been fixed
    ##        line = ""


    ##    if any(x in line for x in ( "check explicit S usage",)):
    ##        line = remove_error(line,ignore_missing=True)

        if address in sc.remove_error_in_prev_line:
            lines[i-1] = remove_error(lines[i-1].strip()+f" ({address:04x})")
        if address in sc.remove_error_in_next_line:
            lines[i+1] = remove_error(lines[i+1].strip()+f" ({address:04x})")
        if address in sc.line_to_push_cc_protect:
            # protect the sub instructions
            line = "\tPUSH_SR\n"+line
        if address in sc.line_to_pull_cc_protect:
            # protect the sub instructions if any
            for j in range(i+1,len(lines)):
                if not "[...]" in lines[j]:
                    break

            lines[j-1] += "\tPOP_SR\n"
            if j-1==i:
                line = lines[i]

        if "[global]" in line:
            label = line.split(":")[0]
            global_symbols.append(label)
            line = f"{label}:\n"

        m = re.match("(\w+)\s*=\s*(\w+)",line)
        if m:
            equates.append(line)

        lines[i] = line

    with open(source_dir / f"cpu{cpu}_8000.68k","w") as fw:
        # game_specific: fill global symbols
        fw.write(f"""\t.include "cpu{cpu}_data.inc"
    """)
        for g in global_symbols:
            fw.write(f"\t.global\t{g}\n")

        fw.write("\n")


        fw.writelines(lines)


    with open(source_dir / f"cpu{cpu}_data.inc","w") as fw:
        fw.writelines(equates)

doit(cpu=1)
doit(cpu=2)