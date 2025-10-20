<#
.SYNOPSIS
    A prank script that opens the Rickroll video in full-screen, with system volume and brightness set to maximum.

.DESCRIPTION
    This script performs a sequence of actions for maximum prank effect:
    1. Sets the monitor brightness to 100% using WMI.
    2. Sets the system master audio volume to 100% using the Windows Core Audio API.
    3. Opens the Rickroll YouTube video in the default web browser.
    4. Waits a few seconds for the browser to load and become the active window.
    5. Sends the F11 key to make the browser enter full-screen mode.

.NOTES
    - The brightness control uses WMI and should work on most modern systems (especially laptops).
    - The volume control now uses a much more reliable method by directly accessing the system's
      audio endpoint via an embedded C# class. This avoids unreliable keystroke simulation.
    - Run this from a PowerShell terminal.
#>

# --- Step 1: Set Monitor Brightness to 100% ---
try {
    $monitor = Get-WmiObject -Namespace root/wmi -Class WmiMonitorBrightnessMethods
    $monitor.WmiSetBrightness(0, 100)
    Write-Host "Brightness set to maximum." -ForegroundColor Green
}
catch {
    Write-Warning "Could not set monitor brightness. This feature may not be supported on your display."
}


# --- Step 2: Set System Volume to 100% (Most Reliable Method) ---
# This block embeds C# code to directly control the master volume via the Core Audio API.
# This is far more reliable than sending keystrokes.
try {
    $cSharpCode = @"
    using System.Runtime.InteropServices;
    
    [ComImport]
    [Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    internal interface IMMDeviceEnumerator {
        void _VtblGap1_1();
        int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice ppDevice);
    }

    [ComImport]
    [Guid("5CDF2C82-841E-4546-9722-0CF74078229A"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    internal interface IAudioEndpointVolume {
        void _VtblGap1_2();
        int SetMasterVolumeLevelScalar(float fLevel, System.Guid pguidEventContext);
        void _VtblGap2_1();
        int GetMasterVolumeLevelScalar(out float pfLevel);
    }
    
    [ComImport]
    [Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    internal interface IMMDevice {
        int Activate([MarshalAs(UnmanagedType.LPStruct)] System.Guid iid, int dwClsCtx, System.IntPtr pActivationParams, [MarshalAs(UnmanagedType.IUnknown)] out object ppInterface);
    }

    public class VolumeControl {
        public static void SetMasterVolume(float volumeLevel) {
            IMMDeviceEnumerator enumerator = (IMMDeviceEnumerator)new MMDeviceEnumerator();
            enumerator.GetDefaultAudioEndpoint(0, 1, out IMMDevice dev);
            dev.Activate(typeof(IAudioEndpointVolume).GUID, 0, System.IntPtr.Zero, out object epvObj);
            IAudioEndpointVolume epv = (IAudioEndpointVolume)epvObj;
            epv.SetMasterVolumeLevelScalar(volumeLevel, System.Guid.Empty);
        }
    }

    [ComImport]
    [Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")]
    internal class MMDeviceEnumerator { }
"@
    
    Add-Type -TypeDefinition $cSharpCode
    Write-Host "Setting volume to maximum..." -ForegroundColor Green
    # The volume level is a float from 0.0 (0%) to 1.0 (100%).
    [VolumeControl]::SetMasterVolume(1.0)
}
catch {
    Write-Warning "Could not set system volume using the Core Audio API."
}


# --- Step 3: Launch the Rickroll and Go Full-Screen ---
$rickrollUrl = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"

Write-Host "Launching browser..." -ForegroundColor Green
Start-Process -FilePath $rickrollUrl

# Wait for 5 seconds to give the browser time to open and the video to start loading
Write-Host "Waiting for the browser to load..."
Start-Sleep -Seconds 5

# Send the F11 key to the currently active window (which should be the browser)
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

