# Series Get. CSV Format

## Description

Download series values in CSV format.

## Request

### URI

```elm
GET /api/v1/series/csv/nurswgvml007/mpstat.cpu_busy?startDate=previous_hour&endDate=now&columns=date,value
```

### curl

```bash
curl "https://atsd_hostname:8443/api/v1/series/csv/nurswgvml007/mpstat.cpu_busy?startDate=previous_hour&endDate=now&columns=date,entity,metric,value" \
  -k --user {username}:{password}
```

## Response

```ls
date,value
2018-05-12T14:00:00Z,7.0
2018-05-12T14:01:00Z,2.0
2018-05-12T14:02:00Z,5.0
2018-05-12T14:03:00Z,4.95
2018-05-12T14:04:00Z,0.0
```
