# Monthly Change Log: November 2019

## ATSD

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
6509|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): variable writer in **Test** mode.
6574|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): implement back-testing for properties using command log files.
6599|rule editor|Bug|[Rule Engine](../../rule-engine/README.md): apply entity filter in **Entity** auto-complete drop-down on **Test** tab for property and message rules.
6608|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): display intermediate test details.
6615|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): [`sendUdpMessage`](../../rule-engine/functions-utility.md#sendudpmessage).
6619|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): window [field](../../rule-engine/window-fields.md#date-fields) to track the previous command `add_time`.
6638|message|Bug|[Messages](../../api/data/messages/query.md): implement the count method.
6640|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): extract `stderr` when [script](../../rule-engine/functions-script.md) fails.
6646|data-in|Feature|[Data Entry](../../tutorials/getting-started.md#writing-data): upload file with [network](../../api/network/README.md) commands.
6647|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): cannot use [**Derived Commands**](../../rule-engine/derived.md) with message and tags placeholder.
6648|portal|Bug|Portals: [Page widget](https://axibase.com/docs/charts/widgets/page-widget/) must inherit the portal theme.
6652|sql|Bug|[SQL](../../sql/README.md): unexpected double quotes in column names of [outer query](../../sql/README.md#inline-views).
6654|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): cannot use [`scriptOut`](../../rule-engine/functions-script.md) function in variables.
6655|entity|Bug|Entity: incorrect search ignore the required tag condition.
6662|sql|Feature|[SQL](../../sql/README.md): `REGR_SLOPE` and `REGR_INTERCEPT` [analytical](../../sql/README.md#regr_intercept) functions.
6663|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): [linear regression](../../rule-engine/functions-statistical.md) analysis.
6667|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): refactor the **Overview** tab.
6669|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): add more filter parameters to the **View Messages** link.
6670|UI|Feature|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): date format.
6673|csv|Bug|[CSV Parser Wizard](../../tutorials/getting-started-insert.md#csv-files): **Number Format** setting is lost after by the the **Apply** action on **Model** page.
6676|csv|Bug|[CSV Parser Wizard](../../tutorials/getting-started-insert.md#csv-files): cannot automatically parse date with timestamp `MMM dd, yyyy`.
6678|sql|Bug|[SQL](../../sql/README.md): invalid expressions with commas is accepted.
6680|core|Bug|`OutOfMemoryError` error.
6681|sql|Feature|[SQL](../../sql/README.md): type-aware column alignment in the web console.
6682|core|Feature|[Replication](../../administration/monitoring.md#replication): persist metadata commands (`entity`, `metric`, etc).
6683|sql|Bug|[SQL](../../sql/README.md): `NullPointerException` on entity tag match.
6684|sql|Bug|[SQL](../../sql/README.md): incorrect `LIMIT 1` processing.
6685|sql|Bug|[SQL](../../sql/README.md): add error on missing time column when converting results to series.
6686|sql|Feature|[SQL](../../sql/README.md): [`PROPERTY`](../../sql/README.md#property) function.
6687|sql|Feature|[SQL](../../sql/README.md): CSV `GET` export with [`api.guest.access.enabled`](../../administration/server-properties.md#other).
6692|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): usages of [replacement table](../../rule-engine/functions-lookup.md#overview) is not detected in rules.
6693|UI|Bug|UI: add CSV link to [**Replacement Table**](../../rule-engine/functions-lookup.md#overview) editor.
6694|api-rest|Bug|REST API: [replacement table](../../api/meta/replacement-table/get.md#example-with-csv-format) CSV format is broken.
6695|UI|Bug|UI: sort scheduled queries by name.
6697|sql|Feature|[SQL](../../sql/README.md): add [workday calendar](../../sql/README.md#with-workday_calendar) functions.
6698|UI|Feature|UI: add **Data Availability** icon to rule list page.
6699|portal|Feature|UI: link from portal view to portal editor.
6701|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): valid MVEL script highlighted red.
6705|csv|Bug|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): column analysis broken.
6706|sql|Bug|[SQL](../../sql/README.md): `date_round` [`CAST`](../../sql/README.md#cast) error.
6707|sql|Bug|[SQL](../../sql/README.md): correct query became broken.
6709|sql|Bug|[SQL](../../sql/README.md): not able to access quoted [lookup](../../sql/README.md#lookup) tables.
6710|sql|Bug|[SQL](../../sql/README.md): replacement table column not visible in [inner query](../../sql/README.md#inline-views).
6711|sql|Bug|[SQL](../../sql/README.md): access to columns when joining [replacement table](../../sql/README.md#lookup).
6712|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): display warning message when calling [`property`](../../rule-engine/functions-property.md#property) function in **Test**.
6714|sql|Bug|[SQL](../../sql/README.md): [`WITH TIMEZONE`](../../sql/README.md#with-timezone) ignored in [outer query](../../sql/README.md#inline-views).
6715|sql|Bug|[SQL](../../sql/README.md): `NullPointerException` on order.
6717|UI|Bug|[**Replacement Table**](../../rule-engine/functions-lookup.md#overview): new column added on paste into cell.
6718|sql|Bug|[SQL](../../sql/README.md): `NullPointerException` on column validation.
6719|sql|Bug|[SQL](../../sql/README.md): time and [replacement table](../../sql/README.md#lookup) columns.
6720|sql|Feature|[SQL](../../sql/README.md): inherit `TIMEZONE` and `WORKDAY` in inner queries.
6724|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): add command date to diagnostic message.

## Charts

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
6376|calculation|Bug|Derived series: allow usage of [`getValueForDate`](https://axibase.com/docs/charts/syntax/udf.html#getvaluefordate) in `value` setting.
6548|core|Bug|Settings: add support for user-defined [time zones](https://axibase.com/docs/charts/widgets/shared/#timezone).
6605|portal|Feature|Portal: grid display.
6609|widget-settings|Feature|Calendar expression: [`current_working_day`](https://axibase.com/docs/charts/syntax/calendar.html#previous-time).
6651|configuration|Feature|Allow user to write string literals in [`var`](https://axibase.com/docs/charts/syntax/control-structures.html#var) declarations without quotes.
6674|table|Feature|Table Widgets: implement [`null-columns`](https://axibase.com/docs/charts/widgets/shared-table/#column-visibility) setting.
6675|calculation|Feature|[Utility Functions](https://axibase.com/docs/charts/syntax/udf.html#utility-functions): imports are not necessary.
6728|widget-settings|Bug|Settings: replace placeholders in [CSV import](https://axibase.com/docs/charts/syntax/control-structures.html#control-structures).
