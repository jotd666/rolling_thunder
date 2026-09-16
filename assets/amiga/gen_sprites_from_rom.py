"""
Rolling Thunder sprite extraction, straight from the gfx3 ROMs.

Replaces the MAME-gfx-viewer route used by generate_tiles for sprites, which
loses information: the viewer output is RGB, so the transparent pen (15) can
not be told apart from any other pen that happens to be the same colour --
and in clut 0 pens 13, 14 and 15 are all black.

Layout, verified against the F4 gfx viewer snapshot:

    gfx3 = 8 x 64K = 0x80000 bytes -> 1024 elements of 32x32, 4bpp
    512 bytes per element = 4 quadrants of 16x16, in TL, TR, BL, BR order
    each quadrant is 16 rows of 8 bytes, high nibble = left pixel

The sheets are 16 cells across, like the viewer, so a full sheet is
512x2048 and render_screen derives cols=16, count=1024, bank_sprites=128
(= gfx(2)->elements()/8, as MAME does).

Sheets are RGBA with the transparent pen already at alpha 0, and they are
built one clut at a time on demand -- 128 full sheets at once would be about
400 MB.
"""

import os
import pathlib
import zipfile

import numpy as np
from PIL import Image

# gfx3, in load order
SPRITE_ROMS = [
    "rt1_9.12h", "rt1_10.12k", "rt1_11.12l", "rt1_12.12m",
    "rt1_13.12p", "rt1_14.12r", "rt1_15.12t", "rt1_16.12u",
]

SPRITE_W = SPRITE_H = 32
SPRITE_BYTES = SPRITE_W * SPRITE_H // 2          # 512, 4bpp
SPRITE_TRANSPARENT_PEN = 15
SHEET_COLS = 16                                   # same as the gfx viewer

# Colour written into the RGB channels where the transparent pen is. Alpha is 0
# there either way, but a viewer that drops alpha would otherwise show the pen's
# real colour -- which is black in clut 0, and clut 0 also has genuine black
# pixels. 254 is not reachable through the 4-bit resistor DAC, so it can never
# collide with a real colour. Pass None to keep the pen's own colour instead.
TRANSPARENT_RGB = (254, 0, 254)

# quadrant order inside one element: (row, col) of each successive 16x16 block
QUADRANTS = [(0, 0), (0, 1), (1, 0), (1, 1)]      # TL, TR, BL, BR

# cluts.txt holds the whole lookup: 2048 tile entries then 2048 sprite entries
SPRITE_CLUT_BASE = 2048
SPRITE_CLUT_SIZE = 16

ROM_PATH = pathlib.Path(os.environ.get("RTHUNDER_ROMS", "rthunder.zip"))


# --------------------------------------------------------------------------
# ROM reading
# --------------------------------------------------------------------------

def _read_roms(path=None):
    """Concatenate the gfx3 ROMs from a directory or a .zip."""
    path = pathlib.Path(path or ROM_PATH)
    if path.is_dir():
        return b"".join((path / n).read_bytes() for n in SPRITE_ROMS)
    with zipfile.ZipFile(path) as z:
        names = {pathlib.Path(n).name: n for n in z.namelist()}
        missing = [n for n in SPRITE_ROMS if n not in names]
        if missing:
            raise FileNotFoundError(f"{path}: missing {missing}")
        return b"".join(z.read(names[n]) for n in SPRITE_ROMS)


def decode_sprites(path=None):
    """
    -> uint8 array (n, 32, 32) of pen indices, n = 1024 for rthunder.
    """
    data = _read_roms(path)
    if len(data) % SPRITE_BYTES:
        raise ValueError(f"gfx3 is {len(data)} bytes, not a multiple of 512")

    b = np.frombuffer(data, dtype=np.uint8)
    pens = np.empty(b.size * 2, dtype=np.uint8)
    pens[0::2] = b >> 4                            # high nibble = left pixel
    pens[1::2] = b & 0x0F

    # (element, quadrant, y, x)
    q = pens.reshape(-1, len(QUADRANTS), SPRITE_H // 2, SPRITE_W // 2)

    out = np.zeros((q.shape[0], SPRITE_H, SPRITE_W), dtype=np.uint8)
    for k, (qy, qx) in enumerate(QUADRANTS):
        y, x = qy * (SPRITE_H // 2), qx * (SPRITE_W // 2)
        out[:, y:y + SPRITE_H // 2, x:x + SPRITE_W // 2] = q[:, k]
    return out


# --------------------------------------------------------------------------
# cluts
# --------------------------------------------------------------------------

def sprite_cluts(cluts_file=None):
    """
    -> list of 128 cluts of 16 RGB tuples (the sprite half of the lookup).

    Uses gen_cluts when it is importable, so there is a single source of
    truth; falls back to parsing cluts.txt directly.
    """
    if cluts_file is None:
        try:
            import gen_cluts
            return gen_cluts.doit(SPRITE_CLUT_SIZE)[SPRITE_CLUT_BASE // SPRITE_CLUT_SIZE:]
        except Exception:
            cluts_file = "cluts.txt"

    vals = []
    with open(cluts_file, encoding="utf-8-sig") as f:
        for line in f:
            if "#" in line:
                continue
            toks = line.split(",")
            if len(toks) == 4:
                vals.append(tuple(int(x) for x in toks[:3]))
    vals = vals[SPRITE_CLUT_BASE:]
    return [vals[i:i + SPRITE_CLUT_SIZE]
            for i in range(0, len(vals), SPRITE_CLUT_SIZE)]


# --------------------------------------------------------------------------
# sheets
# --------------------------------------------------------------------------

def _make_sheet(pens, clut, cols=SHEET_COLS, transparent_rgb=TRANSPARENT_RGB):
    """One RGBA sheet: every element laid out cols across, pen 15 -> alpha 0."""
    n = pens.shape[0]
    rows = (n + cols - 1) // cols
    idx = np.zeros((rows * SPRITE_H, cols * SPRITE_W), dtype=np.uint8)
    idx[:] = SPRITE_TRANSPARENT_PEN
    for i in range(n):
        r, c = divmod(i, cols)
        idx[r * SPRITE_H:(r + 1) * SPRITE_H,
            c * SPRITE_W:(c + 1) * SPRITE_W] = pens[i]

    pal = np.array([tuple(c)[:3] for c in clut], dtype=np.uint8)
    if transparent_rgb is not None:
        pal = pal.copy()
        pal[SPRITE_TRANSPARENT_PEN] = tuple(transparent_rgb)[:3]
    rgb = pal[idx]
    alpha = np.where(idx == SPRITE_TRANSPARENT_PEN, 0, 255).astype(np.uint8)
    return Image.fromarray(np.dstack([rgb, alpha]), "RGBA")


class LazySheets:
    """
    Sequence of one RGBA sheet per clut, built on first access and cached.
    Drop-in for the list generate_tiles returns: len() and [i] are all that
    render_screen needs.
    """

    def __init__(self, pens, cluts, cols=SHEET_COLS,
                 transparent_rgb=TRANSPARENT_RGB):
        self.pens = pens
        self.cluts = cluts
        self.cols = cols
        self.transparent_rgb = transparent_rgb
        self._cache = {}

    def __len__(self):
        return len(self.cluts)

    def __getitem__(self, i):
        if isinstance(i, slice):
            return [self[k] for k in range(*i.indices(len(self)))]
        if i < 0:
            i += len(self)
        img = self._cache.get(i)
        if img is None:
            img = _make_sheet(self.pens, self.cluts[i], self.cols,
                              self.transparent_rgb)
            self._cache[i] = img
        return img


def doit_sprites_32x32(rom_path=None, cluts_file=None,
                       transparent_rgb=TRANSPARENT_RGB):
    """Same shape of result as generate_tiles.doit_sprites_16x16(), but right."""
    return LazySheets(decode_sprites(rom_path), sprite_cluts(cluts_file),
                      transparent_rgb=transparent_rgb)


# --------------------------------------------------------------------------
# contact sheet, like the gfx viewer
# --------------------------------------------------------------------------

def contact_sheet(pens, clut, cols=SHEET_COLS, zoom=2, first=0, count=None,
                  background=(15, 19, 48), grid=(60, 60, 120),
                  transparent_rgb=TRANSPARENT_RGB):
    """Labelled sheet with hex row/column headers, like MAME's F4 view."""
    from PIL import ImageDraw

    n = pens.shape[0] if count is None else min(count, pens.shape[0] - first)
    rows = (n + cols - 1) // cols
    cw, ch = SPRITE_W * zoom, SPRITE_H * zoom
    mx, my = 6 * zoom * 4, 3 * zoom * 4          # room for the labels

    img = Image.new("RGB", (mx + cols * cw, my + rows * ch), background)
    draw = ImageDraw.Draw(img)

    body = _make_sheet(pens[first:first + n], clut, cols,
                       transparent_rgb).convert("RGB")
    img.paste(body.resize((cols * cw, rows * ch), Image.NEAREST), (mx, my))

    for c in range(cols + 1):
        draw.line([(mx + c * cw, my), (mx + c * cw, my + rows * ch)], fill=grid)
    for r in range(rows + 1):
        draw.line([(mx, my + r * ch), (mx + cols * cw, my + r * ch)], fill=grid)

    for c in range(cols):
        draw.text((mx + c * cw + cw // 2 - 4, my // 2 - 4),
                  f"{c:X}", fill=(255, 255, 255))
    for r in range(rows):
        draw.text((4, my + r * ch + ch // 2 - 4),
                  f"{first + r * cols:X}", fill=(255, 255, 255))
    return img


def main():
    import argparse
    ap = argparse.ArgumentParser(description="extract Rolling Thunder sprites")
    ap.add_argument("--roms", default=str(ROM_PATH), help="rthunder.zip or a directory")
    ap.add_argument("--cluts", default=None, help="cluts.txt (default: via gen_cluts)")
    ap.add_argument("--clut", type=lambda s: int(s, 0), default=0)
    ap.add_argument("--zoom", type=int, default=2)
    ap.add_argument("--rows", type=int, default=None, help="limit rows, for a quick look")
    ap.add_argument("-o", "--output", default=None,
                    help="default: rt_sprites_clut<NN>.png")
    ap.add_argument("--plain", action="store_true",
                    help="no labels or grid, i.e. what render_screen consumes")
    ap.add_argument("--pen-color", action="store_true",
                    help="draw the transparent pen in its real colour "
                         "instead of magenta")
    ap.add_argument("--rgba", action="store_true",
                    help="save with an alpha channel; by default the file is "
                         "flat RGB so the magenta key is actually visible")
    args = ap.parse_args()
    transparent_rgb = None if args.pen_color else TRANSPARENT_RGB

    output = pathlib.Path(args.output or f"rt_sprites_clut{args.clut:02x}.png")
    if not output.suffix:
        output = output.with_suffix(".png")

    pens = decode_sprites(args.roms)
    cluts = sprite_cluts(args.cluts)
    print(f"{pens.shape[0]} sprites of {SPRITE_W}x{SPRITE_H}, "
          f"{len(cluts)} cluts, bank_sprites={pens.shape[0] // 8}")

    count = None if args.rows is None else args.rows * SHEET_COLS
    if args.plain:
        img = _make_sheet(pens if count is None else pens[:count],
                          cluts[args.clut], transparent_rgb=transparent_rgb)
    else:
        img = contact_sheet(pens, cluts[args.clut], zoom=args.zoom, count=count,
                            transparent_rgb=transparent_rgb)
    # alpha 0 over magenta gets composited to black by most viewers, so the
    # key only shows up if the alpha channel is dropped
    if not args.rgba and img.mode == "RGBA":
        img = img.convert("RGB")
    img.save(output)
    print(f"wrote {output} ({img.size[0]}x{img.size[1]}, {img.mode})")


if __name__ == "__main__":
    main()
