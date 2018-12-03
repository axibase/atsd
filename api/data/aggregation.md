# Aggregation

## Statistical Functions

| Name | Description |
|:---|---|
| `MIN`| Minimum value.
| `MAX`| Maximum value.
| `AVG`| Average value.
| `SUM`| Sum of values.
| `COUNT`| Count of values.
| `FIRST`| First value.
| `LAST`| Last value.
| `DELTA`| Difference between the last and the first value.
| `COUNTER` | Sum of positive differences between consecutive values.
| `PERCENTILE_999` | 99.9% Percentile.
| `PERCENTILE_995` | 99.5% Percentile.
| `PERCENTILE_99` | 99% Percentile.
| `PERCENTILE_95` | 95% Percentile.
| `PERCENTILE_90` | 90% Percentile.
| `PERCENTILE_75` | 75% Percentile.
| `PERCENTILE_50` | 50% Percentile.
| `PERCENTILE_25` | 25% Percentile.
| `PERCENTILE_10` | 10% Percentile.
| `PERCENTILE_5` | 5% Percentile.
| `PERCENTILE_1` | 1% Percentile.
| `PERCENTILE_05` | 0.5% Percentile.
| `PERCENTILE_01` | 0.1% Percentile.
| `MEDIAN` | Median value, same as 50% percentile.
| `STANDARD_DEVIATION` | Standard deviation.
| `SLOPE` | Linear regression slope.
| `INTERCEPT` | Linear regression intercept.
| `WAVG` | Weighted average.
| `WTAVG` | Weighted time average.
| `THRESHOLD_COUNT` | Number of threshold violations.
| `THRESHOLD_DURATION` | Cumulative duration of threshold violations.
| `THRESHOLD_PERCENT` | Percentage which violate threshold.
| `MIN_VALUE_TIME` | Unix time in milliseconds of the first maximum value.
| `MAX_VALUE_TIME` | Unix time in milliseconds of the first minimum value.

## Implementation Notes

### General

The descriptive statistics are calculated for all samples in the given period. If the period contains no samples, the statistic is not calculated and is not included in the response.

### `COUNT`

Like other functions, `COUNT` is not calculated if the period contains no samples. Specifically, it does **not** return zero values for empty periods.

### `DELTA`

The `DELTA` function returns the difference between the last value in the current period and the last value in the **previous** period.

* If the previous period contains no values, the function is calculated as the difference between the last and the first value in the current period.
* If there is only one value in the current period and the previous period is empty, the function returns `null` which is included in the response.

### `COUNTER`

The `COUNTER` function returns the sum of positive differences between consecutive samples in the current period starting with the last value in the **previous** period.

* If the previous period contains no values, the calculation starts with the first value in the current period.
* If there is only one value in the current period and the previous period is empty, the function returns `null` which is included in the response.
* If all the differences between consecutive samples are non-negative, the result of the `COUNTER` function is equal to the `DELTA` function.

### `PERCENTILE`

* The percentile function calculates the number which is greater than the specified percentage of values in the given period.
* The `percentage` parameter must be within the `(0, 100]` range.
* `PERCENTILE_100` is equal to `MAX`.
* `PERCENTILE_0` is not valid.
* The percentile [calculation method](https://commons.apache.org/proper/commons-math/javadocs/api-3.0/org/apache/commons/math3/stat/descriptive/rank/Percentile.html) uses `N+1` as the input array size (`N` is the number of samples in the period) and performs linear interpolation between consecutive values.
* `NaN` values are ignored.