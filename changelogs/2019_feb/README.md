# Monthly Change Log: February 2019

## ATSD

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
|5993|forecast|Bug|Forecast: add validation for [`forecast-ssa-decompose-singular-value-threshold`](https://axibase.com/docs/charts/widgets/shared/#forecast-ssa-decompose-singular-value-threshold).
|5989|forecast|Bug|SSA: forecast fails on [`forecast-ssa-decompose-window-length`](https://axibase.com/docs/charts/widgets/shared/#forecast-ssa-decompose-window-length).
|5988|forecast|Bug|[Forecast](../../forecasting/README.md): full decomposition fails.
|5985|csv|Feature|[CSV Parser](../../parsers/csv/README.md): add **Search link** to the **Summary** page.
|5982|csv|Bug|[CSV Parser](../../parsers/csv/README.md): date interpreted as numeric column.
|5981|csv|Feature|[CSV Parser](../../parsers/csv/README.md): add support for non-english month and day names.
|5980|csv|Bug|[CSV Parser](../../parsers/csv/README.md): deprioritize geo columns for **Entity**.
|5978|csv|Bug|[CSV Parser](../../parsers/csv/README.md): ignore high cardinality tags containing intervals.
|5973|csv|Bug|[CSV Parser](../../parsers/csv/README.md): summary page layout and [SQL](../../sql/README.md) statement.
|5972|csv|Bug|[CSV Parser](../../parsers/csv/README.md): add function to extract hosts from ITM agent identifiers if necessary.
|5968|entity|Feature|[Tag Templates](../../configuration/tag-templates.md) editor: show matching entities.
|5966|csv|Bug|[CSV Parser](../../parsers/csv/README.md): `TMZDIFF` ignored in ITM export file.
|5964|csv|Bug|[CSV Parser](../../parsers/csv/README.md): fails to detect date format for `dd-MMM-yy HH:mm:ss` column - ITM export file.
|5960|csv|Bug|[CSV Parser](../../parsers/csv/README.md): failed to test entity from expression.
|5959|csv|Bug|[CSV Parser](../../parsers/csv/README.md): footer line numbers show `N/A`.
|5957|csv|Bug|[CSV Parser](../../parsers/csv/README.md): column analysis for numeric column displayed inconsistent `N/A` information.
|5955|csv|Bug|[CSV Parser](../../parsers/csv/README.md): unexpected `NULL` patterns.
|5953|core|Bug|Core: drop support for 3-letter time zone ids.
|5952|csv|Bug|[CSV Parser](../../parsers/csv/README.md): add auto-completes on Model page.
|5951|csv|Bug|[CSV Parser](../../parsers/csv/README.md): list of metric columns must include only numeric columns.
|5950|csv|Bug|[CSV Parser](../../parsers/csv/README.md): ignore trivial names from entity name candidates.
|5949|csv|Bug|[CSV Parser](../../parsers/csv/README.md): timestamp format on **Model** page.
|5938|csv|Bug|[CSV Parser](../../parsers/csv/README.md): Wrong date format on **Parsing** stage leads to unrecoverable error on **Modelling** stage.
|5937|sql|Feature|SQL: implement [`COVAR`](../../sql/README.md#covar) function to calculate covariance.
|5936|core|Feature|[Incoming webhook](../../api/data/messages/webhook.md): wizard links.
|5934|csv|Bug|[CSV Parser](../../parsers/csv/README.md): column with only 'N' letter is recognized as date.
|5932|csv|Bug|[CSV Parser](../../parsers/csv/README.md): `expand or collapse` state is lost after **Apply** on **Model** stage.
|5931|csv|Bug|[CSV Parser](../../parsers/csv/README.md): columnar layout not working.
|5930|csv|Bug|[CSV Parser](../../parsers/csv/README.md): ignore ordinal columns.
|5928|csv|Feature|[CSV Wizard](../../parsers/csv/README.md): Insert data without saving the parser.
|5927|csv|Bug|[CSV Parser](../../parsers/csv/README.md): ignore numeric GEO columns.
|5926|csv|Bug|[CSV Parser](../../parsers/csv/README.md): no timestamp warning on missing date.
|5924|csv|Bug|[CSV Parser](../../parsers/csv/README.md): re-classify numeric address columns.
|5923|csv|Bug|[CSV Parser](../../parsers/csv/README.md): hide extranous date columns.
|5922|csv|Bug|[CSV Parser](../../parsers/csv/README.md): heade footer height needs to be dynamic.
|5921|csv|Bug|[CSV Parser](../../parsers/csv/README.md): iso-8859 encoding variety.
|5920|rule editor|Bug|Rule Editor: [window fields](../../rule-engine/window-fields.md) in condition.
|5916|data-in|Bug|[Data Entry](../../tutorials/getting-started.md#writing-data): series insertion with text commands entry does not execute rules.
|5912|csv|Bug|[CSV Wizard](../../parsers/csv/README.md): Cannot parse file if column count exceeds 256.
|5904|csv|Bug|[CSV Parser](../../parsers/csv/README.md): entity field reverts to first option.
|5903|csv|Bug|[CSV Parser](../../parsers/csv/README.md): column information wrong.
|5902|csv|Bug|[CSV Wizard](../../parsers/csv/README.md): date parsing fails.
|5899|api-rest|Bug|[Smoothing](../../api/data/series/smooth.md) setting: set default `minimumCount` to `1`.
|5898|api-rest|Bug|[Series Query](../../api/data/series/query.md): transformation order validation.
|5895|UI|Bug|[Forecast](../../forecasting/README.md) Settings: Freemarker error on **Show Meta**.
|5894|csv|Bug|[CSV Wizard](../../parsers/csv/README.md): infinity file uploading.
|5893|api-rest|Bug|[Series Query](../../api/data/series/query.md): forecast after grouping calculation is correct, but the response document is malformed.
|5892|api-rest|Bug|[Series Query](../../api/data/series/query.md): `group-interpolate` must be optional in forecasting transformation.
|5889|forecast|Bug|[Forecast](../../forecasting/README.md): series logging insufficient to reproduce the query.
|5887|data-in|Bug|[Data Entry](../../tutorials/getting-started.md#writing-data): Null error instead actual error.
|5886|rule engine|Feature|Rule Engine: change logic of the [`forecast(name)`](../../rule-engine/functions-forecast.md#forecast) function..
|5885|api-rest|Feature|Series query: implement additional functions - [`COUNT`](../../api/data/aggregation.md), `SUM`(../../api/data/aggregation.md).
|5884|rule engine|Bug|Rule Engine: [Test](../../rule-engine/notifications/README.md#testing-notifications) results misleading on check on exit.
|5883|rule editor|Feature|[Rule Editor](../../rule-engine/README.md): group columns in the results table.
|5881|sql|Feature|SQL: implement [`WAVG`](../../sql/README.md#WAVG) and [`EMA`](../../sql/README.md#EMA) window functions.
|5880|core|Feature|Timer values.
|5879|rule engine|Feature|Rule Engine: [forecast score](../../rule-engine/functions-forecast.md#forecast_score_stdev) function.
|5878|rule editor|Feature|Rule Editor: add variables to the [Test](../../rule-engine/notifications/README.md#testing-notifications) results table.
|5877|data-in|Feature|Data Entry: implement [`randomNormal`](../../rule-engine/functions-random.md#randomNormal) freemarker function.
|5876|api-rest|Bug|[Series Query](../../api/data/series/query.md): transformation order validation error if `aggregate:detail` is present.
|5875|forecast|Bug|[Forecast](../../forecasting/README.md): SSA issues for static series (constant value).
|5874|rule engine|Feature|Rule Engine: implement [`ema()`](../../rule-engine/functions-statistical.md#ema) function.
|5873|forecast|Bug|[Forecast](../../forecasting/README.md): SSA grouping error when triple count is insufficient.
|5868|forecast|Feature|[Forecast](../../forecasting/README.md): SSA settings.
|5867|sql|Feature|SQL: window for [`row_number`](../../sql/README.md#row_number) condition.
|5861|forecast|Bug|Fore[Forecast](../../forecasting/README.md)cast: SSA calculation error.
|5860|forecast|Feature|Java [SSA](https://axibase.com/docs/charts/widgets/shared/#ssa-forecasting-settings): add the `scoringLength` setting.
|5849|forecast|Feature|Java [SSA](https://axibase.com/docs/charts/widgets/shared/#ssa-forecasting-settings): implement forecast scoring and singular value threshold adjustment.
|5846|forecast|Bug|[Forecast](../../forecasting/README.md): [SSA](https://axibase.com/docs/charts/widgets/shared/#ssa-forecasting-settings) clustering returns too many groups.
|5841|rule engine|Bug|Perform non-used Web Driver processes cleanup at start time and once an hour.
|5839|forecast|Support|[Forecast](../../forecasting/README.md): [SSA](https://axibase.com/docs/charts/widgets/shared/#ssa-forecasting-settings) decomposition.
|5837|csv|Bug|[CSV Wizard](../../parsers/csv/README.md): parse failures.
|5832|core|Feature|Core: introduce named patterns for timestamp formatting and parsing.
|5788|forecast|Feature|Implement [SSA](https://axibase.com/docs/charts/widgets/shared/#ssa-forecasting-settings) forecasting method in Java.
|5780|forecast|Feature|[Series Query](../../api/data/series/query.md): choose appropriate names for dynamic forecast parameters.
|5740|csv|Feature|[CSV Parser](../../parsers/csv/README.md): Implement heuristics to map CSV columns to Entity and Metric fields.
|5714|csv|Feature|[CSV Parser](../../parsers/csv/README.md): Add support for series text annotations.
|5606|rule engine|Feature|Rule Engine: implement [`mod()`](../../rule-engine/functions-math.md#mod) function.
|4974|UI|Bug|UI: Single and multiple selects might not work with elements containing HTML entities.

## Charts

Issue| Category    | Type    | Subject
-----|-------------|---------|----------------------
|5970|vscode|Feature|VSCode plugin: add [forecasting settings](https://axibase.com/docs/charts/widgets/shared/#forecasting).
|5890|forecast|Bug|Tooltip: add metadata about joined groups for [SSA](https://axibase.com/docs/charts/widgets/shared/#ssa-forecasting-settings) forecast.
|5888|widget-settings|Bug|[`group-statistic`](https://axibase.com/docs/charts/widgets/shared/#group-statistic): fix `DELTA` aggregation.
|5872|core|Bug|Error processing: extract error from `responseText`.
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
