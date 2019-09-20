# Monthly Change Log: August 2019

## ATSD

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
4210|export|Feature|[Export](../../reporting/ad-hoc-exporting.md#ad-hoc-exporting): simplified method to export and import series data.
4799|UI|Bug|UI: font alternatives.
5961|sql|Feature|[SQL](../../sql/README.md): series output format.
5962|sql|Feature|[SQL](../../sql/README.md): support for non-parameterized [`INSERT`](../../sql/README.md#insert-syntax).
5977|csv|Bug|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): ignore numeric column options in entity column drop-down.
6074|UI|Feature|[Export](../../reporting/ad-hoc-exporting.md#ad-hoc-exporting): result fields in HTML format.
6079|csv|Feature|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): create filter for time columns.
6153|api-rest|Feature|[Series Query](../../api/data/series/query.md): `vwap` calculation and MVEL UDF.
6217|rule editor|Bug|UI: form edit alert on `Ctrl-C`.
6248|export|Bug|Mismatch of default interval unit value on [forecast jobs](../../forecasting/README.md#data-forecasting) page and [export](../../reporting/ad-hoc-exporting.md#ad-hoc-exporting) page if `StarDate` and `EndDate` are specified.
6256|export|Bug|[Forecast](../../forecasting/README.md#data-forecasting): incorrect data type on export form page.
6346|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): create new alert endpoint in ATSD UI.
6350|UI|Feature|[SQL](../../sql/README.md): [`DELETE`](../../sql/README.md#delete-syntax) statement.
6356|export|Bug|[Export](../../reporting/ad-hoc-exporting.md#ad-hoc-exporting) form: `NaN` value is shown as a special character.
6358|sql|Feature|[SQL](../../sql/README.md): expose replacement tables in [SQL](../../sql/README.md).
6397|UI|Feature|UI: add referencing rules.
6400|rule editor|Feature|[Rule Editor](../../rule-engine/README.md): easy access to collections and replacement tables.
6424|csv|Feature|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): detect ATSD `export.csv` schema.
6429|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): improve default chart generation performance for rules with multiple user variables with complex expressions.
6434|core|Feature|Versioning: enable versioning for [rules](../../rule-engine/README.md), [replacement tables](../../rule-engine/functions-lookup.md#overview), [named collections](../../rule-engine/functions-lookup.md#overview).
6436|csv|Bug|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): named tag columns in [SQL](../../sql/README.md) queries.
6437|portal|Feature|UI: integrate monaco editor with Charts extensions.
6438|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): show **Date Filter** status on **Rule Diagnosis** page.
6443|message|Feature|[Message stats](../../api/data/messages/stats.md#messages-stats): restore functionality.
6444|csv|Bug|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): numeric comparison in **Row Filter**.
6445|sql|Feature|[SQL](../../sql/README.md): implement [`is_entity_in_group`](../../sql/README.md#is_entity_in_group) function.
6446|api-rest|Bug|REST API: property [`GET`](../../api/data/properties/get.md) returns date in wrong format.
6447|entity_views|Bug|UI: entity view search not finding records.
6449|csv|Bug|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): month extraction fails.
6450|rule engine|Feature|[Replacement Table](../../api/meta/replacement-table/create-or-replace.md#replacement-table-create-or-replace): key column name in CSV format.
6451|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): replacement table schema change causes rule error.
6454|client|Feature|[Python API Client](https://github.com/axibase/atsd-api-python#atsd-python-client): implement properties [`url_query`](https://github.com/axibase/atsd-api-python/blob/master/atsd_client/services.py#L135).
6457|UI|Bug|UI: long [Entity Group](../../configuration/entity_groups.md) list distorts the entity editor.
6459|entity_views|Bug|[Entity Views](../../configuration/entity_views.md): **Default View** cannot pass validation.
6462|message|Feature|Message Search: add **Time Zone** field.
6466|sql|Feature|[SQL](../../sql/README.md): random() function.
6468|core|Feature|Versioning for portals and entity views.
6469|sql|Feature|[SQL](../../sql/README.md): allow wildcard in outer query.
6471|UI|Bug|UI: broken links to portals, entity views, forecasts if id > 999.
6472|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): user variables with `null` values are converted to empty strings in [notifications](../../rule-engine/notifications/README.md).
6473|csv|Bug|[CSV Parser Wizard](../../tutorials/getting-started-insert.md#csv-files): illegal timestamp pattern generated if several timestamp columns exist and one of the timestamps is of optimized type.
6476|sql|Feature|[SQL](../../sql/README.md): trunc function.
6477|api-rest|Bug|Search entities by expression: entity cache is not used.
6478|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): incorrect rule link for [`rule_window`](../../rule-engine/functions-rules.md#rule_window) function.
6479|sql|Bug|[SQL](../../sql/README.md): [`WITH TIMEZONE`](../../sql/README.md#with-timezone) option not supported by [`DELETE`](../../sql/README.md#delete-syntax).
6481|rule editor|Feature|[Rule Editor](../../rule-engine/README.md): view group members.
6482|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): represent test results in time zone specified in **Date Filter**.
6483|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): slow validation of [`last_open`](../../rule-engine/functions-alert-history.md) function.
6484|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): [web notification](../../rule-engine/notifications/README.md) test fails if entity is a wildcard.
6485|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): apply filter to entity auto-complete on **Test** tab.
6486|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): db_statistics function to load all descriptive statistics for the interval.
6487|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): [`db_last`](../../rule-engine/functions-series.md#db_last) function ignores current time in **Test** mode.
6489|portal|Bug|Portal Editor: include entity parameter in the view by name link.
6490|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): [`getPortalLink`](../../rule-engine/functions-link.md#getportallink) function.
6493|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): `NullPointerException` in rule **Test** mode if command value is `NaN`.
6495|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): [`now`](../../rule-engine/window-fields.md#current-time-fields) object is not initialized to current time in **Test** mode.
6496|entity|Bug|UI: [Entity Group](../../configuration/entity_groups.md) editor.
6498|entity|Bug|Entity Group: synchronization fails if one of group has errors.
6499|UI|Feature|UI: replacement table multi-line description and number formatting.
6500|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): [calendar expression](../../shared/calendar.md) fails in **Test** mode.
6504|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): add vars hint on [`rule_window`](../../rule-engine/functions-rules.md#rule_window) property access error.
6506|rule editor|Feature|[Rule Editor](../../rule-engine/README.md): allow to run **Test** for multiple enumerated entities.
6508|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): preserve **Test** form fields on **Save**.
6513|UI|Bug|UI: cannot update [Entity Group](../../configuration/entity_groups.md) with expression that matches multiple (100k) entities.
6516|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): provide descriptive error on **Test** tab.
6517|sql|Feature|[SQL](../../sql/README.md): support additional types for [`CAST`](../../sql/README.md#cast) function.
6521|UI|Bug|Cloned [replacement tables](../../rule-engine/functions-lookup.md#overview) remain after renaming.
6522|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): context links not working.
6525|sql|Feature|[SQL](../../sql/README.md): [`CAST(inputString AS NUMBER)`](../../sql/README.md#cast) function.

## Charts

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
6373|data-loading|Bug|Portal: background updates are triggered for all widgets when dialog window is open.
6414|widget-settings|Bug|[`sql/endsql`](https://axibase.com/docs/charts/widgets/shared/#sql) placeholder not properly handled.
6430|chart lab|Feature|ChartLab: data source drop-down.
6431|chart lab|Bug|ChartLab: hide editor frame in full mode.
6440|data-loading|Bug|Malformed response when data contains `x` field.
6458|table|Bug|[Series Table](https://axibase.com/docs/charts/widgets/series-table/#series-table): updates are stopped unexpectedly.
6461|visual design|Feature|Integrate Blueprint icons.
6474|chart lab|Feature|ChartLab: editor issues and formatting enhancements.
6475|widget-settings|Feature|Add support for expr block.
6497|property|Bug|[Property Widget](https://axibase.com/docs/charts/widgets/property-table/): sort by column not working.

## Collector

Issue| Category    | Type    | Subject
------|-------------|---------|--------
6455|mqtt|Feature|[MQTT](https://axibase.com/docs/axibase-collector/jobs/mqtt.html): broker configuration enhancements.
