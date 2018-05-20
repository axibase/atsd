# Series: Delete

## Description

Delete series for the specified metric, entity, and optional series tags.

### Delete Markers

Due to the specifics of the underlying storage technology, the records deleted with this method are not instantly removed from the disk.

Instead, the records are masked with a so called `DELETE` marker. The `DELETE` marker hides all data rows that were recorded **before** the `DELETE` marker.

The actual deletion from the disk, which removes both the `DELETE` marker as well as earlier records, occurs in the background as part of a scheduled procedure called `major compaction`.

As a result, series samples that are re-inserted with timestamps earlier than the pending `DELETE` marker will not be visible.

To remove the pending `DELETE` markers, initiate an `HBase Compaction` on the **Settings > Storage > Delete Tasks** page. The compaction runs in the background and may take some time to complete.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| POST | `/api/v1/series/delete` | `application/json` |

### Parameters

None.

### Fields

An array of objects containing fields for filtering records for deletion.

| **Field**  | **Type** | **Description**  |
|:---|:---|:---|
| `metric` | string | [**Required**] Metric name.|
| `entity` | string | [**Required**] Entity name.|
| `tags` | object | Series tags object, where field name represents tag name and field value is tag value,<br> for example `{"tag-1":"val-1","tag-2":"val2"}` |
| `exactMatch` | boolean | If `exactMatch` is `true`, only one series with exactly the same series tags as in the request is deleted.<br>If `false`, all series which **contain** the series tags in the request (but may also include other series tags) are deleted.<br>If `exactMatch` is `false` and no series tags are specified, all series for the specified metric and entity are deleted.<br>Default value: `true`.|

## Response

In case of a successful operation the response contains a count of deleted series:

```json
{ "series": 1 }
```

The service responds with an error message if the metric or entity is not found, or if no series are matched.

```json
{"error":"com.axibase.tsd.service.meta.SeriesNotFoundException: No series found"}
```

## Exact Match Example

### URI

```elm
POST https://atsd_hostname:8443/api/v1/series/delete
```

### Payload

```json
[{
  "metric": "tcp-connect-status",
  "entity": "nurswgvml007",
  "exactMatch": true,
  "tags": {
    "port": 22080
  }
}]
```

### curl

```bash
curl https://atsd_hostname:8443/api/v1/series/delete \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  --data '[{ "metric":"tcp-connect-status", "entity":"nurswgvml007", "exactMatch": true, "tags": {"port": 22080}}]'
```

## Partial Match Example

### URI

```elm
POST https://atsd_hostname:8443/api/v1/series/delete
```

### Payload

```json
[{
  "metric": "tcp-connect-status",
  "entity": "nurswgvml007",
  "exactMatch": false
}]
```

### curl

```bash
curl https://atsd_hostname:8443/api/v1/series/delete \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  --data '[{ "metric":"tcp-connect-status", "entity":"nurswgvml007", "exactMatch": false}]'
```
