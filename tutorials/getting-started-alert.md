# Getting Started: Alerting

## Contents

1. [Introduction](./getting-started.md)
1. [Inserting Data](./getting-started-insert.md)
1. [Portals](./getting-started-portal.md)
1. [Exporting Data](./getting-started-export.md)
1. [SQL](./getting-started-sql.md)
1. Alerting

## Creating Rules

Open the **Alerts > Rules** page and click **Create** to configure an alert rule for the `temperature` metric using the built-in [Rule Engine](../rule-engine/README.md).

![](./resources/getting-started-4_1.png)

![](./resources/getting-started-4_2.png)

The following [condition](../rule-engine/condition.md) evaluates to `true` and creates an alert if the average value for the last three samples exceeds `50`:

```java
avg() > 50
```

![](./resources/rule-overview.png)

Open the **Filter** tab in the rule editor to allow out-of-order values and to disable the [Time Filter](../rule-engine/filters.md#time-offset-filter) by setting the grace interval to `0`. Otherwise the rule engine ignores measurements timestamped earlier than `1 minute` from current time.

> [Import the rule](https://axibase.com/use-cases/tutorials/shared/import-rule.html) from XML file [`temperature_rule.xml`](./resources/temperature_rule.xml).

Return to **Data Entry** and submit a few commands with values greater than `50`.

```ls
series e:br-1905 m:temperature=55
```

Open **Alerts > Open Alerts** page in the main menu to view currently opened alerts.

![](./resources/rule-open-alerts.png)

Now, insert some commands with lower values to ensure that the average of the last three commands is less than `50`.

```ls
series e:br-1905 m:temperature=20
```

Refresh the **Open Alerts** page to verify that the alert for `temperature-too-high` is closed.

## Email Alerts

To receive alert notifications via email, configure the [Mail Client](../administration/mail-client.md) on **Settings > Mail Client**.

Open the rule editor and enable [alerts](../rule-engine/email.md) on the **Email Notifications** tab as illustrated below.

<!-- markdownlint-enable MD032 -->
:::tip Note
To enable sending portal screenshots, configure the [Web Driver](../rule-engine/notifications/web-driver.md).
:::
<!-- markdownlint-disable MD032 -->

![](./resources/alert-email.png)

Save the rule and insert a few samples on the **Data Entry** page again. ATSD sends the following message when the threshold is exceeded:

![](./resources/alert-email-msg.png)

## Slack Alerts

To receive alerts in [Slack](../rule-engine/notifications/slack.md) create a [bot](../rule-engine/notifications/slack.md#create-bot) user and configure the built-in [`SLACK`](../rule-engine/notifications/slack.md#configure-webhook-in-atsd) webhook.

Open the rule editor and enable alerts on the **Webhooks** tab as illustrated below.

![](./resources/alert-slack.png)

Save the rule and insert commands on the **Data Entry** page again.

The following message appears in Slack when the average exceeds `50` for the last three samples.

![](./resources/alert-slack-msg.png)

Refer to [Outgoing Webhooks](../rule-engine/notifications/README.md) for more details.

## Summary

Congratulations!

You have successfully completed the **Getting Started** Guide for ATSD.

Review [Use Cases](https://axibase.com/use-cases/) for [Research Articles](https://axibase.com/use-cases/research/), [Integration Guides](https://axibase.com/use-cases/integrations/), and advanced [Tutorials](https://axibase.com/use-cases/tutorials/) to make the most of your new database.
