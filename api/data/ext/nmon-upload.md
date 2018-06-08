# nmon File Upload

## Description

Accepts an nmon file for parsing.

## Request

| **Method** | **Path** |
|:---|:---|
| POST | `/api/v1/nmon` |

### Headers

|**Header**|**Value**|
|:---|:---|
| Content-Type | `text/csv` or `text/plain` |
| Content-Disposition | `form-data; filename=fname`, for example <br>`Content-Disposition: form-data; filename=NURSWGVML070_160318_1012.nmon` |

### Query String Parameters

| **Field** | **Type** | **Description** |
|:---|:---|:---|
| p   | string   | [**Required**] Parser Name as configured on **Configuration:Parsers nmon** page, or set to `default`.|
| e      | string   | Entity name, typically name of the server where nmon file was generated.|
| f| string | nmon file name. File name can be optionally specified in the `Content-Disposition` header. |
| z | string | Time zone applied to timestamps specified in local time. |

### Payload

* Payload is nmon file attached as plain text.

## Response

### Fields

None.

### Errors

## Example

### Request

#### URI

```elm
wget -t 1 -T 10 \
    --no-check-certificate \
    --user=axibase \
    --password=******** \
    --auth-no-challenge -O - \
    --post-file="nmon_logs/NURSWGVML070_160319_0516.nmon" \
    --header="Content-type: text/csv" \
    --header="Content-Disposition: form-data; filename=NURSWGVML070_160318_1012.nmon" \
    "https://atsd_hostname:8443/api/v1/nmon?p=default&e=NURSWGVML070"
```

#### Payload

```ls
AAA,progname,topas_nmon
AAA,command,/usr/bin/topas_nmon -ftdTWALM -s 60 -c 1440 -o /opt/NMON/day/ -youtput_dir=/opt/NMON/day/ -ystart_time=20:00:01,Jun16,2016
AAA,version,TOPAS-NMON
AAA,build,AIX
AAA,disks_per_line,150
AAA,host,nurswgvml0023
AAA,user,root
AAA,AIX,6.1.8.1
AAA,TL,08
AAA,runname,nurswgvml0023
...
```

### Response

None.

## Additional Examples
