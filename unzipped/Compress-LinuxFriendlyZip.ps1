# Giriş: Orijinal klasör yolu ve çıkış ZIP dosyası adı
$sourceFolder = "C:\Users\pc\Desktop\mft2-mbo_\unzipped"
$outputZip = "C:\Users\pc\Desktop\mft2-mbo_\unzipped\app_fixed.zip"

# ZIP dosyasını sil (varsa)
if (Test-Path $outputZip) {
    Remove-Item $outputZip -Force
}

# .NET System.IO.Compression kütüphanesini kullan
Add-Type -AssemblyName System.IO.Compression.FileSystem

# ZipArşivini oluştur
$zip = [System.IO.Compression.ZipFile]::Open($outputZip, 'Create')

# Tüm dosyaları ve alt klasörleri sırayla işle
Get-ChildItem -Recurse -File -Path $sourceFolder | ForEach-Object {
    $relativePath = $_.FullName.Substring($sourceFolder.Length + 1)

    # Windows '\' yerine Linux '/' kullan
    $linuxFriendlyPath = $relativePath -replace '\\', '/'

    # ZIP içine ekle
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
        $zip,
        $_.FullName,
        $linuxFriendlyPath,
        [System.IO.Compression.CompressionLevel]::Optimal
    )
}

# Zip dosyasını kapat
$zip.Dispose()

Write-Host "✅ Linux uyumlu zip oluşturuldu: $outputZip"
