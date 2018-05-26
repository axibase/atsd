# Properties for Type 'process' with Multiple Keys

## Request

### URI

```elm
POST /api/v1/properties/query
```

### Payload

```json
[
  {
    "type": "process",
    "entity": "nurswgvml007",
    "key": {"command": "java", "pid": "27297"},
    "startDate": "now - 1 * DAY",
    "endDate": "now",
  }
]
```

## Response

```json
[
   {
       "type": "process",
       "entity": "nurswgvml007",
       "key": {
               "command": "java",
               "fullcommand": "java -server -xmx512m -xloggc:/home/axibase/atsd/logs/gc.log -verbose:gc -xx:+printgcdetails -xx:+printgcdatestamps -xx:+printgctimestamps -xx:+printgc -xx:+heapdumponoutofmemoryerror -xx:heapdumppath=/home/axibase/atsd/logs -classpath /home/axibase/atsd/conf:/home/axibase/atsd/bin/atsd-executable.jar com.axibase.tsd.server",
               "pid": "27297"
       },
       "tags": {
           "%cpu": "5.88",
           "%sys": "0.62",
           "%usr": "5.27",
           "majorfault": "0",
           "minorfault": "0",
           "resdata": "1575544",
           "resset": "456888",
           "restext": "36",
           "shdlib": "13964",
           "size": "1733508"
       },
       "date": "2015-02-05T16:55:02Z"
   }
]
```
