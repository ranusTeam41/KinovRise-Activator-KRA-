# Silent menu downloader/runner for KinovRise

$batPath = "$env:TEMP\KinovRiseMenu.bat"
$batchUrl = "https://raw.githubusercontent.com/ranusTeam41/kinovrise/main/KinovRiseMenu.bat"

$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile($batchUrl, $batPath)

$proc = Start-Process "cmd.exe" -ArgumentList "/c `"$batPath`"" -PassThru
$proc.WaitForExit()
Remove-Item $batPath -ErrorAction SilentlyContinue