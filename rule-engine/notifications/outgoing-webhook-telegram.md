# Telegram Outgoing Webhook

## Overview

The document describes how to relay messages addressed to a Telegram Bot into ATSD for subsequent processing. Typical use cases include replying to information requests and executing predefined actions.

The integration relies on the Telegram Bot API [setWebhook](https://core.telegram.org/bots/api#setwebhook) method to send messages and on the ATSD [webhook](../../api/data/messages/webhook.md) endpoint to receive HTTP requests from Telegram servers and to convert them into message commands that can be stored and processed by the rule engine.

## Create Telegram Bot

The bot is special user account created for automation and integration purposes. You can use an existing bot or create a new one.

* Search for the `BotFather` user in the Telegram client.
* Start a conversation with the [BotFather](https://telegram.me/botfather) user.

    ![](images/botfather.png)

* Send the `/newbot` command and follow the prompts to create a bot user and obtain its token.


## Set Webhook

The webhook URL must contain [user credentials](../../api/data/messages/webhook.md#authentication) and the hostname/port of your ATSD instance, for example:
      
```elm
https://user:password@atsd_host:8443/api/v1/messages/webhook/telegram?entity=telegram
```
        
The target ATSD server must be accessible on one of the supported ports (80, 88, 443, 8443) and have a valid [CA-signed](/administration/ssl-ca-signed.md) or [self-signed](/administration/ssl-self-signed.md) SSL certificate installed.

In case of using a self-signed SSL certificate you'll need to export it in [PEM format](https://core.telegram.org/bots/webhooks#a-self-signed-certificate):

```bash
keytool -importkeystore -srckeystore /opt/atsd/atsd/conf/server.keystore -destkeystore /opt/atsd/atsd/conf/server.keystore.p12 -srcstoretype jks -deststoretype pkcs12

openssl pkcs12 -in /opt/atsd/atsd/conf/server.keystore.p12 -out /opt/atsd/atsd/conf/server.keystore.pem -nokeys
```

Execute one of the following commands to setup a webhook.

* CA-signed SSL certificate installed

    ```bash
    curl -F "url=https://user:password@atsd_host:8443/api/v1/messages/webhook/telegram?entity=telegram" \
      https://api.telegram.org/botBOT_TOKEN/setWebhook
    ```

* Self-signed SSL certificate installed

    ```bash
    curl -F "url=https://user:password@atsd_host:8443/api/v1/messages/webhook/telegram?entity=telegram" \
      -F "certificate=@/opt/atsd/atsd/conf/server.keystore.pem" \
      https://api.telegram.org/botBOT_TOKEN/setWebhook
    ```
Make sure that the `getWebhookInfo` method doesn't return any SSL errors:

```bash
curl "https://api.telegram.org/botBOT_TOKEN/getWebhookInfo"
```
```json
{
  "ok": true,
  "result": {
    "url": "https://user:password@atsd_host:8443/api/v1/messages/webhook/telegram?entity=telegram",
    "has_custom_certificate": true,
    "pending_update_count": 0,
    "max_connections": 40
  }
}
```

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
    OPEN = User ${tags.message.from.first_name} ${tags.message.from.last_name}/${tags.message.from.username} said "${tags.message.text}"
    REPEAT = User ${tags.message.from.first_name} ${tags.message.from.last_name}/${tags.message.from.username} said "${tags.message.text}"
```

* Save the rule by clicking on the **Save** button.

    ![](images/outgoing_webhook_telegram_1.png)
    
* Go to the Telegram and send a direct message to the recently created bot.

    ![](images/outgoing_webhook_telegram_2.png)
    
* It may take a few seconds for the commands to arrive and to trigger the notifications. The rule will create new windows based on incoming `message` commands. You can open and refresh the **Alerts > Open Alerts** page to verify that an alert is open for your rule.

    ![](images/outgoing_webhook_telegram_3.png)  
 
