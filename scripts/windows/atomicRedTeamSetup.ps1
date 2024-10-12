# Exit if any command fails
$ErrorActionPreference = "Stop"

# Variables
$InstallPath = "C:\AtomicRedTeam"

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

# Set Execution Policy to allow the script to run if required
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Install NuGet provider if required
if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
    Write-Output "NuGet provider is not installed. Installing NuGet provider..."
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope AllUsers
}

# Install Atomic Red Team using repository instructions
Write-Output "Installing Atomic Red Team..."
IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing);
Install-AtomicRedTeam -getAtomics -Force -InstallPath $InstallPath

# Verification
Write-Output "Installation completed. Atomic Red Team is installed at $InstallPath."
