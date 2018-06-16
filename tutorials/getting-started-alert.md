# Getting Started: Alerting

## Create Rule

Open the **Alerts > Rules** page and click **Create** to configure an alert rule for the `temperature` metric using the built-in [Rule Engine](../rule-engine/README.md).

![](./resources/getting-started-4_1.png)

![](./resources/getting-started-4_2.png)

The following [condition](../rule-engine/condition.md) evaluates to `true` and creates an alert if the average value for the last 3 samples exceeds `50`:

```java
avg() > 50
```

![](./resources/rule-overview.png)

Open **Filter** tab in the rule editor to allow out-of-order values and to disable the time [filter](../rule-engine/filters.md#date-filter) by setting the grace period to `0`. Otherwise measurements older than `1 minute` are ignored by the rule engine.

> Pro Tip. You can also import the rule from the XML file [temperature_rule.xml](./resources/temperature_rule.xml).

Return to **Data Entry** page and submit a few commands with the value greater than `50`.

```ls
series e:br-1905 m:temperature=55
```

Open **Alerts > Open Alerts** page in the main menu to view currently opened alerts.

![](./resources/rule-open-alerts.png)

Now insert some commands with low values so that the average of the last three commands is less than `50`.

```ls
series e:br-1905 m:temperature=20
```

Reload the **Alerts > Open Alerts** page to verify that the alert for `temperature-too-high` is closed.

## Email Alerts

To receive alert notifications via email, configure the [Mail Client](../administration/mail-client.md) on the **Settings > Mail Client** page.

Open the rule editor and enable [alerts](../rule-engine/email.md) on the **Email Notifications** tab as illustrated below.

> Pro Tip. To send portal screenshots, configure the [Web Driver](../rule-engine/notifications/web-driver.md).

![](./resources/alert-email.png)

Save the rule and insert a few samples on the **Data Entry** page again. You'll receive the following message when the threshold is exceeded:

![](./resources/alert-email-msg.png)

## Slack Alerts

To receive alerts in [Slack](../rule-engine/notifications/slack.md) create a [bot](../rule-engine/notifications/slack.md#create-bot) user and configure the built-in [`SLACK`](../rule-engine/notifications/slack.md#configure-webhook-in-atsd) webhook.

Open the rule editor and enable alerts on the **Web Notifications** tab as illustrated below.

![](./resources/alert-slack.png)

Save the rule and insert commands on the **Data Entry** page again.

The following message appears in Slack when the average exceeds `50` for the last three samples.

![](./resources/alert-slack-msg.png)

Refer to [Outgoing Webhooks](../rule-engine/notifications/README.md) for more details.

## Summary

Congratulations!

You have successfully completed the **Getting Started** guide to Axibase Time Series Database (ATSD).
