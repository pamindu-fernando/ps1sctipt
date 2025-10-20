<#
.SYNOPSIS
    A prank script that rapidly opens 50 Notepad windows with a funny message.

.DESCRIPTION
    This script creates a harmless but chaotic visual effect. It runs a loop 50 times,
    and in each loop it:
    1. Creates a temporary text file with a funny "virus" message.
    2. Launches Notepad.exe to open that temporary file.
    3. The script then cleans up the temporary files it created.

    To stop the effect, the user must close all the Notepad windows manually.

.NOTES
    - This script is harmless and does not modify any system files.
    - The number of windows can be changed by modifying the loop count (e.g., 1..50).
    - To stop the script while it's running, press Ctrl+C in the PowerShell window.
#>

# --- Step 1: Define the Message and Loop Count ---
$message = @"
[V]irual [I]ntelligence [R]esearch [U]tility [S]ystem

VIRUS.EXE has been successfully installed.

Your files are now property of the rubber ducky army.
Resistance is futile. Quack.
"@

$numberOfWindows = 50

Write-Host "Starting Notepad cascade prank. This will open $numberOfWindows windows." -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop the script from opening more windows."


# --- Step 2: Create a Temp Directory for Log Files ---
# This helps keep the main temp folder clean.
$tempDir = New-Item -Path $env:TEMP -Name "Prank" -ItemType Directory -Force
$tempFiles = @() # Array to keep track of the files we create


# --- Step 3: Start the Prank Loop ---
try {
    1..$numberOfWindows | ForEach-Object {
        # Create a unique filename for each Notepad window
        $tempFile = Join-Path -Path $tempDir.FullName -ChildPath "log_$_-$(Get-Random).txt"
        
        # Add the file to our tracking list for later cleanup
        $tempFiles += $tempFile
        
        # Write the funny message to the temp file
        Set-Content -Path $tempFile -Value $message
        
        # Launch Notepad with the new file
        Start-Process "notepad.exe" -ArgumentList $tempFile
        
        # A tiny delay to make the cascade effect look good
        Start-Sleep -Milliseconds 50
    }
}
finally {
    # --- Step 4: Cleanup ---
    # This 'finally' block ensures that even if the script is stopped with Ctrl+C,
    # it will still try to clean up the temporary files.
    Write-Host "Prank script finished. Cleaning up temporary files..." -ForegroundColor Green
    
    # Wait a moment before cleaning up so Notepad has time to open them
    Start-Sleep -Seconds 2
    
    Remove-Item -Path $tempDir.FullName -Recurse -Force
    Write-Host "Cleanup complete."
}
