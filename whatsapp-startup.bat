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

# Step 3: Attempt to close the captured process
if ($null -eq $whatsAppProcess) {
    
} else {
    try {
        $whatsAppProcess.CloseMainWindow() | Out-Null
    } catch {
    }
}
