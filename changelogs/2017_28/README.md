# Weekly Change Log: July 10, 2017 - July 16, 2017

## ATSD

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
| 4390 | sql | Bug | Fixed [`CAST`](../../sql/README.md#reserved-words) conversion error with the built-in `time` column. |
| [4375](#issue-4375) | sql | Feature | Added support for [`CURRENT_TIMESTAMP`](../../sql/README.md#current_timestamp) and [`DBTIMEZONE`](../../sql/README.md#dbtimezone) functions. |
| [4360](#issue-4360) | forecast | Feature | Added support for additional aggregation functions in [forecast](../../forecasting/README.md) settings: `AVG`, `MIN`, `MAX`, `SUM`, `COUNT`.  |

### Issue 4375

The `CURRENT_TIMESTAMP` function returns current database date and time in the ISO format similar to the [`NOW`](../../sql/README.md#reserved-words)
function which returns current database time in Unix milliseconds.

The [`DBTIMEZONE`](../../sql/README.md#dbtimezone) function returns the current database time zone name or GMT offset.

![](./Images/4375.png)

### Issue 4360

A custom aggregation function such as `MAX` can now be selected in **Forecast** settings. Previously only supported `AVG` function. Aggregation functions are applied to regularize the underlying time series prior to applying Holt-Winters or ARIMA algorithms.

#### AVG

Averages the values during a period.

![](./Images/4360.1.1.png)

#### MAX

Displays the maximum value during a period.

![](./Images/4360.2.png)

#### MIN

Displays the minimum value during a period.

![](./Images/4360.3.png)

#### SUM

Sums the values during a period.

![](./Images/4360.4.png)

#### COUNT

Displays the number of samples for a period.

![](./Images/4360.5.png)
