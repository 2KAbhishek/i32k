#!/usr/bin/env bash
set -e

current_dir="${BASH_SOURCE[0]%/*}"
[[ "$current_dir" == "${BASH_SOURCE[0]}" || "$current_dir" == "." ]] && current_dir="$PWD"
readonly current_dir

case "${OSTYPE:-$(uname -s)}" in
    darwin* | Darwin* | *darwin*) HOST_OS="darwin" ;;
    linux* | Linux* | *linux*)   HOST_OS="linux" ;;
    freebsd* | FreeBSD* | *freebsd*) HOST_OS="freebsd" ;;
    *) HOST_OS="linux" ;;
esac
readonly HOST_OS

cmd_sudo() {
    if [[ "$EUID" -ne 0 ]] && command -v sudo &>/dev/null; then
        sudo "$@"
    else
        "$@"
    fi
}

# Detect if the system is Arch-based
if [ -f /etc/arch-release ] || command -v pacman &>/dev/null; then
    echo "Arch Linux detected. Preparing to install dependencies..."
    cmd_sudo pacman -S --needed --noconfirm \
        autotiling brightnessctl btop calcurse cliphist i3-wm i3lock i3status jq \
        kitty lxqt-policykit maim ncdu networkmanager picom playerctl pulsemixer \
        python ranger rofi rofi-emoji swappy thunar thunar-archive-plugin \
        thunar-volman ttf-firacode-nerd ttf-roboto tumbler xclip xorg-setxkbmap \
        xorg-xauth xorg-xinit xorg-xinput xorg-xset xorg-xsetroot xss-lock
else
    echo "Warning: This script only supports automated package installation on Arch-based systems."
fi

echo "Creating system directories..."
mkdir -p "$HOME/Pictures/Screenshots"

echo "Creating symlinks to ~/.config..."
ln -sfnv "$current_dir/i3" "$HOME/.config/i3"

echo "i32k setup completed successfully!"
