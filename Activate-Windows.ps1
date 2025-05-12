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
