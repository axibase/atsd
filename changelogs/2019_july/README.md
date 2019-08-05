# Monthly Change Log: July 2019

## ATSD

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
5086|sql|Feature|SQL: `endtime` calculations to align with [`CALENDAR`](../../sql/README.md#calendar-alignment).
5779|csv|Feature|[CSV Parser Wizard](../../tutorials/getting-started-insert.md#csv-files): implement Series parser.
5901|api-rest|Bug|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): model issues.
6156|rule editor|Bug|Rule Editor: [window variables](../../rule-engine/window-fields.md#window-and-command-fields) are not accessible for property window.
6163|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): optimize financial rules.
6226|forecast|Bug|Forecast: linear values present in [SSA](../../api/data/series/forecast.md#forecasting) forecast.
6265|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): default portal does not generate additional series graphs if [`db_last`](../../rule-engine/functions-series.md#db_last) function contains dynamic property.
6282|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): support Markdown in [Emails](../../rule-engine/email.md#email-action).
6285|message|Feature|UI: add button to generate console widget from [**Search**](../../search/README.md) page.
6303|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): log storm into `err.log`.
6312|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): warning is not shown when creating a new rule with webhook that contains unknown placeholder.
6319|api-network|Bug|TCP: no response from [`debug`](../../api/network/message.md#troubleshooting) command on tag values with line separator.
6326|UI|Feature|UI: show [groups](../../administration/user-authorization.md#entity-permissions) for entity in **Entity Editor**.
6336|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): implement time hash function to block competing actions.
6337|UI|Feature|[Replacement Table](../../api/meta/replacement-table/create-or-replace.md#replacement-table-create-or-replace): implement CSV format.
6342|data-in|Bug|[**Data Entry**](../../tutorials/getting-started.md#writing-data): versioned value inserted twice.
6345|rule editor|Bug|[Rule Engine](../../rule-engine/README.md): cannot use autocomplete and syntax is not highlighted if form contains errors.
6349|sql|Bug|[SQL](../../sql/README.md): calendar expressions in `INSERT` and `UPDATE` statements.
6350|UI|Feature|[SQL](../../sql/README.md): `DELETE` statement.
6352|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): force windows initialization for [`count()`](../../rule-engine/functions-statistical.md#count) rules.
6355|export|Bug|[Export](../../reporting/ad-hoc-exporting.md#ad-hoc-exporting): incorrect display of versioning data.
6360|sql|Bug|SQL: incorrect [`IN`](../../sql/README.md#in-expression) condition processing in `WHERE` clause.
6361|sql|Bug|SQL: extract precision from [round](../../sql/README.md#mathematical-functions) functions.
6362|sql|Bug|SQL: [cancel](../../sql/sql-console.md#cancel) does not stop a long-running query.
6364|message|Bug|**Message Search**: incorrect results for keywords.
6365|sql|Bug|SQL: slow query performance with [`JOIN`](../../sql/README.md#joins).
6366|sql|Bug|SQL: [date condition](../../sql/README.md#multiple-intervals) errors.
6367|sql|Feature|SQL: [workday](../../sql/README.md#is_workday) and [weekday](../../sql/README.md#is_weekday) functions.
6369|sql|Bug|[SQL Console](../../sql/sql-console.md): number is not highlighted, if it comes after division sign `/`.
6372|entity_views|Feature|[Entity Views](../../configuration/entity_views.md): support math functions from Rule Engine in Entity View expressions.
6374|sql|Feature|SQL: allow sting expressions in [date functions](../../sql/README.md#date-functions).
6378|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): fix [`min`](../../rule-engine/functions-math.md#max) and [`max`](../../rule-engine/functions-math.md#max) functions validation with constant arguments.
6381|sql|Bug|SQL: `NullPointerException` with [`ROW_NUMBER`](../../sql/README.md#row_number).
6382|sql|Feature|SQL: support multiple [`WITH`](../../sql/README.md#partition-condition) clauses.
6383|sql|Bug|SQL: `NullPointerException` with [`LOOKUP`](../../sql/README.md#lookup) function.
6384|UI|Bug|Metrics: create page does not work.
6385|message|Feature|**Message Search**: add entity link and row to form copy.
6386|UI|Bug|[SQL Console](../../sql/sql-console.md): open link in new tab to prevent unsaved alert.
6388|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): incorrect change alert.
6390|sql|Bug|SQL: slow query performance with [`JOIN`](../../sql/README.md#joins) - [date condition](../../sql/README.md#multiple-intervals) not passed to filter.
6392|metric|Feature|**Message Search** history suggest.
6396|sql|Bug|SQL: [console](../../sql/sql-console.md) is not showing results for queries that run more than 2 minutes.
6398|sql|Bug|SQL: define tags columns [ordering](../../sql/README.md#collation).
6400|rule editor|Feature|[Rule Editor](../../rule-engine/README.md): easy access to collections and replacement tables.
6401|rule engine|Bug|[Rule Editor](../../rule-engine/README.md): unexpected **Time Open** and **Time Cancel** in Test results.
6404|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): continue cell validation after first error.
6408|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): incorrect alert.
6412|UI|Bug|UI: [topic](../../rule-engine/email.md#topic-watchers) table broken.
6415|sql|Feature|SQL: allow [`first_value`](../../sql/README.md#first_value) and `last_value` functions to get first and last row in the partition.
6416|sql|Bug|SQL: [`min`](../../sql/README.md#aggregate-functions)  and [`max`](../../sql/README.md#aggregate-functions) datetime with period show incorrect value.
6418|sql|Feature|SQL: [workday](../../sql/README.md#is_workday) function behavior when increment is `0`.
6419|csv|Bug|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): apply request parameters for series parser.
6421|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): rule remains in `REPEAT` status despite being deactivated by date filter.
6422|sql|Bug|SQL: columns not accessible in queries to [`atsd_entity`](../../sql/README.md#atsd_entity-table).
6423|sql|Feature|SQL: function to count the number of working days between two input dates.
6425|csv|Feature|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): add custom tag with static value.
6427|UI|Bug|[CSV Parser Wizard](../../tutorials/getting-started-insert.md#csv-files): wrong error message.

## Charts

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
5869|forecast|Bug|Forecast: [style](https://axibase.com/docs/charts/widgets/time-chart/#forecast-style) must be applied to forecasts with any mode, not only `column` or `column-stack`.
6231|chart lab|Feature|ChartLab Upgrade: migrate to Monaco editor.
6269|core|Bug|Charts: NMON Portal is not loaded.
6393|widget-settings|Bug|[`label-format`](https://axibase.com/docs/charts/widgets/shared/#label-format) is not applied to derived series.
6406|chart lab|Bug|ChartLab: post-upgrade issues.
6411|chart lab|Bug|ChartLab: enhancements.

## Collector

Issue| Category    | Type    | Subject
------|-------------|---------|--------
6347|kafka|Bug|[Kafka Job](https://axibase.com/docs/axibase-collector/jobs/kafka.html#kafka-job): `NullPointerException` on using non-existing JSON field for time in `JSON` mode.
6371|json|Bug|[JSON Job](https://axibase.com/docs/axibase-collector/jobs/json.html#json-job): cyrillic symbols presented as question marks on HBS.
6377|file|Bug|[File Job](https://axibase.com/docs/axibase-collector/jobs/file.html#file-job): `NullPointerException` with attempt to clone configuration.
6413|json|Bug|[JSON Job](https://axibase.com/docs/axibase-collector/jobs/json.html#json-job): `NullPointerException` on attempt to launch Viewer for unsaved configuration.
6428|UI|Bug|UI: font is downloaded instead of redirect in incognito mode.
