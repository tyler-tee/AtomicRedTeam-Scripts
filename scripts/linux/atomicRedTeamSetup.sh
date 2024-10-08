#!/bin/bash

# Exit script if any command fails
set -e

# Directory to store Atomic Red Team and logs
LOG_DIR="/opt/art/logs"
ART_REPO="/opt/atomic-red-team"
ART_MODULE="$ART_REPO/Invoke-AtomicRedTeam"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install necessary dependencies if not present
install_dependencies() {
    if ! command_exists git; then
        echo "Git not found. Installing Git..."
        sudo apt-get update && sudo apt-get install -y git
    fi

    if ! command_exists curl; then
        echo "Curl not found. Installing Curl..."
        sudo apt-get install -y curl
    fi

    if ! command_exists pwsh; then
        echo "PowerShell not found. Installing PowerShell..."
        sudo apt-get update
        sudo apt-get install -y wget apt-transport-https software-properties-common
        wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
        sudo dpkg -i packages-microsoft-prod.deb
        sudo apt-get update
        sudo apt-get install -y powershell
    fi
}

# Install dependencies
install_dependencies

# Ensure Atomic Red Team repository exists
if [ ! -d "$ART_REPO" ]; then
    echo "Cloning Atomic Red Team repository to $ART_REPO"
    sudo git clone https://github.com/redcanaryco/atomic-red-team.git "$ART_REPO"
else
    echo "Atomic Red Team repository already exists at $ART_REPO"
fi

# Ensure log directory exists
if [ ! -d "$LOG_DIR" ]; then
    echo "Creating log directory at $LOG_DIR"
    sudo mkdir -p "$LOG_DIR"
fi

echo "Atomic Red Team setup completed."
