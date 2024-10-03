#!/bin/bash

# Exit script if any command fails
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Full paths to binaries
BREW_BIN="/opt/homebrew/bin/brew"
POWERSHELL_BIN="/usr/local/bin/pwsh"
GIT_BIN="/usr/bin/git"

# Install Homebrew if it's not installed
if ! command_exists brew; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /etc/profile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
fi

# Install PowerShell if it's not installed
if ! command_exists pwsh; then
    echo "Installing PowerShell..."
    $BREW_BIN install --cask powershell
else
    echo "PowerShell is already installed."
fi

# Install Atomic Red Team
if [ ! -d "/opt/atomic-red-team" ]; then
    echo "Cloning Atomic Red Team repository..."
    $GIT_BIN clone https://github.com/redcanaryco/atomic-red-team.git /opt/atomic-red-team
    echo "Installing Atomic Test Harness for PowerShell (Invoke-AtomicRedTeam)..."
    $POWERSHELL_BIN -Command "& {Install-Module -Name Invoke-AtomicRedTeam -Force -Scope AllUsers}"
else
    echo "Atomic Red Team is already installed."
fi

# Fetch the latest Atomic tests
echo "Fetching the latest Atomic tests..."
cd /opt/atomic-red-team
$GIT_BIN pull origin main

echo "Atomic Red Team and tests have been installed and updated."

# Add Atomic Red Team to system-wide PATH
if ! grep -q 'export PATH="$PATH:/opt/atomic-red-team"' /etc/profile; then
    echo 'export PATH="$PATH:/opt/atomic-red-team"' >> /etc/profile
    echo "Added Atomic Red Team to system-wide PATH."
fi

echo "Installation complete."
