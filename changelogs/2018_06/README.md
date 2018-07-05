# Monthly Change Log: June 2018

## ATSD

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
5423 | rule engine | Bug | [Rule Engine](../../rule-engine/README.md): Deserialization errors for rules with type and source filters.
5421 | administration | Bug | Backup: Customizable [directory](../../administration/backup.md#backup-directory).
5420 | rule engine | Bug | [Rule Engine](../../rule-engine/README.md): Optimize cases with multiple rules enabled.
5419 | UI | Bug | UI: Apply DST offset to Time Zone drop-down lists.
5413 | rule engine | Feature | Rule Engine: Implement [`toNumber`](../../rule-engine/functions-utility.md#tonumber) function for `null`-safe number parsing.
5412 | api-rest | Feature | [Series Get](../../api/data/series/get.md) method: Add support for period alignment.
5411 | message | Bug | [Message Table TTL](../../api/data/messages/delete.md#ttl) specified in `server.properties` ignored.
5407 | UI | Bug | UI: Type field suggestion broken on **Data Entry** page.
5405 | rule engine | Feature | Rule Engine: [System Commands](../../rule-engine/commands.md) - pass window fields into `bash` script as named variables.
5403 | rule editor | Bug | [Rule Engine](../../rule-engine/commands.md): Replace Entity Filter widget with autocomplete-capable simple input field.
5402 | UI | Feature | UI: Rename **Web Notifications** as [**Outgoing Webhooks**](../../rule-engine/notifications/README.md).
5401 | UI | Feature | UI: Move **Webhook Requests** to **Alerts** menu.
5399 | test | Bug | API Tests: Message tests failing because of low [`messages.timeToLive`](../../api/data/messages/delete.md#ttl).
5397 | administration | Bug | `IllegalArgumentException` for [Backup upload](../../administration/backup.md).
5396 | security | Bug | [Security](../../administration/user-authentication.md): Duplicate JSON response in case of authentication failure.
5394 | client | Bug | ATSD [API Java](https://github.com/axibase/atsd-api-java): Handling for `Throwable` errors.
5393 | api-rest | Feature | API: Add `InsertTime`.
5387 | search | Bug | [Search](../../api/meta/misc/search.md): Full re-index fails on disk space shortage.
5384 | administrator | Feature | Monitoring: Add **Database Statistics** page to show last values of internal metrics.
5381 | log_aggregator | Bug | Aggregation Log Filter: Support multiple collectors.
5380 | sql | Bug | SQL: [`date_format`](../../sql/examples/datetime-format.md#date-format-function) function returns incorrect time zone format.
5379 | search | Bug | Search: Shutdown during full search index rebuild.
5370 | UI | Feature | UI: Add links to **Metric Settings** page.
5366 | administration | Feature | Scheduler: Modify frequent tasks to sleep a fixed interval between iterations.
5365 | administration | Feature | UI: Implement [Backup](../../administration/backup.md) to export server settings, properties, and metrics to file.
5364 | administration | Feature | [Logging](../../administration/logging.md): Increase log detail for full search reindex and group update tasks.
5363 | log_aggregator | Bug | Aggregation Logger: `ConcurrentModificationException` related to Shutdown Hook.
5362 | csv | Bug | [CSV Parsers](../../parsers/csv/README.md): Show user-friendly message for broken files.
5359 | statistics | Bug | Series Statistics: **Entity** label not shown.
5357 | api-rest | Bug | [Logger](../../administration/logging.md) generates excessive `Invalid Command` warnings without explanation.
5353 | client | Support | [Python API Client](https://github.com/axibase/atsd-api-python): Add example of script with parameters to delete series.
5350 | installation | Bug | [Installation](../../installation/README.md): Debian 9 offline fails to install dependencies.
5349 | jdbc | Feature | [JDBC Driver](https://github.com/axibase/atsd-jdbc): Optimize datetime parsing.
5348 | sql | Bug | SQL: Pre-process entity check in [`atsd_series`](../../sql/examples/select-atsd_series.md) query to work around metric limit.
5346 | UI | Feature | Property: Add [**Properties**](../../administration/data_retention.md#deleting-properties) page to view or delete properties for a given entity.
5331 | jdbc | Bug | [JDBC Driver](https://github.com/axibase/atsd-jdbc): Provide `User-Agent` header to ascertain whether JDBC driver or HTTP client used `/api/sql` endpoint.
5322 | sql | Bug | SQL: Cannot provide two consecutive single quotes to [`date_format`](../../sql/examples/datetime-format.md#date-format-function) function in pattern parameter.
5303 | security | Bug | Redirect from HTTP to HTTPS.
5295 | portal | Bug | [Portal Editor](../../portals/README.md): commented freemarker strings are not ignored.
5292 | core | Bug | [Metrics for Entity](../../api/data/alerts/examples/query/alerts-query-multiple-metrics-specified-entity.md): slow response for large number of metrics.
5272 | core | Feature | Core: Migrate date formatters and parsers from `joda.time` to `java.time`.
5248 | xml | Feature | Support [placeholders](../../rule-engine/placeholders.md) in environment variables during import.
5196 | api-rest | Feature |Meta API: [Replacement Table](../../api/meta/replacement-table/README.md) methods.
5152 | rule editor | Bug | Rule Editor: Labels for [Webhook](../../rule-engine/notifications/README.md) parameters are not set if validation error occurs.
5094 | entity_views | Bug | [Entity Views](../../configuration/entity_views.md): Unknown format function causes `400` error.
5085 | sql | Feature | SQL: [`endtime` function](../../sql/#endtime) - add support for literal dates.
5058 | rule engine | Feature | [Rule Engine](../../rule-engine/README.md): Log security function results as ATSD message.
3666 | UI | Bug | UI: Unable to search multiline queries in on **Query Statistics** page.
3546 | api-rest | Feature | [Meta API](../../api/meta/README.md): Method to retrieve user roles and groups.