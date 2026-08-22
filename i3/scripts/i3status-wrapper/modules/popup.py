"""
Interactive click & scroll action handlers for i3bar blocks.
Maps (block_name, mouse_button) to terminal commands and system utilities.
"""

import os
import subprocess

TERM_FLOAT = ["kitty", "--single-instance", "--class", "floating_shell", "-e"]
HOME = os.path.expanduser("~")

CLICK_ACTIONS = {
    # Network (Left click -> nmtui)
    ("network", 1): TERM_FLOAT + ["nmtui"],
    # Volume (Left click -> pulsemixer | Middle/Right -> Mute | Scroll -> +/- 5%)
    ("volume", 1): TERM_FLOAT + ["pulsemixer"],
    ("volume", 2): ["pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle"],
    ("volume", 3): ["pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle"],
    ("volume", 4): ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%"],
    ("volume", 5): ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%"],
    # Brightness (Left click / Scroll up -> +5% | Right click / Scroll down -> -5%)
    ("brightness", 1): ["brightnessctl", "set", "+5%"],
    ("brightness", 3): ["brightnessctl", "set", "5%-"],
    ("brightness", 4): ["brightnessctl", "set", "+5%"],
    ("brightness", 5): ["brightnessctl", "set", "5%-"],
    # System Stats (Left click -> btop)
    ("cpu_usage", 1): TERM_FLOAT + ["btop"],
    ("memory", 1): TERM_FLOAT + ["btop"],
    ("battery", 1): TERM_FLOAT + ["btop"],
    # Disk (Left click -> ncdu | Right click -> ranger)
    ("disk_info", 1): TERM_FLOAT + ["ncdu", "--color", "dark", "-x", HOME],
    ("disk_info", 3): TERM_FLOAT + ["ranger", HOME],
    # Clock (Left click -> calcurse)
    ("tztime", 1): TERM_FLOAT + ["calcurse"],
}


def launch_cmd(cmd_list):
    """Spawn a detached subprocess without blocking."""
    try:
        subprocess.Popen(cmd_list, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except Exception:
        pass


def handle_click_event(event):
    """Dispatch mouse clicks and scroll wheel events via map lookup."""
    name = event.get("name")
    button = event.get("button", 1)

    cmd = CLICK_ACTIONS.get((name, button))
    if cmd:
        launch_cmd(cmd)
