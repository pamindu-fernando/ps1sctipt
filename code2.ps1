<#
.SYNOPSIS
    A simple script to open the default web browser to the classic Rickroll URL.

.DESCRIPTION
    This script defines the URL for Rick Astley's "Never Gonna Give You Up" and then uses
    the Start-Process cmdlet to launch it in the user's default browser.
    It's a harmless prank and a good example of how to open a website via a script.

.EXAMPLE
    .\rickroll.ps1
    This will immediately open the YouTube video in your default browser.
#>

# Define the URL you want to open
$rickrollUrl = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"

# Use the Start-Process cmdlet to open the URL.
# This is the modern equivalent of just typing a URL into the Run box.
# It will automatically use the default application for that protocol (your browser for https).
Start-Process -FilePath $rickrollUrl

# Add a little message to the console for effect.
Write-Host "You know the rules, and so do I."
