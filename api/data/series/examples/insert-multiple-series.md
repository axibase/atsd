# Insert Multiple Series

Insert samples for multiple series in one request.

## Request 

### URI

```elm
POST https://atsd_hostname:8443/api/v1/series/insert
```

### Payload

```json
[{
    "entity": "nurswgvml007",
    "metric": "mpstat.cpu_busy",
    "data": [
      { "d": "2016-06-07T16:00:00.000Z", "v": 17.7 },
	  { "d": "2016-06-07T16:00:15.000Z", "v": 19.2 }
    ]
},{
    "entity": "nurswgvml009",
    "metric": "memory.memory_used_percent",
    "data": [
      { "d": "2016-06-07T15:58:00.000Z", "v": 27.8 },
	  { "d": "2016-06-07T15:58:32.000Z", "v": 3.8 }
    ]
}]
```
