# KinovRise Activator 1.0 - PowerShell Version
# Run this script with Administrator privileges
Clear-Host
function Show-Menu {
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "          KinovRise Activator 1.0"
    Write-Host "============================================"
    Write-Host "[1] Activate Windows"
    Write-Host "[2] Activate Office"
    Write-Host "[3] Exit"
    Write-Host "============================================"
}

function Activate-Windows {
    $confirm = Read-Host "Do you want to activate Windows? (Y/N)"
    if ($confirm -ieq "Y") {
        Clear-Host
        Write-Host "Checking Windows activation status..." -ForegroundColor Yellow

        $isKMS = cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /dli | Select-String "Volume"

        if ($isKMS) {
            Write-Host "Windows is already activated !" -ForegroundColor Green
        } else {
            Write-Host "Windows is not activated. Activating..." -ForegroundColor Yellow
            cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
            cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /skms kms.tsforge.net
            cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /ato
            Write-Host "`nActivation result:"
            cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /xpr
        }
        Pause
    }
}

function Activate-Office {
    $confirm = Read-Host "Convert Retail to LTSC and activate Office? (Y/N)"
    if ($confirm -ieq "Y") {
        Clear-Host
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
            Pause
            return
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

        Pause
    }
}

do {
    Clear-Host
    Show-Menu
    $choice = Read-Host "Enter your choice"
    switch ($choice) {
        "1" { Activate-Windows }
        "2" { Activate-Office }
        "3" { break }
        default { Write-Host "Invalid choice. Try again." -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
} while ($true)
