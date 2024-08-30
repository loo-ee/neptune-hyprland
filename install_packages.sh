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
    qt5-quickcontrols
    qt5-quickcontrols2
    qt5-graphicaleffects
    hyprland
    dunst
    rofi-lbonn-wayland-git
    waybar
    swww
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
    ark
    vim
    neovim
    visual-studio-code-bin
    starship
    fastfetch
    zoxide
    hyprshade
    hypridle
    hyprlock
    onefetch
    gum
    gnome-disk-utility
    atril
    gvfs-mtp
    pcmanfm
    firewalld
    zsh-theme-powerlevel10k-git
    btrfs-assistant
    zsh
)

# Update the system
sudo pacman -Syu

# Install packages
for package in "${packages[@]}"; do
    yay --noconfirm -S "$package"
done

echo "All packages have been installed successfully."

