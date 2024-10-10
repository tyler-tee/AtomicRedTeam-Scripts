# Exit script if any command fails
$ErrorActionPreference = "Stop"

# Variables
$LOG_DIR = "C:\AtomicRedTeam\Logs"
$ART_MODULE_PATH = "C:\AtomicRedTeam\Invoke-AtomicRedTeam"

# Ensure the Atomic Red Team module is installed
if (-not (Get-Module -ListAvailable -Name Invoke-AtomicRedTeam)) {
    Write-Output "Invoke-AtomicRedTeam PowerShell module is not installed. Please install it before running this script."
    exit 1
}

# Ensure log directory exists
if (-not (Test-Path $LOG_DIR)) {
    New-Item -ItemType Directory -Path $LOG_DIR
}

# List of Atomic Red Team tests to run (example)
$tests_to_run = "T1003", "T1059.001"

# Run each test and log output
foreach ($test in $tests_to_run) {
    $log_file = "$LOG_DIR\$test.json"
    Write-Output "Running Atomic Test: $test and logging to $log_file"
    
    # Execute the test and log the output
    Invoke-AtomicTest $test -LoggingModule 'Invoke-AtomicLogger' -ExecutionLogPath $log_file

    # Check if log file was created
    if (Test-Path $log_file) {
        Write-Output "Test log saved to $log_file"
    } else {
        Write-Output "Test log for $test was not created."
    }
}

# Check Windows Defender logs for any alerts
Write-Output "Checking Windows Defender logs for any detections..."

# Search Windows Defender event logs for detections
$defender_logs = Get-WinEvent -LogName "Microsoft-Windows-Windows Defender/Operational" | 
    Where-Object { $_.Message -match "threat" -or $_.Message -match "detected" }

# Display Defender log detections
if ($defender_logs) {
    Write-Output "Windows Defender detected the following threats:"
    foreach ($log in $defender_logs) {
        Write-Output $log.Message
    }
} else {
    Write-Output "No threats detected by Windows Defender."
}

Write-Output "Atomic Red Team tests completed."
