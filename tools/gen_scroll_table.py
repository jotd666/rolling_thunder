import bitplanelib
import os,pathlib


this_dir = pathlib.Path(os.path.abspath(__file__)).parent
src_dir = this_dir / os.pardir / "src" / "amiga"

# http://amiga-dev.wikidot.com/hardware:bplcon1


# table with fine shift + byte offset
def doit(width,dual_playfield):
    static_x_shift = width // 2  # shift other bitplane by half to get clipping effect on sprites
    asm_output = src_dir / f"scroll_table_{width}.68k"
    wmask = width-1
    scroll_table = [0]*512


    if dual_playfield:
        static_lsb = (static_x_shift-1) >> 4
        static_msb = (static_x_shift-1) & 0xF


        # bob playfield
        other_plane_mask_1 = static_lsb << 2
        other_plane_mask_2 = static_msb


    items = []
    for x in range(0,512):
        shift = (wmask-(x & wmask))
        offset = (x // width)*(width//8)
        # pre-encode shift for bplcon

        shiftval_msb = ((shift&(wmask & 0x30))>>2)      # 2 high bits H7 H6
        shiftval_lsb = (shift&0xF)                      # 4 low bits H5->H2
        if not dual_playfield:
            other_plane_mask_1 = shiftval_msb
            other_plane_mask_2 = shiftval_lsb

        items.append((shiftval_msb<<4)|other_plane_mask_1)
        items.append((shiftval_lsb<<4)|other_plane_mask_2)

        items.append(0)
        items.append(offset)

    if asm_output:
        with open(asm_output,"w") as f:
            bitplanelib.dump_asm_bytes(bytes(items),f,True)
    return items

if __name__ == "__main__":
    #doit(width = 64, dual_playfield = True)   # FMODE=3
    #doit(width = 16, dual_playfield = False)   # FMODE=0
    doit(width = 32, dual_playfield = False)   # FMODE=1/2
