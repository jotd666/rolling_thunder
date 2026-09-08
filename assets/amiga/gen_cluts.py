from shared import *

tilegen = dump_dir / "tilegen"

def doit(nb_colors):
    cluts_file = sheets_path / "cluts.txt"

    cluts = []
    current = []

    with open(cluts_file) as f:
        for line in f:
            if '#' in line:
                continue
            toks = line.split(",")
            if len(toks)==4:
                toks = tuple([int(x) for x in toks[0:3]])
                current.append(toks)
                if len(current)==nb_colors:
                    cluts.append(current)
                    current=[]
    return cluts

if __name__ == "__main__":
    cluts = doit(8)