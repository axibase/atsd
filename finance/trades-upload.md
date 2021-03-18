# Backfill Trades

The endpoint accepts a daily file archive containing [trade](command-trade-insert.md) commands. It is primarily used for backfilling of missing trades at the end of the trading session, particularly if the trades are streamed over the UDP protocol. The operation is executed asynchronously.

## Request

| **Method** | **Path** |
|:---|:---|
| `POST` | `/api/v1/trades/upload` |

### Request Parameters

| Name | Default Value | Description |
|---|---|---|
| `file` | - | Multipart file parameter |
| `filename` | - | Required if file content is sent as body |
|`include` | - | Comma separated list of market identifier [codes](https://www.iso20022.org/market-identifier-codes) to **process**. |
|`exclude` | - | Comma separated list of market identifier [codes](https://www.iso20022.org/market-identifier-codes) to **discard**. |
| `exchange` | - | Exchange name applied to commands with empty exchange field. |
| `insert` | `true` | Insert missing trades into the database. If disabled, missing trades are logged without insertion. |
| `add_new_instruments` | `false` | Insert trades for an instrument which is not yet present in the database. |
| `on_mismatch` | report | Action to perform if the trade in file differs from a corresponding trade in the database.<br>Possible values: `ignore`,`report`,`update`.<br>`ignore`: ignore the difference.<br>`report`: log mismatched trades to log file.<br>`update`: log to file and overwrite the trade in the database.
| `debug` | `false` | Log mismatched or missing trades to `logs/snapshot_${job_id}.log` file. |

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
--header 'Authorization: Bearer ****' \
--form 'file=@/path/to/trade_commands.tar.gz' \
--form 'insert=true' \
--form 'include=IEXG,XNGS' \
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

$Headers = @{Authorization = "Bearer ****"}
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