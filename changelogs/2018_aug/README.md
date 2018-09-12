# Monthly Change Log: August 2018

## ATSD

Issue| Category   | Type   | Subject
-----|-------------|---------|----------------------
5651|rule engine|Bug|Validator ignores [property functions](../../rule-engine/functions.md#properties) and [derived commands](../../rule-engine/derived.md).
5649|installation|Feature|Validate [installation](../../installation/README.md#linux-packages) on `Ubuntu 18.04`.
5641|rule editor|Feature|Add **View Alert Log** links to [**Logging**](../../rule-engine/logging.md#alert-logging) tab.
5640|rule engine|Feature|Serialize Alert History record as map in the [details](../../rule-engine/details-table.md#details-table) table.
5639|rule engine|Feature|Add context to [script](../../rule-engine/functions-script.md#script-functions) execution log.
5629|rule engine|Feature|Modify the default map-to-string serialization format.
5628|rule engine|Bug|Validator fails to check metric name specified in the [`value()`](../../rule-engine/functions.md#value) function.
5627|rule editor|Bug|Incompatible numeric type error.
5625|rule engine|Feature|Modify [`db_message_last`](../../rule-engine/functions-message.md#db_message_last) function to return an empty object if no records are found.
5624|rule engine|Feature|Display `type` and `source` instead of metric for non-series rules on the rule list page.
5621|rule engine|Feature|Implement search on the rule list page.
5619|UI|Feature|Optimize [Incoming Webhook](../../rule-engine/incoming-webhooks.md#diagnostics) detail page layout.
5618|rule engine|Feature|Do not evaluate [user variables](../../rule-engine/variables.md#variables) unless needed (lazy mode).
5616|rule editor|Bug|Validator incorrectly rejects [`entityLink`](../../rule-engine/links.md#entitylink) variable.
5615|rule engine|Bug|[`last_open()`](../../rule-engine/functions-alert-history.md#last_open) function overloads the database.
5614|rule engine|Bug|`NullPointerException` encountered during rule test if [**Load History**](../../administration/logging.md) is enabled.
5611|rule engine|Bug|Exception raised when saving [alert history](../../administration/logging.md) for newly created entity.
5609|rule engine|Bug|Set [`window_first_time`](../../rule-engine/window-fields.md#date-fields) field to empty string if the window is empty.
5607|sql|Bug|Incorrect metadata returned by the [`/api/sql`](../../sql/api.md#sql-query-api-endpoint) endpoint if the column alias contains line breaks.
5604|rule engine|Bug|Alert history not [logged](../../administration/logging.md) if message text is empty.
5603|rule editor|Bug|Standardize button style and placements in the rule editor.
5602|rule editor|Bug|[Logging](../../administration/logging.md) status is incorrectly shown as `Disabled`.
5601|rule engine|Bug|Correctly initialize [`now`](../../rule-engine/functions-date.md#now) object in the filter log.
5599|rule engine|Bug|Validate email addresses in [Email Action](../../rule-engine/email.md#email-action).
5598|rule engine|Bug|Type and source [filters](../../rule-engine/filters.md#filters) are lost when rule is cloned.
5597|rule engine|Feature|Add [details](../../rule-engine/details-table.md) to rule windows with `CANCEL` status.
5596|csv|Bug|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): empty line in the middle causes issues for fixed width parser.
5594|rule engine|Feature|Make time zone and date pattern optional in [`date_format`](../../rule-engine/functions-date.md#date_format) function.
5593|rule engine|Feature|Validate patterns specified in [date format](../../rule-engine/functions-date.md#date_format) and [date parse](../../rule-engine/functions-date.md#date_parse) functions.
5590|export|Bug|[Export](../../reporting/ad-hoc-exporting.md#ad-hoc-exporting) page: gracefully handle client disconnect.
5587|api-rest|Bug|Data API: [Series Query](../../api/data/series/query.md#series-query) with small `limit` and `time=all` is slow.
5584|api-rest|Bug|Data API: [Property Query](../../api/data/properties/query.md#properties-query) with `limit` is slow.
5580|rule engine|Bug|Validator incorrectly highlights failing [variables](../../rule-engine/variables.md#variables).
5579|sql|Feature|Add time zone support to [`MINUTE()`](../../sql/README.md#minute) function.
5577|rule engine|Bug|[`IN`](../../rule-engine/functions-collection.md#in) operator fails to work on string function result.
5575|api-rest|Feature|Data API: [Series Query](../../api/data/series/smooth.md) - implement smooth transformation.
5573|rule editor|Feature|Implement response action [logging](../../administration/logging.md).
5572|message|Feature|Data API: add support for `type` and `source` fields in [expression](../../api/meta/expression.md#expression-syntax).
5568|rule editor|Bug|Rule Editor: List files without executable permissions in the [**Scripts**](../../rule-engine/scripts.md#script) drop-down.
5567|client|Feature|Python [client](../../api/clients/README.md): disable default logging.
5565|core|Feature|[Backup](../../administration/backup.md#backup-and-restore) configuration resources.
5563|rule editor|Bug|Rule Editor: add validation for function [arguments](../../rule-engine/functions.md#arguments).
5562|core|Bug|Core: [Login](../../administration/user-authentication.md#user-authentication) page raises `500` error.
5561|entity_views|Feature|[Entity Group](../../configuration/entity_groups.md#entity-groups): inherit entity views from parent group.
5559|rule editor|Feature|Highlight missing [placeholders](../../rule-engine/filters.md#entity-names-filter).
5558|rule editor|Bug|Validate [Entity Name Filter](../../rule-engine/filters.md#entity-names-filter).
5557|rule engine|Bug|Entity comparison must be case-insensitive in [**Filter**](../../rule-engine/filters.md).
5556|entity_views|Feature|[Entity View](../../configuration/entity_views.md#entity-views) portal: add `server-aggregate=true` to the multi-entity portal.
5554|security|Bug|Add [LDAP](../../installation/ldap/jxplorer.md) switch to the Resource Viewer User wizard.
5553|sql|Feature|Add support for optional custom time zone in [`EXTRACT`](../../sql/README.md#extract) date functions.
5548|rule engine|Feature|Implement `DateTime` [`to_timezone`](../../rule-engine/object-datetime.md#to_timezone-function) function.
5547|UI|Feature|Rule Editor: add alert on page exit with unsaved changes in Firefox.
5546|client|Feature|Python [client](../../api/clients/README.md): set user-agent in api requests.
5545|core|Feature|Modify Server header in HTTP [responses](../../api/README.md#database-api).
5544|api-rest|Bug|[Series Query](../../api/data/series/query.md#series-query): invalid JSON returned.
5543|entity|Bug|Entity Group: implement [`hasProperty`](../../configuration/functions-entity-groups-expression.md#hasproperty) function.
5542|sql|Feature|Implement [`WITH TIMEZONE`](../../sql/README.md#with-timezone) clause to override the default server time zone applied to query.
5541|entity|Feature|[Entity Group](../../configuration/entity_groups.md#entity-groups): refactor form layout.
5540|entity|Bug|[Entity Group](../../configuration/entity_groups.md#entity-groups): cannot delete a group.
5539|core|Bug|Resolve [date format](../../shared/date-format.md) inconsistencies.
5538|api-rest|Bug|REST API: Entity Group [update](../../api/meta/entity-group/update.md) method returns incorrect results.
5537|UI|Bug|UI: [user editor](../../administration/user-authorization.md#user-wizards) fields are erroneously auto-completed in Firefox.
5535|entity|Bug|[Entity Group](../../configuration/entity_groups.md#entity-groups): wrong entities included.
5534|security|Feature|[Users](../../administration/user-authentication.md#user-authentication): Implement Create Resource Viewer User wizard.
5533|metric|Bug|Metric Search: implement search by all criteria [fields](../../search/README.md#syntax).
5531|rule engine|Bug|`500` error raised on alert [status](../../rule-engine/README.md) change.
5530|rule engine|Bug|Rule Engine: [details table](../../rule-engine/details-table.md#details-table) unavailable.
5527|UI|Feature|Implement a compact drop-down on select pages.
5524|entity|Feature|[Entity Group](../../configuration/entity_groups.md#entity-groups): implement parent groups.
5523|entity_views|Feature|[Entity View](../../configuration/entity_views.md#entity-views): support for multiple entity groups.
5522|rule engine|Bug|Rule Engine: `DictionaryNotFound` exception logged if tags autocomplete used in [rules](../../rule-engine/README.md) with `message` or `property` datatype.
5517|rule engine|Feature|Rule Engine: Implement [`DateTime.add`](../../rule-engine/object-datetime.md#add-function) function.
5497|rule engine|Bug|[property command](../../api/network/property.md#property-command) sent from **Data Entry** form is not processed in rule engine.
5496|message|Bug|[Message](../../api/data/messages/insert.md#description) collision: add hash to row key to eliminate collision between records.
5494|sql|Feature|Add support for boolean functions in [`WHERE`](../../sql/README.md#where-clause) and [`HAVING`](../../sql/README.md#having-filter) clauses.
5492|sql|Feature|Implement [calendar](../../sql/README.md#calendar-expressions) arithmetic for `time` and `datetime` column values.
5490|sql|Bug|`ClassCastException` in [SQL](../../sql/README.md) query.
5482|versioning|Bug|[Versioning](../../versioning/README.md): attempt to insert versioned value for a non-versioned metric must cause a validation error.
5478|client|Feature|Python [client](../../api/clients/README.md): migrate to Python version `3`.
5467|administrator|Feature|Implement UI download for HBase/HDFS [log files](../../administration/logging.md#hbase-log-files).
5466|sql|Feature|Implement [`is_workday`](../../sql/README.md#is_workday) function to check if the date is a working day in a given country.
5448|rule engine|Feature|Implement [`last_open()`](../../rule-engine/functions-alert-history.md#last_open) function to retrieve status changes.
5415|client|Feature|[ATSD API JAVA](../../api/clients/README.md) client: set `User-Agent` header.
5173|core|Bug|Code style: Replace Calendar usage with JSR-310 API.
5038|rule engine|Feature|[Rule Editor](../../rule-engine/README.md): implement **Filter Log** page.
4814|sql|Bug|Fix interpolation [`PREVIOUS`](../../sql/README.md#interpolation-function) with `fill=false`.
4560|UI|Feature|UI: entity search by [last insert date](../../rule-engine/entity-fields.md#entity-object-fields).

## Charts

Issue| Category    | Type    | Subject
-----|-------------|---------|----------------------
5588|widget-settings|Feature|Add [smooth](https://github.com/axibase/charts/blob/master/widgets/shared/README.md#series-settings) settings.

## Collector

Issue| Category    | Type    | Subject
-----|-------------|---------|----------------------
5560|UI|Feature|UI: Database [form](https://axibase.com/docs/axibase-collector/jobs/jdbc-data-source.html#jdbc-data-source) improvements.
5529|core|Bug|Core: Retrieve ATSD version through [ATSD API JAVA](../../api/clients/README.md) client.
5525|core|Feature|Core: set custom `User-Agent` header for request sent by the [ATSD API JAVA](../../api/clients/README.md) client.
5416|UI|Bug|UI: After [login](https://axibase.com/docs/axibase-collector/installation.html#login) collector redirects to `favicon` image.
5148|core|Feature|Send failure percentage as message tag on [`PARTIAL_FAILURE`](https://axibase.com/docs/axibase-collector/monitoring.html#monitoring).
5131|core|Bug|Duplicate [storage driver](https://axibase.com/docs/axibase-collector/atsd-server-connection.html#storage-driver-configuration) created on container restart.