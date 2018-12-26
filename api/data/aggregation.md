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
| `PERCENTILE(n)` | `n`-th [percentile](#percentile), for example `PERCENTILE(75)` or `PERCENTILE(99.5)`.<br>`n` is a decimal number between `[0, 100]`.
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

* The `percentile(n)` function returns the number which is greater than the specified percentage `n` of values in the given period.
* The `n` parameter must be within the `[0, 100]` range.
* `PERCENTILE(100)` = `MAX`.
* `PERCENTILE(97.5)` is equal to `97.5%` percentile.
* `PERCENTILE(50)` = `MEDIAN`.
* `PERCENTILE(0)` = `MIN`.
* The function implements the [`R6`](https://www.itl.nist.gov/div898/handbook/prc/section2/prc262.htm) method which uses `N+1` as the array size (`N` is the number of samples in the period) and performs linear interpolation between consecutive values.
* `NaN` values are ignored from the input array.