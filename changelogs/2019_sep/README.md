# Monthly Change Log: September 2019

## ATSD

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
3049|sql|Feature|[SQL](../../sql/README.md): [math](../../sql/README.md#mathematical-functions) functions.
5772|UI|Feature|[CSV Parser Wizard](../../tutorials/getting-started-insert.md#csv-files): implement wizard-based parser UI.
5858|odbc|Feature|[ODBC](https://github.com/axibase/atsd-odbc/releases) driver.
6225|UI|Feature|[Rule Engine](../../rule-engine/README.md): save notification state when user switches [webhook](../../rule-engine/notifications/README.md).
6251|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): add support for [`orb tags`](../../rule-engine/control-flow.md) and [`expression`](../../rule-engine/condition.md) context to [Email](../../rule-engine/email.md) recipients input.
6278|rule editor|Bug|[Rule Engine](../../rule-engine/README.md): [`expression`](../../rule-engine/condition.md) syntax is not highlighted in [Email](../../rule-engine/email.md) recipients.
6425|csv|Feature|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): add custom tag with static value.
6460|message|Bug|Message stats: flexible filtering using [`tagExpression`](../../api/data/messages/stats.md#calculation-fields).
6480|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): unable to show alert details if a [variable](../../rule-engine/condition.md#variables) has `null` value.
6488|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): optional parameter for [`detailsTable`](../../rule-engine/details-table.md) to print only local variables.
6492|sql|Bug|[SQL](../../sql/README.md): strange result with `LIMIT 1` during write activity.
6503|rule engine|Bug|[Rule Editor](../../rule-engine/README.md): message search direction in [webhook](../../rule-engine/notifications/README.md) test.
6507|rule editor|Feature|[Rule Editor](../../rule-engine/README.md): add local [variables](../../rule-engine/condition.md#variables) to auto-complete.
6509|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): [variable](../../rule-engine/condition.md#variables) writer in **Test** mode.
6510|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): support [calendar syntax](../../shared/calendar.md) in [`db_statistics`](../../rule-engine/functions-series.md#db_statistics) and [`db_statistic`](../../rule-engine/functions-series.md#db_statistic) functions.
6518|sql|Feature|[SQL](../../sql/README.md): support `DayOfMonth` and `DayOfYear` units in [`EXTRACT`](../../sql/README.md#extract) function.
6523|rule editor|Bug|[Rule Engine](../../rule-engine/README.md): **Test** using init and event scripts inconclusive.
6524|UI|Bug|[Replacement Table](../../api/meta/replacement-table/create-or-replace.md#replacement-table-create-or-replace): datatype and header guess incorrect in paste.
6526|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): add all conditions to context links.
6528|sql|Bug|[SQL](../../sql/README.md): fix [`DATEADD`](../../sql/README.md#dateadd) to recognize date in [ISO format](../../shared/date-format.md).
6529|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): [**Derived Commands**](../../rule-engine/derived.md) validator loads wrong command.
6532|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): **Test** error lacks explanation.
6533|rule editor|Feature|[Rule Editor](../../rule-engine/README.md): auto-complete in placeholders.
6535|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): infinite or `NaN` error is non-descriptive.
6536|sql|Feature|[SQL](../../sql/README.md): `DISTINCT` keyword in [aggregation](../../sql/README.md#analytical-functions) functions.
6538|sql|Feature|[SQL](../../sql/README.md): support `SELECT DISTINCT`.
6539|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): add `iso` field to [`DateTime`](../../rule-engine/object-datetime.md) object.
6540|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): **Test** results unexpected for `count == 0` rule.
6543|rule editor|Feature|[Rule Editor](../../rule-engine/README.md): support `Ctrl+click` in functions with argument expressions.
6544|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): field name or expression missing from error message in **Test** mode.
6545|UI|Feature|UI: standardise page titles.
6551|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): error message not specific.
6552|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): allow [`db_statistics`](../../rule-engine/functions-series.md#db_statistics) to calculate statistics for multiple series.
6553|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): always date filter column.
6555|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): functions missing in auto-complete.
6556|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): `BETWEEN` operator fails when used in user [variables](../../rule-engine/condition.md#variables).
6559|sql|Feature|[SQL](../../sql/README.md): add function to [access](../../sql/README.md#collection) **Named Collection**.
6560|sql|Feature|[SQL](../../sql/README.md): sliding [time window](../../rule-engine/window.md#time-based-windows).
6563|sql|Feature|[SQL](../../sql/README.md): link to console from preview.
6564|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): do not initialize windows for series that do not satisfy **Test** filter.
6565|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): cache [`value()`](../../rule-engine/functions-value.md) calls during **Test**.
6569|rule editor|Bug|[Rule Engine](../../rule-engine/README.md): [notification](../../rule-engine/notifications/README.md) test hangs.
6570|administrator|Feature|[Logging](../../administration/logging.md): do not compress non-log files in `logs` directory.
6571|sql|Bug|[SQL](../../sql/README.md): unexpected column order in [`OUTER`](../../sql/README.md#outer-join) query.
6576|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): user [variable](../../rule-engine/condition.md#variables) is not accessible in [property-based](../../rule-engine/filters.md#data-type-filter) window.
6577|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): [`db_message_last`](../../rule-engine/functions-message.md#db_message_last) returns not the last message.
6581|rule editor|Feature|[Rule Editor](../../rule-engine/README.md): add syntax highlight to [`condition`](../../rule-engine/condition.md) script fields.
6593|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): [`unlock`](../../rule-engine/functions-utility.md#unlock) function.
6597|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): statistics are empty for window with size 1.
6598|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): HTTP 500 error on [property-based](../../rule-engine/filters.md#data-type-filter) [time](../../rule-engine/window.md#time-based-windows) window when opening for view it after time exceeds.

## Charts

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
6359|console|Feature|Table Widgets: implement setting to [highlight](https://axibase.com/docs/charts/widgets/shared-table/#new-row-color) recently received rows.
6379|table|Feature|Alert Table: add functionality to [collapse](https://axibase.com/docs/charts/widgets/alert-table/#collapsible) row.
6439|table|Bug|Table Widgets: button icons are not vertically aligned.
6542|table|Bug|Table Widgets: derived column became broken if [`label`](https://axibase.com/docs/charts/widgets/shared/#label) is specified.
6546|widget-settings|Bug|Settings: [`auto-scale`](https://axibase.com/docs/charts/widgets/time-chart/#auto-scale) and [`max-range-force`](https://axibase.com/docs/charts/widgets/shared/#max-range-force).
6557|chart lab|Bug|[Calendar](https://axibase.com/docs/charts/widgets/calendar-chart/): add missing validator rules.
6567|chart lab|Support|ChartLab and Language Server: obsolete syntax in widget snippets.
6575|treemap|Bug|[Treemap](https://axibase.com/docs/charts/widgets/treemap/): add validation rules.

## Collector

Issue| Category    | Type    | Subject
------|-------------|---------|--------
6344|core|Bug|Core: prevent memory leak.
6456|mqtt|Bug|[MQTT](https://axibase.com/docs/axibase-collector/jobs/mqtt.html):JSON configuration enhancement.
6587|administrator|Feature|Administration: show time sync with storage as alert.
