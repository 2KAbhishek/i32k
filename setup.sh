#!/usr/bin/env bash

set -e

# Detect if the system is Arch-based
if [ -f /etc/arch-release ] || command -v pacman &>/dev/null; then
    echo "Arch Linux detected. Preparing to install dependencies..."

    sudo pacman -S --needed \
        autotiling i3-wm i3status i3lock rofi rofi-emoji kitty xclip cliphist \
        swappy maim xorg-xbacklight feh polkit-gnome network-manager-applet \
        xorg-xauth xorg-xinit xorg-xset xorg-xinput \
        xfce4-power-manager thunar tumbler thunar-archive-plugin thunar-volman \
        ttf-firacode-nerd ttf-roboto python
else
    echo "Warning: This script only supports package installation on Arch-based systems."
fi

echo "Creating system directories..."
mkdir -p ~/Pictures/Screenshots/
mkdir -p ~/.config/i3

echo "Creating symlinks to ~/.config..."
ln -sfnv "$PWD"/i3 ~/.config/i3

echo "Setup completed successfully!"
