# Monthly Change Log: June 2019

## ATSD

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
5965|api-rest|Feature|[Series Query](../../api/data/series/query.md): extend [grouping](../../api/data/series/group.md#group-processor) transformation to group series based on correlation and constraints.
6059|csv|Bug|[CSV Upload](../../parsers/csv/README.md#uploading-csv-files): multiple unique series insertion using new CSV parser form leads to `last_insert` table blocking and `OOM`s.
6062|csv|Bug|[CSV Parser](../../parsers/csv/README.md#uploading-csv-files): optimize analysis to handle larger files.
6068|forecast|Feature|[**Forecast Settings**](../../forecasting/README.md#data-forecasting): store forecast under a new metric.
6076|data-in|Bug|Message [command](../../api/network/message.md#message-command), inserted on **Data Entry** page not stored.
6112|api-rest|Feature|[Series Query](../../api/data/series/query.md): implement last timestamp [filter](../../api/data/series/query.md#last-insert-filter).
6154|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): property processing on incremental updates.
6170|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): function changes.
6171|api-rest|Feature|[Series Query](../../api/data/series/query.md): implement [`autoAggregate`](../../api/data/series/forecast.md#regularization) option for forecasts.
6181|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): customizable action execution delay.
6226|forecast|Bug|Forecast: linear values present in [SSA](../../api/data/series/forecast.md#ssa-fields) forecast.
6230|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): retain windows on minor change.
6233|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): [`sendTcpMessageReply`](../../rule-engine/functions-utility.md#sendtcpmessagereply) function to send string to remote server/port via TCP and read response.
6234|api-network|Bug|Network API: [`property`](../../api/data/properties/insert.md) command with empty tags is not recognized as non-valid.
6241|UI|Feature|Metric for entity search: support wildcards.
6245|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): [**Log to Alert History**](../../rule-engine/logging.md#alert-logging) `setting is not serialized`.
6250|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): improve date [filter](../../rule-engine/README.md#filtering).
6251|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): add support for [orb tags](../../rule-engine/control-flow.md#control-flow) and expression context to [Email](../../rule-engine/email.md#email-action) recipients input.
6252|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): add `timeOfDay` field to [`DateTime`](../../rule-engine/object-datetime.md#fields) object.
6257|rule engine|Feature|Users: add [`Topics`](../../rule-engine/email.md#topic-watchers) field.
6259|rule editor|Bug|Rule Editor: add client validation of [`Delay`](../../rule-engine/email.md#trigger-settings) values.
6260|rule editor|Bug|[Rule Engine](../../rule-engine/README.md): error is not highlighted.
6262|forecast|Bug|[**Forecast Settings**](../../forecasting/README.md#data-forecasting): time settings are broken.
6264|UI|Bug|**Data Entry**: tooltip placement is incorrect.
6267|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): support the [`db_baseline`](../../rule-engine/functions-series.md#db_baseline) function in default portal.
6271|sql|Bug|[Scheduled SQL](../../sql/scheduled-sql-store.md): encoding issue.
6281|rule editor|Feature|[Rule Engine](../../rule-engine/README.md): command processing order.
6282|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): support markdown in [Emails](../../rule-engine/email.md#email-action).
6284|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): drop [Rule Error](../../rule-engine/README.md#rule-errors) status after successful alert action.
6286|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): provide timeout setting for [custom webhooks](../../rule-engine/notifications/custom.md#custom-webhook).
6287|core|Bug|UI: **Series Statistics** page not accessible if tag contains special characters such as forward slash.
6289|UI|Bug|UI: numeric input values disappear after save.
6290|export|Bug|[Export](../../reporting/ad-hoc-exporting.md#ad-hoc-exporting): incorrect export form serialization if tag value contains wildcard or backslash character.
6291|security|Bug|[Server Properties](../../administration/server-properties.md#server-properties): wrong property value lead to problems with validation of other properties.
6293|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): infinite [Email](../../rule-engine/email.md#email-action) notifications testing.
6294|api-rest|Bug|[Series Query](../../api/data/series/query.md): [`sampleFilter`](../../api/data/series/query.md#sample-filter) does not support `BETWEEN` operator.
6295|UI|Feature|UI: [SQL](../../sql/README.md) statement from **Series Statistics** page.
6296|api-rest|Feature|[Series Query](../../api/data/series/query.md): add functions to sample filter's context.
6298|rule engine|Bug|[Rule](../../rule-engine/README.md) Import from XML fails.
6300|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): testing errors are propagated to real windows.
6302|message|Feature|UI: Message Search form - add receive counters to the [`type`](../../api/data/messages/query.md#message-filter-fields) drop-down.
6304|message|Bug|[Message Receive Statistics](../../administration/data_retention.md#top-message-types): message [counted](../../api/data/messages/count.md#messages-count) twice if it is inserted with **Data Entry** form.
6308|core|Bug|Core: ATSD does not [start](../../installation/README.md#axibase-time-series-database-installation) if no network interfaces present.
6310|UI|Feature|Integration User Creation.
6313|administrator|Bug|[Server Properties](../../administration/server-properties.md#server-properties): apply default value if empty value is set.
6318|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): retry on `UnknownHostException`.
6319|api-network|Bug|TCP: no response from [`debug`](../../api/network/message.md#troubleshooting) command on tag values with line separator.
6320|core|Bug|Performance degradation change.
6321|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): [webhook](../../rule-engine/notifications/README.md#outgoing-webhooks) settings are not implemented for rules with opened windows.
6322|administrator|Feature|API DOS monitor.
6323|message|Bug|[Messages](../../api/data/messages/query.md#messages-query): wrong tags columns order.
6325|rule engine|Bug|Rule Search: substring in name.
6329|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): cryptic [validation](../../rule-engine/variables.md#variables) error.
6330|UI|Bug|UI: [Rule Editor](../../rule-engine/README.md) - strange UI with whitespace in dependent rules.
6333|security|Bug|[LDAP](../../administration/user-authorization.md): connection error.
6334|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): add timeout on [Rule Filter](../../rule-engine/filters.md) execution.
6335|UI|Bug|UI: vertical alignment broken.

## Charts

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
5826|widget-settings|Feature|[Label format](https://axibase.com/docs/charts/syntax/label-formatting.html#label-formatting): add support for `alias` placeholder.
5882|calculation|Bug|[`fill-value`](https://axibase.com/docs/charts/widgets/shared/#fill-value): allow to specify interpolation type.
6148|table|Bug|Table widgets: [aggregation](https://axibase.com/docs/charts/configuration/aggregators.html#aggregation-functions) in client even if `server-aggregate=true`.
6180|table|Bug|Table widgets: [`format`](https://axibase.com/docs/charts/syntax/format-settings.html#format-settings) is not applied to string cells.
6254|widget-settings|Bug|[Date filter](https://axibase.com/docs/charts/widgets/shared/#date-filter) error message must be more descriptive.
6279|widget-settings|Bug|[Label format](https://axibase.com/docs/charts/syntax/label-formatting.html#label-formatting) does not resolve statistics for `detail`.
6297|console|Bug|[Console](https://axibase.com/docs/charts/widgets/alert-table/): [`onclick`](https://axibase.com/docs/charts/widgets/shared-table/#on-click) not filtering.
6332|console|Bug|[Console](https://axibase.com/docs/charts/widgets/alert-table/): severity code padding is miscalculated.
6341|table|Bug|Table: accept comma separated keys in [`columns`](https://axibase.com/docs/charts/widgets/shared-table/#columns) setting.

## Collector

Issue| Category    | Type    | Subject
------|-------------|---------|--------
6328|jdbc|Feature|[JDBC](https://axibase.com/docs/axibase-collector/jobs/jdbc.html): Schemas Viewer.
