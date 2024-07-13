#!/bin/bash

# Source directory where the archives are located
SOURCE_DIR="./arcs"

# Define an associative array with the archive file names and their respective extraction locations
declare -A files=(
    ["Font_CascadiaCove.tar.gz"]="$HOME/.local/share/fonts"
    ["Font_MaterialDesign.tar.gz"]="$HOME/.local/share/fonts"
    ["Font_JetBrainsMono.tar.gz"]="$HOME/.local/share/fonts"
    ["Font_MapleNerd.tar.gz"]="$HOME/.local/share/fonts"
    ["Font_MononokiNerd.tar.gz"]="$HOME/.local/share/fonts"
    ["Font_NotoSansCJK.tar.gz"]="/usr/share/fonts"
    ["Cursor_BibataIce.tar.gz"]="/usr/share/icons"
    ["Cursor_BibataIce_Home.tar.gz"]="$HOME/.icons"
    ["Gtk_Wallbash.tar.gz"]="$HOME/.themes"
    ["Sddm_Candy.tar.gz"]="/etc/sddm.conf.d"
)

# Function to extract tar.gz files
extract() {
    local archive=$1
    local destination=$2
    
    if [ -f "$archive" ]; then
        echo "Extracting $archive to $destination..."
        tar -xzvf "$archive" -C "$destination"
    else
        echo "Error: $archive not found."
    fi
}

# Loop through the files and extract them to their destinations
for archive in "${!files[@]}"; do
    destination=${files[$archive]}
    source_path="$SOURCE_DIR/$archive"
    
    # Ensure the destination directory exists
    if [ ! -d "$destination" ]; then
        mkdir -p "$destination"
    fi
    
    # Extract the file
    extract "$source_path" "$destination"
done

# Update font cache
echo "Updating font cache..."
fc-cache -fv

echo "All files have been extracted and font cache updated."
