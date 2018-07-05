# Monthly Change Log: June 2018

## ATSD

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
5423 | rule engine | Bug | [Rule Engine](https://axibase.com/docs/atsd/rule-engine/): Deserialization errors for rules with type and source filters.
5421 | admin | Bug | Backup: Customizable [directory](https://axibase.com/docs/atsd/administration/backup.html#backup-directory).
5420 | rule engine | Bug | [Rule Engine](https://axibase.com/docs/atsd/rule-engine/): Optimize cases with multiple rules enabled.
5419 | UI | Bug | UI: Apply DST offset to Time Zone drop-down lists.
5413 | rule engine | Feature | Rule Engine: Implement [`toNumber`](https://axibase.com/docs/atsd/rule-engine/functions-utility.html#tonumber) function for `null`-safe number parsing.
5412 | api-rest | Feature | [Series Get](https://axibase.com/docs/atsd/api/data/series/get.html) method: Add support for period alignment.
5411 | message | Bug | [Message Table TTL](https://axibase.com/docs/atsd/api/data/messages/delete.html#ttl) specified in `server.properties` ignored.
5407 | UI | Bug | UI: Type field suggestion broken on **Data Entry** page.
5405 | rule engine | Feature | Rule Engine: [System Commands](https://axibase.com/docs/atsd/rule-engine/commands.html) - pass window fields into `bash` script as named variables.
5403 | rule editor | Bug | [Rule Engine](https://axibase.com/docs/atsd/rule-engine/commands.html): Replace Entity Filter widget with autocomplete-capable simple input field.
5402 | UI | Feature | UI: Rename **Web Notifications** as [**Outgoing Webhooks**](https://axibase.com/docs/atsd/rule-engine/notifications/).
5401 | UI | Feature | UI: Move **Webhook Requests** to **Alerts** menu.
5399 | test | Bug | API Tests: Message tests failing because of low [`messages.timeToLive`](https://axibase.com/docs/atsd/api/data/messages/delete.html#ttl).
5397 | admin | Bug | `IllegalArgumentException` for [Backup upload](https://axibase.com/docs/atsd/administration/backup.html).
5396 | security | Bug | [Security](https://axibase.com/docs/atsd/administration/user-authentication.html): Duplicate JSON response in case of authentication failure.
5394 | client | Bug | ATSD [API Java](https://github.com/axibase/atsd-api-java): Handling for `Throwable` errors.
5393 | api-rest | Feature | API: Add `InsertTime`.
5387 | search | Bug | [Search](https://axibase.com/docs/atsd/api/meta/misc/search.html): Full re-index fails on disk space shortage.
5384 | administrator | Feature | Monitoring: Add **Database Statistics** page to show last values of internal metrics.
5381 | log_aggregator | Bug | Aggregation Log Filter: Support multiple collectors.
5380 | sql | Bug | SQL: [`date_format`](https://axibase.com/docs/atsd/sql/examples/datetime-format.html#date-format-function) function returns incorrect timezone format.
5379 | search | Bug | Search: Shutdown during full search index rebuild.
5370 | UI | Feature | UI: Add links to **Metric Settings** page.
5366 | admin | Feature | Scheduler: Modify frequent tasks to sleep a fixed interval between iterations.
5365 | admin | Feature | UI: Implement [Backup](https://axibase.com/docs/atsd/administration/backup.html) to export server settings, properties, and metrics to file.
5364 | admin | Feature | [Logging](https://axibase.com/docs/atsd/administration/logging.html): Increase log detail for full search reindex and group update tasks.
5363 | log_aggregator | Bug | Aggregation Logger: `ConcurrentModificationException` related to Shutdown Hook.
5362 | csv | Bug | [CSV Parsers](https://axibase.com/docs/atsd/parsers/csv/): Show user-friendly message for broken files.
5359 | statistics | Bug | Series Statistics: **Entity** label not shown.
5357 | api-rest | Bug | [Logger](https://axibase.com/docs/atsd/administration/logging.html) generates excessive `Invalid Command` warnings without explanation.
5353 | client | Support | [Python API Client](https://github.com/axibase/atsd-api-python): Add example of script with parameters to delete series.
5350 | installation | Bug | [Installation](https://axibase.com/docs/atsd/installation/): Debian 9 offline fails to install dependencies.
5349 | jdbc | Feature | [JDBC Driver](https://github.com/axibase/atsd-jdbc): Optimize datetime parsing.
5348 | sql | Bug | SQL: Preprocess entity check in [`atsd_series`](https://axibase.com/docs/atsd/sql/examples/select-atsd_series.html) query to work around metric limit.
5346 | UI | Feature | Property: Add [**Properties**](https://axibase.com/docs/atsd/administration/data_retention.html#deleting-properties) page to view or delete properties for a given entity.
5331 | jdbc | Bug | [JDBC Driver](https://github.com/axibase/atsd-jdbc): Provide User-Agent header to ascertain whether JDBC driver or HTTP client used `/api/sql` endpoint.
5322 | sql | Bug | SQL: Cannot provide two consecutive single quotes to [`date_format`](https://axibase.com/docs/atsd/sql/examples/datetime-format.html#date-format-function) function in pattern parameter.
5303 | security | Bug | Redirect from HTTP to HTTPS.
5295 | portal | Bug | [Portal Editor](https://axibase.com/docs/atsd/portals/): commented freemarker strings are not ignored.
5292 | core | Bug | [Metrics for Entity](https://axibase.com/docs/atsd/api/data/alerts/examples/query/alerts-query-multiple-metrics-specified-entity.html): slow response for large number of metrics.
5272 | core | Feature | Core: Migrate date formatters and parsers from `joda.time` to `java.time`.
5248 | xml | Feature | Support [placeholders](https://axibase.com/docs/atsd/rule-engine/placeholders.html) in environment variables during import.
5196 | api-rest | Feature |Meta API: [Replacement Table](https://axibase.com/docs/atsd/api/meta/replacement-table/) methods.
5152 | rule editor | Bug | Rule Editor: Labels for [Webhook](https://axibase.com/docs/atsd/rule-engine/notifications/) parameters are not set if validation error occurs.
5094 | entity_views | Bug | [Entity Views](https://axibase.com/docs/atsd/configuration/entity_views.html): Unknown format function causes `400` error.
5085 | sql | Feature | SQL: [`endtime` function](https://axibase.com/docs/atsd/sql/#endtime) - add support for literal dates.
5058 | rule engine | Feature | [Rule Engine](https://axibase.com/docs/atsd/rule-engine/): Log security function results as ATSD message.
3666 | UI | Bug | UI: Unable to search multiline queries in on **Query Statistics** page.
3546 | api-rest | Feature | [Meta API](https://axibase.com/docs/atsd/api/meta/): Method to retrieve user roles and groups.