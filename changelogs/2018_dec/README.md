# Monthly Change Log: December 2018

## ATSD

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
|5805|sql|bug|SQL: [PERCENTILE](../../sql/README.md#percentile) accepts invalid input in case of decimal metric.
|5777|forecast|bug|[Series Query](../../api/data/series/query.md): timestamps misaligned in forecast.
|5778|forecast|bug|[Series Query](../../api/data/series/query.md): caterpillar script error.
|5807|core|bug|Core: Invalid datetime parsing for 2-digit year without separator.
|5808|api-rest|bug|[Alerts Query](../../api/data/alerts/query.md): entity match needs to be case-**in**sensitive.
|5810|sql|feature|SQL: implement inclusive/exclusive comparison for [`BETWEEN`](../../sql/README.md#between-expression) operator .
|5792|sql|feature|SQL: implement [`RANK`](../../sql/README.md#partition-ordering) and [`DENSE_RANK`](../../sql/README.md#partition-ordering) analytic function.
|5789|sql|feature|SQL: implement offset and default for [`LAG`](../../sql/README.md#lag) and [`LEAD`](../../sql/README.md#lead) functions.
|5736|sql|bug|SQL: precision loss in integer [arithmetic](../../sql/README.md#arithmetic-operators).
|5086|sql|feature|SQL: `endtime` calculations to align with `CALENDAR`.
|5819|license|bug|[License](../../licensing.md): previous licenses ignored on ATSD restart.
|5821|license|bug|[License](../../licensing.md): add new fields to licence request and version check.
|5822|sql|feature|SQL: implement aliases for [`FIRST_VALUE`](../../sql/README.md#first_value) and [`LAST_VALUE`](../../sql/README.md#last_value) functions.
|5824|statistics|bug|SQL [`PERCENTILE`](../../sql/README.md#percentile): allow 0-percentile.
|5825|sql|feature|SQL: implement [`MEDIAN_ABS_DEV`](../../sql/README.md#median_abs_dev) aggregation function.
|5817|forecast|bug|[Forecasts](../../forecasting/README.md): remove malformed leading samples from Holt-Winters reconstructed series.
|5818|api-rest|feature|[Series Query](../../api/data/series/query.md): median absolute deviation [MAD](../../api/data/aggregation.md) aggregator.
|5816|forecast|bug|[Forecasts](../../forecasting/README.md): abnormal starting values in ARIMA and Holt-Winters reconstructed series.
|5811|sql|bug|SQL console: `datetime` column in `atsd_interval` table is not formatted.
|5762|core|feature|Stored interval functionality.
|5812|core|bug|[Workday Calendar](../../rule-engine/workday-calendar.md): Update calendars for year 2019.


## Charts

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
|5814|forecast|bug|[Forecasts](https://axibase.com/docs/charts/widgets/shared/#forecast-name): multiple issues.
|5791|widget-settings|bug|Widget settings: 100 [percentile](https://axibase.com/docs/charts/syntax/value-functions.html#statistical-functions) is incorrectly processed.
|5794|calendar|feature|Calendar: [data-labels](https://axibase.com/docs/charts/widgets/calendar-chart/#data-labels).