import os,pathlib,shutil,json

from shared import *


def add(contents,code,clut,nb_cluts):
    contents[code*nb_cluts+clut] = 1
def rem(contents,code,clut,nb_cluts):
    contents[code*nb_cluts+clut] = 0

def merge(used_name,nb_items,nb_cluts,overwrite=False):
    merged_path_file = used_graphics_dir


    # merge sprites with existing file + moves from level 1
    used_dump = data_dir / os.path.basename(used_name)
    if used_dump.exists():
        with open(used_dump,"rb") as f:
            new_contents = f.read()
    else:
        new_contents = bytearray(nb_cluts*nb_items)

    old_used = merged_path_file / used_name
    if old_used.exists() and not overwrite:
        with open(old_used,"rb") as f:
            old_contents = bytearray(f.read())
    else:
        old_contents = bytearray(nb_cluts*nb_items)

    contents = bytearray([a|b for a,b in zip(new_contents,old_contents)])



    if old_contents == contents:
        print(f"Nothing new for {used_name}")
    else:
        for i,(a,b) in enumerate(zip(old_contents,contents)):
            if a!=b:
                code,clut = divmod(i,nb_cluts)
                print(f"{used_name}: New: code={code:02x}, clut={clut:02x}")


    with open(merged_path_file / used_name,"wb") as f:
        f.write(contents)

merge("hud_used_tiles",FG_NB_TILES,FG_NB_CLUTS,overwrite=False)
merge("bg0_used_tiles",BG_NB_TILES,BG_NB_CLUTS,overwrite=False)
merge("bg1_used_tiles",BG_NB_TILES,BG_NB_CLUTS,overwrite=False)
####merge("bg2_used_tiles",BG_NB_TILES,BG_NB_CLUTS,overwrite=True)
merge("used_sprites",SPRITE_NB_TILES,SPRITE_NB_CLUTS,overwrite=True)

##  @00da cell= 793 (code=0x019 bank=6) clut=0x046 16x16 src=(16, 0) pos=( 175, 172) pri=4 flip=00
##  @00ca cell= 281 (code=0x019 bank=2) clut=0x002 16x16 src=( 0, 0) pos=( 346, 168) pri=4 flip=10
##  @00ba cell= 270 (code=0x00e bank=2) clut=0x002 32x16 src=( 0,16) pos=( 346, 210) pri=4 flip=10
##  @00aa cell= 274 (code=0x012 bank=2) clut=0x002 16x32 src=( 0, 0) pos=( 350, 178) pri=4 flip=10
##  @009a cell= 410 (code=0x01a bank=3) clut=0x002 16x16 src=( 0, 0) pos=( 253, 209) pri=4 flip=10
##  @008a cell= 396 (code=0x00c bank=3) clut=0x002 32x16 src=( 0, 0) pos=( 205, 209) pri=4 flip=10
##  @007a cell= 404 (code=0x014 bank=3) clut=0x002 16x16 src=(16, 0) pos=( 237, 209) pri=4 flip=10
##  @006a cell= 404 (code=0x014 bank=3) clut=0x002 16x16 src=( 0, 0) pos=( 269, 209) pri=4 flip=10
##  @002a cell= 777 (code=0x009 bank=6) clut=0x041 32x32 src=( 0, 0) pos=( 315,   7) pri=4 flip=00
##  @001a cell= 776 (code=0x008 bank=6) clut=0x041 32x32 src=( 0, 0) pos=( 283,   7) pri=4 flip=00
##  @000a cell= 777 (code=0x009 bank=6) clut=0x041 32x32 src=( 0, 0) pos=(  59,   7) pri=4 flip=00
##  @-006 cell= 784 (code=0x010 bank=6) clut=0x043 16x16 src=(16,16) pos=( 187, 172) pri=0 flip=00

