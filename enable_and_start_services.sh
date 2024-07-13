#!/bin/bash

# Array of services to enable and start
services=(
    "NetworkManager"
    "bluetooth"
    "sddm"
)

# Function to enable and start a service
enable_and_start_service() {
    local service=$1
    
    echo "[INFO] Enabling $service..."
    sudo systemctl enable "$service"
    
    echo "[INFO] Starting $service..."
    sudo systemctl start "$service"
    
    echo "[INFO] $service enabled and started."
}

# Loop through the services array and enable/start each service
for service in "${services[@]}"; do
    enable_and_start_service "$service"
done

echo "[INFO] All specified services have been enabled and started."
