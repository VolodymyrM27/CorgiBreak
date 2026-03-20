#!/usr/bin/env python3
"""Extract individual animation frames from the corgi sprite sheet."""

from PIL import Image
import os

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.dirname(SCRIPT_DIR)
SPRITE_SHEET = os.path.join(PROJECT_DIR, "Resources", "corgi-asset.png")
OUTPUT_DIR = os.path.join(PROJECT_DIR, "Resources", "CorgiFrames")

# Grid coordinates from the sprite sheet
V_LINES = [96, 159, 223, 287, 351, 415, 479, 543, 607, 671, 735, 799]
H_LINES = [0, 63, 127, 191, 255, 319, 383, 447, 511]

ANIMATIONS = [
    ("jump", 10),
    ("idle1", 5),
    ("idle2", 5),
    ("sit", 9),
    ("walk", 5),
    ("run", 8),
    ("sniff", 8),
    ("sniffwalk", 8),
]

INSET = 2


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    img = Image.open(SPRITE_SHEET)

    for row, (name, frame_count) in enumerate(ANIMATIONS):
        y = H_LINES[row] + INSET
        h = H_LINES[row + 1] - H_LINES[row] - INSET * 2

        for col in range(frame_count):
            x = V_LINES[col] + INSET
            w = V_LINES[col + 1] - V_LINES[col] - INSET * 2

            frame = img.crop((x, y, x + w, y + h))
            filename = f"{name}_{col}.png"
            frame.save(os.path.join(OUTPUT_DIR, filename))
            print(f"  Saved {filename} ({w}x{h})")

    print(f"\nDone! Extracted frames to {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
