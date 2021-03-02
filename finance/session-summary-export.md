# Statistics

## Description

Retrieves records from the session summary table in CSV format.

## Request

| **Method** | **Path** |
|:---|:---|
| `POST` | `/api/v1/trade-session-summary/export` |

### Payload Parameters

| **Name** | **Required** | **Description** | **Example** |
|-----------|--------------|----------------|--------------|
| `startDate`  | yes | Start date in [ISO format](../shared/date-format.md#supported-formats), inclusive | `"2021-01-01T00:00:00Z"` |
| `endDate`  | yes | End date in [ISO format](../shared/date-format.md#supported-formats), exclusive | `"2022-01-01T00:00:00Z"` |
| `stages` | no | Array of stage identifiers. All stages are retrieved if not specified | `["O", "N"]`
| `sessions` | no | Array of session types. All session types are retrieved if not specified | `["DAY"]`
| `instruments` | no | Array of instrument filter objects. Wildcards supported to match multiple instruments. Disjunction operation is applied to multiple items. All instruments are retrieved if not specified | `[{"symbol" : "A*", "class": "TQBR"}]`
| `fields` | no | Array of column names in response. If specified, datetime, symbol or entity, and at least one statistic must be present. If not specified, a predefined set of fields is used, i.e. `datetime,session,stage,symbol,class,exchange` + all statistics | `["timestamp", "entity", "session", "high", "low"]`

```json
{
    "startDate": "2021-02-09T00:00:00Z",
    "endDate":   "2021-02-10T00:00:00Z",
    "instruments": [{
        "symbol" : "SIBN", "class" : "TQBR"
    }],
    "stages": ["N", "O"],
    "sessions": ["DAY"],
    "fields": ["datetime", "entity", "stage", "high", "low"]
}
```

## Response

### Payload

```txt
datetime,entity,stage,high,low
2021-02-09T06:59:33.000648Z,sibn_[tqbr],O,345.3,345.3
2021-02-09T15:39:59.589420Z,sibn_[tqbr],N,347.9,337.25
```

## Example

```sh
$ curl --request POST 'https://atsd_hostname:8443/api/v1/trade-session-summary/export' \
--insecure --include --user {username}:{password} \
--header 'Content-Type: application/json' \
--data-raw '{
    "startDate": "2021-02-09T00:00:00Z",
    "endDate":   "2021-02-10T00:00:00Z",
    "instruments": [{
        "symbol" : "SIBN", "class" : "TQBR"
    }],
    "stages": ["N", "O"],
    "sessions": ["DAY"],
    "fields": ["datetime", "entity", "stage", "high", "low"]
}'
```