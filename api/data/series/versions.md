# Versions

`version` is an object. Contains source, status and change time fields for versioned metrics.

When a metric is versioned, the database retains the history of series value changes for the same timestamp along with version_source and version_status.

| **Name** | **Description**   |
|:---|:---|
| `versioned` | Boolean. Returns version status, source, time/date if metric is versioned. |
| `versionFilter`| Expression to filter value history (versions) by version value, status, source or time, for example: `value > 0`, `version_status = 'Deleted'` or `version_source LIKE '*user*'`. To filter by version time, use the `date()` function, for example, `version_time > date('2015-08-11T16:00:00Z')` or `version_time > date('current_day')`. The `date()` function accepts End Time syntax.|

<aside class="notice">
Versioned values are always returned with version time/date (<code>t</code> or <code>d</code>). Version time is the value change time, when the version is stored in ATSD.
</aside>

## Example

### Request

```json
[
        {
            "entity": "e-vers",
            "metric": "m-vers",
            "versioned":true,
            "versionFilter":"version_status='provisional' && value > 0",
            "startDate": "2015-11-10T13:00:00Z",
            "endDate": "2015-11-12T13:00:00Z",
            "type": "HISTORY",
            "timeFormat": "iso"
        }
    ]
```

### Response

```json
[
        {
            "entity": "e-vers",
            "metric": "m-vers",
            "tags": {},
            "type": "HISTORY",
            "aggregate": {
                "type": "DETAIL"
            },
            "data": [
                {
                    "d": "2015-11-10T13:00:00.000Z",
                    "v": 2,
                    "version": {
                        "d": "2015-11-10T14:20:00.678Z",
                        "status": "provisional"
                    }
                },
                {
                    "d": "2015-11-10T13:15:00.000Z",
                    "v": 3.42,
                    "version": {
                        "d": "2015-11-10T14:20:00.657Z",
                        "status": "provisional"
                    }
                },
                {
                    "d": "2015-11-10T13:30:00.000Z",
                    "v": 4.68,
                    "version": {
                        "d": "2015-11-10T14:20:00.638Z",
                        "status": "provisional"
                    }
                }
            ]
        }
    ]
```
