# Series URL Query. CSV Format

## Description

CSV file is exported.

## Request

### URI

```elm
GET https://atsd_hostname:8443/api/v1/series/csv/nurswgvml007/mpstat.cpu_busy?startDate=previous_hour&endDate=now&columns=date,entity,metric,value
```

### curl

```css
curl --insecure https://atsd_hostname:8443/api/v1/series/csv/nurswgvml007/mpstat.cpu_busy?startDate=previous_hour&endDate=now&columns=date,entity,metric,value \
  --include --user {username}:{password} \
  --request GET
```

## Response

```ls
time,entity,metric,value
2015-05-12T14:00:00Z,nurswgvml007,mpstat.cpu_busy,7.0
2015-05-12T14:01:00Z,nurswgvml007,mpstat.cpu_busy,2.0
2015-05-12T14:02:00Z,nurswgvml007,mpstat.cpu_busy,5.0
2015-05-12T14:03:00Z,nurswgvml007,mpstat.cpu_busy,4.95
2015-05-12T14:04:00Z,nurswgvml007,mpstat.cpu_busy,0.0
```
