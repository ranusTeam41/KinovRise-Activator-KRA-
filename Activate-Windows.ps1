function Show-ProgressBar {
    param([string]$Activity, [int]$Seconds)
    for ($i=1; $i -le $Seconds; $i++) {
        Write-Progress -Activity $Activity -Status "$i/$Seconds giây..." -PercentComplete (($i/$Seconds)*100)
        Start-Sleep -Seconds 1
    }
    Write-Progress -Activity $Activity -Completed
}

# Kiểm tra malware
function Check-Malware {
    Write-Host "Malware scan in progress..." -ForegroundColor Yellow
    $malwareIndicators = @(
        "AutoKMS.exe", "KMSpico.exe", "kmsauto.exe",
        "C:\Windows\Temp\kmsauto.log",
        "C:\Windows\System32\Tasks\KMSpico"
    )
    foreach ($item in $malwareIndicators) {
        $fileExists = Test-Path $item
        $procExists = Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -eq ([System.IO.Path]::GetFileNameWithoutExtension($item)) }
        if ($fileExists -or $procExists) {
            Write-Host "Warning: Potential malware detected ($item). Activation aborted." -ForegroundColor Red
            pause
            exit
        }
    }
    Write-Host "No malware detected. Proceeding with activation..." -ForegroundColor Green
}
Check-Malware
Show-ProgressBar -Activity "Activating Windows..." -Seconds 5

Write-Host "Checking Windows activation status..." -ForegroundColor Yellow
$isKMS = cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /dli | Select-String "Volume"
if ($isKMS) {
    Write-Host "Windows is already activated!" -ForegroundColor Green
} else {
    Write-Host "Windows is not activated. Activating..." -ForegroundColor Yellow
    cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
    cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /skms kms.tsforge.net
    cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /ato
    Write-Host "`nActivation result:"
    cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /xpr
}
pause
