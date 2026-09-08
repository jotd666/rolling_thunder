# we're trying to work cleanly this time: instead of generating pics and storing them, we generate them
# and return the list, it takes 1 or 2 seconds

import glob,shutil,os,re,pathlib
from PIL import Image
from shared import *
import bitplanelib
import gen_cluts






# theoritically: could generate 64 tilemaps (like in RallyX) but only 25 maps are non black (0->0x19)


def doit(nb_colors,offset,nb_cluts,kind,ref_clut_index,dump_it=False):
    cluts = gen_cluts.doit(nb_colors)
    tilegen = dump_dir / "tilegen" / kind
    pal4_file = sheets_path / f"{kind}_color_{ref_clut_index:02x}.png"  # reference sheet with all colors represented

    cluts = cluts[offset:]

    rval = []
    if dump_it:
        tilegen.mkdir(exist_ok=True,parents=True)

    source = Image.open(pal4_file)

    # this reference clut has all 4 colors different. We can use that to generate
    # the other cluts (mame gfx save only saves up to 32 cluts, we need 64)
    ref_clut = cluts[ref_clut_index]
    for i in range(0,nb_cluts):
        this_clut = cluts[i]
        dest = Image.new("RGB",source.size)
        if len(set(this_clut))>1:  # avoid all black
            rep_dict = {k:v for k,v in zip(ref_clut,this_clut)}
            rep_dict[magenta] = magenta

            dest_file = tilegen / f"pal_{i:02x}.png"
            if i==ref_clut_index:
                dest.paste(source)
            else:
                src = source.load()
                dst = dest.load()

                width, height = source.size

                for y in range(height):
                    for x in range(width):
                        pix = src[x, y]
                        newpix = rep_dict.get(pix)
                        if not newpix:
                            print(f"{pal4_file}:{i} color {pix} not found at {x},{y}")
                            newpix = pix
                        dst[x, y] = newpix
            if dump_it:
                dest.save(dest_file)

        rval.append(dest)
    return rval

def doit_tiles_8x8(dump_it=False):
    return doit(8,0,64,"hud",ref_clut_index=0x0,dump_it=dump_it)
def doit_tiles_16x16(dump_it=False):
    return doit(8,512//8,128,"tiles_16x16",ref_clut_index=0,dump_it=dump_it)
def doit_sprites_16x16(dump_it=False):
    return doit(16,256//16,16,"sprites_16x16",ref_clut_index=0,dump_it=dump_it)

if __name__ == "__main__":
    doit_tiles_8x8(True)
    #doit_tiles_16x16(False)
    #doit_sprites_16x16(True)
