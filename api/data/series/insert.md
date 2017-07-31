# Series: Insert

## Description

Insert a timestamped array of numbers for a given series identified by metric, entity, and series tags.

* Entity name, metric name, and tag names can contain only printable characters. Names are case-insensitive and are converted to lower case when stored.
* Tag values are **case-sensitive** and are stored as submitted.
* The number of series tags cannot exceed 1024.
* New entities, metrics, and tag names are created automatically.
* New metrics are initialized with the `float` data type by default.
* If an insert for a new metric contains `version` in the first [Sample](#sample-object), the metric will be created as versioned.
* To change the data type, create or update the metric using the web interface or [metric update API method](../../../api/meta/metric/update.md).

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| POST | `/api/v1/series/insert` | `application/json` |

### Parameters

None.

### Fields

The request contains an array of series objects, each containing an array of timestamped value objects.

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| entity | string | [**Required**] Entity name |
| metric | string | [**Required**] Metric name |
| tags | object | Object containing series tags, where field name represents tag name and field value is tag value.<br>`{"tag-1":string,"tag-2":string}` |
| type | string | Type of inserted data: `HISTORY`, `FORECAST`. Default: `HISTORY` |
| forecastName | string | Forecast name. <br>Applicable if `type` is `FORECAST`.<br>`forecastName` can be used to store a custom forecast identified by name. <br>If `forecastName` is omitted, the values overwrite the default forecast.  |
| data | array | [**Required**] Array of [Value](#value-object) objects.<br>Example `[{"d":"2016-06-01T12:08:42.518Z", "v":50.8}]`.|

#### Value Object

* The value object contains a numeric and/or text value and the time when it was observed.
* The object may contain sample time in Epoch milliseconds (`t` field) or ISO format (`d` field).
* Minimum time that can be stored in the database is **1970-01-01T00:00:00.000Z**, or 0 millisecond from Epoch time.
* Maximum date that can be stored by the database is **2106-02-07T06:59:59.999Z**, or 4294969199999 milliseconds from Epoch time.

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| t | integer | [**Required**] Sample time in Epoch milliseconds.<br>Example `{"t":1464782922000, "v":50.8}`.|
| d | string | [**Required**] Sample time in ISO format.<br>Example `{"d":"2016-06-01T12:08:42Z", "v":50.8}`. |
| v | number | [**Required**] Numeric sample value at time `t`/`d`. <br>`null` is supported and will be stored as `NaN` (Not a Number).<br>Example `{"d":"2016-06-01T12:08:42Z", "v": null}` |
| s | number | Standard deviation of the forecast value `v`.<br>Example  `{"d":"2016-06-01T12:08:42Z", "v":50.8, "s":12.340}`.<br>Applicable if `type` is `FORECAST`.|
| x | string | Optional text sample value at time `t`/`d`. <br>Empty string `""` is supported and will be stored as `""`.<br>Example `{"d":"2016-06-01T12:08:42Z", "v": null, "x": "Shutdown"}` |
| version | object | Object containing version source and status fields for versioned metrics.<br>`{"source":string, "status":string}`.<br>Applicable if the metric is versioned. |

`data` example:

```json
"data": [
	{ "d": "2016-06-05T05:49:18.127Z", "v": 17.7 },
	{ "d": "2016-06-05T05:49:25.127Z", "v": 14.0 }
]
```

#### Number Representation

* The string representation of the inserted number consists of an optional sign, '+' ('\u002B') or '-' ('\u002D'), followed by a sequence of zero or more decimal digits ("the integer"), optionally followed by a fraction, optionally followed by an exponent.
* The exponent consists of the character 'e' ('\u0065') or 'E' ('\u0045') followed by an optional sign, '+' ('\u002B') or '-' ('\u002D'), followed by one or more decimal digits.
* The fraction consists of a decimal point followed by zero or more decimal digits. The string must contain at least one digit in either the integer or the fraction.
* The number formed by the sign, the integer, and the fraction is referred to as the [**significand**](https://en.wikipedia.org/wiki/Significand).
* The **significand** value stripped from trailing zeros should be within Long.MAX_VALUE `9223372036854775807` and Long.MIN_VALUE  `-9223372036854775808` (19 digits). Otherwise the database will throw an **llegalArgumentException: BigDecimal significand overflows the long type** for decimal metrics or round the value for non-decimal metrics. For example, significand for `1.1212121212121212121212121212121212121212121` contains 44 digits and will be rounded to `1.121212121212121212` if inserted for non-decimal metric.

## Response

### Fields

None.

### Errors

|  **Status Code**  | **Description** |
|:---|:---|
| 400 | IllegalArgumentException: Empty entity.|
| 400 | IllegalArgumentException: Negative timestamp.|
| 400 | IllegalArgumentException: No data. |
| 400 | IllegalArgumentException: BigDecimal significand overflows the long type. |
| 500 | JsonParseException: Unexpected character "}" |
| 500 | JsonMappingException: No enum constant in field type.|

## Example

### Request

#### URI

```elm
POST https://atsd_host:8443/api/v1/series/insert
```

#### Payload

```json
[{
    "entity": "nurswgvml007",
    "metric": "mpstat.cpu_busy",
    "data": [
		{ "d": "2016-06-05T05:49:18.127Z", "v": 17.7 },
		{ "d": "2016-06-05T05:49:25.127Z", "v": 14.0 }
    ]
}]
```

#### curl

* `--data` Payload

```elm
curl https://atsd_host:8443/api/v1/series/insert \
  --insecure --verbose --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request POST \
  --data '[{"entity": "nurswgvml007", "metric": "mpstat.cpu_busy", "data": [{ "t": 1462427358127, "v": 22.0 }]}]'
  ```

* file

```elm
curl https://atsd_host:8443/api/v1/series/insert \
  --insecure --verbose --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request POST \
  --data @file.json
  ```

## Additional Examples

* [ISO Time Format](examples/insert-iso-time-format.md)
* [Scientific Notation](examples/insert-scientific-notation.md)
* [Not A Number](examples/insert-nan.md)
* [Number Value and Text Value](examples/insert-number-text.md)
* [Text Value](examples/insert-text.md)
* [Multiple Samples](examples/insert-multiple-samples.md)
* [Series with Tags](examples/insert-with-tags.md)
* [Multiple Series](examples/insert-multiple-series.md)
* [Forecast](examples/insert-forecast.md)
* [Named Forecast](examples/insert-named-forecast.md)
* [Forecast Deviation](examples/insert-forecast-deviation.md)
* [Versioned Metric](examples/insert-versioned-metric.md)
