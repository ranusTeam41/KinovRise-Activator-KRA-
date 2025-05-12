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
    cscript.exe //nologo $ospp /unpkey:XXXXX
    cscript.exe //nologo $ospp /inpkey:FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH
    cscript.exe //nologo $ospp /sethst:kms.tsforge.net
    cscript.exe //nologo $ospp /act
    Write-Host "`nOffice Activation Status:"
    cscript.exe //nologo $ospp /dstatus
} else {
    Write-Host "Office is either already activated or not Retail." -ForegroundColor Green
}
pause
