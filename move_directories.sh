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

# Function to copy items with appropriate sudo handling
copy() {
    local src=$1
    local dest=$2

    if [ "$(dirname "$dest")" = "/usr/share" ]; then
        sudo cp -rf "$src" "$dest"
    else
        cp -rf "$src" "$dest"
    fi
}

# Loop through the associative array and copy folders
for SRC in "${!paths[@]}"; do
    DEST="${paths[$SRC]}"

    # Check if source directory exists
    if [ ! -d "$SRC" ]; then
        echo "[WARN] Error: Source directory $SRC does not exist."
        continue
    fi

    # Check if destination directory exists; if not, create it
    if [ ! -d "$DEST" ]; then
        echo "[INFO] Destination directory $DEST does not exist. Creating it..."
        mkdir -p "$DEST"
    fi

    # Copy contents from source to destination, overwriting existing files and directories
    cp -rf "$SRC"/* "$DEST"
    echo "[INFO] Copied contents from $SRC to $DEST"
done

# Copy .bashrc file to home directory
cp -f ./.bashrc "$HOME/"
echo "[INFO] Generated .bashrc file"

# Set SDDM theme to sugar-candy
THEME_NAME="sugar-candy"

# Check if /etc/sddm.conf exists
if [ ! -f /etc/sddm.conf ]; then
    echo "Creating new /etc/sddm.conf..."
    sudo touch /etc/sddm.conf
fi

# Add or update the theme setting in /etc/sddm.conf
sudo bash -c "cat << EOF > /etc/sddm.conf
[Theme]
Current=$THEME_NAME
EOF"

echo "[INFO] SDDM theme set to $THEME_NAME."

echo "[INFO] All specified contents have been copied to their destinations, overwriting existing files if necessary."
