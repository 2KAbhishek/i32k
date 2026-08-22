"""
Real-time network download bandwidth calculator and formatter.
"""

import os

# Internal state across ticks
_last_iface = None
_last_rx = 0


def get_default_interface():
    """Find the default route interface, or fallback to any active non-loopback interface."""
    try:
        with open("/proc/net/route") as f:
            for line in f.readlines()[1:]:
                fields = line.strip().split()
                if (
                    len(fields) >= 4
                    and fields[1] == "00000000"
                    and (int(fields[3], 16) & 2)
                ):
                    return fields[0]
    except Exception:
        pass

    try:
        for iface in os.listdir("/sys/class/net"):
            if iface == "lo":
                continue
            operstate_path = f"/sys/class/net/{iface}/operstate"
            if os.path.exists(operstate_path):
                with open(operstate_path) as f:
                    if f.read().strip() == "up":
                        return iface
    except Exception:
        pass

    return None


def is_wireless(iface):
    """Check if interface is wireless."""
    return os.path.exists(f"/sys/class/net/{iface}/wireless") or os.path.exists(
        f"/sys/class/net/{iface}/phy80211"
    )


def get_rx_bytes(iface):
    """Read total received bytes from sysfs."""
    try:
        with open(f"/sys/class/net/{iface}/statistics/rx_bytes") as f:
            return int(f.read().strip())
    except Exception:
        return 0


def format_speed(bytes_per_sec):
    """Format bandwidth speed in human-readable units."""
    if bytes_per_sec < 1024:
        return f"{bytes_per_sec:.0f} B/s"
    elif bytes_per_sec < 1024 * 1024:
        return f"{bytes_per_sec / 1024:.1f} KB/s"
    elif bytes_per_sec < 1024 * 1024 * 1024:
        return f"{bytes_per_sec / (1024 * 1024):.1f} MB/s"
    else:
        return f"{bytes_per_sec / (1024 * 1024 * 1024):.1f} GB/s"


def get_bandwidth_block(dt):
    """Generate the network bandwidth i3bar block."""
    global _last_iface, _last_rx

    iface = get_default_interface()
    if not iface:
        _last_iface = None
        _last_rx = 0
        return {
            "name": "network",
            "instance": "none",
            "markup": "none",
            "full_text": "󰖪",
            "color": "#ff0043",
        }

    rx = get_rx_bytes(iface)
    if iface != _last_iface or _last_rx == 0:
        speed = 0.0
    else:
        speed = max(0.0, (rx - _last_rx) / dt)

    _last_iface = iface
    _last_rx = rx

    icon = "" if is_wireless(iface) else "󰈀"
    return {
        "name": "network",
        "instance": iface,
        "markup": "none",
        "full_text": f"{icon}  {format_speed(speed)}",
        "color": "#eeeeee",
    }
