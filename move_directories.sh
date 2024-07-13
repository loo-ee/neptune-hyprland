#!/bin/bash

# Define an associative array for source and destination directories
declare -A paths=(
    ["./bin"]="$HOME/.local/share/bin"
    ["./config"]="$HOME/.config"
    ["./icons"]="$HOME/.icons"
    ["./neptune"]="$HOME/.cache/neptune"
    ["./sugar-candy"]="/usr/share/sddm/themes/sugar-candy"
    ["./themes"]="$HOME/.themes"
)

# Function to move items with appropriate sudo handling
move() {
    local src=$1
    local dest=$2

    if [ "$(dirname "$dest")" = "/usr/share" ]; then
        sudo mv -f "$src" "$dest"
    else
        mv -f "$src" "$dest"
    fi
}

# Loop through the associative array and move folders
for SRC in "${!paths[@]}"; do
    DEST="${paths[$SRC]}"

    # Check if source directory exists
    if [ ! -d "$SRC" ]; then
        echo "Error: Source directory $SRC does not exist."
        continue
    fi

    # Check if destination directory exists; if not, create it
    if [ ! -d "$DEST" ]; then
        echo "Destination directory $DEST does not exist. Creating it..."
        mkdir -p "$DEST"
    fi

    # Move contents from source to destination, overwriting existing files and directories
    for item in "$SRC"/*; do
        if [ -e "$item" ]; then
            echo "Moving $(basename "$item") from $SRC to $DEST..."
            move "$item" "$DEST"
        fi
    done
done

sudo mv -f ./.bashrc $HOME/

echo "All specified contents have been moved to their destinations, overwriting existing files if necessary."
