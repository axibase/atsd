# List Metrics for Last Insert Date Range

List metrics with `lastInsertDate` within the specified range. To exclude metrics without `lastInsertDate`, set `minInsertDate` to `1970-01-01T00:00:00Z`.

## Request

### URI

```elm
GET /api/v1/metrics?minInsertDate=1970-01-01T00:00:00Z&maxInsertDate=1980-01-01T00:00:00Z&limit=3
```

## Response

```json
[{
   "name": "bi.im_net1.q_fp",
   "enabled": true,
   "dataType": "FLOAT",
   "description": "Exports - net - excl. ships and aircraft",
   "label": "BI.IM_NET1.Q_FP",
   "persistent": true,
   "retentionDays": 0,
   "seriesRetentionDays": 0,
   "invalidAction": "NONE",
   "lastInsertDate": "2007-03-31T00:00:00.000Z",
   "units": "$, million",
   "versioned": false,
   "interpolate": "LINEAR"
}, {
   "name": "bi.im_net1.q_ppr",
   "enabled": true,
   "dataType": "FLOAT",
   "description": "Exports - net - excl. ships and aircraft",
   "label": "BI.IM_NET1.Q_PPR",
   "persistent": true,
   "retentionDays": 0,
   "seriesRetentionDays": 0,
   "invalidAction": "NONE",
   "lastInsertDate": "2007-03-31T00:00:00.000Z",
   "units": "Index, base 2005=100",
   "versioned": false,
   "interpolate": "LINEAR"
}, {
   "name": "chg.ward",
   "enabled": true,
   "dataType": "FLOAT",
   "persistent": true,
   "retentionDays": 0,
   "seriesRetentionDays": 0,
   "invalidAction": "NONE",
   "lastInsertDate": "2007-04-09T13:17:36.000Z",
   "versioned": false,
   "interpolate": "LINEAR"
}]
```
