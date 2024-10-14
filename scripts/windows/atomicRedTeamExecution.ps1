# Exit if any command fails
$ErrorActionPreference = "Stop"

# Variables
$InstallPath = "C:\AtomicRedTeam"
$LogDir = "C:\AtomicRedTeam\Logs"

# Function to check if a command exists
function Command-Exists {
    param ($command)
    try {
        Get-Command $command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

# Check if Git is installed, if not, install Git
if (-not (Command-Exists "git")) {
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
Install-Module -Name invoke-atomicredteam,powershell-yaml -Scope AllUsers;
Install-AtomicRedTeam -getAtomics -Force -InstallPath $InstallPath

# Ensure log directory exists
if (-not (Test-Path -Path $LogDir)) {
    Write-Output "Creating log directory at $LogDir"
    New-Item -Path $LogDir -ItemType Directory | Out-Null
} else {
    Write-Output "Log directory already exists at $LogDir"
}

# Verification
Write-Output "Installation completed. Atomic Red Team is installed at $InstallPath."
