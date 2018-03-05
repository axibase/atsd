Monthly Change Log: February 2018
==================================================

## ATSD

Issue| Category    | Type    | Subject              
-----|-------------|---------|----------------------
5047 | rule engine | Bug | CANCEL window doesn't display user variables.
5044 | security | Feature | User permissions page: add group-level details.
5041 | rule engine | Bug | Telegram doesn't support `<br>` when parse_mode is to `html`.
5040 | rule engine | Bug | Entity-ungrouped rule windows are missing.
5039 | rule engine | Feature | [Convert function](../../rule-engine/functions-format.md#convert) unit processing, [`formatBytes`](../../rule-engine/functions-format.md#formatbytes) function.
5036 | admin | Feature | Backup multiple record types from archive.
5034 | data-in | Feature | Internal [timer metrics](../../rule-engine/window.md#timers).
5033 | rule engine | Bug | [`db_statistic`](../../rule-engine/functions-db.md#db_statistic) function use current time during Test.
5030 | rule engine | Bug | Telegram timeouts.
5028 | rule engine | Bug | Illegal entity name (an empty string) while save alert messages.
5025 | rule engine | Bug | Alert_duration value.
5024 | rule engine | Feature | Wildcard in key section of the [property search](../../rule-engine/property-search.md#property-search-syntax) expression.
5022 | export | Bug | Entity View: export to XML.
5021 | sql | Bug | `LAST(datetime)` displays UNIX time.
5017 | rule engine | Bug | Display window details even if window is in CANCEL status.
5015 | rule engine | Bug | Quote escaping with backslash.
5014 | rule engine | Bug | HipChat notification: inline links in portal description message.
5013 | rule engine | Bug | System command execution error should create Rule Error entry.
5012 | entity_views | Bug | 'Entity Tag' link not applied to 'Entity Tag' column.
5011 | rule editor | Bug | Table cells on Test tab missing.
5009 | entity_views | Bug | Allow blank if default values is blank in dictionary columns.
5008 | data-in | Support | [collectd](../../integration/collectd/README.md#collectd): installation and configuration.
5005 | entity_views | Bug | Add on Save validation and display error message at runtime.
5004 | rule engine | Bug | Default values for exposed web notification parameters are ignored.
5003 | rule engine | Support | Modify telegram webhook processor to handle edited messages.
5002 | rule engine | Bug | Disable notification for related messages in Telegram.
5000 | sql | Feature | Add rule name to SQL statistics.
4995 | rule engine | Feature | Add page listing rules for endpoint.
4994 | rule engine | Bug | Markdown entities need proper escaping in Telegram configurations.
4992 | UI | Bug | UI: part of the main menu is not visible.
4991 | installation | Support | scollector validation.
4988 | rule engine | Feature | Implement [`addPortal`](../../rule-engine/functions-portal.md#portal-functions) function for collection of entities.
4985 | rule engine | Bug | Variables containing lower-cased SQL alias expressions are filtered out after saving.
4981 | sql | Feature | HTML format in scheduled SQL.
4979 | entity_views | Feature | Metrics column tooltip.
4976 | data-in | Support | [tcollector](../../integration/tcollector#tcollector) installation update.
4973 | rule editor | Bug | Append [Disabled] suffix to web config name if it had been attached to notification and then disabled.
4972 | export | Bug | Export Query: Add support for date placeholders in Email Subject field.
4971 | entity_views | Bug | Apply metrics column formatting if 'Last Insert Date' for the specified metric is not available.
4970 | UI | Bug | UI: Search page expression causes browser to freeze.
4969 | entity_views | Bug | Changes cause new EVs to be created on database restart.
4968 | entity_views | Bug | Entries are deleted after saving.
4967 | statistics | Bug | Series Statistics: (wrong) statistics for several series calculated, instead single series statistics.
4966 | rule engine | Bug | Make property search case-insensitive.
4965 | rule engine | Bug | Implement [`toBoolean`](../../rule-engine/functions-utility.md#toboolean) function.
4963 | entity_views | Feature | Add support for [text functions](../../configuration/entity_views.md#text-functions) from rule engine.
4961 | entity_views | Feature | Metrics column [formatting](../../configuration/entity_views.md#formatting-functions).
4959 | UI | Feature | Tag Templates: Index and default order.
4956 | rule engine | Bug | The error continues to display after delete a rule.
4955 | rule engine | Bug | [`addTable`](../../rule-engine/functions-format.md#reference) function to return any object as table.
4954 | rule engine | Bug | Disallow non-boolean conditions.
4948 | rule engine | Bug | [Statistical functions](../../rule-engine/functions-statistical.md#overview) in filter expression.
4947 | sql | Bug | Incorrect LIMIT applied.
4942 | rule engine | Bug | Fix markdown entities escaping in Telegram.
4941 | entity_views | Feature | Add link to multi-entity portal to sub-groups.
4938 | rule engine | Bug | Filter expression.
4936 | rule engine | Bug | Implement function [`getEntities`](../../rule-engine/functions-lookup.md#getentities) and [`getEntityCount`](../../rule-engine/functions-lookup.md#getentitycount).
4930 | documentation | Bug | Window duration definition.
4918 | api-rest | Bug | Data API: webhook hangs if.
4907 | statistics | Feature | Create rule from statistics page.
4906 | rule editor | Feature | Move detailed error from title into a dialog.
4904 | rule editor | Feature | Inherit notification settings from 'On Open' trigger.
4902 | rule engine | Feature | Refactor text functions to accept primary input as object instead of string.
4890 | rule engine | Feature | Implement [security functions](../../rule-engine/functions-security.md#security-functions).
4886 | UI | Feature | UI: Multiple Enhancements.
4884 | rule engine | Bug | Some functions cannot be used on Overview tab.
4882 | rule engine | Feature | Referencing dependent [variables in condition](../../rule-engine/variables.md#references).
4878 | rule engine | Feature | Add optional parameters to [`rule_open`](../../rule-engine/functions-rules.md#rule_open) and [`rule_window`](../../rule-engine/functions-rules.md#rule_window) for more precise matching.
4862 | admin | Bug | Logging: change level from ERROR to WARN for user-invoked errors.
4842 | rule editor | Bug | Rule Editor: Test is not working.
4837 | rule engine | Bug | Notifications: Telegram doesn't resolve local URLs.
4836 | api-rest | Bug | Data API: multiple interpolate queries for the same series.
4835 | api-rest | Bug | Data API: limit on series interpolate query.
4828 | rule engine | Feature | [Attach portal](../../rule-engine/web-notifications.md#attachments) to notification.
4818 | rule engine | Feature | Implement [`scriptOut`](../../rule-engine/functions-script.md#script-functions) function to return stdout of a bash or python script.
4800 | rule engine | Feature | Notifications: editable [Details Table](../../rule-engine/web-notifications.md#attachments) format.
4657 | client | Feature | Refactor Python examples.
4984 | UI | Feature | Entity View: [Split table by column](../../configuration/entity_views.md#split-table-by-column) values.

## Collector

Issue| Category    | Type    | Subject              
-----|-------------|---------|----------------------
5060 | json | Bug | JSON: npe in Test.
5052 | docker | Bug | Docker: docker.fs.total.size.rw collection irregularity.
5043 | core | Bug | Collector CPU is abnormally high.
5037 | jmx | Feature | Add possibility to access column by name in Item List.
5035 | jmx | Feature | Add "show password" button in configuration.
5027 | jmx | Feature | Ignore beans based on client expression.
5026 | jmx | Feature | Execute configuration against multiple remote server.
5016 | jmx | Feature | Change behavior of Series Tags field.
4998 | docker | Bug | Invalid CPU percentage value.
4997 | admin | Support | Set XmX in collector containers launched with Docker job to 256.
4986 | kafka | Bug | Kafka consumer: delete.
4978 | jmx | Bug | Malformed commands.


