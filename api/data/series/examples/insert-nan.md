# Series Insert Not A Number 

## Description

Insert Not a Number (NaN) as a `null` value.  

## Request

### URI

```elm
POST https://atsd_hostname:8443/api/v1/series/insert
```
### Payload

```json
[
    {
        "entity": "nurswgvml007",
        "metric": "mpstat.cpu_busy",
        "data": [
            {
                "d": "2016-06-05T05:49:25.127Z",
                "v": null
            }
        ]
    }
]
```
