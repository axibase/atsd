# Monthly Change Log: June 2018

## ATSD

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
5423 | rule engine | Bug | [Rule Engine](../../rule-engine/README.md): Deserialization errors for rule XML backup files with type and source filters.
5421 | administration | Feature | Backup: Implement customizable [backup directory](../../administration/backup.md#backup-directory).
5420 | rule engine | Feature | [Rule Engine](../../rule-engine/README.md): Increase throughput with multiple rules enabled.
5419 | UI | Feature | UI: Apply DST offset to **Time Zone**.
5413 | rule engine | Feature | Rule Engine: Implement [`toNumber`](../../rule-engine/functions-utility.md#tonumber) function for `null`-safe number parsing.
5412 | api-rest | Feature | [Series Get](../../api/data/series/get.md) method: Implement period alignment parameter.
5411 | message | Bug | [Message Table TTL](../../api/data/messages/delete.md#ttl) specified in `server.properties` is ignored.
5407 | UI | Bug | UI: Type field auto-complete is broken on **Data Entry** page.
5405 | rule engine | Feature | [Script](../../rule-engine/scripts.md): Pass window fields into scripts as named variables.
5403 | rule editor | Bug | Rule Engine: [Entity Filter](../../rule-engine/filters.md#entity-name-filter) dual list replaced with auto-complete text input field.
5402 | UI | Feature | UI: Rename **Web Notifications** as [**Outgoing Webhooks**](../../rule-engine/notifications/README.md).
5401 | UI | Feature | UI: Move **Webhook Requests** to **Alerts** menu.
5399 | test | Bug | API Tests: Message tests fail if [`messages.timeToLive`](../../api/data/messages/delete.md#ttl) is too low.
5397 | administration | Bug | `IllegalArgumentException` raised for [backup upload](../../administration/backup.md).
5396 | security | Bug | [Security](../../administration/user-authentication.md): JSON response duplicated in case of authentication failure.
5394 | client | Bug | ATSD [Java client](https://github.com/axibase/atsd-api-java): Do not catch `Throwable` errors.
5393 | api-rest | Feature | API: Add `addInsertTime` parameter for [entities](../../api/meta/entity/list.md#query-parameters) API requests.
5387 | search | Bug | [Search](../../api/meta/misc/search.md): Full re-index fails on disk space shortage.
5384 | administrator | Feature | Monitoring: Add **Database Statistics** page with main database metrics.
5381 | log_aggregator | Feature | Aggregation Log Filter: Add support for multiple collectors.
5380 | sql | Bug | SQL: [`date_format`](../../sql/examples/datetime-format.md#date_format-function) function returns incorrect time zone format.
5379 | search | Bug | Search: Shutdown during full search index rebuild.
5370 | UI | Feature | UI: Add links to **Metric Settings** page.
5366 | administration | Feature | Scheduler: Modify frequent tasks to sleep a fixed interval between iterations.
5365 | administration | Feature | UI: Implement [Export Configuration](../../administration/support.md) option to export server settings, properties, and metrics to JSON file.
5364 | administration | Feature | [Logging](../../administration/logging.md): Increase log detail for full search re-index and group update tasks.
5363 | log_aggregator | Bug | Aggregation Logger: `ConcurrentModificationException` raised by shutdown hook.
5362 | csv | Bug | [CSV Parsers](../../parsers/csv/README.md): Messages for broken files are not user-friendly.
5359 | statistics | Bug | Series Statistics: **Entity** label not shown.
5357 | api-rest | Bug | [Logger](../../administration/logging.md) generates excessive `Invalid Command` warnings without explanation.
5353 | client | Support | [Python API Client](https://github.com/axibase/atsd-api-python): Add script example with delete series parameters.
5350 | installation | Bug | [Installation](../../installation/README.md): Installation process fails to install Debian 9 on an offline system.
5349 | jdbc | Feature | [JDBC Driver](https://github.com/axibase/atsd-jdbc): Speed up `datetime` column parsing.
5348 | sql | Feature | SQL: Pre-process entity check in [`atsd_series`](../../sql/examples/select-atsd_series.md) query to work around metric limit.
5346 | UI | Feature | Property: Add [**Properties**](../../administration/data_retention.md#deleting-properties) page to view or delete properties for a given entity.
5331 | jdbc | Feature | [JDBC Driver](https://github.com/axibase/atsd-jdbc): Set correct `User-Agent` header to determine whether JDBC driver or HTTP client used `/api/sql` endpoint.
5322 | sql | Bug | SQL: Extra quotes to [`date_format`](../../sql/examples/datetime-format.md#date_format-function) function generate error.
5295 | portal | Bug | [Portal Editor](../../portals/README.md): Freemarker comments are not ignored.
5292 | core | Bug | [Metrics for Entity](../../api/data/alerts/examples/query/alerts-query-multiple-metrics-specified-entity.md): Slow response for large number of entities.
5272 | core | Feature | Core: Migrate date formatters and parsers from `joda.time` to `java.time`.
5196 | api-rest | Feature |Meta API: Implement [Replacement Table](../../api/meta/replacement-table/README.md) methods.
5152 | rule editor | Bug | Rule Editor: Labels for [Webhook](../../rule-engine/notifications/README.md) parameters not set if validation error occurs.
5094 | entity_views | Bug | [Entity Views](../../configuration/entity_views.md): Unknown format function causes `400` error.
5058 | rule engine | Feature | [Rule Engine](../../rule-engine/README.md): Log security function results in ATSD as messages.
3666 | UI | Bug | UI: Unable to search multiline queries on **Query Statistics** page.

## Collector

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
5248 | xml | Feature | Support [placeholders](../../rule-engine/placeholders.md) in environment variables during import.
5095 | file | Bug | [File](https://axibase.com/docs/axibase-collector/jobs/file.html): `NullPointException` raised during test.
