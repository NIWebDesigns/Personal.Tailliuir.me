# Function to open the application's URL
function Open-AppURL {
    param (
        [string]$AppName,
        [string]$URL
    )
    Write-Host "Opening download page for $($AppName)..."
    try {
        Start-Process $URL
        Write-Host "--- Opened $($AppName)'s URL: $($URL) ---`n"
    }
    catch {
        Write-Warning "Failed to open URL for $($AppName): $($_.Exception.Message)"
    }
}

# Main script logic
function Main {
    $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
    $appConfigFile = Join-Path $scriptPath "applications.json"

    if (-not (Test-Path $appConfigFile)) {
        Write-Error "Application configuration file not found: $($appConfigFile)"
        return
    }

    try {
        $appData = Get-Content $appConfigFile | ConvertFrom-Json
        $applications = $appData.apps | Sort-Object Name
    }
    catch {
        Write-Error "Failed to load or parse applications.json: $($_.Exception.Message)"
        return
    }

    if (-not $applications) {
        Write-Host "No applications found in the configuration file."
        return
    }

    $selectedApps = @()
    $running = $true

    while ($running) {
        Clear-Host
        Write-Host "--- Simple App Manager (URL Mode) ---"
        Write-Host "Available Applications:`n"

        for ($i = 0; $i -lt $applications.Count; $i++) {
            $app = $applications[$i]
            $status = if ($selectedApps -contains $app) { "[SELECTED]" } else { "" }
            Write-Host "$($i + 1). $($app.name) (`$($app.category)) $status"
        }

        Write-Host "`nSelected: $($($selectedApps.Name) -join ', ')"
        Write-Host "`nOptions:"
        Write-Host "  S - Select/Deselect an app by number"
        Write-Host "  O - Open URL for selected apps"
        Write-Host "  C - Clear selection"
        Write-Host "  Q - Quit"

        $choice = Read-Host "`nEnter your choice (number, S, O, C, Q)"

        switch ($choice.ToUpper()) {
            "S" {
                $appNumber = Read-Host "Enter the number of the app to select/deselect"
                if ($appNumber -match '^\d+$' -and $appNumber -ge 1 -and $appNumber -le $applications.Count) {
                    $index = [int]$appNumber - 1
                    $appToToggle = $applications[$index]
                    if ($selectedApps -contains $appToToggle) {
                        $selectedApps = $selectedApps | Where-Object { $_ -ne $appToToggle }
                        Write-Host "$($appToToggle.name) deselected."
                    } else {
                        $selectedApps += $appToToggle
                        Write-Host "$($appToToggle.name) selected."
                    }
                } else {
                    Write-Warning "Invalid app number."
                }
                Start-Sleep -Seconds 1 # Give user time to read feedback
            }
            "O" {
                if ($selectedApps.Count -eq 0) {
                    Write-Warning "No apps selected to open URL."
                } else {
                    foreach ($app in $selectedApps) {
                        Open-AppURL -AppName $app.name -URL $app.url
                    }
                    $selectedApps = @() # Clear selection after action
                }
                Read-Host "Press Enter to continue..."
            }
            "C" {
                $selectedApps = @()
                Write-Host "Selection cleared."
                Start-Sleep -Seconds 1
            }
            "Q" {
                $running = $false
                Write-Host "Exiting App Manager. Goodbye!"
            }
            default {
                Write-Warning "Invalid choice. Please try again."
                Start-Sleep -Seconds 1
            }
        }
    }
}

# Run the main function
Main
