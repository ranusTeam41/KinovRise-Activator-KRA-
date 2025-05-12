

$batPath = "$env:TEMP\KinovRiseMenu.bat"
$batchUrl = "https://raw.githubusercontent.com/ranusTeam41/kinovrise/main/KinovRiseMenu.bat"


Write-Host "Downloading menu..." -ForegroundColor Cyan
$webClient = New-Object System.Net.WebClient
$webClient.DownloadProgressChanged += {
    $pct = $_.ProgressPercentage
    Write-Progress -Activity "Downloading KinovRiseMenu.bat" -Status "$pct% Complete" -PercentComplete $pct
}
$webClient.DownloadFileAsync($batchUrl, $batPath)

while ($webClient.IsBusy) {
    Start-Sleep -Milliseconds 200
}

Write-Progress -Activity "Downloading KinovRiseMenu.bat" -Completed
Write-Host "Download complete.`nLaunching menu..." -ForegroundColor Green


$proc = Start-Process "cmd.exe" -ArgumentList "/c `"$batPath`"" -PassThru


$proc.WaitForExit()
Remove-Item $batPath -ErrorAction SilentlyContinue
Write-Host "Menu closed and cleaned up." -ForegroundColor Yellow
