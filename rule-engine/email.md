# Email Action

Email action delivers messages to subscribers based on [window](window.md) status events.

You can program the messages to be sent only once, at a pre-determined frequency, or when the underlying condition is cancelled.

The **Minimum Notification Interval** provides a protection against accidental email storms.

## Email Client

Messages are sent by the built-in [mail client](../administration/mail-client.md) which is configured on the **Settings > Configuration > Mail Client** page.

The optional [header and footer](../administration/mail-client.md#header-and-footer) text specified at the mail client level applies to all outgoing messages.

```html
<p style="color: #8db600;">--- Classification: UNCLASSIFIED ---</p>
```

![](./images/email-footer.png)

## Enable Notifications

Open the **Email Notifications** tab in the Rule Editor.

![](./images/email-tab-rule.png)

Set `Enabled` status and enter one or more email addresses.

Set toggle to **Yes** to subscribe to notifications initiated by `OPEN`, `REPEAT`, or `CANCEL` triggers.

![](./images/email_config_all.png)

For repeat notifications, adjust the notification frequency using **Repeat Interval**, for example every **6 hours** or every **10 events**.

If necessary, clear the **Same as On Open** checkbox to configure message content independently.

### Notification Settings

| Name | Description |
| --- | --- |
| Enabled | Enable or disable email delivery. |
| Name | User-defined email configuration name.<br>Each rule can have multiple independently executed configurations. |
| Recipients | One or more email [subscriber](#subscribers) addresses. |
| Priority | Message priority to classify messages in commonly used email clients: `Low`, `Normal`, `High`. |
| Merge Messages | Merge multiple notifications from different rules into one email message **for the same subscriber** to reduce the number of email messages from arriving within a short time span.<br>The subject line of merged messages is generated automatically and contains rule names, metric names, and the total number of merged notifications in the given message. <br>For example: `Alerts(2)-cpu_busy: statistical-time, nmon_cpu`. |
| Minimum Notification Interval | Minimum interval between messages to prevent excessive email messages generated by a rule.<br>The rule engine discards messages that are generated by the rule before the specified interval from the last sent message expires. |

## Subscribers

### Email Address

```txt
Recipients = user@example.org
```

### Email Address List

Multiple addresses can be separated by comma, semi-colon, or whitespace.

```txt
Recipients = user@example.org, test@example.org
```

> All addresses are included in the `To:` field. Sending messages to `Cc:` or `Bcc:` fields is not supported.

### Group Members

The `get_group_emails` function retrieves the list of email addresses of active (non-locked) members of the specified user group.

```csharp
Recipients = ${get_group_emails('DevOps')}
```

If the group does not exist or contains no members with emails, the message delivery is cancelled.

### Topic Watchers

The `subscribers` function retrieves the list of users who have subscribed to the specified topic on their personal user account pages.

```csharp
Recipients = ${subscribers('docker')}
```

![](./images/user-topics.png)

The list of topics is managed by an administrator as a replacement table at `https://atsd:8443/replacement-tables/%24topics`.

![](./images/topic-list.png)

Multiple topic names can be enumerated to deliver the message to subscribers of multiple topics.

```csharp
Recipients = ${subscribers('docker', 'audit')}
```

### Lookup Address

The following example retrieves the address from the specified tag of the entity for which the alert is raised, to dynamically determine the subscriber based on alert fields.

```csharp
Recipients = ${entity.tags.owner}
```

Similar results can be achieved by mapping alert fields to subscribers in a replacement table which can be accessed with the [`lookup`](functions-lookup.md#lookup) function.

```csharp
Recipients = ${lookup('on-call', tags.site)}
```

If the expression evaluates to an empty string, the email delivery is cancelled. To deliver the message to a fall-back address, apply the `ifEmpty` check.

```csharp
Recipients = ${ifEmpty(entity.tags.owner, 'user@example.org')}
```

In the above example, if the tag `owner` is not set for the given entity, the message is sent to `user@example.org` by default.

### Conditional Address

To customize the delivery address based on alert field, use the [branching](control-flow.md#branching).

```csharp
@if{tags.site == 'SVL'}
  user@example.org
@end{}
```

## Conditional Delivery

The [branching](control-flow.md#branching) syntax in the **Recipients** or **Text** fields can be utilized to cancel the message delivery if certain conditions are met, for example to disable delivery during non-working hours.

```javascript
@if{NOT now.timeOfDay BETWEEN '08:00' AND '20:00'}
${cancelAction()}
@end{}
```

## Message Content

The email message consists of **Subject** and **Text** parts.

Both fields can include any text as well as [placeholders](placeholders.md) to customize outgoing messages based on alert details.

```bash
Warning! Rule ${rule} for server ${entity} is active.
```

[Placeholders](placeholders.md), escaped with `$` and wrapped in curly brackets `${expression}`, are evaluated and replaced with actual values when the notification is sent.

```bash
Warning! Rule JVM Memory Low for server nurswgvml007 is active.
```

### Subject Field

The **Subject** field can include plain text, HTML [entity characters](https://dev.w3.org/html5/html-author/charref), and emoji. HTML markup is **not** supported.

![](./images/email-subject.png)

Note that subjects which exceed the `78` character limit according to [RFC 2822](https://www.ietf.org/rfc/rfc2822.txt), Section `2.1.1` are truncated or rejected by mail servers. The actual limit is typically higher, but is implementation-specific.

If placeholders in the subject potentially evaluate to long strings, apply [`truncate`](functions-text.md#truncate) or [`abbreviate`](functions-text.md#abbreviate) functions to ensure that the subject length remains within the limit.

```bash
${entity} received message '${abbreviate(tags.notification, 50)}'
```

### Text Field

The **Text** field can include any text including emoji and HTML [entity characters](https://dev.w3.org/html5/html-author/charref) as well as [placeholders](placeholders.md).

Unlike the **Subject** field, **Text** is not constrained by a length limit and supports HTML markup.

```bash
Database Error.
Code: <b>${tags.code}</b>
<pre>
${message}
</pre>
```

Message text can include output of scripts, SQL queries, and API calls formatted as HTML tables.

```bash
Top-10 running containers by CPU:
${addTable(executeSqlQuery(query), 'html', true)}
```

In addition, the **Text** field can invoke [attachment](functions-portal.md#portal-functions) functions to include portal screenshots as inline images or CSV files as attachments.

```bash
${addPortal('AWS Route53 Health Check Detail', aws_entity)}
```

The **Text** field supports [control flow](control-flow.md#control-flow) syntax which supports the customization of content based on alert details.

```bash
@if{tags.payload.type != 'cron'}
    ${detailsTable('html')}
@end{}
```

## Trigger Settings

| Setting | Description |
| --- | --- |
| Delay on Open | Delay interval for sending notification for `OPEN` status.<br>If the window changes to `CANCEL` status within the specified delay interval, no `OPEN` status email is sent.<br>Set this interval to prevent emails on momentary spikes. |
| Repeat Interval | Interval for sending `REPEAT` status notifications.<br>If **Repeat Interval** is set in time units, the exact interval can vary because the `REPEAT` notifications are triggered by incoming data.<br>In particular, `REPEAT` notifications are not sent if the incoming data flow ceases. |
| Subject | Custom subject text, specified for each status separately.<br>The subject can include placeholders with built-in fields, functions, and expressions, for example: `${round(avg())}`. <br>Note that the maximum allowed length of the subject is limited to several hundred characters in most email clients.|
| Text | Custom message text, specified for each status separately.<br>The text can include placeholders with built-in fields, functions, and expressions, for example: `${round(avg())}`. |
| Attach Details | Include a [summary table](window-fields.md#detail-tables) with window statistics and action links. |
| Attach Portals | One or more portal screenshots attached to the message as inline images.<br>If a portal is a template, placeholders such as entity, metric, tags are resolved from the window fields.<br> **Series Chart**: attach a screenshot containing series monitored by this rule. |

## Grouping

Incoming data is [grouped](grouping.md) into windows by metric, entity, and command tags with each window generating emails separately from the others.

![](./images/email-group-settings.png)

If a rule creates excessive windows, restrict the rule [filter](filters.md) or add [`Override`](overrides.md) exceptions that disable alerting for a particular series.

![](./images/email-group-tags.png)

The override table below contains rules that always return `false` for the matching series since the value cannot exceed `100%`.

![](./images/email-override-group.png)

## Message Composition

* Subject
* Content
  * Header
  * Text
  * Detail Table
    * Entity tags
    * Alert fields
    * Command/Event tags
    * User variables
  * Portal Screenshots (inline images in `png` format)
  * Footer
  * Attachments
    * Files (CSV, Excel, PDF, etc)

![](./images/email-message-composition-1.png)

![](./images/email-message-composition-4.png)

### Subject

The subject can include [placeholders](placeholders.md) with fields and expressions which are replaced by actual values when the message is sent. If a placeholder is not found, the placeholder is replaced with an empty string.

**Sample subject**:

```bash
[${status}] Rule ${rule} for ${entity} ${tags}
```

When using placeholders that can be replaced with text of arbitrary length, apply the [`truncate`](functions-text.md#truncate) or [`abbreviate`](functions-text.md#abbreviate) functions to limit the subject length.

```bash
[${status}] Rule ${rule} for ${entity}: ${truncate(tags.error, 100)}
```

### Text

The message body can include [placeholders](placeholders.md).

Use the HTML tag `<br>` to split content into multiple lines.

```bash
Start Time: ${windowStartTime}<br>
Duration: ${(timestamp / 1000 - windowStartTime) * 1000} ms
```

Placeholders with [link](links.md) fields are automatically inlined.

Message text can include [control flow](control-flow.md) statements for conditional processing.

```bash
[${upper(tags.status)}] ${entityLink} Ω ${getEntityLink(tags.docker-host)}
<span style='color: orange'>${marker}</span>
@if{is_launch}
  ${addTable(entity.tags, 'html')}
@end{}
```

### Header and Footer

A [header and footer](../administration/mail-client.md#header-and-footer) can be specified in both plaintext and HTML format in Email Client Settings and applied to all messages.

Header and footer do **not** support any placeholders.

```html
<p style="color: #8db600; font-weight: bold; margin: 0px; padding: 0px;">Classification: UNCLASSIFIED</p>
```

```html
<p style="color: #8db600;">END of MESSAGE</p>
```

![](./images/email-header.png)

### Details Table

The details table is optional and is formatted with styles for enhanced readability in commonly used email client software.

![](./images/email-attach-details.png)

Each table includes multiple parts which are compiled depending on the alert context.

Below the table, links are provided to view extended alert information, open charts, and export underlying data.

![](./images/email-detail-table-bottom.png)

Decimal numbers are rounded to five significant digits for readability.

### Portals

:::tip Web Driver
To attach screenshots, a [web driver](notifications/web-driver.md) must be installed and configured on the ATSD server.
:::

To attach a screenshot of the default portal for the given metric, entity and tags, enable **Series Chart**.

![](./images/email-screenshot-enable.png)

Charts can include multiple series depending on statistical functions referenced in the condition.

```javascript
abs(forecast_deviation(median())) > 2 && (median() < 200 || median() > 600)
```

![](./images/email-screenshot-series.png)

If a rule correlates multiple metrics using [database functions](functions-series.md) or [rules functions](functions-rules.md) these metrics are included in the screenshot on the right axis.

```javascript
avg() > 10 && db_last('memfree') < 500000
```

![](./images/email-screenshot-correlate.png)

To attach additional portals, select them from the **Additional Portal** drop-down list.

![](./images/email-screenshot-portals.png)

If the additional portal is a [template](../portals/portals-overview.md#template-portals) portal, placeholders such as entity, metric, tags are set based on the current window fields.

## Monitoring

Monitor the number of messages sent per minute with the [`email_notifications_per_minute`](../administration/monitoring.md#rule-engine) metric collected by ATSD.

```elm
https://atsd_hostname:8443/portals/series?entity=atsd&metric=email_notifications_per_minute
```

![](../administration/images/monitor-email.png)
