# Web Notifications

## Overview

Web notifications provide a mechanism for event-driven integration of the database with external HTTP services.

They can be used to automate tasks such as sending an alert into a Slack channel, updating a bug tracker, starting a CI build, publishing to an AWS SNS topic, or controlling IoT devices.

Example: [Slack](notifications/slack.md) Alert

![](images/slack-alert.png)

## Notification Types

The rule engine supports both built-in and custom web notification types.

### Collaboration Services

The built-in notification types for chat and collaboration services deliver alert messages and contextual charts to a channel or group.

| Type | Send Message | Send Chart | Integration Model | Hosting Model |
| --- | --- | --- | --- | --- |
| [SLACK](notifications/slack.md) | Yes | Yes | [Slack Bot API](https://api.slack.com/bot-users) | Cloud |
| [TELEGRAM](notifications/telegram.md) | Yes | Yes | [Telegram Bot API](https://core.telegram.org/bots/api) | Cloud |
| [DISCORD](notifications/discord.md) | Yes | Yes | [Discord API](https://discordapp.com/developers/docs/intro) | Cloud |
| [HIPCHAT](notifications/hipchat.md) | Yes | Yes | [HipChat Data Center API](https://www.hipchat.com/docs/apiv2/) | Self-hosted |

### Integration Services

| Type | Customizable Fields | Description |
| --- | --- | --- |
| [AWS-API](notifications/aws-api.md) | All | Integrate with [AWS](https://aws.amazon.com). |
| [AWS-SNS](notifications/aws-sns.md) | Topic, Message and Subject | Publish a message to an [AWS SNS](https://aws.amazon.com/sns/?p=tile) topic. |
| [AWS-SQS](notifications/aws-sqs.md) | Queue and Message| Send a message to an [AWS SQS](https://aws.amazon.com/sqs/?p=tile) queue. |
| [AZURE-SB](notifications/azure-sb.md) | Queue/Topic and Message | Send a message to an [Azure Service Bus](https://docs.microsoft.com/en-us/azure/service-bus-messaging) |
| [GCP-PS](notifications/gcp-ps.md) | Topic and Message | Send a message to a [Google Cloud Pub/Sub](https://cloud.google.com/pubsub) topic. |
| [WEBHOOK](notifications/webhook.md) | None | Send pre-defined fields as a JSON document or form to an HTTP endpoint. |
| [CUSTOM](notifications/custom.md) | All | Send any JSON content or form parameters to an HTTP endpoint. Examples: [pagerduty](notifications/custom-pagerduty.md), [zendesk](notifications/custom-zendesk.md), [github](notifications/custom-github.md), [circleci](notifications/custom-circleci.md), [jenkins](notifications/custom-jenkins.md), [ifttt](notifications/custom-ifttt.md)|

## Window Status

Notifications are triggered on window status events.

A [window](window.md) is an in-memory object created by the rule engine for each unique combination of metric, entity, and tags extracted from incoming commands.

As the new data is received and old data is removed from the window, the rule engine re-evaluates the condition which can cause the status of the current window to change, triggering a notification.

### Initial Status

New windows are created based on incoming data and no historical data is loaded from the database.

The window for the given metric/entity/tags is created only when the first command for this series is received by the rule engine.

The new windows are assigned initial status of `CANCEL` which is then updated based on results of the condition (`true` or `false`).

### Window Lifecycle

All windows for the current rule are deleted from memory if the rule is deleted or modified and saved in the editor.

### Triggers

The web notification can be triggered whenever the window changes its status as well as at scheduled intervals while the status is `REPEAT`.

### Status Events

| Previous Status | New Status | Previous Condition Value | New Condition Value | Trigger Supported |
| --- | --- | --- | --- | --- |
| `CANCEL` | `OPEN` | `false` | `true` | Yes |
| `OPEN`  | `REPEAT` | `true` | `true` | Yes |
| `REPEAT` | `REPEAT` | `true` | `true` | Yes |
| `OPEN` | `CANCEL` | `true` | `false` | Yes |
| `REPEAT` | `CANCEL` | `true` | `false` | Yes |
| `CANCEL` | `CANCEL` | `false` | `false` | No |

### `OPEN` Status

The `OPEN` status is assigned to the window when the condition changes value from `false` to `true`.

### `REPEAT` State

The `REPEAT` status is assigned to an `OPEN` window when the condition returns `true` based on the second received command.

While the window is in `REPEAT` status, a notification can be sent with the frequency specified in the rule editor.

### `CANCEL` State

`CANCEL` is the initial status assigned to new windows. It is also assigned to the window when the the condition changes from `true` to `false` or when the window is deleted on rule modification.

Triggering a repeat notification in `CANCEL` status is not supported. Such behavior can be emulated by creating a separate rule with a negated expression which returns `true` instead of `false` for the same condition.

## Payload

The payload is determined by the notification type. Typically the payload is text content in the form of a JSON document or form fields. Some built-in notification types support sending chart screenshots in addition to text content.

## Creating Notification

Open the **Alerts > Web Notifications** page and click 'Create'.

Select the notification type in the drop-down.

Set the status to 'Enabled'.

Enter a name by which the notification will be listed on the 'Web Notifications' tab in the rule editor.

> If the notification type supports sending charts as images, configure the web driver as described [here](notifications/web-driver.md).

The same notification can be re-used by multiple rules.

### Parameters

Each notification type has displays its own set of settings:

* Fixed settings that can not be customized in the rule editor.
* Editable which can be changed in the rule editor.

The customizable settings are marked with an enabled checkbox.

![](images/slack-text-check.png)

The administrator can specify which settings are fixed and which can be modified in the rule editor.

For example, an API Bot identifier or authentication token is a fixed setting, whereas the text message is customizable and is resolved dynamically based on the window status and placeholder values.

## Testing Notifications

Fill out the required fields for the given notification type.

Click 'Test' to verify the delivery.

If the notification type supports sending charts, select one of the portals from the 'Test Portal' drop-down.

The notification request is successful if the endpoint returns status `200` (OK).

![](images/slack-test.png)

## Using Notifications in Rules

Open **Alerts > Rules** page.

Select a rule by name, open the 'Web Notifications' tab in the rule editor.

Choose one of the notifications from the 'Endpoint' drop-down.

Configure when the notification are triggered by enabling triggers for different status change events: on `Open`, `Repeat`, and on `Cancel`.

![](images/notify-triggers.png)

Multiple notifications to different endpoints can be enabled for the same rule.

### Jitter Control

The `Delay on 'OPEN'` setting allows deferring the trigger fired for the `OPEN` status. This is accomplished by deferring an `OPEN` notification and cancelling it in case the window status reverts to `CANCEL` within the specified grace interval.

This setting can be used to reduce alert jitter when the window alternates between the `OPEN` and `CANCEL` status.

### Repeat Alerts

If the window remains in the `REPEAT` status, it can be configured to repetitively trigger the notification with the following frequency:

| Frequency | Description |
| --- | --- |
| All | The notification is triggered each time the window is updated and remains in the `REPEAT` status (expression continues to be `true`). |
| Every *N* events | The notification is triggered every Nth occurrence of the new data being added to the window. |
| Every *N* minutes | The notification is triggered when the window is updated but no more frequently than the specified interval. |

### Message Text

The editor displays a `Text` field where the alert message can be customized with [placeholders](placeholders.md).

Sample alert message with placeholders:

```ls
[${status}] ${rule} for ${entity} ${tags}.
```

The alert message can include links to ATSD resources using [link placeholders](links.md) such as the `${chartLink}`.

```javascript
${chartLink}
```

The text can include [control flow](control-flow.md) statements for conditional processing.

```javascript
*[${tags.status}]* <${entityLink}|${ifEmpty(entity.label, entity)}> Ω <${getEntityLink(tags.docker-host)}|${ifEmpty(getEntity(tags.docker-host).label, tags.docker-host)}>

@if{is_launch}
  ${addTable(entity.tags, 'ascii')}
@end{}
```

### Attachments

Attachments options are enabled in the rule editor if the capability is implemented by the API of the receiving service.

![](images/notify-attach.png)

The option `Attach Portals` sends one or more portals when active. If a portal is a [template](../portals/portals-overview.md#template-portals), placeholders such as entity, metric, tags will be resolved from the alert time series key.

![](images/notify-attach-4.png)

The option `Series Chart` sends the default portal for the current metric, entity and tags as an image when active. 

![](images/notify-attach-1.png)

The option `Attach Details` sends an alert details table when active. It is possible to specify the [format](details-table.md#formats) of the details table or a [Telegram](./notifications/telegram.md) endpoint.

![](images/notify-attach-2.png)

![](images/notify-attach-3.png)


### Multiple Endpoints

In order to update multiple endpoints for the same status change event, add notifications, identified by unique name, in the rule editor. The order in which notifications are delivered is nondeterministic.

## Stopping Messages

The rule engine ignores alerts initiated for disabled notifications.

To temporarily disable sending alerts from all rules through the selected notification, set its status to 'Disabled' on the **Alerts > Web Notifications** page.

## Delivery Control

Notification results are recorded in the database as messages and can be viewed under the 'notification' type on the Message Search page.

```elm
https://atsd_host:8443/messages?search=1&search=&type=notification&interval.intervalCount=1&interval.intervalUnit=WEEK
```

![](images/notify-error.png)

## Monitoring

The number of notifications sent per minute can be monitored with the [`web_service_notifications_per_minute`](../administration/monitoring.md#rule-engine) metric collected by the database.

```elm
https://atsd_host:8443/portals/series?entity=atsd&metric=web_service_notifications_per_minute
```

![](images/notifications-monitoring.png)

## Error Handling

The notification request is delivered successfully if the endpoint returns `200` (OK) status code.

**No retry** is attempted in case of error. If the notification fails, the rule engine writes an `ERROR` event in the `atsd.log` and stores a corresponding messages with `CRITICAL` severity in the database.

If the error occurs during chart preparation, the rule engine falls back to sending a text message containing the chart link and the error details, if available.

## Network Settings

If the ATSD server cannot connect to the remote API server directly due to network restrictions, use one of the following configuration options displayed in the **Network Settings** section.

* **API Gateway**

  In this configuration, an API gateway such as an [NGINX Reverse Proxy](https://www.nginx.com/resources/admin-guide/reverse-proxy/) accepts the request from ATSD on the specified path, sends the request to the remote API server, fetches the response, and sends it back to ATSD. This proxy maps particular paths to remote servers.

  NGINX configuration for Slack:

  ```
    location /api/chat.postMessage {
        proxy_pass https://slack.com/api/chat.postMessage;
    }
    location /api/files.upload {
        proxy_pass https://slack.com/api/files.upload;
    }
  ```

  NGINX configuration for Telegram:

  ```
    location /bot {
        proxy_pass https://api.telegram.org/bot;
    }
  ```

  NGINX configuration for Discord:

  ```
    location /api/webhooks {
        proxy_pass https://discordapp.com/api/webhooks;
    }
  ```  

  Modify the `Base URL` by replacing it with the corresponding API gateway URL.

  ![](images/notify-network-base.png)

* **HTTP/HTTPS/SOCKS Proxy**

  A network proxy of this type doesn't explicitly map receive paths and remote URLs.

  Keep the `Base URL` as originally specified and instead fill out the `Proxy URL` and optional client credentials fields.

  ![](images/notify-proxy.png)

  Supported protocols are HTTP/HTTPS and SOCKS v5.

  Examples:

  * `http://10.102.0.80/proxy`
  * `https://10.102.0.80/proxy`
  * `socks5://10.102.0.54`
