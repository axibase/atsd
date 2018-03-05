Monthly Change Log: January 2018
==================================================

## ATSD

Issue| Category    | Type    | Subject              
-----|-------------|---------|----------------------
4940 | rule engine | Feature | Rule Engine: add administrative [setting](../../rule-engine/window.md#cancel-status) to control On Cancel behavior.
4934 | UI | Bug | UI: Incorrect link in tooltip.
4931 | rule engine | Bug | Zero time filter is not saved on rule XML export.
4929 | rule engine | Bug | Web notifications: Telegram discards long messages.
4926 | sql | Bug | SQL: Non-boolean datatype for conditions.
4923 | rule engine | Bug | Rule Engine: telegram 400 error doesn't contain information about the message.
4921 | security | Bug | Screenshot user can't log in.
4920 | security | Bug | Disabled user is able to execute SQL queries.
4914 | rule engine | Bug | Rule Engine: Meaningless error messages for HipChat.
4913 | client | Feature | Upgrade R client.
4911 | rule engine | Bug | Pass query into sql client containing `>` character.
4910 | rule engine | Bug | Implement [`executeSqlQuery`](../../rule-engine/functions-db.md#executesqlquery) function to return result of SQL query.
4908 | rule engine | Feature | Create rule from message search page.
4901 | rule engine | Feature | Implement [utility function](../../rule-engine/functions-utility.md#utility-functions) to extract host, port, protocol from url.
4900 | rule engine | Feature | Implement lookup function [`getEntityName`](../../rule-engine/functions-lookup.md#getentityname).
4899 | rule engine | Feature | Implement [`trim`](../../rule-engine/functions-text.md#trim) text function to remove leading and trailing non-printable characters.
4897 | rule engine | Feature | Implement [`getPropertyLink`](../../rule-engine/functions-link.md#getpropertylink) function for entity.
4896 | rule engine | Feature | Implement [`getPropertyTypes`](../../rule-engine/functions-property.md#getpropertytypes) function to return a list of property types for the entity.
4893 | UI | Feature | Statistics page: format metric and entity tags with associated templates.
4892 | rule engine | Feature | Extend [`excludeKeys`](../../rule-engine/functions-collection.md#excludekeys) function - add support for patterns.
4889 | rule engine | Bug | Web Notifications: round numbers.
4888 | rule engine | Bug | Email subject should not include inline links.
4887 | core | Bug | Temporary json file format.
4883 | rule engine | Bug | Window remains in OPEN status after all commands are removed.
4879 | rule engine | Feature | Add support for [orb-tags](../../rule-engine/control-flow.md) in email and web notifications.
4877 | rule engine | Bug | `entity_tags` expression fails if used without key.
4876 | rule engine | Feature | Add optional parameter to db_message to search by message.
4875 | rule engine | Feature | Add date filter to rule list.
4874 | rule engine | Feature | Add variables table in email notification.
4873 | rule engine | Feature | Implement [entity lookup](../../rule-engine/functions-lookup.md#getentity) function.
4872 | rule engine | Feature | Implement [`property_map`](../../rule-engine/functions-property.md#reference) function.
4871 | rule engine | Feature | Implement [`addTable`](../../rule-engine/functions-format.md#reference) function.
4870 | rule engine | Feature | Implement [entity link](../../rule-engine/links.md#entitylink) placeholders.
4869 | rule engine | Bug | Print empty string instead of `null` if placeholder evaluates to `null`.
4868 | message | Bug | Webhook: change parameter and field [precedence](../../api/data/messages/webhook.md#parameter-precedence).
4867 | api-rest | Bug | Data API: First period is out of selection interval with END_TIME aggregation.
4866 | sql | Bug | Incorrect `GROUP BY MONTH` with non-CALENDAR align.
4865 | rule engine | Bug | The `milliseconds` function fails if input is null.
4864 | rule engine | Bug | Change behavior of [text functions](../../rule-engine/functions-text.md#keepafter).
4863 | rule engine | Feature | Default value for [`lookup`](../../rule-engine/functions-lookup.md#lookup) function.
4861 | api-rest | Feature | Webhook: set [command time](../../api/data/messages/webhook.md#command-parameters) from (milli)seconds.
4858 | rule engine | Feature | Add [`unquote`](../../rule-engine/functions-text.md#unquote) function.
4857 | rule engine | Bug | Delete open alerts when entity is deleted.
4856 | rule engine | Bug | Random functions generate the same item in different consequent invocations.
4854 | rule engine | Feature | Implement new [math functions](../../rule-engine/functions-math.md#reference).
4853 | rule engine | Bug | Fix NPE while preparing details table.
4852 | rule engine | Bug | Rule window page shows broken record for property window.
4851 | rule engine | Feature | Implement [freemarker-style text functions](../../rule-engine/functions-text.md#reference).
4850 | rule editor | Bug | Allow to skip evaluating some functions on rule save.
4849 | rule engine | Bug | Error in time format functions.
4848 | UI | Bug | Export page: FreeMarker error for forecast export.
4846 | rule engine | Feature | Web notifications: add status columns.
4845 | forecast | Bug | Forecast settings: tooltips disappeared.
4844 | data-in | Support | Add instruction to configure an outgoing webhook for [Slack](../../rule-engine/notifications/outgoing-webhook-slack.md) and [Telegram](../../rule-engine/notifications/outgoing-webhook-telegram.md).
4838 | portal | Bug | Rule portal: series label not resolved and last value not correct.
4833 | rule engine | Feature | Implement Web Notifications for [Microsoft Azure](../../rule-engine/notifications/azure-sb.md).
4832 | rule engine | Feature | Implement Web Notifications for [Google Cloud Platform](../../rule-engine/notifications/gcp-ps.md).
4827 | UI | Feature | UI: Send commands by Ctrl+Enter.
4826 | rule engine | Bug | API request hangs while rule is being processed.
4823 | rule editor | Feature | Rule Editor refactoring.
4822 | sql | Bug | Incorrect selection interval inference from filter conditions.
4821 | sql | Feature | Overlapping error for non-overlapping intervals.
4820 | api-rest | Bug | Data API: time series query with grouping - not correct result of min_value_time aggregation.
4789 | UI | Bug | Data Entry page command templates.
4786 | entity | Feature | Tag Template: auto-generate from actual tags.
4777 | api-rest | Bug | Data API series query: empty response instead of expected series (tag filters error).
4768 | api-rest | Bug | Data API, series query: If query has series limit then unwanted empty series could occur in response.
4746 | api-rest | Feature | Data API: add [`order`](../../api/data/series/rate.md#parameters) field to "rate" function.
4729 | api-rest | Bug | Data API: series query - aggregate and group order and period.
4727 | jdbc | Bug | JDBC driver: FileNotFoundException on log4j.
4700 | sql | Bug | Incorrect GROUP BY PERIOD END_TIME with DST change inside period.
4660 | statistics | Feature | DAO: calculate only requested statistics.
3573 | security | Feature | SSL: upgrade cypher protocols.
2870 | api-rest | Bug | REST API - authentication errors - check 403 status and json format in responses.
2709 | rule engine | Feature | Messages: one-click to create rule from message.
2086 | rule editor | Bug | Rule "Test" not working for messages.

## Collector

Issue| Category    | Type    | Subject              
-----|-------------|---------|----------------------
4928 | kafka | Bug | Exception in kafka job with `message format=API` command.
4924 | core | Bug | Disk usage is abnormal.
4895 | core | Bug | Delete temporary files.