import subprocess,os,glob,shutil,pathlib

progdir = pathlib.Path(os.path.abspath(os.path.join(os.path.dirname(__file__),os.pardir)))

gamename = "rolling_thunder"

# directory where everything is built
datadir = progdir / "data"
datadir.mkdir(exist_ok=True,parents=True)

for s in ["convert_sounds.py","convert_graphics.py"]:
    subprocess.check_call(["cmd","/c",s],cwd=os.path.join(progdir,"assets","amiga"))

#gen_scroll_table.main()


# JOTD path for cranker, adapt to whatever your path is :)
os.environ["PATH"] += os.pathsep+r"K:\progs\cli"

cmd_prefix = ["make","-f",str(progdir / "makefile.am")]

subprocess.check_call(cmd_prefix+["clean"],cwd=progdir / "src")

subprocess.check_call(cmd_prefix+["RELEASE_BUILD=1"],cwd=progdir / "src")
# create archive

outdir = progdir / "dist" / "RollingThunder"

if os.path.exists(outdir):
    shutil.rmtree(outdir)

outdir.mkdir(exist_ok=True,parents=True)

for file in ["readme.md",f"RollingThunder_AGA.slave"]:
    shutil.copy(progdir / file,outdir)


shutil.copy(progdir / "assets" / "amiga" / "RollingThunder_AGA.info",outdir)



# cleanup of log files in data dir that whdload creates
for x in datadir.glob("*_used_*"):
    os.remove(x)



dataout = outdir / "data"

dataout.mkdir(exist_ok=True,parents=True)

pack_data = True  # set to false to create unpacked distros (much faster)

for sourcefile in datadir.glob("*"):
    if sourcefile.is_file():
        destfile = dataout / sourcefile.name
        pack_data = not sourcefile.name.endswith(".mod")
        # -= RNC ProPackED v1.8 [by Lab 313] (01/26/2021) =-
        with open(sourcefile,"rb") as f:
            header = f.read(3).decode(errors="ignore")
        if header=="RNC" or not pack_data:
            # already packed/do not pack
            print(f"Copying {destfile}...")
            shutil.copy(sourcefile,destfile)
        else:
            cmd = ["propack","p",str(sourcefile),str(destfile)]
            print(f"Packing {destfile}...")
            p = subprocess.run(cmd,check=False,stdout=subprocess.DEVNULL)
            if p.returncode:
                print(f"failed packing {destfile}")
                shutil.copy(sourcefile,destfile)



exename = "RollingThunder_aga"
#subprocess.run(["cranker_windows.exe","-f",str(datadir / exename),"-o",str(dataout / exename)],check=True,stdout=subprocess.DEVNULL)
# we can't really use cranker now, seems to crash at startup. Never mind!!
shutil.copy(datadir / exename,dataout / exename)
subprocess.run(cmd_prefix+["clean"],cwd=os.path.join(progdir,"src"))

arcname = progdir / f"RollingThunder_HD.lha"
arcname.unlink(missing_ok=True)
cmd = ["lha","-r","a",arcname,"*"]

subprocess.run(cmd,cwd=outdir.parent,check=True)