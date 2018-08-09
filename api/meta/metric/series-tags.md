# Metric: series tags

## Description

Retrieves unique **series** tags values for the specified metric.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/metrics/{metric}/series/tags` |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `metric` | **[Required]** Metric name. |

### Query Parameters

| **Parameter** |**Type**| **Description** |
|:---|:---|:---|
| `entity` | string| Filter series for the specified entity name. |
| `tags.{tag-name}` | string | Filter series with the specified series tag value.<br>Supported wildcards: `*`.<br>Examples: `&tags.site=ABC` or `&tags.site=AB*&tags.location=*`. |
| `tags` | string | Include specified series tags in the response.<br>Supported wildcards: `*`. Default: `*` (all tags).<br>Example: `tags=si*` or `tags=site,location`|
| `minInsertDate` |string|Include series with `lastInsertDate` equal or greater than `minInsertDate`.<br>`minInsertDate` can be specified in [ISO format](../../../shared/date-format.md) or using [calendar](../../../shared/calendar.md) keyword.|
| `maxInsertDate` |string|Include series with `lastInsertDate` less than `maxInsertDate`.<br>`maxInsertDate` can be specified in [ISO format](../../../shared/date-format.md) or using [calendar](../../../shared/calendar.md) keyword.|

## Response

### Fields

| **Field** | **Description** |
|:---|:---|
| {tag-name} | A sorted array of unique values for the series tag identified by name.<br>For example, `"file_system": ["/", "/media/datadrive", "/mnt/u113452"]` |

### Errors

None.

## Example

### Request

#### URI

```elm
GET /api/v1/metrics/disk_used/series/tags?entity=nurswgvml006
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/metrics/disk_used/series/tags?entity=nurswgvml006 \
  --insecure --include --user {username}:{password}
```

### Response

```json
{
  "file_system": ["/dev/mapper/vg_nurswgvml006-lv_root", "/dev/sdb1", "//u113452.store01/backup"],
  "mount_point": ["/", "/media/datadrive", "/mnt/u113452"]
}
```

## Additional Examples

* Include only `mount_point` tag in the response.

```elm
GET /api/v1/metrics/disk_used/series/tags?file_system=/&tags=mount_point
```

```json
{
  "mount_point":["/","/app","/dev","/media/datadrive","/mnt/u113452"]
}
```