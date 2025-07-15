# my-script.ps1
# This is a sample PowerShell script to be hosted on GitHub.
# It demonstrates basic output and system information retrieval.

Write-Host "Hello from your GitHub-hosted PowerShell script!"
Write-Host "--------------------------------------------------"

# Get current date and time
$currentTime = Get-Date
Write-Host "Current Date and Time: $currentTime"

# Get operating system information
$osInfo = Get-ComputerInfo -Property OsName, OsVersion, OsBuildNumber
Write-Host "Operating System: $($osInfo.OsName)"
Write-Host "OS Version: $($osInfo.OsVersion)"
Write-Host "OS Build: $($osInfo.OsBuildNumber)"

# Get current user
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
Write-Host "Current User: $currentUser"

Write-Host "--------------------------------------------------"
Write-Host "Script execution finished successfully."

# You can add more complex logic here,
# but for a first script, keep it simple and safe!
