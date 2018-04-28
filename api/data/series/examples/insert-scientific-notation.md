# Series Insert In Scientific Notation

## Description

Insert a number value specified in scientific notation (exponent).  

## Request

### URI

```elm
POST https://atsd_hostname:8443/api/v1/series/insert
```

### Payload
```json
[{
    "entity": "nurswgvml007",
    "metric": "page_count",
    "data": [
	  { "d": "2016-06-05T05:49:25.127Z", "v": 1.234e10 },
	  { "d": "2016-06-05T06:49:25.127Z", "v": 1.3e10 }
    ]
}]
```
