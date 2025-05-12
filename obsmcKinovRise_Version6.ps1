# English menu, input validation, loop until Exit

$menu = @(
    @{Name="Activate Windows"; EncFile="Active-Windows.enc"},
    @{Name="Activate Office";  EncFile="Active-Office.enc"},
    @{Name="Exit"; EncFile=""}
)

function Show-Menu {
    Write-Host "`n========= KinovRise Loader ========="
    for ($i=0; $i -lt $menu.Count; $i++) {
        Write-Host ("({0}) {1}" -f ($i+1), $menu[$i].Name)
    }
    Write-Host "(q) Back to menu"
}

while ($true) {
    Show-Menu
    $choice = Read-Host "Select a function (1-${($menu.Count)})"
    if ($choice -eq 'q') { continue }
    if ($choice -eq '3') { Write-Host "Exit."; break }
    if ($choice -notmatch '^[1-2]$') { Write-Host "Invalid!"; continue }

    $encFile = $menu[$choice-1].EncFile
    if ([string]::IsNullOrEmpty($encFile)) { Write-Host "Exit."; break }

    $encUrl = "https://raw.githubusercontent.com/ranusTeam41/kinovrise/main/$encFile"
    $key = "j5rD4N!8xQw@2eTfZlVmAsYuGkLpOiRe" # Must be exactly 32 characters

    try {
        $enc = Invoke-RestMethod -Uri $encUrl
        if ([string]::IsNullOrEmpty($enc)) { throw "Encrypted file is empty or missing!" }
        $raw = [Convert]::FromBase64String($enc)
        $iv = $raw[0..15]
        $data = $raw[16..($raw.Length-1)]
        $aes = [Security.Cryptography.Aes]::Create()
        $aes.Key = [Text.Encoding]::UTF8.GetBytes($key)
        $aes.IV = $iv
        $aes.Mode = "CBC"
        $aes.Padding = "PKCS7"
        $decryptor = $aes.CreateDecryptor()
        $plaintext = $decryptor.TransformFinalBlock($data, 0, $data.Length)
        Invoke-Expression ([Text.Encoding]::UTF8.GetString($plaintext))
    } catch {
        Write-Host "ERROR: Failed to download or decrypt the script." -ForegroundColor Red
        Write-Host "Details: $_"
    }
}
