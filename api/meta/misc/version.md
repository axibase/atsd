# version

## Description

Retrieves database version including licensing details as well as a `date` object with local time and offset.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/version` |

## Response

### Fields

| **Name** | **Type** | **Description** |
|:---|:---|:---|
| `buildInfo`  | object | Database version information. |
| `license` | object | Database license details.  |
| `date` | object | Current date, start date, time zone, and offset information.  |
| `settings` | object | Basic database settings such as the `server.url` and `hostname`.  |

### Errors

## Example

### Request

#### URI

```elm
GET https://atsd_hostname:8443/api/v1/version
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/version \
  -k --user {username}:{password}
```

### Response

```json
{
    "buildInfo": {
        "revisionNumber": "13732",
        "buildNumber": "4345",
        "buildId": "4345"
    },
    "license": {
        "forecastEnabled": true,
        "hbaseServers": 5,
        "remoteHbase": true,
        "productVersion": "Enterprise Edition",
        "dataVersioningEnabled": true
    },
    "date": {
        "localDate": "2016-07-21 14:05:39.956",
        "currentDate": "2016-07-21T14:05:39Z",
        "timeZone": {
            "name": "GMT0",
            "offsetMinutes": 0
        },
        "startDate": "2016-07-21T13:45:18Z",
        "currentTime": 1469109939956
    }
}
```
