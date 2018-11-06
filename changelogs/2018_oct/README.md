# Monthly Change Log: October 2018

## ATSD

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
5752 | core | Bug | [Messages](../../api/data/README.md#messages): Messages with `null` tag value passed to rule engine. |
5749 | sql | Bug | SQL: [`METRICS`](../../sql/README.md#metrics) function only reads first argument. |
5746 | UI | Bug | [SQL Console](../../sql/sql-console.md): Column types inferred incorrectly for functions which retain argument type. |
5745 | sql | Bug | SQL: [`LEAD`](../../sql/README.md#lead) and [`LAG`](../../sql/README.md#lag) functions return incorrect column data type for `datetime` column. |
5737 | sql | Bug | SQL: Return correct data types for [metadata tables](../../sql/README.md#tables): `atsd_metric` and `atsd_entity`. |
5735 | jdbc | Feature | [JDBC Driver](https://github.com/axibase/atsd-jdbc/blob/master/README.md): Unsupported `java_long` data type in Spotfire. |
5733 | jdbc | Feature | [JDBC Driver](https://github.com/axibase/atsd-jdbc/blob/master/README.md): Update default columns for [metadata tables](../../sql/README.md#tables): `atsd_metric` and `atsd_entity`. |
5732 | core | Bug | [ATSD cluster](../../installation/hbase-cluster.md) start failure. |
5731 | core | Bug | [License](../../licensing.md) check ignores node count. |
5729 | sql | Feature | SQL: Add support for [`creationTime`](../../sql/README.md#entity-columns) column. |
5728 | jdbc | Feature | JDBC: Add support for [`atsd_entity`](../../sql/README.md#atsd_entity-table) and [`atsd_metric`](../../sql/README.md#atsd_metric-table) metadata tables in JDBC driver. |
5727 | sql | Bug | [SQL](../../sql/): Incorrect arithmetic operator precedence. |
5726 | sql | Feature | [SQL](../../sql/): implement [metadata tables](../../sql/README.md#tables): `atsd_metric` and `atsd_entity`. |
5725 | installation | Bug | [Docker Installation](../../installation/images.md): `LicenseServiceImpl` error. |
5723 | sql | Bug | [SQL](../../sql/): `NullPointerException` on Compare. |
5721 | client | Feature | Python client: Add [`export_portals_for_docker_hosts`](https://github.com/axibase/atsd-api-python/blob/master/README.md#reports) method. |
5720 | api-rest | Feature | [Data API](../../api/meta/misc/portal.md): Implement method to export portal as PNG image. |
5719 | core | Bug | Metric List: Slow response time. |
5717 | rule engine | Bug | [Rule Engine](../../rule-engine/): Rule threshold notifications are not properly exported. |
5716 | rule editor | Bug | [Rule Engine](../../rule-engine/): Long URL after rule clone. |
5713 | csv | Bug | CSV Parser: `ArrayIndexOutOfBoundsException` shown instead of human-readable error during use of [schema-based parser](../../parsers/csv/README.md#schema-based-parsing). |
5712 | statistics | Bug | `NullPointerException` upon series statistics access. |
5709 | rule engine | Feature | [Rule Engine](../../rule-engine/): Implement **Test** for Message and Property rules. |
5688 | core | Bug | Web: Static resource URL with `jsessionid` returns `404` error. |
5685 | license | Feature | [License](https://github.com/axibase/atsd/blob/master/axibase_tsd_se_license.pdf) refactoring. |
5660 | rule editor | Bug | Rule Editor: `500` error upon [webhook](../../rule-engine/notifications/) deletion. |
5630 | statistics | Bug | Statistics: Replace `ResizableDecimalArray` with a default solution. |
5600 | sql | Bug | SQL: [`REPLACE`](../../sql/README.md#string-functions) function does not allow line break replacement. |
5589 | rule engine | Bug | [Rule Engine](../../rule-engine/): Review notification thresholds. |
5564 | rule editor | Feature | [Email](../../rule-engine/email.md) and [Webhook](../../rule-engine/notifications/) action validation. |
5107 | sql | Feature | SQL: `JOIN` using subqueries - support for [`ON`](../../sql/README.md#join-syntax) condition. |
4655 | UI | Bug | UI: Typeahead does not encode HTML entities when rendering items in list. |

---

## Charts

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
5566 | core | Bug | Duplicate requests triggered by Charts when period switches in [`auto`](https://github.com/axibase/charts/blob/master/widgets/treemap/README.md#mode) mode. |

---

## Collector

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
5743 | core | Feature | [Storage Driver](https://axibase.com/docs/axibase-collector/atsd-server-connection.html): Enforce ATSD compatibility. |
5741 | json | Bug | [JSON Job](https://axibase.com/docs/axibase-collector/jobs/json.html): **Delete on Upload** option fails. |
5739 | json | Bug | [JSON Job](https://axibase.com/docs/axibase-collector/jobs/json.html): `NullPointerException` for file processing in **Run** mode. |
5738 | json | Bug | [JSON Job](https://axibase.com/docs/axibase-collector/jobs/json.html): File is deleted during test without selecting **Delete Files on Upload**. |
5718 | pi | Bug | [PI Job](https://axibase.com/docs/axibase-collector/jobs/pi.html): JSP test error. |
5129 | http | Feature | [HTTP Job](https://axibase.com/docs/axibase-collector/jobs/http.html): Collect SSL certificate expiration days and SSL certificate status. |
