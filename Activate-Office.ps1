function Check-Malware {
    Write-Host "Malware scan in progress..." -ForegroundColor Yellow
    $malwareIndicators = @(
        "AutoKMS.exe", "KMSpico.exe", "kmsauto.exe",
        "C:\Windows\Temp\kmsauto.log",
        "C:\Windows\System32\Tasks\KMSpico"
    )
    $foundMalware = $false
    foreach ($item in $malwareIndicators) {
        $fileExists = Test-Path $item
        $procExists = Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -eq ([System.IO.Path]::GetFileNameWithoutExtension($item)) }
        if ($fileExists -or $procExists) {
            Write-Host "Warning: Potential malware detected ($item). Activation will not proceed." -ForegroundColor Red
            $foundMalware = $true
        }
    }
    if (-not $foundMalware) {
        Write-Host "No malware detected. Proceeding with activation..." -ForegroundColor Green
        return $true
    } else {
        Write-Host "Activation aborted due to malware detection." -ForegroundColor Red
        return $false
    }
}

function Show-ProgressBar {
    param([string]$Activity, [int]$Seconds)
    for ($i=1; $i -le $Seconds; $i++) {
        Write-Progress -Activity $Activity -Status "$i/$Seconds seconds..." -PercentComplete (($i/$Seconds)*100)
        Start-Sleep -Seconds 1
    }
    Write-Progress -Activity $Activity -Completed
}

if (Check-Malware) {
    Show-ProgressBar -Activity "Activating Office..." -Seconds 5

    Write-Host "Checking for installed Office..." -ForegroundColor Yellow

    $officePaths = @(
        "C:\Program Files\Microsoft Office\Office16",
        "C:\Program Files\Microsoft Office\Office15",
        "C:\Program Files (x86)\Microsoft Office\Office16",
        "C:\Program Files (x86)\Microsoft Office\Office15"
    )

    $ospp = $null
    foreach ($path in $officePaths) {
        if (Test-Path "$path\ospp.vbs") {
            $ospp = "$path\ospp.vbs"
            break
        }
    }

    if (-not $ospp) {
        Write-Host "Office not found or unsupported version." -ForegroundColor Red
        pause
        exit
    }

    $status = cscript.exe //nologo $ospp /dstatus | Select-String "RETAIL"

    if ($status) {
        Write-Host "Retail Office detected. Activating..." -ForegroundColor Yellow
        cscript.exe //nologo $ospp /unpkey:XXXXX | Out-Null
        cscript.exe //nologo $ospp /inpkey:FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH | Out-Null
        cscript.exe //nologo $ospp /sethst:kms.digiboy.ir | Out-Null
        cscript.exe //nologo $ospp /act | Out-Null
        Write-Host "`nOffice Activation Status:"
        cscript.exe //nologo $ospp /dstatus
    } else {
        Write-Host "Office is either already activated or not Retail." -ForegroundColor Green
    }
}
pause
