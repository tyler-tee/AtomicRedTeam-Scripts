# Exit if any command fails
$ErrorActionPreference = "Stop"

# Variables
$ARTRepoPath = "C:\AtomicRedTeam"
$ModulePath = "$ARTRepoPath\Invoke-AtomicRedTeam"

# Check if Git is installed, if not install Git
if (-not (Get-Command "git" -ErrorAction SilentlyContinue)) {
    Write-Output "Git is not installed. Installing Git..."

    # Download Git installer
    $gitInstallerPath = "$env:TEMP\Git-Installer.exe"
    Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.1/Git-2.42.0-64-bit.exe" -OutFile $gitInstallerPath

    # Run Git installer silently
    Start-Process -FilePath $gitInstallerPath -ArgumentList "/SILENT" -Wait
} else {
    Write-Output "Git is already installed."
}

# Clone Atomic Red Team repository if it doesn't exist
if (-not (Test-Path $ARTRepoPath)) {
    Write-Output "Cloning Atomic Red Team repository to $ARTRepoPath..."
    git clone https://github.com/redcanaryco/atomic-red-team.git $ARTRepoPath
} else {
    Write-Output "Atomic Red Team repository already exists at $ARTRepoPath."
}

# Install PowerShell module Invoke-AtomicRedTeam if not already installed
if (-not (Get-Module -ListAvailable -Name "Invoke-AtomicRedTeam")) {
    Write-Output "Installing Invoke-AtomicRedTeam PowerShell module..."
    Install-Module -Name Invoke-AtomicRedTeam -Force -Scope AllUsers
} else {
    Write-Output "Invoke-AtomicRedTeam PowerShell module is already installed."
}

# Set Execution Policy to allow the script to run if required
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Verification
Write-Output "Installation completed. Atomic Red Team is installed at $ARTRepoPath."
