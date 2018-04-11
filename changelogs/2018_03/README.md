Monthly Change Log: March 2018
==================================================

## ATSD

**Issue**| **Category**    | **Type**    | **Subject**              
-----|-------------|---------|----------------------
5170 | forecast | Bug | NPE in [forecast](../../forecasting#data-forecasting) settings.
5169 | export | Bug | [Scheduled Query](../../reporting/scheduled-exporting.md#scheduled-exporting): Tmp files not deleted if Store enabled and no other output specified.
5165 | entity_views | Bug | Grouping column error if [view](../../configuration/entity_views.md#entity-views) is empty.
5164 | [log_aggregator](https://github.com/axibase/aggregation-log-filter) | Bug | Replace sun.misc.BASE64Encoder.
5161 | export | Bug | Refer to portal by name instead of ID for [entity groups](../../configuration/entity_groups.md#entity-groups).
5159 | sql | Feature | Add name, author and description placeholders in [scheduled SQL](../../sql/scheduled-sql.md#sql-scheduler) queries.
5155 | export | Bug | [Scheduled Query](../../reporting/scheduled-exporting.md#scheduled-exporting): NPE on commands store.
5153 | rule engine | Bug | [Rule Engine](../../rule-engine): Generic type is not resolved for TagsMap.
5151 | core | Feature | Add User-Agent header in [outgoing](../../rule-engine/web-notifications.md#web-notifications) http requests.
5150 | sql | Feature | Implement short ISO formats for [datetime](../../sql/README.md#interval-condition) literal.
5146 | security | Bug | Rename built-in collector [groups](../../administration/user-authorization.md#collector-user).
5144 | rule engine | Bug | [`entity_label`](../../rule-engine/functions-lookup.md#entity_label) function.
5142 | rule editor | Bug | Check [placeholder](../../rule-engine/placeholders.md#placeholders) syntax for validity on save.
5139 | sql | Bug | SQL: Сolumn name [sensitivity](../../sql#case-sensitivity) in subqueries.
5132 | security | Bug | Disable [collector account](../../administration/collector-account.md#collector-account) creation without admin rights.
5130 | [entity_views](../../configuration/entity_views.md#entity-views) | Bug | Import doesn't display warnings if group is not found.
5128 | security | Feature | Add page for password [obfuscation](../../administration/passwords-obfuscation.md#password-obfuscation).
5127 | security | Bug | NPE in [account](../../administration/user-authentication.md#built-in-account) exist checks.
5125 | UI | Feature | [Webhook Request Page](../../api/data/messages/webhook.md#diagnostics): view payload, parameters and headers.
5124 | rule editor | Bug | Fix slow rendering if the [rule](../../rule-engine#concepts) has web notifications.
5122 | security | Feature | Add wizards for creating [collector](../../administration/user-authorization.md#collector-user) and [webhook](../../api/data/messages/webhook.md#webhook-user-wizard) users.
5120 | api-rest | Feature | [Webhook API](../../api/data/messages/webhook.md#messages-webhook): auto-subscribe to [AWS notifications](../../api/data/messages/webhook.md#amazon-ws).
5117 | rule engine | Bug | [db_message](../../rule-engine/functions-db.md#database-functions) functions: do not throw an exception if type or source not found.
5116 | rule engine | Bug |[`db_message_count`](../../rule-engine/functions-db.md#db_message_count) function returns different results.
5115 | rule engine | Feature | [`rule_window`](../../rule-engine/functions-rules.md#rule_window) fields.
5113 | security | Bug | New [user group](../../administration/user-authorization.md#portal-permissions) is allowed to view all portals by default.
5107 | sql | Feature | Join using subqueries - support for [ON](../../sql#join-syntax) condition.
5105 | [entity_views](../../configuration/entity_views.md#entity-views) | Bug | Do not display column value if related entity tag value is not set.
5104 | sql | Feature | [Scheduled](../../sql/scheduled-sql.md#sql-scheduler) report error on missing raw data.
5103 | monitoring | Bug | Simon console doesn't work.
5098 | sql | Bug | Fix NPE in outer join with extra tag in one of the [subqueries](../../sql#inline-views).
5096 | sql | Bug | Fix NPE in outer [join](../../sql#joins).
5093 | rule engine | Bug | Resolve generic type parameter of returned collections by [property](../../rule-engine/functions-property.md#property-functions) functions.
5090 | rule engine | Bug | Access to [collection](../../rule-engine/functions-collection.md#collection-functions) objects.
5081 | UI | Bug | Selected [entity group](../../configuration/entity_groups.md#entity-groups) is not remembered.
5078 | installation | Bug | [Installation](../../installation#installation): apply nohup to default startup scripts.
5070 | sql | Feature | [Inline queries](../../sql#inline-views): remove time/datetime column requirement.
5067 | rule engine | Bug | [`getEntityLink`](../../rule-engine/functions-link.md#getentitylink) function raises NPE on empty entity.
5066 | rule engine | Bug | [AWS API](../../rule-engine/web-notifications.md#integration-services): Fix test mode for configuration.
5065 | rule engine | Feature | [Web Notifications](../../rule-engine/web-notifications.md#web-notifications): Add type, toggle fields.
5063 | export | Bug | [Tag filter](../../reporting/ad-hoc-exporting.md#ad-hoc-exporting) with wildcard allows any tag values.
5055 | csv | Bug | Incorrect version fields are stored from [uploaded](../../parsers/csv#uploading-csv-files-into-axibase-time-series-database) .csv file.
5051 | export | Bug | [Scheduled Query](../../reporting/scheduled-exporting.md#scheduled-exporting): Output Path collision.
5049 | api-rest | Bug | Data API: slow search by property in [entityExpression](../../api/data/filter-entity.md#entity-filter-fields).
5036 | admin | Feature | Backup multiple record types from zip/tar.gz archive.
5018 | rule engine | Bug | Web Notifications: raw url presence breaks markdown format in [Telegram](../../rule-engine/notifications/telegram.md#telegram-notifications).
5012 | [entity_views](../../configuration/entity_views.md#entity-views) | Bug | 'Entity Tag' link not applied to 'Entity Tag' column.
5001 | rule engine | Feature | Telegram: [getUpdates](../../rule-engine/notifications/telegram.md#reacting-to-bot-messages) message retriever as an alternative to webhook.
4957 | sql | Bug | [Period](../../sql#period) query now takes long time to execute.
4925 | rule engine | Feature | Rule Engine: [rule_window](../../rule-engine/functions-rules.md#rule_window) function.
4909 | security | Support | Install DV SSL certificate from Lets Encrypt CA.
4667 | export | Bug | Incorrect [export](../../reporting/ad-hoc-exporting.md) of versioned values.
2158 | rule engine | Feature | [Load historical](../../rule-engine/window.md#initial-status) data on window start.

## Collector

**Issue**| **Category**    | **Type**    | **Subject**             
-----|-------------|---------|----------------------
5141 | [jdbc](https://github.com/axibase/axibase-collector/blob/master/jobs/jdbc.md#jdbc-job) | Support | Timestamp format error in JDBC job.
5140 | UI | Bug | Empty page on opening simon console.
5114 | core | Bug | Collector CPU is abnormally high.
5099 | [aws](https://github.com/axibase/axibase-collector/blob/master/jobs/aws.md#aws-job) | Bug | Entity create error.
5089 | UI | Bug | Add 'Execution Time' column to [job](https://github.com/axibase/axibase-collector/tree/master/jobs#jobs) list.
5084 | [aws](https://github.com/axibase/axibase-collector/blob/master/jobs/aws.md#aws-job) | Bug | Job without pool is hanging.
5079 | [json](https://github.com/axibase/axibase-collector/blob/master/jobs/json.md#json-job) | Bug | Not all commands arrive in ATSD.
5074 | [aws](https://github.com/axibase/axibase-collector/blob/master/jobs/aws.md#aws-job) | Bug | Cloud front metrics not collected.
5071 | [aws](https://github.com/axibase/axibase-collector/blob/master/jobs/aws.md#aws-job) | Bug | 403 error caused by pagination.
5069 | [jmx](https://github.com/axibase/axibase-collector/blob/master/jobs/jmx.md#jmx-job) | Bug | Non-existing attributes in log.
5062 | [aws](https://github.com/axibase/axibase-collector/blob/master/jobs/aws.md#aws-job) | Bug | AWS region issues.
5056 | [docker](https://github.com/axibase/axibase-collector/blob/master/jobs/docker.md#docker-job) | Feature | Extract Apache Mesos container labels.
