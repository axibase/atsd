# Monthly Change Log: April 2018

## ATSD (omitted: 5275, 5265, 5263, )

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
5246 | rule engine | Bug |