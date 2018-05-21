# Export URL Format

## `curl` Command Request

```elm
https://atsd_hostname:8443/export?settings={"m":"metric","e":"entity","si":"1-WEEK","t":"DATA","f":"CSV"}
```

## Example Encoded

```bash
curl -u {username}:{password} -o output.csv -k -v \
  "https://atsd_hostname:8443/export?settings=%7B%22tags%22%3A%5B%7B%22k%22%3A%22command%22%2C%22v%22%3A%22*%22%7D%5D%2C%22m%22%3A%22proc_memory_used%22%2C%22e%22%3A%22awsswgvml001%22%2C%22si%22%3A%223-MINUTE%22%2C%22t%22%3A%22DATA%22%2C%22f%22%3A%22CSV%22%7D"
```

## Example Parsed

```elm
https://atsd_hostname:8443/export?settings={"m":"cpu_used","e":"nurswgvml001","si":"1-WEEK","et":"date('2014-11-11 00:00:00')","t":"DATA","f":"CSV","ai":"1-HOUR","a":["P_99"],"i":"LINEAR"}
```

## JSON Format

| Field | Description | Example |
| --- | --- | --- |
|  `m`  |  Metric name  |  `"m":"metric"`  |
|  `e`  |  Entity name  | `"e":"entity"`  |
|  `g`  |  Entity group  |  `"g":"group"`  |
|  `tags`  |  Tags array  |  `"tags":[{"k":"key1","v":"value11"},{"k":"key2","v":"value2"}]`  |
|  `si`  |  Selection Interval  | `si":"1-WEEK"`  |
|  `et`  |  End time  |  `"et":"today"`  |
|  `l` |  Limit  |  `"l":1000`  |
|  `f`  |  Export Format (CSV, HTML)  |  `"f":"CSV"`  |
|  `t`  |  Export Type (DATA, FORECAST)  |  `"t":"DATA"`  |
|  `ai`  |  Aggregation Interval  |  `"ai":"1-HOUR"`  |
|  `a`  |  Aggregation Functions  |  `"a":["AVG", "MIN"]`  |
|  `i`  |  Interpolation (LINEAR, STEP)  |  `"i" : "LINEAR"`  |

## Aggregation Functions

* AVG
* MIN
* MAX
* SUM
* COUNT
* STANDARD_DEVIATION
* WAVG
* WTAVG
* PERCENTILE_50
* PERCENTILE_75
* PERCENTILE_90
* PERCENTILE_95
* PERCENTILE_99
* PERCENTILE_995
* PERCENTILE_999

## Interval Time Units

* SECOND
* MINUTE
* HOUR
* DAY
* WEEK
* MONTH
* QUARTER
* YEAR

## Interpolation Functions

Interpolation functions can insert missing intervals in returned aggregated data:

| Function Name | Description |
| --- | --- |
|  `STEP`  |  Missing value equals previous (last) value.  |
| `LINEAR`  |  Missing value is computed using linear interpolation between previous (last) and next available value.  |
|  `NONE`  |  Missing values are not inserted.  |

If the interpolation function is not specified in the request, missing intervals are not created.
