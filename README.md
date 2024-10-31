# Atomic Red Team Automation

Multiplatform scripts used to orchestrate the setup and execution of Atomic Red Team tests across various environments. This repository provides scripts to facilitate and streamline the deployment, execution, and cleanup of Atomic Red Team tests, helping security professionals simulate and test adversarial techniques on different platforms.

## Features
- **Automated Setup**: Configure environments and install dependencies needed for Atomic Red Team tests.
- **Cross-Platform Support**: Run on macOS, Linux, and Windows with platform-specific scripts.
- **Execution and Cleanup**: Execute tests and clean up artifacts, ensuring system integrity after testing.

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/tyler-tee/atomic-red-team-automation.git
   cd atomic-red-team-automation
   ```
2. Run the appropriate setup script based on your platform (macOS/Linux/Windows).

## Usage
- To execute Atomic Red Team tests, run the respective script for your operating system:
  ```bash
  ./scripts/setup-macos.sh    # For macOS
  ./scripts/setup-linux.sh    # For Linux
  ./scripts/setup-windows.ps1 # For Windows
  ```
- The scripts handle both setup and execution, guiding you through any required configurations.

## Platform-Specific Notes
Each script is tailored to its respective platform. Be sure to review any specific instructions within the script files for optimal compatibility.

## License
This project is licensed under the MIT License.
