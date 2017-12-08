# Slack Notifications

## Overview

The `SLACK` [notification](../web-notifications.md) provides a built-in capability to send alert messages, alert detail tables, and charts into Slack channels. The integration is based on the [Slack Bot API](https://api.slack.com/bot-users).

## Prerequisites

Install and configure the [Web Driver](web-driver.md) in order to enable sending chart screenshots into Slack.

## Create Workspace

If necessary, go to https://slack.com/create and follow the prompts to create a new workspace.

## Create Channel

* Click **Create a channel**

  ![](images/create_channel.png)

* Check (enable) **Private** option to restrict access to the channel.
* Invite users to join the channel in order to receive alerts from the ATSD rule engine

    ![](images/create_channel2.png)   

* Click **Create Channel**.

## Create ATSD Slack Bot

* Open https://my.slack.com/services/new/bot
* Check Workspace

    ![](images/check_workspace.png)  

* Specify the username.
* Click **Add bot integration**.

    ![](images/atsd_bot_slack.png)  

* Review the setup instructions.
* Copy the API Token for future reference. Click **Save Integration**.

    ![](images/api_token.png)

* Invite the bot user to the channel.

    * Go back to https://my.slack.com/
    * Click **Invite others to this private channel**.

    ![](images/add_atsd_bot.png)

    * Choose any option for the channel.

    ![](images/channel_option.png)

    * Enter the bot name into the search field.

    ![](images/add_atsd_bot_to_slack.png)

    * Click **Invite**.

## Get Channel Id

 * Click on the target IM/public/private channel to display the channel URL, for example `messages/D822261LK/team/U81D8UY64/`.
 
     ![](images/slack_channel_id.png)
     
 * Copy the channel Id which is specified between the `messages/` and `/team` parts, for example `D822261LK`.
 
In case of sending messages to a public or private channel you can just use the name of the channel instead of its Id, for example `devops` or `general`.

## Create Slack Notification in ATSD

* Open **Alerts > Web Notifications** page.
* Click on an existing `SLACK` template, or click the **Create** button below and switch the form to `SLACK` type.
* Specify the `Auth Token` and `Channels` parameters. See parameter descriptions below.

    ![](images/slack-settings.png)   

* Click **Test**

   ![](images/slack_message_test.png)

* Select **Test Portal** to verify screenshot delivery.

   ![](images/new_test_portal.png)   

* Click **Send Screenshot**

   ![](images/slack_send_screen.png)

* If tests are passing OK, check **Enable**, click **Save**.

## Notification Settings

|**Setting**|**Description**|
|---|---|
|Auth Token|Bot API authentication token (see above).|
|Bot Username|Set your bot's user name.|
|Channels|Comma-separated list of channels, private groups, or IM channels to send message to. Each entry can be a name or an encoded ID.|
|Text|Message text to be sent. This field should be left blank so it can be customized in the rule editor.|
|Parse Mode|Change how messages are formatted. See [Basic message formatting](https://api.slack.com/docs/message-formatting)|
|Names as Links|Find and link channel names and usernames.|

## Testing Notification Rule

### Create/import rule

* Create a new rule or import an existing rule for a built-in metric as described below.
* Download the file [rules.xml](resources/rules.xml).
* Open the **Alerts > Rules > Import** page.
* Check (enable) **Auto-enable New Rules**, attach the `rules.xml` file, click **Import**.

### Configure notification

* Open **Alerts > Rules** page and select a rule.
* Open the **Web Notifications** tab.
* Select Slack from the **Endpoint** drop-down.
* Enable the `OPEN`, `REPEAT`, and `CANCEL` triggers.
* Customize the alert message using [placeholders](../placeholders.md) as necessary, for example:

```ls
    OPEN = [${status}] ${rule} for ${entity} ${tags}. ${ruleLink}
    REPEAT = [${status}] ${rule} for ${entity} ${tags}. Duration: ${alert_duration_interval}. ${ruleLink}
    CANCEL = [${status}] ${rule} for ${entity} ${tags}. Duration: ${alert_duration_interval}. ${ruleLink}
```

* Save the rule by clicking on the **Save** button.

  ![](images/slack_notification.png)

* The rule will create new windows based on incoming data.
It may take a few seconds for the first commands to arrive and to trigger the notifications. You can open and refresh the **Alerts > Open Alerts** page to verify that an alert is open for your rule.

## Example

![](images/slack_test_1.png)

![](images/slack_test_2.png)
