# Monthly Change Log: May 2019

## ATSD

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
6280|core|Bug|[Database](../../installation/README.md) startup failed.
6277|security|Bug|Audit log: [log](../../administration/logging.md#logging) deleted series key in human-readable format.
6274|UI|Bug|Users: cannot edit [user group](../../administration/user-authorization.md#entity-permissions) with members.
6273|administrator|Bug|[User Group](../../administration/user-authorization.md#entity-permissions): unable to delete group.
6272|administrator|Bug|[User Group](../../administration/user-authorization.md#entity-permissions): add warning when creating a group with duplicate name.
6271|sql|Bug|[Scheduled SQL Queries](../../sql/scheduled-sql.md#sql-scheduler): non-ASCII encoding issue with published SQL reports.
6266|administrator|Feature|Security: log an audit event when the record is created or deleted.
6263|core|Bug|Duplicate commands are sent to the target ATSD by the [replicator](../..//administration/command-replication.md#command-replication).
6260|rule editor|Bug|[Rule Engine](../../rule-engine/README.md): error is not highlighted.
6259|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): validate delay settings.
6253|core|Feature|[Log](../../administration/logging.md#logging) series deletion.
6252|rule engine|Feature|Rule Engine: add [`timeOfDay`](../../rule-engine/object-datetime.md#fields) field to `DateTime` object.
6251|rule engine|Feature|Rule Engine: add support for [orb tags](../../rule-engine/control-flow.md#control-flow) and expression context to [Email](../../rule-engine/email.md#email-action) recipients input.
6249|entity|Feature|UI: add option to create new entity with pre-selected entity tags from [template](../../configuration/tag-templates.md#tag-templates).
6247|UI|Bug|UI: [CSV Wizard](../../tutorials/getting-started-insert.md#csv-files): fix column width calculation.
6246|export|Bug|[Export](../../reporting/ad-hoc-exporting.md#ad-hoc-exporting): tag is lost if form is opened from new [forecast job](../../forecasting/README.md#data-forecasting).
6245|rule engine|Bug|Rule Engine: [**Log to Alert History**](../../rule-engine/logging.md#logging-to-database) setting is missing in exported XML files.
6244|data-in|Feature|[Property](../../api/data/properties/insert.md#properties-insert) command: empty tag value must delete stored tag.
6243|portal|Feature|UI: add metric viewer links to **Entity** and **Metric** editors.
6242|UI|Bug|Entity editor: all [time zones](../../shared/timezone-list.md#time-zones) are highlighted as red.
6240|forecast|Bug|Forecast editor: validate incorrectly set tags.
6239|forecast|Bug|Incorrect table name displayed in [forecast](../../forecasting/README.md#data-forecasting) settings.
6235|rule engine|Bug|[`sendTcpMessageReply`](../../rule-engine/functions-utility.md#sendtcpmessagereply) cannot read the response.
6234|api-network|Bug|Network API: [property](../../api/data/properties/insert.md#properties-insert) command with empty tags is not recognized as malformed.
6233|rule engine|Bug|Rule Engine: [`sendTcpMessageReply`](../../rule-engine/functions-utility.md#sendtcpmessagereply) function to send text to a remote server via TCP and read the response.
6224|api-rest|Bug|Mismatch between requested [forecast](../../api/data/series/forecast.md#forecasting) series and series  query response.
6223|rule engine|Bug|Rule Engine: [**Load History**](../../rule-engine/window.md#life-cycle) tag filtering works incorrectly.
6216|rule engine|Feature|Rule Engine: implement [`sendTcpMessage`](../../rule-engine/functions-utility.md#sendtcpmessage) function to send string to remote server/port via TCP.
6211|email|Bug|[Mail client](../../administration/mail-client.md#mail-client): HTTP 500 error when trying to save configuration.
6198|rule engine|Bug|Rule Engine: [formatter](../../rule-engine/functions-date.md#dateformatter) output on `NaN` and invalid dates.
6193|rule engine|Feature|Rule Engine: implement [function](../../rule-engine/control-flow.md#conditional-processing) to cancel a pending action.
6190|rule engine|Bug|Rule Engine: [`rule_window`](../../rule-engine/functions-rules.md#rule_window) variable data types are passed to the dependent window.
6095|sql|Bug|SQL: series tag [filter](../../sql/examples/filter-by-series-tag.md#filter-by-series-tag) ignores dots.
6089|csv|Feature|[CSV Wizard](../../tutorials/getting-started-insert.md#csv-files): add links to [Export](../../reporting/ad-hoc-exporting.md#ad-hoc-exporting) form.
6051|forecast|Feature|[Forecast Jobs](../../forecasting/README.md#data-forecasting): add group-action to run selected forecasts.
5974|csv|Feature|[CSV Wizard](../../tutorials/getting-started-insert.md#csv-files): highlight columns with numeric constants.

## Charts

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
6261|widget-settings|Feature|Render [SQL](https://axibase.com/docs/charts/widgets/shared/#sql) query results as series.
6232|widget-settings|Bug|Numeric [`format`](https://axibase.com/docs/charts/syntax/format-settings.html#format-settings) applied to tag column.
6177|widget-settings|Bug|Portal Configuration: [`tag-expression`](https://axibase.com/docs/charts/widgets/shared/#tag-expression) incorrectly applies to `[series]`.

## Collector

 Issue| Category    | Type    | Subject
 ------|-------------|---------|--------
6238|kafka|Bug|[Kafka](https://axibase.com/docs/axibase-collector/jobs/kafka.html#kafka-job) job: add support for JSON fields at nested levels.
5940|jdbc|Feature|[JDBC](https://axibase.com/docs/axibase-collector/jobs/jdbc.html#jdbc-job) job: highlight duplicates in commands.
