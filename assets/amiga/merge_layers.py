"""
Merge rendered layer dumps into one picture.

Images are given bottom-first: the first one is the background and is drawn
opaque, every later one is composited over it with black treated as
transparent (that is what the tilemap's transparent pen renders as in these
dumps).

    merge_layers.py title_layer_0.png title_layer_2.png -o title.png

Crop modes:
    default      union of the non-transparent content of every input
    --screen     288x224, the real visible window, anchored on the content
    --rect x,y,w,h   explicit
    --full       no crop, keep the whole 512x256 tilemap
"""

# working setup: ..\amiga\merge_layers.py --rect 0,24,320,256 -o title_layers.png title_layer_0.png title_layer_2.png
import argparse
import pathlib

import numpy as np
from PIL import Image

SCREEN_W, SCREEN_H = 288, 224
BLACK = (0, 0, 0)


def content_bbox(arr, key):
    """Bounding box of pixels that are not `key`, or None if there are none."""
    mask = np.any(arr != np.array(key, dtype=np.uint8), axis=-1)
    if not mask.any():
        return None
    ys, xs = np.where(mask)
    return int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1


def union_bbox(boxes):
    boxes = [b for b in boxes if b]
    if not boxes:
        return None
    return (min(b[0] for b in boxes), min(b[1] for b in boxes),
            max(b[2] for b in boxes), max(b[3] for b in boxes))


def merge(paths, key=BLACK, rect=None, screen=False, full=False,
          background=None, verbose=True):
    imgs = [Image.open(p).convert("RGB") for p in paths]
    arrs = [np.array(im, dtype=np.uint8) for im in imgs]

    boxes = [content_bbox(a, key) for a in arrs]
    if verbose:
        for p, b in zip(paths, boxes):
            print(f"{pathlib.Path(p).name}: content {b}")

    if full:
        box = (0, 0, imgs[0].width, imgs[0].height)
    elif rect:
        x, y, w, h = rect
        box = (x, y, x + w, y + h)
    else:
        box = union_bbox(boxes)
        if box is None:
            raise ValueError("every input is entirely transparent")
        if screen:
            # centre the visible window on the content, clamped to the image
            cx = (box[0] + box[2]) // 2
            cy = (box[1] + box[3]) // 2
            x = max(0, min(imgs[0].width - SCREEN_W, cx - SCREEN_W // 2))
            y = max(0, min(imgs[0].height - SCREEN_H, cy - SCREEN_H // 2))
            box = (x, y, x + SCREEN_W, y + SCREEN_H)
    if verbose:
        print(f"crop {box} -> {box[2]-box[0]}x{box[3]-box[1]}")

    w, h = box[2] - box[0], box[3] - box[1]
    out = Image.new("RGB", (w, h), tuple(background or key))

    for i, im in enumerate(imgs):
        piece = im.crop(box)
        if i == 0 and background is None:
            out.paste(piece, (0, 0))          # bottom layer is opaque
            continue
        a = np.array(piece, dtype=np.uint8)
        opaque = np.any(a != np.array(key, dtype=np.uint8), axis=-1)
        mask = Image.fromarray(np.where(opaque, 255, 0).astype(np.uint8), "L")
        out.paste(piece, (0, 0), mask)
    return out


def _rect(text):
    v = [int(x, 0) for x in text.replace("x", ",").split(",")]
    if len(v) != 4:
        raise argparse.ArgumentTypeError("expected x,y,w,h")
    return v


def main():
    ap = argparse.ArgumentParser(description="merge layer dumps, bottom first")
    ap.add_argument("images", nargs="+", help="bottom layer first")
    ap.add_argument("-o", "--output", default="merged.png")
    ap.add_argument("--rect", type=_rect, default=None, help="x,y,w,h")
    ap.add_argument("--screen", action="store_true",
                    help=f"crop to {SCREEN_W}x{SCREEN_H} around the content")
    ap.add_argument("--full", action="store_true", help="no crop")
    ap.add_argument("--transparent", default="0,0,0",
                    help="transparent colour, default 0,0,0")
    ap.add_argument("--background", default=None,
                    help="fill colour under every layer, e.g. 0,128,128")
    ap.add_argument("--scale", type=int, default=1)
    args = ap.parse_args()

    key = tuple(int(x, 0) for x in args.transparent.split(","))[:3]
    bg = (tuple(int(x, 0) for x in args.background.split(","))[:3]
          if args.background else None)

    img = merge(args.images, key=key, rect=args.rect, screen=args.screen,
                full=args.full, background=bg)

    output = pathlib.Path(args.output)
    if not output.suffix:
        output = output.with_suffix(".png")
    if args.scale > 1:
        img = img.resize((img.width * args.scale, img.height * args.scale),
                         Image.NEAREST)
    img.save(output)
    print(f"wrote {output} ({img.width}x{img.height})")


if __name__ == "__main__":
    main()
