#!/usr/bin/env bash

set -e

# Detect if the system is Arch-based
if [ -f /etc/arch-release ] || command -v pacman &>/dev/null; then
    echo "Arch Linux detected. Preparing to install dependencies..."
    sudo pacman -S --needed \
        autotiling brightnessctl btop calcurse cliphist i3-wm i3lock i3status jq \
        kitty lxqt-policykit maim ncdu networkmanager picom playerctl pulsemixer \
        python ranger rofi rofi-emoji swappy thunar thunar-archive-plugin \
        thunar-volman ttf-firacode-nerd ttf-roboto tumbler xclip xorg-setxkbmap \
        xorg-xauth xorg-xinit xorg-xinput xorg-xset xorg-xsetroot xss-lock
else
    echo "Warning: This script only supports package installation on Arch-based systems."
fi

echo "Creating system directories..."
mkdir -p ~/Pictures/Screenshots/
mkdir -p ~/.config/i3

echo "Creating symlinks to ~/.config..."
ln -sfnv "$PWD"/i3 ~/.config/i3

echo "Setup completed successfully!"
