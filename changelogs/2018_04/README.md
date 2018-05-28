# Monthly Change Log: April 2018

## ATSD 

(omitted: 5275, 5265, 5263, 5235, 5215, )

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
5277 | installation | Bug | Enable rules and other records imported into [ATSD sandbox](https://github.com/axibase/dockers/tree/atsd-sandbox#overview) by default.
5269 | api-rest | Bug | ATSD warning message added for [web queries](https://axibase.com/docs/atsd/rule-engine/functions.html#web-query) failing due to `SocketTimeoutException`.
5267 | rule engine | Bug | Add details for [web notification](https://axibase.com/docs/atsd/rule-engine/notifications/#creating-notifications) errors in [Rule Engine](https://axibase.com/docs/atsd/rule-engine/).
5260 | rule engine | Bug | Remove default port from header in outgoing HTTP requests.
5256 | security | Bug | Security Incidents page not displaying all incoming events.
5254 | api-rest | Bug | Return [webhook](https://axibase.com/docs/atsd/administration/user-authorization.html#webhook-user) errors in JSON format instead of HTML.
5253 | security | Bug | Fix credentials error in newly-created [webhook](https://axibase.com/docs/atsd/administration/user-authorization.html#webhook-user).
5252 | security | Feature | `Path` column added to table at **Settings** > **Diagnostics** > **Security Incidents** page.
5250 | rule engine | Bug |
5249 | rule engine | Bug | AWS [web notification](https://axibase.com/docs/atsd/rule-engine/notifications/#creating-notifications) configuration unable to be cloned.
5247 | rule engine | Bug | Validation error when trying to rename cloned [web notification](https://axibase.com/docs/atsd/rule-engine/notifications/#creating-notifications) configuration.
5246 | rule engine | Bug | [Rule Engine](https://axibase.com/docs/atsd/rule-engine/) set to ignore empty arrays and strings when returning JSON lists for [web notifications](https://axibase.com/docs/atsd/rule-engine/notifications/#creating-notifications).
5240 | rule engine | Bug | [`db_last`](https://axibase.com/docs/atsd/rule-engine/functions-series.html#db-last) function returns last value regardless of when it was stored.
5237 | rule engine | Bug | Multi-line [`queryPost`](https://github.com/axibase/atsd/blob/master/rule-engine/functions-web-query.md#querypost) templates enabled in [Rule Engine](https://github.com/axibase/atsd/tree/master/rule-engine)
5236 | rule engine | Feature | [`db_last`](https://github.com/axibase/atsd/blob/master/rule-engine/functions-series.md#db_laststring-m) and [`db_statistic`](https://axibase.com/docs/atsd/rule-engine/functions-series.html#db-statistic) return `Double.NaN` if no matching series are found or if no values were recorded within the selection interval.
5229 | api-rest | Bug | `GENERAL_ERROR` not displayed in **Settings** > **Diagnostics** > **Security Incidents** for unauthorized [webhook](https://axibase.com/docs/atsd/administration/user-authorization.html#webhook-user).
5228 | UI | Feature | `User` and `Method` columns added to [webhook](https://axibase.com/docs/atsd/administration/user-authorization.html#webhook-user) administration page, **Settings** > **Diagnostics** > **Webhook Requests**.
5224 | sql | Bug | `NumberFormatException` raised when [`REPLACE`](https://axibase.com/docs/atsd/sql/#string-functions) function inserts [`NaN`](https://axibase.com/docs/atsd/sql/#not-a-number-nan) value.
5223 | rule engine | Bug | Create function [`jsonToMaps`](https://axibase.com/docs/atsd/rule-engine/functions-table.html#jsontomaps) which converts string lists to a collection of maps containing keys and values.
5221 | security | Feature | Enable SSL certificate update via `curl` command without server restart.
5219 | security | Bug | Increase scope of certificate renewal options available via [`certbot`](https://axibase.com/docs/atsd/administration/ssl-lets-encrypt.html#certbot-installation).
5218 | sql | Feature | Support configurable metric limit for [`LIKE`](https://axibase.com/docs/atsd/sql/#like-expression) expressions.
5217 | rule engine | Bug | Refactor [Slack notifications](https://axibase.com/docs/atsd/rule-engine/notifications/slack.html) fields.
5214 | UI | Bug | Warning will be raised if user attempts to [create user](https://axibase.com/docs/atsd/administration/user-authentication.html#user-authentication) which already exists.
5213 | rule engine | Feature | [`LIKE`](https://axibase.com/docs/atsd/rule-engine/functions-collection.html#like) operator added to [Rule Engine](https://axibase.com/docs/atsd/rule-engine/).
5208 | api-rest | Bug | [Wildcard](https://axibase.com/docs/atsd/api/data/#wildcards) support for [tags](https://axibase.com/docs/atsd/api/data/messages/examples/query/messages-query-tags.html) queries.
5200 | rule engine | Feature | [Web Query Functions](https://axibase.com/docs/atsd/rule-engine/functions-web-query.html) added to query external web services via [Rule Engine](https://axibase.com/docs/atsd/rule-engine/).
5198 | UI | Feature | [Webhook User Wizard](https://axibase.com/docs/atsd/api/data/messages/webhook.html#webhook-user-wizard) and [Collector User Wizard](https://axibase.com/docs/atsd/administration/collector-account.html#collector-user-wizard) configured to auto-generate new user passwords.
5197 | api-rest | Bug | [Data API](https://axibase.com/docs/atsd/api/data/) path [endpoints](https://axibase.com/docs/atsd/api/data/#data-api-endpoints) simplified.
5195 | security | Bug | Warning added for invalid [SSL certificate](https://axibase.com/docs/atsd/administration/ssl-self-signed.html) upload.
5193 | forecast | Bug |[Forecast Calendar](https://axibase.com/docs/atsd/forecasting/calendar_exceptions_testing.html#calendar) form errors:<br> - Space in Calendar Name now supported;<br> - `Starttime 00:00` supported;<br> - Invalid date conversion disabled;<br> - `Starttime 29-Feb` supported.
5188 | core | Bug | JsonFactory objects moved to JsonUtil class for performance enhancement.
5185 | entity | Bug | `NullPointerException` returned for non-existent `entity`.
5184 | portal | Bug |
5183 | forecast | Bug | 