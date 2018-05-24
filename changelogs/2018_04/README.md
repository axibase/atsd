# Monthly Change Log: April 2018

## ATSD (omitted: 5275, 5265, 5263, 5235, )

**Issue**| **Category**    | **Type**    | **Subject**
-----|-------------|---------|----------------------
5277 | installation | Bug | Enable rules and other records imported into [ATSD sandbox](https://github.com/axibase/dockers/tree/atsd-sandbox#overview) by default.
5269 | api-rest | Bug | ATSD warning message added for [web queries](https://github.com/axibase/atsd/blob/master/rule-engine/functions-web-query.md) failing due to `SocketTimeoutException`.
5267 | rule engine | Bug | Add details for [web notification](https://github.com/axibase/atsd/blob/master/rule-engine/web-notifications.md#web-notifications) errors in [Rule Engine](https://github.com/axibase/atsd/blob/master/rule-engine/README.md).
5260 | rule engine | Bug | Remove default port from header in outgoing HTTP requests.
5256 | security | Bug | Security Incidents page not displaying all incoming events.
5254 | api-rest | Bug | Return [webhook](https://github.com/axibase/atsd/blob/master/rule-engine/notifications/webhook.md#webhook) errors in JSON format instead of HTML.
5253 | security | Bug | Fix credentials error in newly-created [webhook](https://github.com/axibase/atsd/blob/master/rule-engine/notifications/webhook.md#webhook).
5252 | security | Feature | `Path` column added to table at **Settings** > **Diagnostics** > **Security Incidents** page.
5250 | rule engine | Bug |
5249 | rule engine | Bug | AWS [web notification](https://github.com/axibase/atsd/blob/master/rule-engine/web-notifications.md#web-notifications) configuration unable to be cloned.
5247 | rule engine | Bug | Validation error when trying to rename cloned [web notification](https://github.com/axibase/atsd/blob/master/rule-engine/web-notifications.md#web-notifications) configuration.
5246 | rule engine | Bug | [Rule Engine](https://github.com/axibase/atsd/tree/master/rule-engine) set to ignore empty arrays and strings when returning JSON lists for [web notifications](https://github.com/axibase/atsd/blob/master/rule-engine/web-notifications.md#web-notifications).
5240 | rule engine | Bug | [`db_last`](https://github.com/axibase/atsd/blob/master/rule-engine/functions-series.md#db_laststring-m) function returns last value regardless of when it was stored.
5237 | rule engine | Bug | Multi-line [`queryPost`](https://github.com/axibase/atsd/blob/master/rule-engine/functions-web-query.md#querypost) templates enabled in [Rule Engine](https://github.com/axibase/atsd/tree/master/rule-engine)
5236 | rule engine | Feature | `[db_last](https://github.com/axibase/atsd/blob/master/rule-engine/functions-series.md#db_laststring-m)` and `[db_statistic](https://github.com/axibase/atsd/blob/master/rule-engine/functions-series.md#db_statistic)` return `Double.NaN` if no matching series are found or if no values were recorded within the selection interval.
5229 | api-rest | Bug | `GENERAL_ERROR` not displayed in **Settings** > **Diagnostics** > **Security Incidents** for unauthorized [webhook](https://github.com/axibase/atsd/blob/master/rule-engine/notifications/webhook.md#webhook).
5228 | UI | Feature | `User` and `Method` columns added to [webhook](https://github.com/axibase/atsd/blob/master/rule-engine/notifications/webhook.md#webhook) administration page, **Settings** > **Diagnostics** > **Webhook Requests**.
5224 | sql | Bug | `NumberFormatException` raised when [`REPLACE`](https://github.com/axibase/atsd/tree/master/sql#string-functions) function inserts `NaN` value.
5223 | rule engine | Bug | 