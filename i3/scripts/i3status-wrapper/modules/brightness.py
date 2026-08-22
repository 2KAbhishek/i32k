"""
Display brightness reader with dynamic icons based on percentage.
"""

import glob
import os


def get_brightness_block():
    """Read current display brightness percentage and select dynamic icon."""
    try:
        backlights = glob.glob("/sys/class/backlight/*")
        if not backlights:
            return None
        dev = backlights[0]
        with open(os.path.join(dev, "brightness")) as f:
            b = int(f.read().strip())
        with open(os.path.join(dev, "max_brightness")) as f:
            mb = int(f.read().strip())
        pct = round((b / mb) * 100)
        icon = "󰃞" if pct < 33 else ("󰃟" if pct < 66 else "󰃠")
        return {
            "name": "brightness",
            "instance": os.path.basename(dev),
            "markup": "none",
            "full_text": f"{icon} {pct}%",
            "color": "#eeeeee",
        }
    except Exception:
        return None
