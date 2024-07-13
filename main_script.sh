#!/bin/bash

# Define paths to the scripts
INSTALL_PACKAGES_SCRIPT="./install_packages.sh"
MOVE_DIRECTORIES_SCRIPT="./move_directories.sh"
EXTRACT_AND_UPDATE_SCRIPT="./restore_font.sh"
START_SERVICES_SCRIPT="./enable_and_start_services.sh"

# Function to execute a script if it exists and is executable
run_script() {
    local script_path=$1
    local script_name=$2

    if [ -x "$script_path" ]; then
        echo "[INFO] Running $script_name..."
        "$script_path"
    else
        echo "[WARN] Error: $script_name not found or not executable."
        exit 1
    fi
}

# Run each script
run_script "$INSTALL_PACKAGES_SCRIPT" "install_packages.sh"
run_script "$EXTRACT_AND_UPDATE_SCRIPT" "extract_and_update.sh"
run_script "$START_SERVICES_SCRIPT" "enable_and_start_services.sh"

# Decorative output with "Neptune" ASCII art
echo -e "\n\033[1m\033[34m
   _   _       _ _     _             
  | | | |_ __ (_) |_  (_) __ _ _ __  
  | | | | '_ \| | __| | |/ _\` | '_ \ 
  | |_| | | | | | |_  | | (_| | | | |
   \___/|_| |_|_|\__| |_|\__,_|_| |_|

\033[0m"

echo -e "\n[INFO] All scripts have been executed successfully.\n\033[1mWELCOME TO NEPTUNE!\033[0m"

sudo systemctl start sddm
