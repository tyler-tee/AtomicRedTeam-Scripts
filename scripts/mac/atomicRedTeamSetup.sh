#!/bin/bash

# Exit script if any command fails
set -e

# Variables
LOG_DIR="/opt/art/logs"
ART_REPO="/opt/atomic-red-team"

# Add Homebrew to the PATH
if [ -d "/opt/homebrew/bin" ]; then
    export PATH="/opt/homebrew/bin:$PATH"  # For Apple Silicon (M1/M2) Macs
elif [ -d "/usr/local/bin" ]; then
    export PATH="/usr/local/bin:$PATH"  # For Intel Macs
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Ensure Homebrew is installed
if ! command_exists brew; then
    echo "Homebrew is not installed. Please install Homebrew before running this script."
    exit 1
else
    echo "Homebrew is installed."
fi

# Install PowerShell using Homebrew
if ! command_exists pwsh; then
    echo "Installing PowerShell..."
    brew install --cask powershell
else
    echo "PowerShell is already installed."
fi

# Clone Atomic Red Team repository if it doesn't exist
if [ ! -d "$ART_REPO" ]; then
    echo "Cloning Atomic Red Team repository..."
    git clone https://github.com/redcanaryco/atomic-red-team.git "$ART_REPO"
else
    echo "Atomic Red Team repository already exists."
fi

# Install Invoke-AtomicRedTeam PowerShell module
if ! pwsh -Command "Get-Module -ListAvailable -Name Invoke-AtomicRedTeam" >/dev/null 2>&1; then
    echo "Installing Atomic Test Harness for PowerShell (Invoke-AtomicRedTeam)..."
    pwsh -Command "& {Install-Module -Name Invoke-AtomicRedTeam -Force -Scope AllUsers}"
else
    echo "Invoke-AtomicRedTeam PowerShell module is already installed."
fi

# Set up log directory for test outputs
if [ ! -d "$LOG_DIR" ]; then
    echo "Creating log directory at $LOG_DIR"
    sudo mkdir -p "$LOG_DIR"
    sudo chown -R $(whoami) "$LOG_DIR"
else
    echo "Log directory already exists at $LOG_DIR"
fi

echo "Atomic Red Team setup completed."
