function Show-ProgressBar {
    param([string]$Activity, [int]$Seconds)
    for ($i=1; $i -le $Seconds; $i++) {
        Write-Progress -Activity $Activity -Status "$i/$Seconds giây..." -PercentComplete (($i/$Seconds)*100)
        Start-Sleep -Seconds 1
    }
    Write-Progress -Activity $Activity -Completed
}

function Check-Malware {
    Write-Host "Đang quét malware..." -ForegroundColor Yellow
    $malwareIndicators = @(
        "AutoKMS.exe", "KMSpico.exe", "kmsauto.exe",
        "C:\Windows\Temp\kmsauto.log",
        "C:\Windows\System32\Tasks\KMSpico"
    )
    foreach ($item in $malwareIndicators) {
        if (Test-Path $item -or (Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -eq [System.IO.Path]::GetFileNameWithoutExtension($item) })) {
            Write-Host "Phát hiện malware ($item). Hủy kích hoạt." -ForegroundColor Red
            pause
            exit
        }
    }
    Write-Host "Không phát hiện malware, bắt đầu kích hoạt..." -ForegroundColor Green
}

Check-Malware
Show-ProgressBar -Activity "Đang kích hoạt Office..." -Seconds 5

Write-Host "Đang kiểm tra Office đã cài đặt..." -ForegroundColor Yellow

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
    Write-Host "Không tìm thấy Office hoặc không hỗ trợ." -ForegroundColor Red
    pause
    exit
}

$status = cscript.exe //nologo $ospp /dstatus | Select-String "RETAIL"

if ($status) {
    Write-Host "Đã phát hiện Office Retail. Đang kích hoạt..." -ForegroundColor Yellow
    # KHÔNG hiện lệnh, chỉ thông báo tiến trình
    cscript.exe //nologo $ospp /unpkey:XXXXX | Out-Null
    cscript.exe //nologo $ospp /inpkey:FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH | Out-Null
    cscript.exe //nologo $ospp /sethst:kms.tsforge.net | Out-Null
    cscript.exe //nologo $ospp /act | Out-Null
    Write-Host "`nTrạng thái kích hoạt Office:"
    cscript.exe //nologo $ospp /dstatus
} else {
    Write-Host "Office đã kích hoạt hoặc không phải bản Retail." -ForegroundColor Green
}
pause
