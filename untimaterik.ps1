<#
.SYNOPSIS
    A prank script that opens the Rickroll video in full-screen, with system volume and brightness set to maximum.

.DESCRIPTION
    This script performs a sequence of actions for maximum prank effect:
    1. Sets the monitor brightness to 100% using WMI.
    2. Sets the system audio volume to 100% by sending the "Volume Up" key multiple times.
    3. Opens the Rickroll YouTube video in the default web browser.
    4. Waits a few seconds for the browser to load and become the active window.
    5. Sends the F11 key to make the browser enter full-screen mode.

.NOTES
    - The brightness control uses WMI and should work on most modern systems (especially laptops),
      but may not work on all external monitors.
    - The volume control now uses the Wscript.Shell COM object for better reliability.
    - Run this from a PowerShell terminal.
#>

# --- Step 1: Set Monitor Brightness to 100% ---
try {
    # Get the WMI object that controls monitor brightness
    $monitor = Get-WmiObject -Namespace root/wmi -Class WmiMonitorBrightnessMethods
    # The first parameter is a timeout, the second is the brightness level (0-100)
    $monitor.WmiSetBrightness(0, 100)
    Write-Host "Brightness set to maximum." -ForegroundColor Green
}
catch {
    Write-Warning "Could not set monitor brightness. This feature may not be supported on your display."
}


# --- Step 2: Set System Volume to 100% (More Reliable Method) ---
# This method uses the Wscript.Shell COM object which can be more reliable for sending media keys.
try {
    $wshell = New-Object -ComObject Wscript.Shell
    Write-Host "Setting volume to maximum..." -ForegroundColor Green
    # Send the "Volume Up" key 50 times to ensure it reaches 100% from 0%
    1..50 | ForEach-Object {
        # [char]0xAF is the hex code for the VOLUME_UP media key.
        $wshell.SendKeys([char]0xAF)
        # Add a very small delay to ensure each key press is registered by the system.
        Start-Sleep -Milliseconds 20
    }
}
catch {
    Write-Warning "Could not create Wscript.Shell object to control volume."
}


# --- Step 3: Launch the Rickroll and Go Full-Screen ---
$rickrollUrl = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"

Write-Host "Launching browser..." -ForegroundColor Green
Start-Process -FilePath $rickrollUrl

# Wait for 5 seconds to give the browser time to open and the video to start loading
Write-Host "Waiting for the browser to load..."
Start-Sleep -Seconds 5

# Send the F11 key to the currently active window (which should be the browser)
# We need to load the .NET assembly to send the F11 key.
try {
    Add-Type -AssemblyName System.Windows.Forms
    Write-Host "Engaging full-screen mode." -ForegroundColor Green
    [System.Windows.Forms.SendKeys]::SendWait("{F11}")
}
catch {
    Write-Warning "Could not load assembly to send F11 key."
}


# --- Final Message ---
Write-Host "A full commitment's what I'm thinking of." -ForegroundColor Cyan

