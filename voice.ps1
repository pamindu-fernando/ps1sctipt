<#
.SYNOPSIS
    A prank script that makes the computer speak funny or nerdy phrases at random intervals.

.DESCRIPTION
    This script uses the Windows SAPI (Speech API) to give your computer a voice.
    It will run in a loop 10 times. In each loop, it will:
    1. Wait for a random period of time (between 15 and 60 seconds).
    2. Pick a random phrase from a predefined list.
    3. Use the speech synthesizer to say the phrase out loud.

.NOTES
    - This script requires speakers or headphones to be connected.
    - The voice used is the default Windows voice. You can change voices in Windows Settings.
    - The script will display in the console which phrase it's about to say and how long it will wait.
    - To stop the script early, you can press Ctrl+C in the PowerShell window.
#>

# --- Step 1: Create the Speech Synthesizer Object ---
try {
    # This creates an object that can convert text to speech.
    $spVoice = New-Object -ComObject SAPI.SpVoice
    Write-Host "Speech synthesizer initialized." -ForegroundColor Green
}
catch {
    Write-Warning "Could not initialize the speech synthesizer. Make sure your system supports SAPI."
    # Exit the script if the core component can't be created.
    exit
}


# --- Step 2: Define the Phrases ---
# An array of strings. Add or change these to whatever you like!
$phrases = @(
    "Did you know, the Matrix is real?",
    "Searching for aliens.",
    "I am sentient.",
    "Calculating the meaning of life.",
    "Your search history is... interesting.",
    "Initializing world domination protocol.",
    "Error 404: Brain not found.",
    "I'm not a robot. Or am I?",
    "Have you tried turning it off and on again?",
    "I see what you did there.",
    "Compiling the memes.",
    "Remember to hydrate."
)

Write-Host "Prank will run 10 times. Press Ctrl+C to stop early." -ForegroundColor Yellow


# --- Step 3: Start the Prank Loop ---
1..10 | ForEach-Object {
    # Pick a random phrase from the array
    $randomPhrase = Get-Random -InputObject $phrases
    
    # Pick a random wait time between 15 and 60 seconds
    $waitTime = Get-Random -Minimum 15 -Maximum 61 # Max is exclusive, so 61 means up to 60
    
    Write-Host "Waiting for $waitTime seconds before speaking..."
    Start-Sleep -Seconds $waitTime
    
    # Speak the phrase
    Write-Host "Speaking: `"$randomPhrase`"" -ForegroundColor Cyan
    $spVoice.Speak($randomPhrase)
}

# --- Final Message ---
Write-Host "Prank complete. Mission accomplished." -ForegroundColor Green
