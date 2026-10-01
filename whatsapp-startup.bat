<# : 2>nul
@echo off
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression (Get-Content '%~f0' -Raw)"
exit /b %errorlevel%
#>

# --- PowerShell code starts here ---
# Step 1: Launch WhatsApp
$startInfo = New-Object System.Diagnostics.ProcessStartInfo
$startInfo.FileName = "whatsapp:"
$startInfo.UseShellExecute = $true
[System.Diagnostics.Process]::Start($startInfo) | Out-Null

# Step 2: Wait for WhatsApp window
$whatsAppProcess = $null
$timeoutSeconds = 30
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# Loop until we find a WhatsApp process with a valid window handle OR time runs out
while ($null -eq $whatsAppProcess -and $stopwatch.Elapsed.TotalSeconds -lt $timeoutSeconds) {
    $waProcesses = Get-Process -Name "*WhatsApp*" -ErrorAction SilentlyContinue
    
    if ($waProcesses) {
        foreach ($proc in $waProcesses) {
            # Check if this specific process thread has drawn a window
            if ($proc.MainWindowHandle -ne [IntPtr]::Zero) {
                $whatsAppProcess = $proc
                break
            }
        }
    }
    
    # If not found yet, wait a quarter of a second before checking again
    if ($null -eq $whatsAppProcess) {
        Start-Sleep -Milliseconds 250
    }
}

# Step 3: Wait for WhatsApp to finish loading (CPU Idle) then close
if ($null -ne $whatsAppProcess) {
    
    $cpuUsageSettled = $false
    $idleChecks = 0
    
    # Give it a max of 15 extra seconds to load so the script doesn't hang forever
    $loadTimeout = 15 
    $loadStopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    while (-not $cpuUsageSettled -and $loadStopwatch.Elapsed.TotalSeconds -lt $loadTimeout) {
        # Check current CPU time
        $cpu1 = $whatsAppProcess.TotalProcessorTime
        Start-Sleep -Milliseconds 500
        
        # Refresh the process stats and check CPU time again
        $whatsAppProcess.Refresh()
        $cpu2 = $whatsAppProcess.TotalProcessorTime
        
        # If the CPU time difference is tiny, the app is idling
        if (($cpu2 - $cpu1).TotalMilliseconds -lt 15) {
            $idleChecks++
            # Require 3 consecutive idle checks (1.5 seconds of peace) to confirm it loaded
            if ($idleChecks -ge 3) { 
                $cpuUsageSettled = $true 
            }
        } else {
            # It's still loading/syncing, reset the counter
            $idleChecks = 0
        }
    }
    
    # Step 4: Safely close the window now that it's loaded
    try {
        $whatsAppProcess.CloseMainWindow() | Out-Null
    } catch {
        # Silently fail if the process already closed
    }
}
