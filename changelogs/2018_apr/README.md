# Monthly Change Log: April 2018

## ATSD

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
5277 | installation | Bug | Auto-enable imported rules in [ATSD sandbox](https://github.com/axibase/dockers/tree/atsd-sandbox#overview) by default.
5269 | api-rest | Bug | Stale status displayed for an [outgoing webhook](../../rule-engine/notifications/README.md) failing due to `SocketTimeoutException`.
5267 | rule engine | Bug | Add context information for [outgoing webhook](../../rule-engine/notifications/README.md#creating-notifications) errors.
5260 | rule engine | Bug | Remove default port from header in outgoing HTTP requests.
5256 | security | Bug | Security Incidents page not displaying the latest incidents.
5254 | api-rest | Bug | Return errors in JSON format in [webhook](../../api/data/messages/webhook.md) method.
5253 | security | Bug | Fix credentials error in newly created [webhook](../../administration/user-authorization.md#webhook-user).
5252 | security | Feature | `Path` column added to table at **Settings** > **Diagnostics** > **Security Incidents** page.
5250 | rule engine | Bug | Some errors not displayed in the rule engine.
5249 | rule engine | Bug | AWS API [webhook](../../rule-engine/notifications/aws-api.md) configuration not cloned.
5247 | rule engine | Bug | Validation error when trying to rename cloned [webhook](../../rule-engine/notifications/README.md) configuration.
5246 | rule engine | Bug | [`flattenJson`](../../rule-engine/functions-table.md#flattenjson) function must ignore empty arrays.
5240 | rule engine | Bug | [`db_last`](../../rule-engine/functions-series.md#db_last) function fails to load records older than 1 hour.
5237 | rule engine | Feature | Add support for multi-line expressions in the rule editor.
5236 | rule engine | Bug | Log error when records are not found by [`db_last`](../../rule-engine/functions-series.md#db_last) and [`db_statistic`](../../rule-engine/functions-series.md#db_statistic) functions.
5229 | api-rest | Bug | `GENERAL_ERROR` not displayed in **Settings** > **Diagnostics** > **Security Incidents** for unauthorized user.
5228 | UI | Feature | `User` and `Method` columns added to the incoming webhook page on **Settings** > **Diagnostics** > **Webhook Requests**.
5224 | sql | Bug | Scheduled SQL query with [store](../../sql/scheduled-sql-store.md) option causes `NumberFormatException` on `NaN` value.
5223 | rule engine | Feature | Implement [`jsonToMaps`](../../rule-engine/functions-table.md#jsontomaps) function to converts string lists to a collection of maps.
5221 | security | Feature | Implement a form to create and install a self-signed certificate.
5218 | sql | Feature | Support configurable limit for `LIKE` filter in `atsd_series` [queries](../../sql/README.md#atsd_series-table).
5217 | rule engine | Feature | Simplify [Slack webhook](../../rule-engine/notifications/slack.md) configuration.
5214 | UI | Bug | Display warning if user attempts to [create user](../../administration/user-authentication.md#user-authentication) which already exists.
5213 | rule engine | Feature | Accept collections in [`LIKE`](../../rule-engine/functions-collection.md#like) operator.
5208 | api-rest | Bug | Wildcards in tags ignored in the [metric list](../../api/meta/metric/list.md) method when entity is specified.
5200 | rule engine | Feature | Implement [Web Query Functions](../../rule-engine/functions-web-query.md) to query external web services.
5198 | UI | Feature | Automatically generate passwords in [Webhook User](../../api/data/messages/webhook.md#webhook-user-wizard) and [Collector User](../../administration/collector-account.md#use-wizard) wizards.
5197 | api-rest | Feature | Incoming [webhook](../../api/data/messages/webhook.md): default parameters simplified.
5195 | security | Bug | Server error raised when uploading [SSL certificate](../../administration/ssl-self-signed.md).
5193 | forecast | Bug |[Forecast Calendar](../../forecasting/calendar_exceptions_testing.md#calendar) form errors.
5188 | core | Bug | `JsonFactory` objects moved to `JsonUtil` class for performance enhancement.
5185 | entity | Bug | Fix `NullPointerException` raised during entity group synchronization on non-existent `entity`.
5184 | portal | Bug | Fix error raised when new [portal](../../portals/) is created.
5183 | forecast | Bug | Fix server error when using manually defined [algorithm parameters](../../forecasting/README.md#algorithm-parameters) in forecasts.
5182 | core | Bug | Text value not [logged](../../administration/metric-persistence-filter.md) in `command_discarded.log`.
5181 | rule editor | Bug | Simplify [Telegram](../../rule-engine/notifications/telegram.md#telegram-notifications) webhook configuration.
5179 | UI | Bug | New [User Group](../../administration/user-authentication.md#user-authentication) members and permissions not saved.
5177 | search | Feature | Make the directory used for temporary search index files configurable.
5175 | api-rest | Bug | Correct incoming [webhook](../../api/data/messages/webhook.md) processing error.
5162 | rule editor | Bug | Unable to customize `On Cancel` trigger for [webhooks](../../rule-engine/notifications/README.md#creating-notifications).
5161 | backup | Bug | Refer to exported [portals](../../portals/) by name instead of `id` in XML files.
5157 | administrator | Bug | Standardize line breaks when storing [configuration files](../../administration/editing-configuration-files.md#editing-configuration-files).
5156 | installation | Bug | Fix non-printable characters in start script.

## Collector

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
5232 | data-source | Feature | Upgrade `JDBC` drivers.
5230 | [`jdbc`](https://axibase.com/docs/axibase-collector/jobs/jdbc.html#jdbc-job) | Bug | JDBC Job does not work properly in test mode.
5212 | `xml` | Bug | Server error raised when importing job XML file.
5199 | [`jdbc`](https://axibase.com/docs/axibase-collector/jobs/jdbc.html#jdbc-job) | Feature | Add support for `${HOST}` placeholder.
