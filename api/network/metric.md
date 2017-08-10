# `metric` Command

## Description

Creates or updates fields and tags of the specified metric.

If the metric doesn't exist, it will be created automatically.

## Syntax

```css
metric m:{metric} b:{enabled} p:{data-type} l:{label} d:{description} i:{interpolate} u:{units} f:{filter} z:{timezone} v:{versioning} a:{invalid_action} min:{minimum_value} max:{maximum_value} t:{tag-1}={text} t:{tag-2}={text}
```

* Metric name and tag names are case-insensitive and are converted to lower case when stored.
* Label, description, units, filter, and tag values are case-sensitive and are stored as submitted.
* Other fields are case-insensitive.
* Tag values cannot be empty.
* Metric tags and fields that are not specified are left unchanged.
* To reset a field to the default value or to delete a tag, use double-quoted empty string, for example `z:""`.

### Fields

| **Field** | **Type** | **Description** |
|:---|:---|:---|
| m         | string           | **[Required]** Metric name. |
| b         | boolean          | Enabled status. If the metric is disabled, new data received for this metric is discarded. |
| l         | string           | Label. |
| d         | string           | Description. |
| p         | string           | Data type: short, integer, long, float, double, decimal. Default: float. |
| i         | string           | Interpolation mode: linear, previous. |
| u         | string           | Units. |
| f         | string           | Filter expression. |
| z         | string           | Time Zone ID, for example `America/New_York` or `EST`.<br>Refer to [Java Time Zone](timezone-list.md) table for a list of supported Time Zone IDs.<br>The timezone is applied by date-formatting functions to return local time in a metric-specific timezone.<br>To reset the time zone to the default value, specify it as a double-quoted empty string `z:""`.|
| v         | boolean          | Versioning enabled/disabled. |
| a         | string           | Invalid action. |
| tp        | string           | Time precision.  |
| pe        | boolean          | Persistent. |
| rd        | number           | Retention Interval Days. |
| min       | number           | Minimum value. |
| max       | number           | Maximum value. |
| t         | string           | [Multiple] Metric tag name and value.  |

Refer to [Metric API](../meta/metric/list.md#fields) for field descriptions.

### ABNF Syntax

Rules inherited from [Base ABNF](base-abnf.md).

```properties
command = "metric" MSP metric [MSP enabled] [MSP label] [MSP units] [MSP description] [MSP data-type] [MSP interpolate] [MSP filter] [MSP timezone] [MSP versioning] [MSP invalidAction] [MSP timePrecision] [MSP persistent] [MSP retentionIntervalDays] [MSP minValue] [MSP maxValue] *(MSP tag)
metric = "m:" NAME
enabled = "b:" ("true" / "false")
data-type = "p:" ("short" / "integer" / "long" / "float" / "double" / "decimal")
interpolate = "i:" ("linear" / "previous")
label = "l:" VALUE
units = "u:" VALUE
description = "d:" VALUE
filter = "f:" VALUE
timezone = "z:" (TIMEZONE / DQUOTE DQUOTE)
versioning = "v:" ("true" / "false")
invalidAction = "a:" ("none" / "transform" / "discard" / "raise_error", "set_version_status")
timePrecision = "tp:" ("second" / "millisecond")
persistent = "pe:" ("true" / "false")
retentionIntervalDays = "rd:" (POSITIVE_INTEGER / DQUOTE DQUOTE)
minValue = "min:" (FRACTIONAL_NUMBER / REAL_NUMBER / DQUOTE DQUOTE)
maxValue = "max:" (FRACTIONAL_NUMBER / REAL_NUMBER / DQUOTE DQUOTE)
tag = "t:" NAME "=" VALUE
```

## Examples

```ls
metric m:temperature p:long v:false t:type=water
```

```ls
metric m:temperature b:false p:long v:false l:"Water Temperature" z:PST u:Celsius t:type=water
```
