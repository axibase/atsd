# Monthly Change Log: February 2019

## ATSD

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
|5993|forecast|Bug|[Forecast](../../api/data/series/forecast.md): add validation for [`forecast-ssa-decompose-singular-value-threshold`](https://axibase.com/docs/charts/widgets/shared/#forecast-ssa-decompose-singular-value-threshold).
|5989|forecast|Bug|[SSA](../../api/data/series/forecast.md): forecast fails on [`forecast-ssa-decompose-window-length`](https://axibase.com/docs/charts/widgets/shared/#forecast-ssa-decompose-window-length).
|5988|forecast|Bug|[Forecast](../../api/data/series/forecast.md): full decomposition fails.
|5985|csv|Feature|[CSV Parser](../../parsers/csv/README.md): add link to **Search** results on the **Summary** page.
|5982|csv|Bug|[CSV Parser](../../parsers/csv/README.md): date interpreted as numeric column.
|5981|csv|Feature|[CSV Parser](../../parsers/csv/README.md): add support for non-English dates.
|5980|csv|Bug|[CSV Parser](../../parsers/csv/README.md): change priority of `geo` columns for **Entity**.
|5978|csv|Bug|[CSV Parser](../../parsers/csv/README.md): ignore high cardinality tags containing intervals.
|5973|csv|Bug|[CSV Parser](../../parsers/csv/README.md): enhance summary page layout and add [SQL](../../sql/README.md) queries.
|5972|csv|Bug|[CSV Parser](../../parsers/csv/README.md): implement function to extract hosts from ITM agent identifiers.
|5968|entity|Feature|[Tag Template](../../configuration/tag-templates.md) editor: add link to view matching entities.
|5966|csv|Bug|[CSV Parser](../../parsers/csv/README.md): `TMZDIFF` ignored in ITM files.
|5964|csv|Bug|[CSV Parser](../../parsers/csv/README.md): fails to detect date format for `dd-MMM-yy HH:mm:ss` column in ITM files.
|5960|csv|Bug|[CSV Parser](../../parsers/csv/README.md): failed to test entity from expression.
|5959|csv|Bug|[CSV Parser](../../parsers/csv/README.md): footer shows `N/A`.
|5957|csv|Bug|[CSV Parser](../../parsers/csv/README.md): column analysis for numeric column contains inconsistent `N/A` details.
|5955|csv|Bug|[CSV Parser](../../parsers/csv/README.md): unexpected `NULL` patterns.
|5953|core|Bug|Core: drop support for 3-letter time zone identifiers.
|5952|csv|Bug|[CSV Parser](../../parsers/csv/README.md): add auto-completes to Model page expression fields.
|5951|csv|Bug|[CSV Parser](../../parsers/csv/README.md): list of possible metric columns must include only numeric columns.
|5950|csv|Bug|[CSV Parser](../../parsers/csv/README.md): ignore trivial names from entity column candidates.
|5949|csv|Bug|[CSV Parser](../../parsers/csv/README.md): modify datetime format on **Model** page.
|5938|csv|Bug|[CSV Parser](../../parsers/csv/README.md): Wrong date format on **Parsing** page leads to unrecoverable error on **Modelling** stage.
|5937|sql|Feature|SQL: implement [`COVAR`](../../sql/README.md#covar) function to calculate covariance.
|5936|core|Feature|[Incoming webhook](../../api/data/messages/webhook.md): add wizard links.
|5934|csv|Bug|[CSV Parser](../../parsers/csv/README.md): column with only 'N' letter recognized as date.
|5932|csv|Bug|[CSV Parser](../../parsers/csv/README.md): `expand` or `collapse` state lost after **Apply** on **Model** page.
|5931|csv|Bug|[CSV Parser](../../parsers/csv/README.md): columnar layout not working.
|5930|csv|Bug|[CSV Parser](../../parsers/csv/README.md): ignore columns with ordinal numbers (counters).
|5928|csv|Feature|[CSV Wizard](../../parsers/csv/README.md): Insert data without saving the parser.
|5927|csv|Bug|[CSV Parser](../../parsers/csv/README.md): ignore numeric latitude/longitude columns.
|5926|csv|Bug|[CSV Parser](../../parsers/csv/README.md): no timestamp warning on missing date.
|5924|csv|Bug|[CSV Parser](../../parsers/csv/README.md): re-classify numeric address columns.
|5923|csv|Bug|[CSV Parser](../../parsers/csv/README.md): hide extraneous date columns.
|5922|csv|Bug|[CSV Parser](../../parsers/csv/README.md): header and footer height needs to be dynamic.
|5921|csv|Bug|[CSV Parser](../../parsers/csv/README.md): reduce ISO-8859 encoding variety.
|5920|rule editor|Bug|Rule Editor: [window fields](../../rule-engine/window-fields.md) in condition.
|5916|data-in|Bug|[Data Entry](../../tutorials/getting-started.md#writing-data): series insertion with text commands does not reach the rule engine.
|5912|csv|Bug|[CSV Wizard](../../parsers/csv/README.md): fails to parse file with more than 256 columns.
|5904|csv|Bug|[CSV Parser](../../parsers/csv/README.md): entity field reverts to first option.
|5903|csv|Bug|[CSV Parser](../../parsers/csv/README.md): column analysis displays incorrect details.
|5902|csv|Bug|[CSV Wizard](../../parsers/csv/README.md): date parsing fails.
|5899|api-rest|Bug|[Smoothing](../../api/data/series/smooth.md) setting: set default `minimumCount` to `1`.
|5898|api-rest|Bug|[Series Query](../../api/data/series/query.md): transformation order validation.
|5895|UI|Bug|[Forecast](../../forecasting/README.md) Settings: Freemarker error on **Show Meta**.
|5894|csv|Bug|[CSV Wizard](../../parsers/csv/README.md): file upload is hanging.
|5893|api-rest|Bug|[Series Query](../../api/data/series/query.md): [forecast](../../api/data/series/forecast.md) response document is malformed.
|5892|api-rest|Bug|[Series Query](../../api/data/series/query.md): `group-interpolate` must be optional in forecasting transformation.
|5889|forecast|Bug|[Forecast](../../api/data/series/forecast.md): series logging insufficient to reproduce the query.
|5887|data-in|Bug|[Data Entry](../../tutorials/getting-started.md#writing-data): No error displayed instead of actual error.
|5886|rule engine|Feature|Rule Engine: change logic of the [`forecast(name)`](../../rule-engine/functions-forecast.md#forecast) function.
|5885|api-rest|Feature|Series Query: implement additional smoothing functions - [`COUNT`](../../api/data/aggregation.md), [`SUM`](../../api/data/aggregation.md).
|5884|rule engine|Bug|Rule Engine: [Test](../../rule-engine/notifications/README.md#testing-notifications) results misleading if Check on Exit is enabled.
|5883|rule editor|Feature|[Rule Editor](../../rule-engine/README.md): group columns in the results table.
|5881|sql|Feature|SQL: implement [`WAVG`](../../sql/README.md#analytical-functions) and [`EMA`](../../sql/README.md#analytical-functions) window functions.
|5880|core|Feature|Change values by the built-in timer metrics.
|5879|rule engine|Feature|Rule Engine: implement [forecast score](../../rule-engine/functions-forecast.md#forecast_score_stdev) function.
|5878|rule editor|Feature|Rule Editor: add user variables to the [Test](../../rule-engine/notifications/README.md#testing-notifications) results table.
|5877|data-in|Feature|Data Entry: implement [`randomNormal`](../../rule-engine/functions-random.md#randomnormal) freemarker function.
|5876|api-rest|Bug|[Series Query](../../api/data/series/query.md): transformation order validation error if `aggregate:detail` is present.
|5875|forecast|Bug|[Forecast](../../api/data/series/forecast.md): SSA forecast fails for static series (constant value).
|5874|rule engine|Feature|Rule Engine: implement [`ema()`](../../rule-engine/functions-statistical.md#ema) function.
|5873|forecast|Bug|[Forecast](../../api/data/series/forecast.md): SSA grouping error when eigenvector count is insufficient.
|5868|forecast|Feature|[Forecast](../../api/data/series/forecast.md): implement SSA algorithm in Java.
|5867|sql|Feature|SQL: window for [`row_number`](../../sql/README.md#row_number) condition.
|5861|forecast|Bug|[Forecast](../../api/data/series/forecast.md): SSA calculation error.
|5860|forecast|Feature|Java [SSA](https://axibase.com/docs/charts/widgets/shared/#ssa-forecasting-settings): add the `scoringLength` setting.
|5849|forecast|Feature|Java [SSA](https://axibase.com/docs/charts/widgets/shared/#ssa-forecasting-settings): implement forecast scoring and singular value threshold setting.
|5846|forecast|Bug|[Forecast](../../api/data/series/forecast.md): [SSA](https://axibase.com/docs/charts/widgets/shared/#ssa-forecasting-settings) clustering returns too many groups.
|5841|rule engine|Bug|Perform Web Driver processes cleanup at start time and once an hour.
|5839|forecast|Support|[Forecast](../../forecasting/README.md): [SSA](https://axibase.com/docs/charts/widgets/shared/#ssa-forecasting-settings) decomposition.
|5837|csv|Bug|[CSV Wizard](../../parsers/csv/README.md): parse failures.
|5832|core|Feature|Core: introduce named patterns for timestamp formatting and parsing.
|5788|forecast|Feature|Implement [SSA](https://axibase.com/docs/charts/widgets/shared/#ssa-forecasting-settings) forecasting method in Java.
|5780|forecast|Feature|[Series Query](../../api/data/series/query.md): standardize dynamic [forecast](../../api/data/series/forecast.md) setting names.
|5740|csv|Feature|[CSV Parser](../../parsers/csv/README.md): Implement heuristics to map CSV columns to Entity and Metric fields.
|5714|csv|Feature|[CSV Parser](../../parsers/csv/README.md): Add support for series text annotations.
|5606|rule engine|Feature|Rule Engine: implement [`mod()`](../../rule-engine/functions-math.md#mod) function.
|4974|UI|Bug|UI: Single and multiple selects might not work with elements containing HTML entities.

## Charts

Issue| Category    | Type    | Subject
-----|-------------|---------|----------------------
|5970|vscode|Feature|VSCode plugin: add [forecasting settings](https://axibase.com/docs/charts/widgets/shared/#forecasting).
|5890|forecast|Feature|Tooltip: add metadata about joined groups for [SSA](https://axibase.com/docs/charts/widgets/shared/#ssa-forecasting-settings) forecast.
|5888|widget-settings|Bug|[`group-statistic`](https://axibase.com/docs/charts/widgets/shared/#group-statistic): fix `DELTA` aggregation.
|5872|core|Bug|Error processing: extract error message from `responseText`.
|5871|widget-settings|Bug|Widget settings: [`INTERPOLATE`](https://axibase.com/docs/charts/widgets/shared/#interpolate) is not sent to server for `stdev`.
|5870|widget-settings|Feature|Widget settings: add support for [`forecast-ssa-auto`](https://axibase.com/docs/charts/widgets/shared/#ssa-forecasting-settings) setting.
|5831|widget-settings|Bug|[Treemap](https://axibase.com/docs/charts/widgets/treemap/#treemap-widget) and [Calendar](https://axibase.com/docs/charts/widgets/calendar-chart/#calendar-chart): force black color on light background independent of theme.

## Collector

Issue| Category    | Type    | Subject
-----|-------------|---------|----------------------
|5992|core|Bug|[Job](https://axibase.com/docs/axibase-collector/job-generic.html#jobs) Execution: running job without storage driver causes `NPE`.
|5948|UI|Bug|UI: JSP error if [Job](https://axibase.com/docs/axibase-collector/job-generic.html#jobs) cannot be imported.
|5943|docker|Bug|[Docker](https://axibase.com/docs/axibase-collector/jobs/docker.html#docker-job): log information about container properties collection time.
|5908|core|Bug|Reduce logging of INFO steps.
|5907|docker|Bug|[Docker](https://axibase.com/docs/axibase-collector/jobs/docker.html#docker-job): property remover fails on 204.
