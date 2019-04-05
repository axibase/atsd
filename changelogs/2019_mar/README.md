# Monthly Change Log: March 2019

## ATSD

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
|6122|sql|Bug|SQL: `NPE` in [`WHERE`](../../sql/README.md#where-clause) conditions containing unknown columns or inline views.
|6111|metric|Bug|Metric Suggestions: `NullPointerException`.
|6104|csv|Bug|[CSV Parser](../../parsers/csv/README.md): schema-based parser `NPE` on initialization.
|6101|UI|Bug|[Calendar](../../forecasting/calendar_exceptions_testing.md#calendar) cannot be created.
|6100|license|Feature|Include [forecast](../../forecasting/README.md) module in the default SE license.
|6098|security|Feature|[Forecasts](../../forecasting/README.md): add license validation for series forecasts page.
|6092|forecast|Bug|[Forecast](../../forecasting/README.md) settings: some fields are not cloned.
|6089|csv|Feature|[CSV Wizard](../../tutorials/getting-started-insert.md#csv-files): add links to [**Export**](../../reporting/ad-hoc-exporting.md#ad-hoc-export-settings) form.
|6088|export|Feature|[**Export**](../../reporting/ad-hoc-exporting.md#ad-hoc-export-settings) form: add link to create [scheduled](../../reporting/scheduled-exporting.md) export job and refactor export links.
|6084|csv|Bug|[CSV Parser](../../parsers/csv/README.md): reduce severity from `ERROR` to `WARN` for user errors.
|6082|security|Feature|Security: add api [endpoint](../../administration/ssl-ca-signed.md#upload-certificates-to-atsd) to perform SSL certificate replacement.
|6077|api-rest|Bug|API: Wrong group index in [SSA](../../api/data/series/forecast.md#ssa-fields) forecast.
|6075|export|Bug|[**Export**](../../reporting/ad-hoc-exporting.md#ad-hoc-export-settings) form: broken fields.
|6073|metric|Feature|Metric Editor: add section/links to [forecast](../../forecasting/README.md) settings.
|6071|forecast|Bug|[Forecast](../../forecasting/README.md): viewer shows incorrect group name.
|6069|csv|Feature|[CSV Parser](../../parsers/csv/README.md): enrich upload progressbar with performed actions.
|6068|forecast|Feature|[Forecast](../../forecasting/README.md) settings: store forecast under a new metric.
|6065|export|Bug|Export: incorrect row count in [CSV Parser](../../parsers/csv/README.md) for export data with metadata.
|6060|csv|Bug| [CSV Parser](../../parsers/csv/README.md): highlight non-standard Header setting .
|6056|csv|Bug|[CSV Parser](../../parsers/csv/README.md) :descriptions.
|6055|csv|Bug|[CSV Parser](../../parsers/csv/README.md) Wizard: "Line Delimiter" and "Skip first Lines".
|6053|csv|Bug|[CSV Parser](../../parsers/csv/README.md) Wizard: "Encoding" and "Skip first Lines".
|6050|forecast|Bug|[SSA](../../api/data/series/forecast.md#ssa-fields): handle large group count gracefully.
|6044|security|Bug|Security: `API_META_WRITE` role required to access [`/api/v1/series/`](../../api/data/series/get.md#request).
|6042|forecast|Bug|[Forecast](../../forecasting/README.md): [SSA](../../api/data/series/forecast.md#ssa-fields) remove error - score interval is too big.
|6034|forecast|Bug|[Forecast](../../forecasting/README.md): `NPE` when [score interval](../../api/data/series/forecast.md#ssa-fields) is not specified.
|6030|UI|Bug|UI: adjust [SQL](../../sql/README.md) query dates on **Series Statistics** page.
|6027|csv|Feature|[CSV Parser](../../parsers/csv/README.md): summary page layout.
|6026|UI|Bug|UI: **Series Statistics** page - adjust dates.
|6023|license|Bug|[License](../../installation/#license) Server: `NullPointerException`.
|6022|UI|Bug|UI: [histogram](https://axibase.com/docs/charts/widgets/histogram/#histogram-chart) tabs broken on **Series Statistics** page.
|6021|core|Bug|Series [tag](../../sql/examples/select-all-tags.md#select-all-series-tags) full scans.
|6019|UI|Bug|UI: entity [pagination](../../search/entity-search.md#entity-search) not displayed if entity count is small.
|6018|security|Feature|OAuth2 access [tokens](../../administration/user-authentication.md#token-authentication) for restricted access to [REST API](../../api/data/#rest-api).
|6017|forecast|Bug|[Forecast](../../forecasting/README.md): [SSA](../../api/data/series/forecast.md#ssa-fields) `ArrayIndexOutOfBoundsException`.
|6016|core|Feature|Coprocessors: make coprocessor compatible with HDP HBase version.
|6014|client|Feature|Increase required Python version to 3.5.x in [ATSD Python clinet](../../api/clients/#api-clients).
|6012|security|Bug|Error in user account code.
|6010|forecast|Bug|[Forecast](../../forecasting/README.md): [SSA](../../api/data/series/forecast.md#ssa-fields) too many values error message.
|6009|core|Feature|Core: split `atsd_tag` [table](../../administration/monitoring-metrics/database-tables.md#monitoring-metrics-using-database-tables) into `tags_tag_series` and `atsd_tag_message`.
|6008|core|Bug|[Logging](../../administration/logging.md#logging): log failed command in case of persistence issues.
|6007|api-rest|Bug|[Series Query](../../api/data/series/query.md#series-query): percentiles are no longer supported by group [transformation](../../api/data/series/query.md#transformations).
|6004|csv|Feature|[CSV Parser](../../parsers/csv/README.md): summary page enhancements.
|6002|api-rest|Bug|[Series Query](../../api/data/series/query.md#series-query): [forecast](../../api/data/series/forecast.md#forecasting) placement affected by included series.
|6001|csv|Bug|[CSV Parser](../../parsers/csv/README.md): bad period for forecast link.
|6000|forecast|Feature|[forecast](../../api/data/series/forecast.md#forecasting): add score interval duration to response metadata.
|5999|csv|Bug|[CSV Parser](../../parsers/csv/README.md): date range must be in standard database format (not source).
|5998|data-in|Bug|[Series Query](../../api/data/series/query.md#series-query): group `NPE`.
|5997|csv|Feature|[CSV Wizard](../../tutorials/getting-started-insert.md#csv-files): highlight filtered rows.
|5996|api-rest|Feature|API: support of alphabet-based numbers in [`forecast-ssa-group-auto-union`](../../api/data/series/forecast.md#ssa-fields) setting.
|5987|forecast|Bug|[Forecast](../../forecasting/README.md): ARIMA `NPE` with `auto-regression-interval`.
|5984|UI|Bug|UI: right align numeric tags on the entity/metric list.
|5983|csv|Bug|[CSV Parser](../../parsers/csv/README.md): add line breaks in model column header to conserve space.
|5971|csv|Bug|[CSV Parser](../../parsers/csv/README.md): column with multiple dots incorrectly classified as numeric.
|5965|api-rest|Feature|[Series Query](../../api/data/series/query.md#series-query): extend [grouping](../../api/data/series/group.md#group-processor) transformation to group series based on correlation and constraints.
|5962|sql|Feature|SQL: support for non-parameterized `INSERT`.
|5954|csv|Feature|[CSV Parser](../../parsers/csv/README.md): calculate range of dates at Parse stage.
|5947|client|Bug|[Python client](../../api/clients/#api-clients) installation.
|5845||Feature|[Series Query](../../api/data/series/query.md#series-query): implement [grouping](../../api/data/series/group.md#group-processor) of forecast / reconstructed series.
|5803|api-rest|Feature|[Series Query](../../api/data/series/query.md#series-query): refactor [`percentile`](../../api/data/aggregation.md#statistical-functions) type.

## Charts

|Issue| Category    | Type    | Subject
-----|-------------|---------|----------------------
|6099|time-chart|Bug|[Label-format](https://axibase.com/docs/charts/syntax/label-formatting.html#label-formatting): legend is not calculated for `detail`.
|6029|text|Feature|[Text Widget](https://axibase.com/docs/charts/widgets/text-widget/#text-widget): implement tooltips.
|6015|forecast|Bug|Forecast: numeric overflow in [forecast](https://axibase.com/docs/charts/widgets/shared/#forecasting) metadata.
|6006|widget-settings|Feature|Implement [`coalesce`](https://axibase.com/docs/charts/syntax/label-formatting.html#coalesce) function.
|5995|widget-settings|Bug|[Percentile](https://axibase.com/docs/charts/configuration/aggregators.html#percentile) error if `server-aggregate = true`.
|5842|widget-settings|Feature|Widget settings: [`transformation-order`](https://axibase.com/docs/charts/widgets/shared/#transformation-order) setting.

## Collector

|Issue| Category    | Type    | Subject
-----|-------------|---------|----------------------
|5909|docker|Bug|Docker: [job](https://axibase.com/docs/axibase-collector/#jobs) freezing.
