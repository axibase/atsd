# Export Version History

The endpoint retrieves reference data modification dates for the specified instrument.

The response contains timestamps, sorted in ascending order.

To retrieve reference data at the time of the change, append the `version` parameter to the [`entity: get`](./reference-export.md) request.

```elm
GET /api/v1/entities/tsla_[iexg]?version=2020-07-10T08:03:44.094Z
```

## Request

| **Method** | **Path** |
|:---|:---|
| `POST` | `/api/v1/entities/{entity}/versions` |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `entity` | **[Required]** Entity name. |

Example:

```elm
GET /api/v1/entities/tsla_[iexg]/versions
```

## Response

### Payload

```json
[
  "2020-04-20T15:44:08.632Z",
  "2020-05-18T09:04:02.130Z",
  "2020-05-23T04:57:24.746Z",
  "2020-07-10T08:03:44.094Z",
  "2020-10-15T08:58:22.860Z"
]
```