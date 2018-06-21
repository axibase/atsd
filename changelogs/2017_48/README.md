# Weekly Change Log: November 27, 2017 - December 3, 2017

## ATSD

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
| 4774 | rule engine | Bug | Invalid URL validation error for `.site` domain. |
| 4769 | rule engine | Bug | Rule does not update when the linked webhook changes. |
| 4767 | rule engine | Bug | [`CUSTOM`](../../rule-engine/notifications/custom.md) webhook: timeout waiting for connection from pool. |
| 4764 | rule engine | Bug | Do not show entity information in entity non-grouped alert details. |
| 4762 | rule engine | Feature | Simplify [`DISCORD`](../../rule-engine/notifications/discord.md) webhook configuration. |
| 4761 | rule editor | Bug | 'Add override' link not creating a row in the [Overrides](../../rule-engine/overrides.md) table. |
| 4760 | api-rest | Bug | [`series query`](../../api/data/series/query.md) method: entity expression error when using `name` field. |
| 4759 | rule editor | Bug | Buttons disappear when the rule configuration contains errors. |
| 4758 | rule editor | Bug | Error when saving webhook using http protocol. |
| 4756 | api-rest | Bug | Data API: Minimum date for [`series query`](../../api/data/series/query.md) with `FORECAST` type. |
| [4755](#issue-4755) | rule engine | Feature | Implement `db_message` functions for correlation. |
| 4744 | rule engine | Bug | Add chart link to webhook message if chart error is raised. |
| 4725 | api-rest | Bug | Processing error in [`series query`](../../api/data/series/query.md) method with `END_TIME` alignment. |
| 4713 | api-rest | Bug | [`series query`](../../api/data/series/query.md) with `FORECAST` type ignores `addMeta` parameter. |

## Axibase Collector

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
| 4742 | docker | Bug | Add `atsd-url` parameter validation.  |
| 4552 | json | Feature | JSON job: add support for thousand items and more. |

---

### Issue 4755

The `db_message_count` and `db_message_last` functions allow one to correlate different types of data - time series and messages.

#### [`db_message_count`](../../rule-engine/functions-message.md#db_message_count) Function

* Calculate the number of messages matching the specified parameters.

```java
  db_message_count(S interval, S type, S source [, S tags, [S entity]])
```

> `tags` and `entity` arguments are optional.
> If the `type`, `source`, or `tags` fields are set to empty string, they are ignored when matching messages.
> If the `entity` is not specified, the request retrieves messages for the current entity.

  Example:

```java
  // Check if the average exceeds 20 and the 'compaction' message was not received within the last hour for the current entity.
  avg() > 20 && db_message_count('1 hour', 'compaction', '') == 0
```

```java
  // Check if the average exceeds 80 and there is an event with type=backup-error received within the last 15 minutes for entity 'nurswgvml006'.
  avg() > 80 && db_message_count('15 minute', 'backup-error', '', '', 'nurswgvml006') > 0
```

#### [`db_message_last`](../../rule-engine/functions-message.md#db_message_last) Function

* Returns the most recent [message](../../api/data/messages/query.md#fields-1) object matching the specified parameters.

```java
db_message_last(S interval, S type, S source[, S tags, [S entity]])
```

> `tags` and `entity` arguments are optional.
> If the `type`, `source`, or `tags` fields are set to empty string, they are ignored when matching messages.
> If the `entity` is not specified, the request retrieves messages for the current entity.

The returned object contains `type`, `source`, and `tags.{name}` fields of string type and the `date` field of long data type. The `date` field is returned as Unix milliseconds.

  Example:

```java
  last_msg = db_message_last('60 minute', 'logger', '')
  // Check that the average exceeds 50 and the severity of the last message with type 'logger' for the current entity is greater or equal `ERROR`.
  value > 50 && last_msg != null && last_msg.severity.toString() >= "6"
```
