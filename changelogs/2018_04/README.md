# Monthly Change Log: April 2018

## ATSD

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
5277 | installation | Bug | Enable rules and other records imported into [ATSD sandbox](https://github.com/axibase/dockers/tree/atsd-sandbox#overview) by default.
5269 | api-rest | Bug | ATSD warning message added for [web queries](../../rule-engine/functions.md#web-query) failing due to `SocketTimeoutException`.
5267 | rule engine | Bug | Add details for [web notification](../../rule-engine/web-notifications.md) errors in [Rule Engine](../../rule-engine/README.md).
5260 | rule engine | Bug | Remove default port from header in outgoing HTTP requests.
5256 | security | Bug | Security Incidents page not displaying all incoming events.
5254 | api-rest | Bug | Return [webhook](../../administration/user-authorization.md#webhook-user) errors in JSON format instead of HTML.
5253 | security | Bug | Fix credentials error in newly-created [webhook](../../administration/user-authorization.md#webhook-user).
5252 | security | Feature | `Path` column added to table at **Settings** > **Diagnostics** > **Security Incidents** page.
5250 | rule engine | Bug |
5249 | rule engine | Bug | AWS [web notification](../../rule-engine/notifications/#creating-notifications) configuration unable to be cloned.
5247 | rule engine | Bug | Validation error when trying to rename cloned [web notification](../../rule-engine/notifications/#creating-notifications) configuration.
5246 | rule engine | Bug | [Rule Engine](../../rule-engine/README.md) set to ignore empty arrays and strings when returning JSON lists for [web notifications](../../rule-engine/notifications/#creating-notifications).
5240 | rule engine | Bug | [`db_last`](../../rule-engine/functions-series.md#db-last) function returns last value regardless of when it was stored.
5237 | rule engine | Bug | Multi-line [`queryPost`](../../rule-engine/functions-web-query.md#querypost) templates enabled in [Rule Engine](../../rule-engine/README.md)
5236 | rule engine | Feature | [`db_last`](../../rule-engine/functions-series.md#db_laststring-m) and [`db_statistic`](../../rule-engine/functions-series.md#db-statistic) return `Double.NaN` if no matching series are found or if no values were recorded within the selection interval.
5229 | api-rest | Bug | `GENERAL_ERROR` not displayed in **Settings** > **Diagnostics** > **Security Incidents** for unauthorized [webhook](../../administration/user-authorization.md#webhook-user).
5228 | UI | Feature | `User` and `Method` columns added to [webhook](../../administration/user-authorization.md#webhook-user) administration page, **Settings** > **Diagnostics** > **Webhook Requests**.
5224 | sql | Bug | `NumberFormatException` raised when [`REPLACE`](../../sql/#string-functions) function inserts [`NaN`](../../sql/#not-a-number-nan) value.
5223 | rule engine | Bug | Create function [`jsonToMaps`](../../rule-engine/functions-table.md#jsontomaps) which converts string lists to a collection of maps containing keys and values.
5221 | security | Feature | Enable SSL certificate update via `curl` command without server restart.
5219 | security | Bug | Increase scope of certificate renewal options available via [`certbot`](../../administration/ssl-lets-encrypt.md#certbot-installation).
5218 | sql | Feature | Support configurable metric limit for [`LIKE`](../../sql/#like-expression) expressions.
5217 | rule engine | Bug | Refactor [Slack notifications](../../rule-engine/notifications/slack.md) fields.
5214 | UI | Bug | Warning will be raised if user attempts to [create user](../../administration/user-authentication.md#user-authentication) which already exists.
5213 | rule engine | Feature | [`LIKE`](../../rule-engine/functions-collection.md#like) operator added to [Rule Engine](../../rule-engine/README.md).
5208 | api-rest | Bug | [Wildcard](../../api/data/#wildcards) support for [tags](../../api/data/messages/examples/query/messages-query-tags.md) queries.
5200 | rule engine | Feature | [Web Query Functions](../../rule-engine/functions-web-query.md) added to query external web services via [Rule Engine](../../rule-engine/README.md).
5198 | UI | Feature | [Webhook User Wizard](../../api/data/messages/webhook.md#webhook-user-wizard) and [Collector User Wizard](../../administration/collector-account.md#collector-user-wizard) configured to auto-generate new user passwords.
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