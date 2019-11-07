# Monthly Change Log: October 2019

## ATSD

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
6463|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): [**Derived Commands**](../../rule-engine/derived.md) validator enhancement.
6509|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): variable writer in **Test** mode.
6574|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): implement **Test** for properties using command files.
6582|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): expose whole window context in **Windows** filter.
6583|UI|Bug|UI: [named collection](../../rule-engine/functions-lookup.md#overview) usage misses rule [variables](../../rule-engine/condition.md#variables).
6584|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): add entities parameter to [`rule_windows`](../../rule-engine/functions-rules.md#rule_windows).
6585|rule editor|Bug|[Rule Engine](../../rule-engine/README.md): `Ctrl+Click` for [`rule_window`](../../rule-engine/functions-rules.md#rule_window) function.
6586|rule editor|Feature|[Rule Editor](../../rule-engine/README.md): add tag names to auto-complete.
6594|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): change columns on filter page for property rules.
6600|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): boundaries are coloured in red without a reason.
6604|data-in|Bug|[Properties](../../api/network/property.md): commands are not logged if inserted via form.
6608|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): intermediate **Test** details to display progress.
6616|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): [placeholder](../../rule-engine/placeholders.md#placeholders) error does not contain [rule name](../../rule-engine/links.md).
6617|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): handle [placeholder](../../rule-engine/placeholders.md#placeholders) in the command.
6620|csv|Feature|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): add timestamp locale support for old parsers.
6622|csv|Bug|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): input settings do not affect the ability to insert data.
6623|csv|Feature|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): add **Remove Prefix** setting in old parser.
6624|portal|Bug|[Portal](../../portals/README.md): HTTP Error 400 on new portal creation page.
6627|csv|Feature|[CSV Tasks](../../parsers/csv/README.md#uploading-csv-files): add information about number of sent commands and send messages on start of file processing and end of file processing.
6628|csv|Feature|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): allow to modify tag key and value for non-mapped tags.
6630|portal|Bug|[Portal](../../portals/README.md): Phantomjs cannot make a portal screenshot.
6631|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): cache `min` and `max` for [`property`](../../api/network/property.md) commands in `command.log` ZIP files during testing.
6633|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): [script](../../rule-engine/scripts.md) error non-descriptive.
6634|administrator|Bug|[Log](../../administration/logging.md) messages: minimize print out of stack traces where not needed.
6635|message|Bug|Storage: message [clear](../../api/data/messages/delete.md#deleting-all-messages) fails.
6637|core|Bug|Unexpected `OutOfMemoryError` error.
6643|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): show warning if the message filter is too broad.

## Charts

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
6547|calendar|Bug|Calendar: [sort](https://axibase.com/docs/charts/widgets/calendar-chart/#sort-by-statistic) by statistic.
6554|calendar|Feature|Calendar: [controls](https://axibase.com/docs/charts/widgets/calendar-chart/#summarize-period-panel) to change [`summarize-period`](https://axibase.com/docs/charts/widgets/calendar-chart/#summarize-period).
6592|treemap|Bug|Treemap: add support for `value` placeholder in [`label-format`](https://axibase.com/docs/charts/syntax/label-formatting.html#label-formatting).
6595|visual design|Feature|Allow to specify [theme](https://axibase.com/use-cases/tutorials/shared/chartlab.html#miscellaneous-features) as request parameter.
6596|text|Bug|[Text Widget](https://axibase.com/docs/charts/widgets/text-widget/): settings validation.
6610|widget-settings|Bug|[`end-time`](https://axibase.com/docs/charts/widgets/shared/#end-time) error cannot be investigated.
