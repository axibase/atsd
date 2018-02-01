# Slack Outgoing Webhook

## Overview

The Slack [Events API](https://api.slack.com/events-api#receiving_events) allows sending messages into ATSD using its [webhook](../api/data/messages/webhook.md) endpoint. 

The following document describes how to create a Slack Bot that will copy messages received from other Slack users in the same workspace into ATSD.

The ATSD can then be programmed to respond to received commands by means of sending information back into Slack using the `SLACK` web notification type.

## Create Slack Bot

Slack Bot is a special account created specifically for automation purposes.

* Open https://api.slack.com/apps/
   
   ![](images/outgoing_webhook_slack_1.png)
   
* Select an existing app or create a new one.

* Create a bot user.

    * Click on **Bot Users**.

        ![](images/outgoing_webhook_slack_2.png)
        
    * Click on **Add a Bot User**.
    
       ![](images/outgoing_webhook_slack_3.png)
   
    * Review Settings, click on **Add Bot User**.

        ![](images/outgoing_webhook_slack_4.png)
   
    * Click on **Save Changes**.

## Subscribe to Bot Messages

* Click on **Basic Information**.

   ![](images/outgoing_webhook_slack_5.png)

* Click on **Add features and functionality**.

   ![](images/outgoing_webhook_slack_6.png)
   
* Click on **Event Subscriptions**, check **Enable Events**.
 
   ![](images/outgoing_webhook_slack_7.png)
   
* Fill in the **Request URL** field.

  Specify [user credentials](../api/data/messages/webhook.md#authentication) and the hostname/port of your ATSD instance. 
  
  The target ATSD server must be accessible and have a valid CA-signed [SSL certificate](/administration/ssl-ca-signed.md) installed. Self-signed certificates are not supported by Slack at this time.

   ```elm
   https://user:password@atsd_host:8443/api/v1/messages/webhook/slack?entity=slack&command.message=event.text&command.date=event.ts&exclude=event.event_ts&exclude=event_time&exclude=event.icons.image*&exclude=*thumb*&exclude=token&exclude=event_id&exclude=event.message.edited.ts&exclude=*.ts
   ```
   
   *Verified* status should be displayed if the request evaluates correctly.

   ![](images/outgoing_webhook_slack_8.png)   
   
* Click on **Add Bot User Event** at the **Subscribe to Bot Events** section.

   ![](images/outgoing_webhook_slack_9.png)
   
* Enter `message.im` to limit subscriptions only to messages sent **directly** to bot.

   ![](images/outgoing_webhook_slack_10.png)
   
* Click on **Save Changes**.

* Click on **Install App**.

   ![](images/outgoing_webhook_slack_11.png)

* Click on **Install App to Workspace**.

   ![](images/outgoing_webhook_slack_12.png)
   
* Review permissions, click **Authorize**.

   ![](images/outgoing_webhook_slack_13.png)
   
* Go to Slack workspace, make sure the app is visible in the **Apps** section.

   ![](images/outgoing_webhook_slack_14.png)
   
## Testing Webhook

### Create/Import Rule

* Create a new rule or import an existing rule as described below.
* Download the file [rules_outgoing_webhook.xml](resources/rules_outgoing_webhook.xml).
* Open the **Alerts > Rules > Import** page.
* Check (enable) **Auto-enable New Rules**, attach the `rules_outgoing_webhook.xml` file, click **Import**.

### Configure Notification

* Create any of [Collaboration Services](https://github.com/axibase/atsd/blob/master/rule-engine/web-notifications.md#collaboration-services) notification or use existing.
* Open **Alerts > Rules** page and select a rule.
* Open the **Web Notifications** tab.
* Select the notification from the **Endpoint** drop-down.
* Enable the `OPEN`, `REPEAT` triggers.
* Customize the alert message using [placeholders](../placeholders.md) as necessary, for example:

```ls
    OPEN = Received `${message}` from <@${tags.event.user}>
    REPEAT = Received `${message}` from <@${tags.event.user}>
```

* Save the rule by clicking on the **Save** button.

    ![](images/outgoing_webhook_slack_15.png)
    
* Go to the Slack workspace and send direct message to recently created bot.

    ![](images/outgoing_webhook_slack_16.png)
    
    
> Note that message fields in json payload sent by Slack servers contain HTML entities for [3 characters](https://api.slack.com/docs/message-formatting#how_to_escape_characters):
>  * ampersand `&` replaced with `&amp;`
>  * less-than sign, `<` replaced with `&lt;`
>  * greater-than sign, `>` replaced with `&gt;`  
    
* It may take a few seconds for the commands to arrive and to trigger the notifications. The rule will create new windows based on incoming `message` commands. You can open and refresh the **Alerts > Open Alerts** page to verify that an alert is open for your rule.

    ![](images/outgoing_webhook_slack_17.png)    


