# Monthly Change Log: August 2018

## ATSD

Issue| Category   | Type   | Subject
-----|-------------|---------|----------------------
5651|rule engine|Bug|Rule Engine: validate [property functions](../../rule-engine/functions.md#properties) and [derived commands](../../rule-engine/derived.md).
5649|installation|Bug|Test ATSD [installation](../../installation/README.md#linux-packages) on `Ubuntu 18.04`.
5642|installation|Support|[Product Edition](../../pricing.md#standard-edition): Replace Community with Standard.
5641|rule editor|Feature|Rule Editor: add **View Alert Log** buttons to [**Logging**](../../rule-engine/logging.md#alert-logging) tab.
5640|rule engine|Bug|Rule Engine: alert [details](../../rule-engine/details-table.md#details-table) - serialize objects.
5639|rule engine|Feature|Rule Engine: add details to [script](../../rule-engine/functions-script.md#script-functions) execution log.
5629|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): modify map serialization.
5628|rule engine|Bug|Rule Engine: [`value`](../../rule-engine/functions.md#value) function not validated for existing metric name.
5627|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): incompatible types in statement error.
5625|rule engine|Feature|Rule Engine: modify [`db_message_last`](../../rule-engine/functions-message.md#db_message_last) to return an empty object.
5624|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): display `type` / `source` instead of metric for non-series rules.
5621|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): rule list search.
5620|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): update default fields and payloads.
5619|UI|Feature|UI: Optimize [Incoming Webhook](../../rule-engine/incoming-webhooks.md#diagnostics) detail page.
5618|rule engine|Feature|Rule Engine: do not execute [user variables](../../rule-engine/variables.md#variables) unless needed.
5616|rule editor|Bug|Rule Editor: validator rejecting [`entityLink`](../../rule-engine/links.md#entitylink), webhook highlighted as error without highlighting.
5615|rule engine|Bug|Rule Engine: [`last_open()`](../../rule-engine/functions-alert-history.md#last_open) function overloads HBase.
5614|rule engine|Bug|Rule Engine: `NullPointerException` during Test if [**Load History**](../../administration/logging.md) enabled.
5611|rule engine|Bug|Rule Engine: Exception on saving [alert history](../../administration/logging.md) for newly created entity.
5609|rule engine|Bug|Rule Engine: set [`window_first_time`](../../rule-engine/window-fields.md#date-fields) to empty string if not available.
5608|rule engine|Bug|Rule Engine: window name substition or invalid window [grouping](../../rule-engine/window-fields.md#date-fields).
5607|sql|Bug|SQL: incorrect metadata returned by the [`/api/sql`](../../sql/api.md#sql-query-api-endpoint) endpoint.
5604|rule engine|Bug|Rule Engine: alert history is not [logged](../../administration/logging.md) if message is empty.
5603|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): standartize button style and locations.
5602|rule editor|Bug|Rule Editor: [Logging](../../administration/logging.md) status is incorrectly shown as `Disabled` if only alert history is turned on.
5601|rule engine|Bug|Rule Engine: initialize [`now`](../../rule-engine/functions-date.md#now) object to command time in filter log.
5599|rule engine|Bug|Rule Engine: validate email address in [Email Action](../../rule-engine/email.md#email-action).
5598|rule engine|Bug|Rule Engine: [filter](../../rule-engine/filters.md#filters) fields test and source are lost on clone.
5597|rule engine|Feature|Rule Engine: add [details](../../rule-engine/details-table.md) to rule window with `CANCEL` status.
5596|csv|Bug|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): empty line in the middle causes issues for fixed width parser.
5594|rule engine|Feature|Rule Engine: default time zone and date pattern in [`date_format`](../../rule-engine/functions-format.md#date_format) function.
5593|rule engine|Feature|Rule Engine: [date format](../../rule-engine/functions-format.md#date_format) and [parse](../../rule-engine/functions-date.md#date_parse) function validation.
5592|jdbc|Support|[JDBC Driver](https://github.com/axibase/atsd-jdbc/blob/master/README.md): number of rows too low with old driver 1.2.11.
5590|export|Bug|[Export](../../reporting/ad-hoc-exporting.md#ad-hoc-exporting): Handle client disconnect.
5587|api-rest|Bug|Data API: [Series Query](../../api/data/series/query.md#series-query) with small `limit` and `time=all` is slow.
5584|api-rest|Bug|Data API: [Property Query](../../api/data/properties/query.md#properties-query) with limit is slow.
5582|rule editor|Bug|Rule Editor: validator doesn't allow reference to 'rule' in [variables](../../rule-engine/variables.md#variables).
5580|rule engine|Bug|Rule Engine: [variable](../../rule-engine/variables.md#variables) validation misleading.
5579|sql|Feature|Add timezone support to [`MINUTE()`](../../sql#minute) function.
5577|rule engine|Bug|Rule Engine: [`IN`](../../rule-engine/functions-collection.md#in) operator fails to work on string function result.
5575|api-rest|Feature|Data API: [Series Query](../../api/data/series/query.md#series-query) - implement smooth transformation.
5573|rule editor|Feature|Rule Engine: response action [logging](../../administration/logging.md).
5572|message|Feature|Data API: [expression](../../api/meta/expression.md#expression-syntax) doesn't support `type` and `source` fields.
5568|rule editor|Bug|Rule Editor: List files without executable permission in [**Scripts**](../../rule-engine/scripts.md#script) drop-down.
5567|client|Feature|Python [client](../../api/clients/README.md): disable logging.
5565|core|Feature|[Backup](../../administration/backup.md#backup-and-restore) configuration resources.
5563|rule editor|Bug|Rule Editor: add validation for function [arguments](../../rule-engine/functions.md#arguments).
5562|core|Bug|Core: [Login](../../administration/user-authentication.md#user-authentication) page raises 500 error.
5561|entity_views|Feature|[Entity Group](../../configuration/entity_groups.md#entity-groups): inherit entity views from parent group.
5559|rule editor|Feature|Rule Editor: highlight missing [placeholder](../../rule-engine/filters.md#entity-names-filter) warnings.
5558|rule editor|Bug|Rule Editor: validate [Entity Name Filter](../../rule-engine/filters.md#entity-names-filter).
5557|rule engine|Bug|Rule Engine: Support ignore-case entity comparison in [**Filter**](../../rule-engine/filters.md).
5556|entity_views|Feature|[Entity View](../../configuration/entity_views.md#entity-views) portal: add `server-aggregate=true` to the multi-entity portal.
5555|UI|Bug|[Entity Group](../../configuration/entity_groups.md#entity-groups) editor error.
5554|security|Bug|Users: Add [LDAP](../../installation/ldap/jxplorer.md) support in Resource Viewer User form.
5553|sql|Feature|SQL: add support for optional custom timezone in [`EXTRACT`](../../sql/README.md#extract) date functions.
5552|client|Support|Python [client](../../api/clients/README.md): refactor access log report.
5548|rule engine|Feature|Rule Engine: implement `DateTime` [`to_timezone`](../../rule-engine/object-datetime.md#to_timezone-function) function.
5547|UI|Feature|[Rule Editor](../../rule-engine/README.md): alert on page exit with unsaved changes in Firefox.
5546|client|Feature|Python [client](../../api/clients/README.md): set user-agent in api requests.
5545|core|Feature|Modify Server header in HTTP [responses](../../api#database-api).
5544|api-rest|Bug|[Series Query](../../api/data/series/query.md#series-query): invalid JSON returned.
5543|entity|Bug|Entity Group: implement [`hasProperty`](../../configuration/functions-entity-groups-expression.md#hasproperty) function.
5542|sql|Feature|SQL: Implement [`WITH TIMEZONE`](../../sql#with-timezone) clause to override the default server timezone applied to query.
5541|entity|Feature|[Entity Group](../../configuration/entity_groups.md#entity-groups): refactor form.
5540|entity|Bug|[Entity Group](../../configuration/entity_groups.md#entity-groups): cannot delete a group.
5539|core|Bug|[Date format](../../shared/date-format.md) inconsistencies.
5538|api-rest|Bug|REST API: Entity Group [update](../../api/meta/entity-group/update.md) method works incorrect.
5537|UI|Bug|UI: [user editor](../../administration/user-authorization.md#user-wizards) fields pre-filled in Firefox.
5535|entity|Bug|[Entity Group](../../configuration/entity_groups.md#entity-groups): wrong entities included.
5534|security|Feature|[Users](../../administration/user-authentication.md#user-authentication): Implement Create Resource Viewer User wizard.
5533|metric|Bug|Metric Search: implement search by all search criteria [fields](../../search/README.md#syntax).
5531|rule engine|Bug|Rule Engine: 500 error with attempt to change alert [status](../../rule-engine/README.md).
5530|rule engine|Bug|Rule Engine: [details table](../../rule-engine/details-table.md#details-table) unavailable.
5527|UI|Feature|Implement a compact drop-down.
5524|entity|Feature|[Entity Group](../../configuration/entity_groups.md#entity-groups): parent group field.
5523|entity_views|Feature|[Entity View](../../configuration/entity_views.md#entity-views): support for multiple entity groups.
5522|rule engine|Bug|Rule Engine: `DictionaryNotFound` exception logged if tags autocomplete used in [rules](../../rule-engine/README.md) with `message` or `property` datatype.
5517|rule engine|Feature|Rule Engine: Implement [`DateTime.add`](../../rule-engine/object-datetime.md#add-function) method.
5497|rule engine|Bug|Rule Engine: [property command](../../api/network/property.md#property-command) sent from **Data Entry** form is not processed.
5496|message|Bug|[Message](../../api/data/messages/insert.md#description) collision: add hash to row key to eliminate collision between records.
5494|sql|Feature|SQL: boolean functions in [`WHERE`](../../sql#where-clause) and [`HAVING`](../../sql#having-filter) clauses.
5492|sql|Feature|SQL: implement [calendar](../../sql#calendar-expressions) arithmetic for `time` and `datetime` column values.
5490|sql|Bug|`ClassCastException` in [SQL](../../sql/README.md) query.
5482|versioning|Bug|[Versioning](../../versioning/README.md): attempt to insert versioned value for a non-versioned metric must cause a validation error.
5478|client|Feature|Python3 [client](../../api/clients/README.md) migration.
5467|administrator|Feature|HBase/HDFS [Log File](../../administration/logging.md#hbase-log-files) Download.
5466|sql|Feature|SQL: implement [function](../../sql/README.md#is_workday) to check if the date is a workday in a given country.
5463|sql|Bug|[API SQL](../../sql/README.md): Multiple `EofException` log entries during `atsd-jdbc-test` run.
5448|rule engine|Feature|Rule Engine: Implement [`last_open()`](../../rule-engine/functions-alert-history.md#last_open) function to access window.
5437|UI|Feature|Series value [editor](../../versioning/README.md#modifying-values).
5415|client|Bug|ATSD [API JAVA](../../api/clients/README.md): set `User-Agent` through `ClinentManager Factory`.
5173|core|Bug|Codestyle: Replace Calendar usage with JSR-310 API.
5038|rule engine|Feature|[Rule Editor](../../rule-engine/README.md): implement **Filter Log** page.
4814|sql|Bug|SQL: Interpolation [`PREVIOUS`](../../sql/README.md#interpolation-function) with `fill=false`.
4560|UI|Feature|UI: entity search by [last insert date](../../rule-engine/entity-fields.md#entity-object-fields).

## Charts

Issue| Category    | Type    | Subject
-----|-------------|---------|----------------------
5588|widget-settings|Feature|Add [smooth](https://github.com/axibase/charts/blob/master/widgets/shared/README.md#series-settings) settings to charts.

## Collector

Issue| Category    | Type    | Subject
-----|-------------|---------|----------------------
5560|UI|Feature|UI: Database [form](https://axibase.com/docs/axibase-collector/jobs/jdbc-data-source.html#jdbc-data-source) UX improvements.
5529|core|Bug|Core: Retrieve information about ATSD version through [API JAVA](../../api/clients/README.md).
5525|core|Feature|Core: set Custom user-agent for request sent by ATSD [API JAVA](../../api/clients/README.md) client.
5416|UI|Bug|UI: After [login](https://axibase.com/docs/axibase-collector/installation.html#login) collector redirects to favicon.
5148|core|Feature|Send failure percentage as message tag on [`PARTIAL_FAILURE`](https://axibase.com/docs/axibase-collector/monitoring.html#monitoring).
5131|core|Bug|Duplicate [storage driver](https://axibase.com/docs/axibase-collector/atsd-server-connection.html#storage-driver-configuration) on container restart.