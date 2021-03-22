param([string]$src, [string]$dst)

# Compress-Archive -Path $src -DestinationPath $dst

Add-Type -assembly 'System.IO.Compression'
Add-Type -assembly 'System.IO.Compression.FileSystem'
[System.IO.Compression.ZipArchive]$ZipFile = [System.IO.Compression.ZipFile]::Open($dst,([System.IO.Compression.ZipArchiveMode]::Create))
[System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($ZipFile, $src, (Split-Path $src -Leaf))
$ZipFile.Dispose()