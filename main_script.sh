#!/bin/bash

# Define paths to the scripts
INSTALL_PACKAGES_SCRIPT="./install_packages.sh"
MOVE_DIRECTORIES_SCRIPT="./move_directories.sh"
EXTRACT_AND_UPDATE_SCRIPT="./restore_font.sh"
START_SERVICES_SCRIPT="./enable_and_start_services.sh"

# Check if install_packages.sh exists and is executable
if [ -x "$INSTALL_PACKAGES_SCRIPT" ]; then
    echo "Running install_packages.sh..."
    "$INSTALL_PACKAGES_SCRIPT"
else
    echo "Error: $INSTALL_PACKAGES_SCRIPT not found or not executable."
    exit 1
fi

# Check if extract_and_update.sh exists and is executable
if [ -x "$EXTRACT_AND_UPDATE_SCRIPT" ]; then
    echo "Running extract_and_update.sh..."
    "$EXTRACT_AND_UPDATE_SCRIPT"
else
    echo "Error: $EXTRACT_AND_UPDATE_SCRIPT not found or not executable."
    exit 1
fi

echo "All scripts have been executed successfully.\nWELCOME TO NEPTUNE!"
