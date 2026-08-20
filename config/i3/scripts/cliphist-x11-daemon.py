#!/usr/bin/env python3
"""
Lightweight X11 Clipboard Watcher for cliphist
Listens for X11 clipboard owner changes and pipes content into `cliphist store`.
"""

import subprocess
import time


def get_x11_clipboard():
    try:
        proc = subprocess.run(
            ["xclip", "-selection", "clipboard", "-o"],
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            timeout=2,
        )
        return proc.stdout
    except Exception:
        return None


def store_cliphist(data):
    if not data:
        return
    try:
        proc = subprocess.Popen(["cliphist", "store"], stdin=subprocess.PIPE)
        proc.communicate(input=data, timeout=2)
    except Exception:
        pass


def main():
    last_clip = None
    while True:
        try:
            curr_clip = get_x11_clipboard()
            if curr_clip and curr_clip != last_clip:
                last_clip = curr_clip
                store_cliphist(curr_clip)
        except Exception:
            pass
        time.sleep(1.0)


if __name__ == "__main__":
    main()
