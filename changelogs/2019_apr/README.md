# Monthly Change Log: April 2019

## ATSD

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
6227|core|Bug|Excessive [logging](../../administration/logging.md) hides diagnostics.
6221|rule engine|Bug|Rule Engine: corrupted window state is shown on [**Rule Window**](../../rule-engine/README.md#rule-windows) form for subsequent commands with same timestamp.
6213|rule editor|Bug|Rule Engine: can not set [variable](../../rule-engine/variables.md#variables) value to `notify_time`.
6212|client|Bug|[Python API Client](https://github.com/axibase/atsd-api-python): tests failing.
6206|sql|Feature|[Scheduled SQL](../../sql/scheduled-sql.md#sql-scheduler): query results in HTML format without form.
6204|api-network|Bug|Non-descriptive error [logged](../../administration/logging.md) when TCP handler receives an invalid command.
6201|rule editor|Bug|[Rule Engine](../../rule-engine/README.md): HTTP 500 code when trying to access variable from another rule.
6200|rule editor|Bug|Rule Engine: [`coalesce`](../../rule-engine/functions-text.md#coalesce) function with 4 arguments throws an error in variable field.
6196|administrator|Bug|[Server Properties](../../administration/server-properties.md#server-properties): EOL and whitespace not trimmed in `hadoop.properties`.
6195|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): create a separate queue for each action handler.
6194|security|Bug|[API Tokens](../../administration/user-authentication.md#token-authentication): match URL considering different ways of URL encoding.
6187|rule engine|Bug|Rule Engine: [derived command](../../rule-engine/derived.md#derived-commands) causes an error at runtime if it contains line breaks.
6186|rule engine|Bug|Rule Engine: [derived commands](../../rule-engine/derived.md#derived-commands) error hidden.
6185|security|Bug|Security: wrong HTTP codes when trying to get [token](../../administration/user-authentication.md#token-authentication).
6183|rule engine|Bug|Rule Engine: [**Log to Alert History**](../../rule-engine/logging.md#logging-to-database) setting is ignored.
6181|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): customizable action execution delay.
6179|UI|Bug|UI: Unsupported patterns suggested in time autocomplete.
6175|rule editor|Bug|[Rule Engine](../../rule-engine/README.md): update function names for syntax highlighting.
6173|email|Bug|[Mail Client](../../administration/mail-client.md#mail-client): infinite loading with wrong server name.
6172|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): empty window when saving rule without name or condition.
6171|api-rest|Feature|Series Query: implement [`autoAggregate`](../../api/data/series/forecast.md#regularization-fields) setting for forecasts.
6170|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): function changes.
6168|UI|Feature|[Forecast View](../../tutorials/getting-started.md#viewing-statistics): grouping support.
6164|rule engine|Feature|Rule Engine: new [utility](../../rule-engine/functions.md#utility) functions.
6155|rule engine|Feature|Rule Engine: add parameter to [`value`](../../rule-engine/functions-value.md#value-functions) function to return a default if metric is not present in the command.
6154|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): property processing on incremental updates.
6152|rule editor|Bug|Rule Editor: error not raised if [variable](../../rule-engine/variables.md#variables) is declared multiple times.
6150|rule editor|Bug|[Rule Engine](../../rule-engine/README.md): rule validation hangs.
6149|forecast|Bug|Forecast: read [stored forecasts](../../forecasting/README.md#data-forecasting) with the same tag.
6147|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): unreadable expression on condition evaluation exception.
6146|api-rest|Feature|Series Query: implement [grouping](../../api/data/series/group.md#fields) by entity and specified series tags.
6144|forecast|Bug|Forecast: unstable [SSA](../../api/data/series/forecast.md#ssa-fields) calculation.
6142|forecast|Bug|[**Forecast Settings**](../../forecasting/README.md#data-forecasting): series is not available for forecasting if it's last insert time is bigger than now.
6140|core|Bug|Delete error.
6138|core|Bug|`DateParsingUtil::parseWithLocalTime` ignores wrong day number.
6136|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): `Open Details` link shows empty content on some clicks.
6135|UI|Bug|UI: pagination returns too many pages when list is searched by tag.
6143|UI|Bug|Entities page can not be accessed with HTTP 500 error.
6139|forecast|Bug|`ForecastsSettingsDao`: wrong tags escaping.
6133|rule engine|Feature|Rule Engine: [`rule_window`](../../rule-engine/functions-rules.md#rule_window) function must return `ElContext` object.
6132|export|Bug|[Export Form](../../reporting/ad-hoc-exporting.md#ad-hoc-export-settings): Cannot use single quotes in `Entity Expression`.
6130|api-rest|Feature|Properties Query: add [`merge`](../../api/data/properties/query.md#field-filter) setting.
6129|forecast|Bug|[**Forecast Settings**](../../forecasting/README.md#data-forecasting): remove code which process the export from ATSD.
6123|sql|Feature|SQL: allow access to specific entity tags column by name in [outer](../../sql/README.md#inline-views) query.
6120|sql|Bug|SQL: [outer](../../sql/README.md#inline-views) query entity condition ignored.
6116|api-rest|Bug|[Series Query](../../api/data/series/query.md#series-query): `percentile` not supported by forecast.
6114|api-rest|Feature|Series Query: implement forecast [`range`](../../api/data/series/forecast.md#control-fields) limit.
6112|api-rest|Feature|Series Query: implement last timestamp filter.
6109|forecast|Feature|[**Forecast Settings**](../../forecasting/README.md#data-forecasting): implement all forecast settings for each forecast algorithm.
6108|forecast|Bug|[**Forecast Settings**](../../forecasting/README.md#data-forecasting): bad Holt-Winters forecast.
6106|export|Bug|[Scheduled Export](../../reporting/scheduled-exporting.md#scheduled-exporting): field changes.
6091|api-network|Bug|[Data Entry](../../versioning/README.md#data-entry-form): cannot change `Time Zone` for entity.
6078|csv|Bug|[CSV Wizard](../../parsers/csv/README.md#uploading-csv-files): valid header ignored.
6076|data-in|Bug|[Message](../../api/network/message.md#message-command) command on **Data Entry** page not stored.
6072|forecast|Feature|[**Forecast Settings**](../../forecasting/README.md#data-forecasting): form layout.
6067|forecast|Feature|Forecast: add links to charts with produced ARIMA and Holt-Winters forecasts to the [**Forecast Settings**](../../forecasting/README.md#data-forecasting) page.
6062|csv|Bug|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): optimize analysis to handle larger files.
6058|csv|Bug|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): add validation to `Stop Condition -> Stop on matching pattern`.
6053|csv|Bug|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files) Wizard: **Encoding** and **Skip first Lines**.
6037|forecast|Bug|Forecast [SSA](../../api/data/series/forecast.md#ssa-fields): unexpected errors.
6036|forecast|Feature|[**Forecast Settings**](../../forecasting/README.md#data-forecasting): add support of **default forecast** settings for [SSA](../../api/data/series/forecast.md#ssa-fields) forecasts.
6018|security|Feature|OAuth2 access [tokens](../../administration/user-authentication.md#token-authentication) for restricted access to REST API.
6003|forecast|Bug|Forecast: [SSA](../../api/data/series/forecast.md#ssa-fields) produces no forecast with `*-sinfilar-value-threshold` set to `0`.
5975|csv|Bug|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): row filter.
5969|forecast|Feature|[Series Forecast Viewer](../../tutorials/getting-started.md#viewing-statistics).
5965|api-rest|Feature|Series Query: extend [grouping](../../api/data/series/group.md#fields) transformation to group series based on correlation and constraints.
5958|csv|Bug|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): model stage - entity field inconsistent.
5939|csv|Bug|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): multiple fixes.
5687|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): optimize performance of events exiting window.

## Charts

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
6220|widget-settings|Bug|[Validator](https://github.com/axibase/axibase-charts-vscode) errors and column name changes.
6214|time-chart|Bug|Time Chart: [`series-type`](https://axibase.com/docs/charts/widgets/time-chart/#series-type) is not applied.
6176|configuration|Bug|[Alert Table](https://axibase.com/docs/charts/widgets/alert-table/#alert-table): exception with multiline setting.
6162|widget-settings|Bug|Portal config: make [`group-statistic`](https://axibase.com/docs/charts/widgets/shared/#group-statistic) case insensitive.
6159|property|Feature|Property Table: provide a way to process data values as [numbers](https://axibase.com/docs/charts/widgets/property-table/#parse-numbers).
6125|widget-settings|Feature|`movavg` with [`interval`](https://axibase.com/docs/charts/syntax/value-functions.html#movavg-alias-interval-mininterval-function) instead of [`count`](https://axibase.com/docs/charts/syntax/value-functions.html#movavg-alias-count-mincount-function).
6103|widget-settings|Bug|[`[dropdown]`](https://axibase.com/docs/charts/configuration/drop-down-lists.html#drop-down-lists): greedy settings parse.
5935|table|Bug|Series Table: [`format-headers`](https://axibase.com/docs/charts/widgets/shared-table/#format-headers) ignored.
5829|widget-settings|Bug|[`var`](https://axibase.com/docs/charts/syntax/control-structures.html#var) assignment fails if ending semi-colon is present.
5828|widget-settings|Feature|Add support for [`median_abs_dev`](https://axibase.com/docs/charts/configuration/aggregators.html#median_abs_dev).

## Collector

 Issue| Category    | Type    | Subject
 ------|-------------|---------|--------
6167|mqtt|Feature|MQTT: implement [job](https://axibase.com/docs/axibase-collector/jobs/mqtt.html#mqtt-job) supporting MQTT brokers.
