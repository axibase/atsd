# Trade File Upload

## Description

Upload file with [trade commands](command-trade-insert.md) for backfilling.

## Request

| **Method** | **Path** |
|:---|:---|
| `POST` | `/api/v1/trades/upload` |

### Request Parameters

| Name | Default Value | Description |
|---|---|---|
| `file` | - | Multipart file parameter |
|`include` | - | Comma separated list of classes to process. |
|`exclude` | - | Comma separated list of classes to discard. |
| `exchange` | - | Default exchange applied to commands with empty exchange field. |
| `insert` | `true` | Insert missing trades into HBase. If disabled, only check and report the number of missing trades. |
| `add_new_instruments` | `false` | Insert trades for the instrument if the instrument is not yet created in ATSD |
| `on_mismatch` | report | Action done on comparison of trades already stored in ATSD and loaded from file. Possible values: ignore,report,update. Ignore: do not compare columns other than trade_num. Report: log mismatched trades to log file. Update: log to file + update mismatched trades in ATSD
| `debug` | `false` | Log mismatched or missing trades to a file `logs/snapshot_${job_id}.log`
| `filename` | - | Required if file content is sent as body

The parameters can be set as follows:

* Both file and parameters as `multipart/form-data` elements, or
* Parameters in query string, file content in body

### Response

```json
{"file": "<name>", "size": "<size in bytes>", "job_id": "uuid of the job"}
```

## Examples

### curl

```bash
curl --insecure --header "Authorization: Bearer ****" \
  -F "insert=false" -F "debug=true" \
  -F "file=@/path/to/trade_commands.tar.gz" \
  https://atsd_hostname:8443/api/v1/trades/upload
```

```bash
curl --insecure --request POST 'https://atsd_hostname:8443/api/v1/trades/upload' \
--header 'Authorization: Bearer NNNNNNNN' \
--form 'file=@/path/to/trade_commands.tar.gz' \
--form 'insert=true' \
--form 'include=TQBR' \
--form 'add_new_instruments=false' \
--form 'on_mismatch=UPDATE' \
--form 'debug=true'
```

### PowerShell

For PowerShell 6.1+:

```powershell
powershell -file upload.ps1 -path trade_commands.zip
```

```powershell
# upload.ps1
param([string]$path)

$Headers = @{Authorization = "Bearer NNNNNNNN"}
$Uri = 'https://atsd_hostname:9443/api/v1/trades/upload'

$Form = @{
    insert = "true"
    file = Get-Item -Path $path
}

Invoke-RestMethod -Uri $Uri -Headers $Headers -Method Post -Form $Form
```

To create a ZIP archive for uploading:

```powershell
param([string]$src, [string]$dst)

# Compress-Archive -Path $src -DestinationPath $dst

Add-Type -assembly 'System.IO.Compression'
Add-Type -assembly 'System.IO.Compression.FileSystem'
[System.IO.Compression.ZipArchive]$ZipFile = [System.IO.Compression.ZipFile]::Open($dst,([System.IO.Compression.ZipArchiveMode]::Create))
[System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($ZipFile, $src, (Split-Path $src -Leaf))
$ZipFile.Dispose()
```