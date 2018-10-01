# Monthly Change Log: September 2018

## ATSD

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
5708|rule engine|Bug|[Rule Test](../../rule-engine/README.md): **Time Open** and **Time Cancel** columns represent command time instead of alert time.
5707|rule engine|Bug|Rule Test: Repeatable `CANCEL` events shown if [**Check On Exit**](../../rule-engine/condition.md#check-on-exit) is disabled.
5706|message|Feature|Message Search: Support for entity filtering in [expression](../../administration/metric-persistence-filter.md#expression-syntax).
5705|core|Bug|Message: HBase error on long tag value.
5703|sql|Bug|SQL: `datetime` [`CAST`](../../sql/README.md#cast) returns Unix time.
5702|jdbc|Feature|[JDBC Driver](https://github.com/axibase/atsd-jdbc#jdbc-driver): Optimize metadata request.
5699|rule engine|Bug|Rule Engine: Multiple Rule rows in [email template](../../rule-engine/email.md).
5696|installation|Bug|[AWS EMR](../../installation/aws-emr-s3.md) startup error.
5694|rule engine|Feature|Alert logging: Expose [`DateTime` fields](../../rule-engine/object-datetime.md) as dates in ISO format.
5693|security|Bug|[Rule Engine](../../rule-engine/README.md): XSS in Alert History Search.
5691|installation|Bug|Installation: Failure to create Administrator account upon [container](../../installation/images.md) launch.
5688||Bug|Web: Static resource URL with `jsessionid` returns `404` error.
5686|rule engine|Bug|Rule Engine: Erroneous arguments resolve during function validation if [`collection`](../../administration/metric-persistence-filter.md#collection) literal is used.
5682|core|Bug|Core: JSON serialization of `DateTime` object throws exception if [calendar](../../rule-engine/workday-calendar.md) not found.
5681|security|Bug|[License](../../licensing.md): Upload issue.
5680|rule engine|Bug|Rule Engine: `openValue` is not persisted in [Alert History](../../rule-engine/functions-alert-history.md#alerthistory-object).
5679|security|Feature|Add SAN to [self-signed certificates](../../administration/ssl-self-signed.md).
5678|rule engine|Feature|Rule Engine: [`addTable`](../../rule-engine/functions-table.md) for sample collection.
5677|rule editor|Feature|[Rule Editor](../../rule-engine/README.md): Multiple enhancements.
5676|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): Link missing in **Alert Details** table.
5675|core|Bug|[Logging](../../administration/logging.md): Change logging level to `WARN` for user errors.
5674|security|Bug|ATSD default [self-signed certificate](../../administration/ssl-self-signed.md) no longer works in Chrome.
5673|rule engine|Bug|Rule Engine: Extend [`date_format`](../../rule-engine/functions-date.md#date_format) function to accept `DateTime`.
5671|message|Bug|Message Search: [Expression](../../administration/metric-persistence-filter.md#expression-syntax) returns unexpected results.
5670|data-in|Feature|Collect receive statistics for messages with grouping by type.
5669|rule engine|Feature|Rule Engine: Context-aware [`addTable`](../../rule-engine/functions-table.md#addtable-for-map) function.
5668|rule engine|Feature|Rule Engine: Add correlated metrics to default chart.
5666|rule engine|Feature|Rule Engine: Decrease size of [Alert History](../../rule-engine/logging.md#logging-to-database) data stored in HBase.
5665|rule engine|Bug|Rule Engine: [Alert History](../../rule-engine/logging.md#logging-to-database) entry built with live data instead of snapshot.
5664|api-rest|Bug|API: Check [`API_META_WRITE`](../../administration/user-authorization.md#api-roles) role for Meta commands.
5663|rule engine|Bug|Rule Engine: Rule link on [Alert History](../../rule-engine/logging.md#logging-to-database) page does not open Rule form in new tab.
5661|rule engine|Bug|Rule Engine: [Alert History](../../rule-engine/logging.md#logging-to-database) collision on duplicate command logging.
5659|rule editor|Bug|Rule Editor: Non-user-friendly `400` error upon user variable validation failure.
5658|rule editor|Bug|Rule Editor: UI disappears after save.
5654|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): Implement `values()`, `timestamps()`, and `samples()` functions to retrieve window data.
5652|rule engine|Bug|Rule Engine: [Filter Log](../../rule-engine/filters.md#filter-log) does not display all commands.
5650|rule editor|Feature|Rule Editor: UI enhancements for [derived commands](../../rule-engine/derived.md).
5617|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): Add function call statistics during test.
5613|UI|Feature|Copy **Entity** and **Metric** fields and tags from Editor.
5612|rule engine|Feature|Rule Engine: Normalize window [Date Fields](../../rule-engine/window-fields.md#date-fields).
5600|sql|Bug|SQL [`REPLACE`](../../sql/README.md#string-functions) function does not allow replacement of line breaks.
5581|core|Feature|Core: TCP/UDP/HTTP [replication](../../administration/command-replication.md).
5526|UI|Bug|UI: Standardize style for disabled and deleted options in selection fields.
5508|statistics|Bug|Unhandled exception on **Series Statistics** page.
5503|UI|Feature|UI: Add [Change Log](../README.md) link to **Support** tab in top menu.
5231|core|Feature|[Replacement Tables](../../sql/examples/lookup.md#replacement-tables): Add **Type** and **Information** fields.
5097|sql|Bug|[SQL](../../sql/README.md): Allow expressions in **Entity** column to be exposed to parent query.
|4945|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): Erroneous number formatting.

## Collector

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
5647|core|Feature|[Core](https://axibase.com/docs/axibase-collector/atsd-server-connection.html): Implement time-based resend and failover mechanisms.
5646|scheduler|Bug|[Scheduler](https://axibase.com/docs/axibase-collector/scheduling.html): `TransientObjectException` on `00:00` UTC.
5418|snmp|Support|Collector: Test `netsnmp` daemon with [SNMP job](https://axibase.com/docs/axibase-collector/jobs/snmp.html).
5045|core|Feature|Secondary [HTTP Pool](https://axibase.com/docs/axibase-collector/jobs/http-pool.html) for failover.
