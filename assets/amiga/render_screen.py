"""
Rolling Thunder / Namco System 86 screen mockup.

Takes a raw memory dump laid out like the main CPU sees it:

    0x0000-0x1FFF   videoram1   layer 0 @ 0x0000, layer 1 @ 0x1000   (gfx set 0)
    0x2000-0x3FFF   videoram2   layer 2 @ 0x2000, layer 3 @ 0x3000   (gfx set 1)
    0x4000-0x5FFF   spriteram   sprite list @ 0x5800 (= spriteram + 0x1800)

and renders a 288x224 screen using the PIL sheets produced by generate_tiles.

Everything that is NOT in RAM on the real board (scroll registers, tile bank
latch, back colour, per-layer priority) is a parameter here, because those live
in write-only latches and never appear in a RAM dump.

Tile/colour decoding follows namcos86_v.cpp exactly:

    attr      = vram[2*i + 1]
    clut      = attr                      (full 8 bits -> 256 tile cluts of 8 colours)
    layers 0/1: tile = vram[2*i] + page(prom, layer, attr&3)*0x100 + tilebank*0x800
    layers 2/3: tile = vram[2*i] + page(prom, layer, attr&3)*0x100

The "extra" tile index bits do not come straight from the attribute byte: the
two low bits of attr address a 32-byte PROM whose output nibble gives a 3-bit
page number. That is what makes the encoding look self-contradictory.
"""

import argparse
import numpy as np
from PIL import Image

import gen_cluts
import generate_tiles
import gen_sprites_from_rom as gen_sprites

try:
    from shared import magenta
except ImportError:  # keep the module usable standalone
    magenta = (255, 0, 255)


# --------------------------------------------------------------------------
# hardware constants
# --------------------------------------------------------------------------

SCREEN_W, SCREEN_H = 288, 224          # 36*8 x 28*8
TILEMAP_W, TILEMAP_H = 64, 32          # in tiles -> 512x256 pixels

VRAM_BASE = (0x0000, 0x1000, 0x2000, 0x3000)
SPRITERAM = 0x4000
SPRITE_LIST = SPRITERAM + 0x1800       # m_spriteram in MAME

# set_scrolldx / set_scrolldy from video_start()
LAYER_DX = (47, 49, 46, 48)
LAYER_DY = (-9, -9, -9, -9)

SPRITE_CELL = 32                       # gfx(2) elements are 32x32
SPRITE_SIZES = (16, 8, 32, 4)

# transparent pens: set_transparent_pen(7) for tilemaps, 0xf in prio_transpen
TILE_TRANSPARENT_PEN = 7
SPRITE_TRANSPARENT_PEN = 15

# magenta spellings to try as a transparency key before falling back to the
# transparent pen's real palette colour
MAGENTA_KEYS = ((254, 0, 254), (255, 0, 255))
try:
    from shared import magenta as _shared_magenta
    MAGENTA_KEYS = (tuple(_shared_magenta)[:3],) + tuple(
        k for k in MAGENTA_KEYS if tuple(k) != tuple(_shared_magenta)[:3])
except Exception:
    pass

# offset of the tile address PROM inside the "proms" region:
# 512 (RG) + 512 (B) + 2048 (tile clut) + 2048 (sprite clut)
TILE_ADDRESS_PROM_OFFSET = 5120


# --------------------------------------------------------------------------
# tile address PROM
# --------------------------------------------------------------------------

class TileAddressProm:
    """Maps (layer, attr & 3) to a 0x100-tile page number."""

    def __init__(self, data=None):
        if data is None:
            self.data = None
        else:
            data = bytes(data)
            if len(data) > 32:
                data = data[TILE_ADDRESS_PROM_OFFSET:TILE_ADDRESS_PROM_OFFSET + 32]
            if len(data) < 32:
                raise ValueError("tile address PROM must be at least 32 bytes")
            self.data = data

    def page(self, layer, attr):
        if self.data is None:
            # no PROM: assume the identity mapping (wrong, but lets you render
            # something and see which tiles are off)
            return attr & 3
        if layer & 2:
            return (self.data[((layer & 1) << 4) + (attr & 3)] & 0xE0) >> 5
        return (self.data[((layer & 1) << 4) + ((attr & 3) << 2)] & 0x0E) >> 1

    def tile_offset(self, layer, attr, tilebank):
        off = self.page(layer, attr) * 0x100
        if not (layer & 2):
            off += tilebank * 0x800
        return off


# --------------------------------------------------------------------------
# sheets
# --------------------------------------------------------------------------

def _candidates(t):
    """Normalise a transparency spec into a list of RGB tuples."""
    if not t:
        return []
    if isinstance(t[0], (list, tuple)):
        return [tuple(c)[:3] for c in t]
    return [tuple(t)[:3]]


class CellSheets:
    """
    Wraps the list of PIL images returned by generate_tiles (one image per
    clut) and hands out single cells as RGBA, with magenta turned into alpha.

    Conversion to RGBA is lazy and cached, so only the cluts actually used by
    the dump get touched.

    first_index : tile number of the first cell present in the sheet (use 1024
                  for the cropped HUD sheet, which discards the upper half)
    clut_map    : attr -> index into `images`, or None if that clut is absent
    """

    def __init__(self, images, cell_w, cell_h, first_index=0,
                 clut_map=None, transparent=None, name="sheets",
                 cols=None, count=None):
        if not images:
            raise ValueError(f"{name}: empty image list")
        self.images = images
        self.cw = cell_w
        self.ch = cell_h
        self.first_index = first_index
        self.clut_map = clut_map or (lambda c: c)
        # transparent may be an RGB tuple, a list of candidate RGB tuples, or
        # a callable clut_index -> either. A list is tried in order and the
        # first colour actually present in the sheet wins: sheets dumped from
        # MAME mark the transparent pen with magenta, but a sheet built some
        # other way may carry the pen's real palette colour instead, and that
        # colour differs per clut.
        if transparent is None:
            self.transparent = lambda i: ()
        elif callable(transparent):
            self.transparent = transparent
        else:
            self.transparent = lambda i, t=transparent: t
        self.name = name

        w, h = images[0].size
        self.cols = cols or (w // cell_w)
        self.rows = h // cell_h
        self.count = count or (self.cols * self.rows)

        self._sheet_cache = {}
        self._cell_cache = {}
        self._missing = set()
        self._key_used = None

    def _sheet(self, clut_idx):
        img = self._sheet_cache.get(clut_idx)
        if img is None:
            src = self.images[clut_idx]
            if src.mode == "RGBA":
                # decoded straight from ROM: the alpha is already exact
                img = src
            else:
                arr = np.array(src.convert("RGB"), dtype=np.uint8)
                alpha = np.full(arr.shape[:2], 255, dtype=np.uint8)
                for key in _candidates(self.transparent(clut_idx)):
                    hit = np.all(arr == np.array(key, dtype=np.uint8), axis=-1)
                    if hit.any():
                        alpha = np.where(hit, 0, 255).astype(np.uint8)
                        if self._key_used is None:
                            self._key_used = key
                            print(f"{self.name}: transparency keyed on {key}")
                        break
                else:
                    if self._key_used is None:
                        self._key_used = ()
                        print(f"{self.name}: WARNING no transparent colour "
                              f"found, tiles will be opaque")
                img = Image.fromarray(np.dstack([arr, alpha]), "RGBA")
            self._sheet_cache[clut_idx] = img
        return img

    def cell(self, index, clut):
        key = (index, clut)
        cached = self._cell_cache.get(key)
        if cached is not None:
            return cached

        clut_idx = self.clut_map(clut)
        i = index - self.first_index
        if clut_idx is None or not (0 <= clut_idx < len(self.images)) \
                or not (0 <= i < self.count):
            if key not in self._missing:
                self._missing.add(key)
            return None

        x = (i % self.cols) * self.cw
        y = (i // self.cols) * self.ch
        cell = self._sheet(clut_idx).crop((x, y, x + self.cw, y + self.ch))
        self._cell_cache[key] = cell
        return cell

    def report_missing(self):
        if self._missing:
            sample = sorted(self._missing)[:8]
            print(f"{self.name}: {len(self._missing)} missing (tile,clut) pairs, "
                  f"e.g. {sample}")


def default_sheets(verbose=True, rom_path=None):
    """
    Build the three sheet sets.

    layers 0/1 -> generate_tiles tiles_8x8, 8x8 cells, cluts 0..255, pen 7
    layers 2/3 -> the same source sheet as the HUD but *uncropped*, so layer 2
                  (which uses low tile numbers) works too. If you only have the
                  cropped HUD sheet, use hud_cropped_sheets() instead.
    sprites    -> gen_sprites, decoded from gfx3: 1024 cells of 32x32, 128
                  cluts, exact pen-15 transparency, built per clut on demand
    """
    # transparent pen colours, per clut, straight from gen_cluts
    tile_cluts = gen_cluts.doit(8)

    def tile_key(c):
        # MAME-dumped sheets mark pen 7 with magenta; fall back to the pen's
        # own colour for sheets that do not
        return MAGENTA_KEYS + (tile_cluts[c][TILE_TRANSPARENT_PEN],)

    if verbose:
        print("generating tile sheets...")
    tiles = generate_tiles.doit_tiles_8x8()
    if verbose:
        print("generating gfx1 (layer 2/3) sheets...")
    # same as doit_hud_tiles() but without the crop and without the 1-in-4
    # clut decimation, so cell 0 == tile 0 and clut index == attr
    gfx1 = generate_tiles.doit(8, 0, 256, "hud", ref_clut_index=0x0, hud=False)
    if verbose:
        print("decoding sprites from gfx3...")
    sprites = gen_sprites.doit_sprites_32x32(rom_path)

    sheets = dict(
        tiles=CellSheets(tiles, 8, 8, transparent=tile_key, name="tiles_8x8"),
        gfx1=CellSheets(gfx1, 8, 8, transparent=tile_key, name="gfx1"),
        sprites=CellSheets(sprites, SPRITE_CELL, SPRITE_CELL,
                           cols=gen_sprites.SHEET_COLS, name="sprites"),
    )
    if verbose:
        for s in sheets.values():
            print(f"  {s.name}: {len(s.images)} cluts, "
                  f"{s.images[0].size[0]}x{s.images[0].size[1]}, "
                  f"{s.cols}x{s.rows} cells of {s.cw}x{s.ch} = {s.count}")
    return sheets


def hud_cropped_sheets():
    """
    The 1-in-4 / upper-half-discarded HUD sheets, if that is all you have.
    Only usable for layer 3.
    """
    tile_cluts = gen_cluts.doit(8)

    def tile_key(c):
        return MAGENTA_KEYS + (tile_cluts[c * 4][TILE_TRANSPARENT_PEN],)

    imgs = generate_tiles.doit_hud_tiles()
    half = imgs[0].size[0] // 8 * (imgs[0].size[1] // 8)
    return CellSheets(imgs, 8, 8,
                      first_index=half,          # upper half was discarded
                      clut_map=lambda c: c // 4 if c % 4 == 0 else None,
                      transparent=tile_key,
                      name="hud")


# --------------------------------------------------------------------------
# tilemaps
# --------------------------------------------------------------------------

def render_tilemap(dump, layer, sheets, prom, tilebank=0):
    """Render one 512x256 wrapping tilemap as RGBA."""
    base = VRAM_BASE[layer]
    img = Image.new("RGBA", (TILEMAP_W * 8, TILEMAP_H * 8), (0, 0, 0, 0))

    for row in range(TILEMAP_H):
        for col in range(TILEMAP_W):
            o = base + 2 * (row * TILEMAP_W + col)
            code = dump[o]
            attr = dump[o + 1]
            tile = code + prom.tile_offset(layer, attr, tilebank)
            cell = sheets.cell(tile, attr)
            if cell is not None:
                img.paste(cell, (col * 8, row * 8), cell)
    return img


def wrap_crop(src, x, y, w, h):
    """Crop a w*h window out of src with wraparound on both axes."""
    W, H = src.size
    x %= W
    y %= H
    out = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    for ox in (-x, -x + W):
        for oy in (-y, -y + H):
            out.paste(src, (ox, oy), src)
    return out


# --------------------------------------------------------------------------
# sprites
# --------------------------------------------------------------------------

def _blit(screen_np, prio_np, sub, x, y, pri_mask):
    w, h = sub.size
    x0, y0 = max(0, x), max(0, y)
    x1, y1 = min(SCREEN_W, x + w), min(SCREEN_H, y + h)
    if x0 >= x1 or y0 >= y1:
        return

    s = np.array(sub)[y0 - y:y1 - y, x0 - x:x1 - x]
    opaque = s[:, :, 3] > 0
    pr = prio_np[y0:y1, x0:x1].astype(np.uint16)
    allowed = ((np.uint16(pri_mask) >> pr) & 1) == 0
    m = opaque & allowed
    screen_np[y0:y1, x0:x1][m] = s[:, :, :3][m]


def draw_sprites(dump, sheets, screen_np, prio_np, verbose=False,
                 bank_sprites=None, dump_list=False):
    spr = dump[SPRITE_LIST:SPRITE_LIST + 0x800]
    sprite_xoffs = spr[0x7F5] + ((spr[0x7F4] & 1) << 8)
    sprite_yoffs = spr[0x7F7]
    flip = spr[0x7F6] & 1

    verbose=True
    dump_list=True
    if flip and verbose:
        print("warning: flip screen bit is set in the dump, not handled")

    # MAME uses gfx(2)->elements()/8, i.e. the whole sprite ROM region.
    # That equals sheets.count//8 only if one sheet holds every element:
    # check gfx3's size / 512 and override if it does not.
    if bank_sprites is None:
        bank_sprites = max(1, sheets.count // 8)
    if verbose:
        print(f"sprite offsets x={sprite_xoffs} y={sprite_yoffs}, "
              f"bank_sprites={bank_sprites}")
    drawn = 0


    # back to front, exactly like MAME: last entry is not a sprite
    for o in range(0x800 - 0x20, -1, -0x10):
        o -= 6   # JOTD: use the copy before HW copies it
        attr1 = spr[o + 10]
        attr2 = spr[o + 14]
        color = spr[o + 12]

        flipx = (attr1 & 0x20) >> 5
        flipy = attr2 & 0x01
        sizex = SPRITE_SIZES[(attr1 & 0xC0) >> 6]
        sizey = SPRITE_SIZES[(attr2 & 0x06) >> 1]
        tx = (attr1 & 0x18) & (~(sizex - 1))
        ty = (attr2 & 0x18) & (~(sizey - 1))

        sx = spr[o + 13] + ((color & 0x01) << 8)
        sy = -spr[o + 15] - sizey
        sprite = spr[o + 11]
        sprite_bank = attr1 & 0x07
        priority = (attr2 & 0xE0) >> 5
        pri_mask = (0xFF << (priority + 1)) & 0xFF

        sprite = (sprite & (bank_sprites - 1)) + sprite_bank * bank_sprites
        color >>= 1

        sx += sprite_xoffs
        sy -= sprite_yoffs
        sy += 1                      # sprites are delayed by one scanline

        sx &= 0x1FF
        sy = ((sy + 16) & 0xFF) - 16

        cell = sheets.cell(sprite, color)
        code = spr[o+11]
        if dump_list and (code and sprite_bank) and (cell is not None or spr[o + 11] or spr[o + 13]):
            print(f"  @{o:04x} cell=0x{sprite:04x} (code=0x{code:03x} "
                  f"bank={sprite_bank}) clut=0x{color:03x} "
                  f"{sizex:2d}x{sizey:2d} src=({tx:2d},{ty:2d}) "
                  f"pos=({sx:4d},{sy:4d}) pri={priority} "
                  f"flip={flipx}{flipy}{'' if cell is not None else '  MISSING'}")
        if cell is None:
            continue

        sub = cell.crop((tx, ty, tx + sizex, ty + sizey))
        if flipx:
            sub = sub.transpose(Image.FLIP_LEFT_RIGHT)
        if flipy:
            sub = sub.transpose(Image.FLIP_TOP_BOTTOM)

        _blit(screen_np, prio_np, sub, sx, sy, pri_mask)
        drawn += 1

    if verbose:
        print(f"{drawn} sprites drawn")


# --------------------------------------------------------------------------
# full screen
# --------------------------------------------------------------------------

def render_screen(dump, sheets=None, *, prom=None, tilebank=0,
                  scroll=((0, 0), (0, 0), (0, 0), (0, 0)),
                  layer_prio=(0, 0, 0, 0), backcolor=0,
                  layers=(0, 1, 2, 3), with_sprites=True, verbose=True,
                  bank_sprites=None, dump_sprite_list=False,
                  rom_path=None):
    """
    dump        : bytes-like, at least 0x6000 bytes
    sheets      : dict from default_sheets(), generated on demand if None
    prom        : TileAddressProm (or None for the identity fallback)
    scroll      : per layer (scrollx, scrolly) as written to the latches
    layer_prio  : per layer priority 0..7, i.e. (xscroll & 0x0e00) >> 9
    backcolor   : back colour register, pen 7 of that tile clut fills the screen
    """
    if len(dump) < SPRITE_LIST + 0x800:
        raise ValueError(f"dump too short: {len(dump)} bytes")
    if sheets is None:
        sheets = default_sheets(verbose, rom_path)
    if prom is None:
        prom = TileAddressProm(None)

    # backdrop: gfx(0) colorbase + 8*backcolor + 7 -> pen 7 of tile clut
    bg = tuple(gen_cluts.doit(8)[backcolor][TILE_TRANSPARENT_PEN])[:3]
    screen = Image.new("RGB", (SCREEN_W, SCREEN_H), bg)
    prio = Image.new("L", (SCREEN_W, SCREEN_H), 0)

    maps = {}
    for i in layers:
        maps[i] = render_tilemap(dump, i,
                                 sheets["tiles"] if i < 2 else sheets["gfx1"],
                                 prom, tilebank)

    # same draw order as screen_update(): priority 0..7, and within a priority
    # layer 3 first, layer 0 last
    for pri in range(8):
        for i in (3, 2, 1, 0):
            if i not in maps or layer_prio[i] != pri:
                continue
            sx, sy = scroll[i]
            view = wrap_crop(maps[i], sx - LAYER_DX[i], sy - LAYER_DY[i],
                             SCREEN_W, SCREEN_H)
            alpha = view.getchannel("A").point(lambda a: 255 if a else 0)
            screen.paste(view.convert("RGB"), (0, 0), alpha)
            prio.paste(pri, (0, 0), alpha)

    if with_sprites:
        screen_np = np.array(screen)
        prio_np = np.array(prio)
        draw_sprites(dump, sheets["sprites"], screen_np, prio_np, verbose,
                     bank_sprites=bank_sprites, dump_list=dump_sprite_list)
        screen = Image.fromarray(screen_np, "RGB")

    if verbose:
        for s in sheets.values():
            s.report_missing()

    return screen


# --------------------------------------------------------------------------

def _pairs(text):
    out = []
    for part in text.split(","):
        x, _, y = part.partition(":")
        out.append((int(x, 0), int(y or 0, 0)))
    while len(out) < 4:
        out.append((0, 0))
    return out[:4]


def main():
    ap = argparse.ArgumentParser(description="Rolling Thunder screen mockup")
    ap.add_argument("dump", help="raw memory dump (0x0000-0x5FFF)")
    ap.add_argument("-o", "--output", default="screen.png")
    ap.add_argument("--prom", help="proms region, or the 32-byte tile address PROM")
    ap.add_argument("--tilebank", type=int, default=0)
    ap.add_argument("--backcolor", type=lambda s: int(s, 0), default=0)
    ap.add_argument("--scroll", type=_pairs, default=_pairs("0:0,0:0,0:0,0:0"),
                    help="per layer, e.g. 128:0,64:0,0:0,0:0")
    ap.add_argument("--prio", default="0,0,0,0", help="per layer priority 0..7")
    ap.add_argument("--layers", default="0,1,2,3")
    ap.add_argument("--no-sprites", action="store_true")
    ap.add_argument("--bank-sprites", type=int, default=None,
                    help="override gfx(2)->elements()/8 (gfx3 size / 512 / 8)")
    ap.add_argument("--dump-sprites", action="store_true",
                    help="print the decoded sprite list")
    ap.add_argument("--roms", default=None, help="rthunder.zip or ROM directory")
    ap.add_argument("--scale", type=int, default=1)
    args = ap.parse_args()

    dump = open(args.dump, "rb").read()
    prom = TileAddressProm(open(args.prom, "rb").read()) if args.prom else None

    img = render_screen(
        dump,
        prom=prom,
        tilebank=args.tilebank,
        scroll=args.scroll,
        layer_prio=[int(x, 0) for x in args.prio.split(",")],
        backcolor=args.backcolor,
        layers=tuple(int(x, 0) for x in args.layers.split(",") if x != ""),
        with_sprites=not args.no_sprites,
        bank_sprites=args.bank_sprites,
        dump_sprite_list=args.dump_sprites,
        rom_path=args.roms,
    )

    if args.scale > 1:
        img = img.resize((SCREEN_W * args.scale, SCREEN_H * args.scale),
                         Image.NEAREST)
    img.save(args.output)
    print(f"wrote {args.output}")


if __name__ == "__main__":
    main()
