#!/usr/bin/env python3
"""
Lightweight i3status wrapper entry point.
Streams i3status JSON, injects modular plugins, and routes click events.
"""

import json
import os
import signal
import subprocess
import sys
import threading
import time

# Ensure wrapper package directory is in sys.path
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
if SCRIPT_DIR not in sys.path:
    sys.path.insert(0, SCRIPT_DIR)

from modules.bandwidth import get_bandwidth_block
from modules.brightness import get_brightness_block
from modules.popup import handle_click_event

# Ignore SIGPIPE to handle pipe closure cleanly on i3bar reload/exit
if hasattr(signal, "SIGPIPE"):
    signal.signal(signal.SIGPIPE, signal.SIG_DFL)


def click_listener():
    """Background listener for i3bar stdin JSON click events."""
    for line in sys.stdin:
        line_clean = line.strip().lstrip("[").lstrip(",").rstrip("]")
        if not line_clean:
            continue
        try:
            event = json.loads(line_clean)
            if isinstance(event, dict):
                handle_click_event(event)
        except Exception:
            pass


def main():
    # Resolve config path
    user_config = os.path.expanduser("~/.config/i3/i3status.conf")
    script_dir_config = os.path.join(SCRIPT_DIR, "..", "i3status.conf")
    config_file = user_config if os.path.exists(user_config) else script_dir_config

    cmd = ["i3status"]
    if os.path.exists(config_file):
        cmd.extend(["-c", config_file])

    proc = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        text=True,
        bufsize=1,
    )

    def cleanup(signum=None, frame=None):
        try:
            proc.terminate()
        except Exception:
            pass
        sys.exit(0)

    signal.signal(signal.SIGINT, cleanup)
    signal.signal(signal.SIGTERM, cleanup)

    # Start click event listener in background daemon thread
    click_thread = threading.Thread(target=click_listener, daemon=True)
    click_thread.start()

    last_time = time.time()

    try:
        # Read header line and enable click events
        header_line = proc.stdout.readline()
        if not header_line:
            return

        try:
            header_json = json.loads(header_line.strip())
            header_json["click_events"] = True
            sys.stdout.write(json.dumps(header_json) + "\n")
        except Exception:
            sys.stdout.write('{"version":1,"click_events":true}\n')

        # Read array opening line
        open_bracket = proc.stdout.readline()
        if not open_bracket:
            return
        sys.stdout.write(open_bracket)
        sys.stdout.flush()

        for line in proc.stdout:
            line_clean = line.strip()
            if not line_clean:
                continue

            has_comma = line_clean.startswith(",")
            json_str = line_clean[1:] if has_comma else line_clean

            try:
                blocks = json.loads(json_str)
            except Exception:
                sys.stdout.write(line)
                sys.stdout.flush()
                continue

            # 1. Inject Brightness (before Volume)
            bright_block = get_brightness_block()
            if bright_block:
                vol_idx = next(
                    (i for i, b in enumerate(blocks) if b.get("name") == "volume"),
                    None,
                )
                if vol_idx is not None:
                    blocks.insert(vol_idx, bright_block)
                else:
                    blocks.append(bright_block)

            # 2. Inject Bandwidth (after Volume)
            now = time.time()
            dt = max(now - last_time, 0.001)
            last_time = now
            net_block = get_bandwidth_block(dt)

            vol_idx = next(
                (i for i, b in enumerate(blocks) if b.get("name") == "volume"),
                None,
            )
            if vol_idx is not None:
                blocks.insert(vol_idx + 1, net_block)
            else:
                blocks.append(net_block)

            out_json = json.dumps(blocks)
            sys.stdout.write(f",{out_json}\n" if has_comma else f"{out_json}\n")
            sys.stdout.flush()

    except (BrokenPipeError, KeyboardInterrupt):
        pass
    finally:
        cleanup()


if __name__ == "__main__":
    main()
