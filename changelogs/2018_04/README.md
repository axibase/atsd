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
5253 | security | Bug | Fix credentials error in newly-created [webhook](../../administration/user-authorization.md#webhook-user).
5252 | security | Feature | `Path` column added to table at **Settings** > **Diagnostics** > **Security Incidents** page.
5250 | rule engine | Bug | Some errors not displayed in the rule engine.
5249 | rule engine | Bug | AWS API [webhook](../../rule-engine/notifications/aws-api.md) configuration unable to be cloned.
5247 | rule engine | Bug | Validation error when trying to rename cloned [webhook](../../rule-engine/notifications/README.md) configuration.
5246 | rule engine | Bug | [`flattenJson`](../../rule-engine/functions-table.md#flattenjson) function must ignore empty arrays.
5240 | rule engine | Bug | [`db_last`](../../rule-engine/functions-series.md#db-last) function fails to load records older than 1 hour.
5237 | rule engine | Feature | Add support for multi-line expressions in the rule editor.
5236 | rule engine | Bug | Log error when records are not found by [`db_last`](../../rule-engine/functions-series.md#db_laststring-m) and [`db_statistic`](../../rule-engine/functions-series.md#db-statistic) functions.
5229 | api-rest | Bug | `GENERAL_ERROR` not displayed in **Settings** > **Diagnostics** > **Security Incidents** for unauthorized user.
5228 | UI | Feature | `User` and `Method` columns added to the incoming webhook page on **Settings** > **Diagnostics** > **Webhook Requests**.
5224 | sql | Bug | Scheduled SQL query with [store](../../sql/scheduled-sql-store.md) option causes NumberFormatException on NaN value.
5223 | rule engine | Feature | Implement [`jsonToMaps`](../../rule-engine/functions-table.md#jsontomaps) function to converts string lists to a collection of maps.
5221 | security | Feature | Implement a form to create and install a self-signed certificate.
5218 | sql | Feature | Support configurable limit for `LIKE` expressions in `atsd_series` [queries](../../sql/README.md#atsd-series-table).
5217 | rule engine | Bug | Refactor [Slack webhook](../../rule-engine/notifications/slack.md) fields.
5214 | UI | Bug | Display warning if user attempts to [create user](../../administration/user-authentication.md#user-authentication) which already exists.
5213 | rule engine | Feature | [`LIKE`](../../rule-engine/functions-collection.md#like) operator accepts collections.
5208 | api-rest | Bug | Tags not found for wildcards in the [metric list](../../api/meta/metric/list.md) method.
5200 | rule engine | Feature | Implement [Web Query Functions](../../rule-engine/functions-web-query.md) to query external web services.
5198 | UI | Feature | Automatically generate passwords in [Webhook User](../../api/data/messages/webhook.md#webhook-user-wizard) and [Collector User](../../administration/collector-account.md#collector-user-wizard) wizards.
5197 | api-rest | Bug | [Data API](../../api/data/) path [endpoints](../../api/data/#data-api-endpoints) simplified.
5195 | security | Bug | Warning added for invalid [SSL certificate](../../administration/ssl-self-signed.md) upload.
5193 | forecast | Bug |[Forecast Calendar](../../forecasting/calendar_exceptions_testing.md#calendar) form errors:<br> - Space in Calendar Name now supported;<br> - `Starttime 00:00` supported;<br> - Invalid date conversion disabled;<br> - `Starttime 29-Feb` supported.
5188 | core | Bug | JsonFactory objects moved to JsonUtil class for performance enhancement.
5185 | entity | Bug | `NullPointerException` returned for non-existent `entity`.
5184 | portal | Bug | Add default example [portal](../../portals/) when user creates new portal.
5183 | forecast | Bug | Server-side error when using [manually-defined algorithm parameters](../../forecasting/#algorithm-parameters) for [Data Forecasting](../../forecasting/).
5182 | core | Bug | [Persistent metric](../../administration/metric-persistence-filter.md) not stored in `discarded.log` output.
5181 | rule editor | Bug | [Telegram Notification](../../rule-engine/notifications/telegram.md#telegram-notifications) configuration settings simplified.
5179 | UI | Bug | Improve [User Groups](../../administration/user-authentication.md#user-authentication) members / permissions management.
5177 | search | Bug | Support for default search directory configuration added.
5175 | api-rest | Bug | Failed [Webhook](../../api/data/messages/webhook.md) authentication events added to [Webhook Requests](../../api/data/messages/webhook.md#diagnostics) page under **Diagnostics** menu.
5162 | rule editor | Bug | Customization of `On Cancel` parameter for [Web Notifications](../../rule-engine/notifications/#creating-notifications) supported via [Rule Engine](../../rule-engine/README.md) interface.
5161 | export | Bug | Generalize [portal](../../portals/) information when exported from local [ATSD](../../README.md) for compatibility with other instances.
5157 | admin | Bug | Carriage return characters present in `server.properties` file ([Configuration Files](../../administration/editing-configuration-files.md#editing-configuration-files)) removed due to potential to break startup scripts.
5156 | installation | Bug | Support whitespace in [Configuration Files](../../administration/editing-configuration-files.md#editing-configuration-files).
