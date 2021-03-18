# Metric: rename

## Description

Renames the specified metric while retaining its identifier, fields, tags, and the underlying time series data.

The following naming rules apply to the new metric name:

* Non-printable characters with ASCII hexadecimal codes `%x00-%x20` and `%x7F`, such as space and tab, are [not allowed](../../network/metric.md#abnf-syntax).
* The new metric name must not match an existing metric name.
* The new metric name is converted to lower case when stored.

Series commands with the old metric name, received after the renaming is completed, are stored under the old metric name with a new identifier.

## Request

| **Method** | **Path** | **`Content-Type` Header** |
|:---|:---|---:|
| `POST` | `/api/v1/metrics/{name}/rename` | `application/json` |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `name` | **[Required]** Current metric name. |

### Fields

| **Name** | **Type** | **Description** |
|:---|:---|---:|
| `name` | string | **[Required]** New metric name. Must **not** exist in the database. |

## Response

### Fields

None.

## Example

### Request

#### URI

```elm
POST /api/v1/metrics/cpu_busy/rename
```

#### Payload

```json
{
  "name": "cpu_total_busy"
}
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/metrics/cpu_busy/rename \
  -k --user {username}:{password} \
  --header "Content-Type: application/json" \
  --data '{"name":"cpu_total_busy"}'
```

### Response

None.

### Screenshots

Metric Editor page before and after the renaming operation:

![Metric name is `old_name`](../../../images/metric_rename_old_name.png)

![Metric name is `new_name`](../../../images/metric_rename_new_name.png)
