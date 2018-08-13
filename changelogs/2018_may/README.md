# Monthly Change Log: May 2018

## ATSD

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
5340 | statistics     | Bug     | Server error raised when accessing statistics page for series with [`NaN`](../../sql/README.md#not-a-number-nan) values.
5338 | export             | Bug     | Series tags validation error on export page.
5337 | client | Feature | Value filter added for [Python Client](https://github.com/axibase/atsd-api-python#axibase-time-series-database-client-for-python).
5334 | api-rest       | Bug     | Properties [delete query](../../administration/data_retention.md#deleting-properties) returns zero counter even after deleting some records.
5333 | client         | Bug     | [Python Client](https://github.com/axibase/atsd-api-python#axibase-time-series-database-client-for-python) tests failing due to time precision.
5327 | UI             | Bug     | Tags are missing on series list page if entity is specified.
5325 | api-rest       | Bug     | `LIMIT 1` processing error in series [query](../../api/data/series/query.md#series-query) method.
5324 | rule engine    | Bug     | Change [`randomItem`](../../rule-engine/functions-random.md#randomitem) function to return same object type as argument.
5321 | core           | Feature | Implement **Settings** > **Schema** > **Series Consistency Check** page.
5319 | rule engine    | Bug     | Fix infinite loop when monitoring rule errors in rule engine.
5318 | nmon           | Bug     | [`nmon`](../../integration/nmon/README.md#nmon) property record is stale and not updated.
5315 | message        | Bug     | Fix incorrect [wildcard](../../search/entity-search.md) match on the message search page.
5313 | client         | Bug     | [Python Client](https://github.com/axibase/atsd-api-python#axibase-time-series-database-client-for-python): [Message model](https://github.com/axibase/atsd-api-python#inserting-data) standardized.
5310 | message        | Feature | Modify filter processing for tag wildcards and empty tag values on message search page.
5309 | api-rest       | Bug     | `NullPointerException` raised on [message insert](../../api/data/messages/README.md#data-api-messages-methods) when a tag is set to `null`.
5308 | installation   | Feature | Install [Python 3](https://www.python.org/download/releases/3.0/) on [ATSD Sandbox](https://github.com/axibase/dockers/blob/atsd-sandbox/README.md#overview) by default.
5307 | csv            | Bug     | `NullPointerException` raised on CSV parser form in test mode.
5306 | api-rest       | Feature | Add revision field to [version](../../api/meta/misc/version.md) endpoint output.
5301 | rule engine    | Feature | Implement [`db_messages`](../../rule-engine/functions-message.md#db_messages) function.
5286 | rule engine    | Bug     | Custom test message with markdown cannot be sent when testing [Telegram](../../rule-engine/notifications/telegram.md#telegram-notifications) webhook.
5282 | sql            | Bug     | [Scheduled SQL](../../sql/scheduled-sql.md#sql-scheduler) placeholder fails to correctly resolve placeholders.
5281 | rule engine    | Bug     | [`jsonToLists`](../../rule-engine/functions-table.md#jsontolists) function fails to serialize JSON to columns.
5278 | rule engine    | Feature | Remove common prefix in [`jsonToLists`](../../rule-engine/functions-table.md#jsontolists) function.
5266 | rule engine    | Bug     | [Webhooks](../../rule-engine/notifications/README.md) are not initialized in imported rules.
5241 | rule engine    | Feature | Implement [rule error](../../rule-engine/README.md#rule-errors) monitoring.
5234 | api-rest       | Bug     | Change error processing in series [query](../../api/data/series/query.md#series-query) in cases when an exception is raised in the middle of response streaming.
5220 | security       | Feature     | Enforce [SSL certificate](../../administration/ssl-ca-signed.md#installing-ca-signed-certificate) upload restrictions.
5194 | forecast       | Bug     | Fix issues with [forecast](../../forecasting/README.md#data-forecasting) settings form.
5189 | log_aggregator | Bug     | Discard duplicate fields in [Log Aggregator](../../administration/logging.md#logging).
5150 | sql            | Feature | Implement short [ISO format](../../shared/date-format.md) for `datetime` [literal](../../sql/README.md#interval-condition).
4150 | api-rest       | Feature | Implement series [delete](../../api/data/series/delete.md#series-delete) endpoint.
4668 | collectd       | Feature | Refactor [collectd](../../integration/collectd/README.md#collectd) plugin.

## Collector

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
5299|core|Bug| Job configuration cloning fails.
5289|json|Feature| Add [Minimum Time](https://axibase.com/docs/axibase-collector/jobs/json.html#time-fields) filter.
5261|http-pool|Bug|Remove default port from Host header in outgoing `http` requests.
5259|json|Bug|Do not report failure when all responses are not modified.
5255|core|Feature|Add agent header to outgoing `http` requests.
5243|collection|Feature|Add import/export options for [Item Lists](https://axibase.com/docs/axibase-collector/collections.html#item-lists).
5233|jdbc|Bug| Last entities are cloned when [`JDBC`](https://axibase.com/docs/axibase-collector/jobs/jdbc.html) configuration is cloned.
