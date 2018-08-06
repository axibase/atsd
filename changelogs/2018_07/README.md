# Monthly Change Log: July 2018

## ATSD

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
5528 | admin | Bug | [Entity Groups](../../configuration/entity_groups.md): Unable to delete existing groups.|
5520 | test | Feature | [ATSD Java API](https://github.com/axibase/atsd-api-java): Log ATSD version to `VersionTest` method.|
5518 | freemarker | Bug | [Logging](../../administration/logging.md): Freemarker warning on ATSD start.|
5516 | api-rest | Bug | [REST API](../../api/data/README.md): CSV upload raises `500` error.|
5515 | forecast | Bug | [Forecast](../../forecasting/README.md) view and delete error.|
5514 | rule engine | Feature | [Rule Engine](../../rule-engine/README.md): add `Author` filter to **Rule** page.|
5511 | entity_views | Bug | [Entity Groups](../../configuration/entity_groups.md): **Formatting** value determined as `Number` upon validation.|
5510 | api-rest | Bug | REST API: [Python API](https://github.com/axibase/atsd-api-python) tests fail.|
5509 | forecast | Bug | **Export Settings** for [Data Forecasting](../../forecasting/README.md) produces invalid XML.|
5505 | UI | Bug | [SQL Console](../../sql/sql-console.md) generates incorrect output format.|
5504 | api-rest | Bug | [Data API](../../api/data/README.md): Aggregate crashes with `NullPointerException`.|
5501 | rule editor | Bug | Rule Editor: Controls disappear when creating multiple [webhooks](../../rule-engine/notifications/README.md).|
5500 | rule editor | Bug | Rule Editor: [Filter](../../rule-engine/#filtering) interval cannot be modified.|
5498 | client | Bug | [Python Client](https://github.com/axibase/atsd-api-python/blob/master/README.md): `200` to `204` migration.|
5489 | rule engine | Feature | Rule Engine: [`elapsed_minutes`](../../rule-engine/functions-date.md#elapsed-minutes) for ISO datetime literal.|
5487 | rule engine | Bug | [Alert History](../../rule-engine/logging.md#logging-to-database) must include grouping tags to avoid collisions.|
5485 | api-rest | Bug | Identify non-compliant [REST API](../../api/data/README.md) endpoint.|
5481 | export | Bug | Export: [Versioned](../../versioning/README.md) data is not displayed.|
5479 | rule editor | Feature | Rule Engine: [Custom script timeout](../../rule-engine/scripts.md#timeout).|
5477 | admin | Bug | [Docker Image](https://github.com/axibase/dockers/tree/atsd-sandbox#atsd-sandbox-docker-image) installation has forbidden operations.|
5475 | security | Bug | `NullPointerException` raised on [password change](../../administration/user-authentication.md#password-requirements).|
5473 | api-rest | Bug | [Messages: `query`](../../api/data/messages/query.md): Lagging wildcard evaluation.|
5471 | api-rest | Feature | Data API: [Series: `query`](../../api/data/series/query.md) - Implement aggregation without period.|
5470 | core | Feature | Admin: Add [**Workday Calendar Import**](../../rule-engine/workday-calendar.md) page|
5469 | rule editor | Feature | UI: Show [logging status](../../administration/logging.md) on **Rule** page|
5468 | core | Bug | Use [strict mode](https://docs.oracle.com/javase/8/docs/api/java/time/format/ResolverStyle.md) when parsing date.|
5467 | admin | Feature | HBase/HDFS [Log File Download](../../administration/logging.md).|
5465 | client | Feature | [Python Client](https://github.com/axibase/atsd-api-python): Change `Message` model to simplify conversion to `DataFrame`|
5464 | jdbc | Bug | [JDBC Driver](https://github.com/axibase/atsd-jdbc): Remove `metric.timePrecision` field from default columns.|
5462 | UI | Bug | Rule Editor: Tooltips need not be shown for [`CUSTOM` webhook](../../rule-engine/notifications/custom.md) parameters|
5460 | UI | Bug | UI: Client-side [datetime formatting](../../api/data/date-format.md) fails when data are loaded with **Default** pattern.|
5459 | api-rest | Feature | [Meta API](../../api/meta/README.md): Implement metric rename method.|
5458 | api-rest | Bug | Data API: [Series: `query`](../../api/data/series/query.md) error when requesting a small date interval close to current time.|
5457 | sql | Bug | [SQL](../../sql/README.md): `datetime` column returns milliseconds (long) in `CASE` expression.|
5453 | rule engine | Bug | [Rule Engine](../../rule-engine/README.md): Remove logging as ATSD messages.|
5452 | api-rest | Feature | Data API: [Series: `query`](../../api/data/series/query.md) - Compress series by removing duplicate values.|
5450 | rule editor | Bug | Rule Editor: Relocated [Variables](../../rule-engine/variables.md) do not maintain their position upon rule save.|
5449 | rule editor | Bug | Rule Editor: Freemarker error on rule save if [webhook](../../rule-engine/notifications/README.md) configuration is deleted.|
5447 | UI | Feature | SQL: Add [**Query Log**](../../sql/performance.md#query-logging) to SQL menu.|
5446 | sql | Feature | SQL: Store [scheduled](../../sql/scheduled-sql.md) Query Name and ID.|
5445 | api-rest | Feature | [Message: `query`](../../api/data/messages/query.md): Implement **Expression** field.|
5444 | data-in | Bug | [scollector](../../integration/scollector/README.md) metadata update discarded.|
5443 | jdbc | Bug | [JDBC Driver](https://github.com/axibase/atsd-jdbc): Add support for new CSV parser dependency versions.|
5442 | jdbc | Bug | [JDBC Driver](https://github.com/axibase/atsd-jdbc): Handle floating point numbers, including when integral datatype is returned by ATSD.|
5440 | client | Feature | Python API Client: Add [`CommandsService`](https://github.com/axibase/atsd-api-python/blob/master/atsd_client/services.py#L676) to available services.|
5438 | core | Feature | Delete **Time Precision** from Metric form.|
5436 | core | Bug | Delete task lags when [deleting Properties](../../administration/data_retention.md#deleting-properties).|
5434 | rule engine | Bug | [Rule Engine](../../rule-engine/README.md): `type` and `source` filters remain upon `message/property` rule type conversion to `metric`.|
5433 | api-rest | Bug | Rest API: [`command` method](../../api/data/ext/command.md) raises `ConcurrentModificationException` upon `saveEntity`.|
5431 | security | Bug | ATSD `Let's Encrypt` Certificate not updated for [ATSD Trends](https://github.com/axibase/charts/blob/master/README.md).|
5427 | core | Bug | Relocate ATSD [temporary directories](../../administration/change-owner.md#temporary-directories).|
5425 | client | Bug | [Python API Client](https://github.com/axibase/atsd-api-python): `tzlocal` fails to import via offline installation.|
5424 | rule engine | Feature | Rule Engine: Show [Response Actions](../../rule-engine/#actions) on **Rule** page.|
5417 | rule engine | Feature | Rule Engine: Restrict [commands](../../rule-engine/scripts.md) to `/script` directory.|
5406 | rule editor | Bug | Rule Engine: Refactor [filter](../../rule-engine/filters.md) fields.|
5405 | rule engine | Feature | Rule Engine: [System Command](../../rule-engine/scripts.md) - Pass window fields into `bash` script as named variables.|
5404 | rule editor | Feature | Rule Editor: Display helper pane with [placeholders](../../rule-engine/placeholders.md).|
5403 | rule editor | Bug | Rule Engine: Replace **Entity Filter** widget with autocomplete-capable [simple input field](../../rule-engine/filters.md#entity-name-filter).|
5401 | UI | Feature | UI: Rename **Webhook Requests** to [**Incoming Webhooks**](../../rule-engine/incoming-webhooks.md) and move page to **Alerts** menu.|
5375 | log_aggregator | Bug | [Aggregation Logger](../../administration/logging.md): Incorrect timeout handling.|
5368 | log_aggregator | Bug | [Aggregation Logger](https://github.com/axibase/aggregation-log-filter): Security issues with HTTPS.|
5363 | log_aggregator | Bug | [Aggregation Logger](https://github.com/axibase/aggregation-log-filter): `ConcurrentModificationException` related to Shutdown Hook|
5360 | client | Bug | [Python API Client](https://github.com/axibase/atsd-api-python): Forecast tests fail with `400` code. |
5342 | versioning | Bug | [Data API](../../api/data/README.md): `NaN` in versions causes issues.|
5339 | export | Bug | **Export** Page: Series tags are not displayed.|
5329 | api-rest | Bug | [Meta API](../../api/meta/README.md): Metric field usage in expression.|
5326 | api-rest | Bug | [Series: `query`](../../api/data/series/query.md): Incorrect `startDate` in response|
5314 | api-rest | Bug | Data API: [Series: `query`](../../api/data/series/query.md) - multiple errors.|
5288 | api-rest | Feature | [Data API](../../api/data/README.md): Series: `query` - `$version_source` and `$version_status` versioning filters.|
5287 | api-rest | Feature | [Data API](../../api/data/README.md): Series: `query` - Handling for `direction` and `limit` filters.|
5211 | versioning | Bug | [Data API](../../api/data/README.md): Export versioned last insert value when **Display Versions** is selected.|
5210 | UI | Feature | UI **Export** Page: Display unique color for latest version.|
5172 | api-rest | Bug | [Data API](../../api/data/README.md): `delta` and `counter` aggregation functions return inconsistent results for most recent period.|
5145 | export | Bug | Export: Incorrect filter for [versioned](../../versioning/README.md) metrics.|
5088 | api-rest | Bug | Data API: [Series: `query`](../../api/data/series/query.md) - Incorrect limit applied for versioned query with `version` filter.|
5085 | sql | Feature | SQL: [`ENDTIME` function](../../sql/#endtime) - Add support for literal dates.|
4661 | statistics | Feature | [Aggregation functions](../../api/data/aggregation.md) support `BigDecimal` numbers.|
4397 | sql | Feature | [SQL](../../sql/README.md): Allow `JOIN ON` if condition and implicit condition are identical.|
3666 | UI | Bug | UI: Unable to search multiline queries on [**Query Statistics**](../../sql/query-statistics.md) page.|
3546 | api-rest | Feature | [Meta API](../../api/meta/README.md): Method to retrieve user roles and groups.|
1255 | rule engine | Feature | [Rule Engine](../../rule-engine/README.md): Raise alert if forecast predicts that series is expected to exceed a set threshold |

## Collector

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
5513 | snmp | Bug | [SNMP](https://axibase.com/docs/axibase-collector/jobs/snmp.md): **MIB** page is not available for custom port.|
5512 | UI | Feature | [SNMP](https://axibase.com/docs/axibase-collector/jobs/snmp.md): Increase readability of **SNMP Query Statistics** page.|
5507 | jmx | Bug | [JMX](https://axibase.com/docs/axibase-collector/jobs/jmx.md): Viewer mode displays split HTML code instead of actual response.|
5506 | core | Bug | Core : Update [Java Client](https://github.com/axibase/atsd-api-java) to latest release.|
5455 | http | Feature | [HTTP Job](https://axibase.com/docs/axibase-collector/jobs/http.md): Add additional columns to the configuration list|
5441 | docker | Bug | [Docker](https://github.com/axibase/dockers/tree/atsd-sandbox#atsd-sandbox-docker-image): `NullPointerException`.|
5432 | http | Bug | UI: Missing message style for [HTTP Job](https://axibase.com/docs/axibase-collector/jobs/http.md).|
5430 | http | Bug | New [HTTP Pool](https://axibase.com/docs/axibase-collector/jobs/http-pool.md) breaks **Job** page drop-down list.|
5429 | UI | Bug | [Storage Driver](https://axibase.com/docs/axibase-collector/atsd-server-connection.md): Hide internal properties from UI.|
5428 | core | Bug | [HTTP Pool](https://axibase.com/docs/axibase-collector/jobs/http-pool.md) and [Storage Driver](https://axibase.com/docs/axibase-collector/atsd-server-connection.md) tests break a working connection.|
5422 | snmp | Bug | Clone [SNMP Job](https://axibase.com/docs/axibase-collector/jobs/snmp.md) causes `NullPointerException`.|
5414 | http | Bug | Handling for [Job](https://axibase.com/docs/axibase-collector/jobs/README.md) with empty configuration.|
5355 | core | Feature | Initial **Configuration** Page.|
5134 | UI | Bug | Collector: Auto-login upon [account creation](../../administration/collector-account.md#create-user).|