# Version History

## Description

List change dates for the specified entity.

The response contains timestamps, sorted in ascending order. The last timestamp equals `versionDate` in the entity model.

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
GET /api/v1/entities/gazp_[tqbr]/versions
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

> `2020-10-15T08:58:22.860Z` equals entity `versionDate`

To retrieve entity tags and fields at the time of the change, append the `version` parameter to the [`get`](../api/meta/entity/get.md) request.

```elm
GET /api/v1/entities/gazp_[tqbr]?version=2020-07-10T08:03:44.094Z
```