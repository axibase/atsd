# Export Statistics

## Description

Retrieves statistics for the instrument in JSON format.

## Request

| **Method** | **Path** |
|:---|:---|
| `POST` | `/api/v1/properties/query` |

### Payload Parameters

| **Name** | **Description** |
|:---|:---|
| `type` | **[Required]** Set to `statistics`. |
| `entity` | **[Required]** Set to `<symbol>_[<class_code>]`. |
| `startDate` | **[Required]** Set to `1970-01-01T00:00:00Z`.  |
| `endDate` | **[Required]** Set to `now`. |
| `timezone` | Time zone for evaluating [calendar expressions](../shared/calendar.md), if specified in `startDate`/`endDate` parameters. |
| `workdayCalendar` | Workday calendar for evaluating [calendar expressions](../shared/calendar.md), if specified in `startDate`/`endDate` parameters. |

```json
[{
  "type": "statistics",
  "entity": "tsla_[iexg]",
  "startDate": "1970-01-01T00:00:00Z",
  "endDate":   "now",
  "merge": true
}]
```

## Response

### Payload

```json
[
  {
    "type": "statistics",
    "entity": "tsla_[iexg]",
    "key": {},
    "tags": {
      "accruedint": "0",
      "action": "1",
      "admittedquote": "223.02",
      "assured": "false",
      "auctnumtrades": "136",
      "auctprice": "223",
      "auctvalue": "31014840",
      "auctvolume": "139080",
      "bid": "225.07",
      "biddepth": "544",
      "biddeptht": "524892",
      "change": "1.93",
      "chngclose": "2.06",
      "duration": "0",
      "high": "225.62",
      "highbid": "242.82",
      "imbalance": "0",
      "last": "225.08",
      "lastbid": "225.07",
      "lastoffer": "225.08",
      "lcloseprice": "223.02",
      "lcurrentprice": "225.08",
      "low": "221.55",
      "lowoffer": "204.26",
      "marketprice": "225.68",
      "marketprice2": "225.68",
      "marketpricetoday": "225.68",
      "marketvolb": "0",
      "marketvols": "0",
      "min_curr_last": "225.06",
      "min_curr_last_ti": "10:22:00",
      "nfaprice": "225.08",
      "numbids": "4598",
      "numoffers": "3993",
      "numtrades": "35115",
      "offer": "225.08",
      "offerdepth": "35",
      "offerdeptht": "573501",
      "open": "223",
      "openperiodprice": "223",
      "plannedtime": "09:50:00",
      "prevadmittedquot": "223.02",
      "prevdate": "20210119",
      "prevlegalclosepr": "223.02",
      "prevprice": "223.15",
      "prevwaprice": "225.49",
      "priceminusprevwa": "-0.41",
      "qty": "12",
      "rptseq": "548324",
      "rptseq_st": "548318",
      "settledate1": "20210122",
      "snapshot_datetime": "2021-01-20T09:21:35.279149Z",
      "snapshot_start_datetime": "2021-01-20T09:16:47.356865Z",
      "starttime": "06:50:00",
      "time": "13:22:02",
      "tradingsession": "N",
      "valtoday": "5963972773",
      "value": "27009.6",
      "voltoday": "26598960",
      "waprice": "224.22"
    },
    "date": "2021-01-20T10:22:02.978Z"
  }
]
```

## SQL Alternative

```sql
SELECT *
  FROM atsd_session_summary
WHERE class = 'IEXG' AND symbol = 'TSLA'
  AND type = 'Day' AND stage IN ('O', 'N')
  AND datetime between '2021-02-15' and '2021-02-17'
ORDER BY datetime
```