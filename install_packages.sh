#!/bin/bash

# Package list
packages=(
    pipewire
    pipewire-alsa
    pipewire-audio
    pipewire-jack
    pipewire-pulse
    gst-plugin-pipewire
    wireplumber
    pavucontrol
    pamixer
    networkmanager
    network-manager-applet
    bluez
    bluez-utils
    blueman
    brightnessctl
    udiskie
    sddm
    qt5-quickcontrols
    qt5-quickcontrols2
    qt5-graphicaleffects
    hyprland
    dunst
    rofi-lbonn-wayland-git
    waybar
    swww
    swaylock-effects-git
    wlogout
    grimblast-git
    hyprpicker
    slurp
    swappy
    cliphist
    polkit-gnome
    xdg-desktop-portal-hyprland
    pacman-contrib
    python-pyamdgpuinfo
    parallel
    jq
    imagemagick
    qt5-imageformats
    ffmpegthumbs
    kde-cli-tools
    libnotify
    nwg-look
    qt5ct
    qt6ct
    kvantum
    kvantum-qt5
    qt5-wayland
    qt6-wayland
    firefox
    kitty
    dolphin
    ark
    vim
    neovim
    code
    starship
    fastfetch
    hyde-cli-git
)

# Update the system
sudo pacman -Syu

# Install packages
for package in "${packages[@]}"; do
    yay -S --noconfirm "$package"
done

echo "All packages have been installed successfully."

