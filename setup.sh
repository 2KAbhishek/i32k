#!/usr/bin/env bash

set -e

# Detect if the system is Arch-based
if [ -f /etc/arch-release ] || command -v pacman &>/dev/null; then
    echo "Arch Linux detected. Preparing to install dependencies..."

    sudo pacman -S --needed \
        i3-wm i3status rofi rofi-emoji kitty xclip cliphist \
        swappy maim xorg-xbacklight feh volumeicon \
        xfce4 xfce4-goodies ttf-firacode-nerd ttf-roboto python
else
    echo "Warning: This script only supports package installation on Arch-based systems."
fi

echo "Creating system directories..."
mkdir -p ~/Pictures/Screenshots/
mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml

echo "Creating symlinks to ~/.config..."
ln -sfnv "$PWD"/config/i3 ~/.config/i3

echo "Applying XFCE session, desktop & appearance settings..."
# Window Manager: Replace xfwm4 with i3
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client0_Command -n -t string -s "i3" --force-array 2>/dev/null || true
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client4_Command -n -t string -s "" --force-array 2>/dev/null || true

# Desktop: Disable xfdesktop overlay icons
xfconf-query -c xfce4-desktop -p /desktop-icons/style -n -t int -s 0 2>/dev/null || true

# Keyboard: Caps Lock -> Escape and repeat rate
xfconf-query -c keyboard-layout -p /Default/XkbOptions/Group -n -t string -s "caps:escape" --force-array 2>/dev/null || true
xfconf-query -c keyboards -p /Default/KeyRepeat/Delay -n -t int -s 250 2>/dev/null || true
xfconf-query -c keyboards -p /Default/KeyRepeat/Rate -n -t int -s 70 2>/dev/null || true

# Appearance: Theme & Icons
xfconf-query -c xsettings -p /Net/ThemeName -n -t string -s "BWnB" 2>/dev/null || true
xfconf-query -c xsettings -p /Net/IconThemeName -n -t string -s "Reversal-blue-dark" 2>/dev/null || true

# Panel: Copy clean panel template if not already present
if [ ! -f ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml ]; then
    echo "Installing clean XFCE panel layout..."
    cp "$PWD"/config/xfce4/panel.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
fi

echo "Setup completed successfully!"
