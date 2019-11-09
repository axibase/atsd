# Monthly Change Log: October 2019

## ATSD

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
6463|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): validate [**Derived Commands**](../../rule-engine/derived.md) using  a matching command.
6509|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): display history of local variables **Test** mode.
6574|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): implement **Test** for properties using command files.
6582|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): add more fields to the filters on the **Windows** tab.
6583|UI|Bug|UI: [named collection](../../rule-engine/functions-lookup.md#overview) references ignores rules where collection is used.
6584|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): add `entities` parameter to the [`rule_windows`](../../rule-engine/functions-rules.md#rule_windows) function.
6585|rule editor|Bug|[Rule Engine](../../rule-engine/README.md): `Ctrl+Click` for [`rule_window`](../../rule-engine/functions-rules.md#rule_window) function to view referenced records.
6586|rule editor|Feature|[Rule Editor](../../rule-engine/README.md): display tag names in auto-complete lists.
6594|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): change columns on the Filter results page for property rules.
6600|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): borders are colored in red without a reason.
6604|data-in|Bug|[Properties](../../api/network/property.md): commands are not logged in command.log if inserted via Data Entry form.
6608|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): display progress bar with intermediate results on the **Test** tab.
6616|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): [placeholder](../../rule-engine/placeholders.md#placeholders) error does not contain [rule name](../../rule-engine/links.md) in log errors.
6617|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): escape [placeholders](../../rule-engine/placeholders.md#placeholders) present in the incoming command.
6620|csv|Feature|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): add Locale support for old parsers.
6622|csv|Bug|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): writes data into HBase even if data insertion is disabled.
6623|csv|Feature|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): add **Remove Prefix** setting in csv parsers.
6624|portal|Bug|[Portal](../../portals/README.md): HTTP Error 400 when creating a new portal.
6627|csv|Feature|[CSV Tasks](../../parsers/csv/README.md#uploading-csv-files): store messages with the number of processed commands and messages at the beginning and end of file processing.
6628|csv|Feature|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): allow to modify tag key and value for non-mapped tags.
6630|portal|Bug|[Portal](../../portals/README.md): embedded browser cannot make a portal screenshot.
6631|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): cache `min` and `max` for [`property`](../../api/network/property.md) commands in `command.log` ZIP files during testing on **Test** tab.
6633|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): add error details to failed [script](../../rule-engine/scripts.md) tasks.
6634|administrator|Bug|[Log](../../administration/logging.md) messages: minimize print out of stack traces where not needed.
6635|message|Bug|Storage: message [clear](../../api/data/messages/delete.md#deleting-all-messages) fails to delete data.
6637|core|Bug|`OutOfMemoryError` error.
6643|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): show warning if no type and source is specified on the message filter.

## Charts

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
6547|calendar|Bug|Calendar: [sort](https://axibase.com/docs/charts/widgets/calendar-chart/#sort-by-statistic) by statistic.
6554|calendar|Feature|Calendar: [controls](https://axibase.com/docs/charts/widgets/calendar-chart/#summarize-period-panel) to change [`summarize-period`](https://axibase.com/docs/charts/widgets/calendar-chart/#summarize-period).
6592|treemap|Bug|Treemap: add support for `value` placeholder in [`label-format`](https://axibase.com/docs/charts/syntax/label-formatting.html#label-formatting).
6595|visual design|Feature|Allow to specify [theme](https://axibase.com/use-cases/tutorials/shared/chartlab.html#miscellaneous-features) as request parameter.
6596|text|Bug|[Text Widget](https://axibase.com/docs/charts/widgets/text-widget/): settings validation.
6610|widget-settings|Bug|[`end-time`](https://axibase.com/docs/charts/widgets/shared/#end-time) error cannot be investigated.
