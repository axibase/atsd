# Data API: Extended Methods

| **Name** | **Method** | **Path** | **Content-Type** | **Description** |
|:---|:---|:---|:---|:---|
| [Command](command.md) | POST | `/api/v1/command` | `text/plain` | Insert data using commands in Network API via HTTP. |
| [CSV Upload](csv-upload.md) | POST | `/api/v1/csv` | `multipart/*`<br>`text/csv`<br>`application/zip`<br>`application/gzip` | Upload CSV file or multiple CSV files for parsing into series, properties, or messages with the specified CSV parser. |
| [`nmon` Upload](nmon-upload.md) | POST | `/api/v1/nmon` | `text/csv`<br>`text/plain` | Upload `nmon` file for parsing. |
