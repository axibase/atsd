# Monthly Change Log: January 2019

## ATSD

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
|5866|rule engine|Feature|Rule Engine: implement [`median_abs_dev()`](../../rule-engine/functions-statistical.md#median_abs_dev) function.
|5864|forecast|Bug|Rule Engine: validate `forecast` function arguments.
|5862|forecast|Bug|[Forecast](../../forecasting/README.md): scheduled task error.
|5856|forecast|Bug|Forecast: scheduled [PCA](../../forecasting/README.md#overview) task error.
|5854|portal|Bug|Portal: HTML report error with [`percentile`](https://axibase.com/docs/charts/configuration/aggregators.html#percentile) statistics.
|5852|rule engine|Feature|Rule Engine: implement [`is_exceptionday`](../../rule-engine/object-datetime.md#is_exceptionday-function) function.
|5850|forecast|Bug|Forecast: [HW](../../forecasting/README.md#overview) fails on series with 1 day selection interval.
|5847|csv|Bug|CSV: [parser](../../parsers/csv/README.md) fails to ignore first empty lines.
|5843|api-rest|Bug|API: Fix `NPE` in [version](../../api/data/series/versions.md) query.
|5840|csv|Bug|[CSV](../../parsers/csv/README.md) file upload: high CPU load and low throughput.
|5838|core|Bug|Core: classify `atsd_forecast` as a data table.
|5835|sql|Bug|SQL: slow [`atsd_entity`](../../sql/README.md#atsd_entity-table) query if number of entities is large.
|5834|UI|Feature|UI: update Freemarker dependency.
|5833|UI|Bug|[SQL Console](../../sql/sql-console.md): client formatting ignores `DST` offset changes.
|5813|sql|Bug|SQL: [`LAG`](../../sql/README.md#lag) does not accept column aliases.
|5790|data-in|Bug|[Data Entry](../../versioning/README.md#data-entry-form): future dates inserted with delay.
|5773|csv|Bug|[CSV](../../parsers/csv/README.md): possible memory leak if CSV upload is massively used.
|5519|core|Bug|Core: refactor scheduled tasks.
|4418|sql|Feature|SQL: wildcard for [`entity`](../../sql/README.md#entity-columns) and [`metric`](../../sql/README.md#metric-columns) fields.

## Charts

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
|5865|time-chart|Bug|[Smooth](https://axibase.com/docs/charts/widgets/shared/#smoothing) series not displayed if `multiple-series = true`.
|5859|widget-settings|Bug|Wrong `forecast-score-interval` setting conversion to series query field.
|5853|forecast|Bug|Series [legend](https://axibase.com/docs/charts/widgets/shared/#legend) incorrect for multiple forecast series.
|5848|widget-settings|Feature|Widget settings: add support for [`filter`](https://axibase.com/docs/charts/widgets/shared/#filter) setting.
|5842|widget-settings|Feature|Widget settings: [`transformation-order`](https://axibase.com/docs/charts/widgets/shared/#transformation-order) setting.