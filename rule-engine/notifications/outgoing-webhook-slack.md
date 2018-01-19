# Slack Outgoing Webhook

## Overview

Slack [Events API](https://api.slack.com/events-api#receiving_events) allows to send messages from Slack bot to ATSD using [webhook](../api/data/messages/webhook.md) endpoint.

## Add Bot User

* Open https://api.slack.com/apps/
   
   ![](images/outgoing_webhook_slack_1.png)
   
* Select already existing or create a new app.

* Configure a new bot user, if necessary.

    * Click on **Bot Users**.

        ![](images/outgoing_webhook_slack_2.png)
        
    * Click on **Add a Bot User**.
    
       ![](images/outgoing_webhook_slack_3.png)
   
    * Review Settings, click on **Add Bot User**.

        ![](images/outgoing_webhook_slack_4.png)
   
    * Click on **Save Changes**.

## Add Event Subscription

* Click on **Basic Information**.

   ![](images/outgoing_webhook_slack_5.png)

* Click on **Add features and functionality**.

   ![](images/outgoing_webhook_slack_6.png)
   
* Click on **Event Subscriptions**, check **Enable Events**.
 
   ![](images/outgoing_webhook_slack_7.png)
   
* Fill in the **Request URL** field. 

   ```ls
   https://user:password@atsd_host:port/api/v1/messages/webhook/slack?entity=slack
   ```
   *Verified* status should appear.

   ![](images/outgoing_webhook_slack_8.png)   
   
* Click on **Add Bot User Event** at the **Subscribe to Bot Events** section.

   ![](images/outgoing_webhook_slack_9.png)
   
* Enter `message.im` to limit subscriptions to subscribe only to messages sent directly to bot.

   ![](images/outgoing_webhook_slack_10.png)
   
* Click on **Save Changes**.

* Click on **Install App**.

   ![](images/outgoing_webhook_slack_11.png)

* Click on **Install App to Workspace**.

   ![](images/outgoing_webhook_slack_12.png)
   
* Review permissions, click on **Authorize**.

   ![](images/outgoing_webhook_slack_13.png)
   
* Go to workspace, make sure app is visible in **Apps** section.

   ![](images/outgoing_webhook_slack_14.png)
   
## Testing Webhook

### Create/Import Rule

* Create a new rule or import an existing rule as described below.
* Download the file [rules_outgoing_webhook.xml](resources/rules_outgoing_webhook.xml).
* Open the **Alerts > Rules > Import** page.
* Check (enable) **Auto-enable New Rules**, attach the `rules_outgoing_webhook.xml` file, click **Import**.

### Configure Notification

* Open **Alerts > Rules** page and select a rule.
* Open the **Web Notifications** tab.
* Select `SLACK` from the **Endpoint** drop-down.
* Enable the `OPEN`, `REPEAT` triggers.
* Customize the alert message using [placeholders](../placeholders.md) as necessary, for example:

```ls
    OPEN = Received `${message}` from <@${tags.event.user}>
    REPEAT = Received `${message}` from <@${tags.event.user}>
```

* Save the rule by clicking on the **Save** button.

    ![](images/outgoing_webhook_slack_15.png)
    
* Go to workspace and send direct message to recently created bot.

    ![](images/outgoing_webhook_slack_16.png)
    
* It may take a few seconds for the commands to arrive and to trigger the notifications. The rule will create new windows based on incoming `message` commands. You can open and refresh the **Alerts > Open Alerts** page to verify that an alert is open for your rule.

    ![](images/outgoing_webhook_slack_17.png)    


