# Telegram Outgoing Webhook

## Overview

The document describes how to relay messages addressed to a Telegram Bot into ATSD for subsequent processing. Typical use cases include replying to information requests and executing predefined actions.

The integration relies on the Telegram Bot API [setWebhook](https://core.telegram.org/bots/api#setwebhook) method to send messages and on the ATSD [webhook](../../api/data/messages/webhook.md) endpoint to receive HTTP requests from Telegram servers and to convert them into message commands that can be stored and processed by the rule engine.

## Reference

 * [Create Telegram Bot](#create-telegram-bot)
 * [Prepare Webhook URL](#prepare-webhook-url)
 * [Set Webhook](#set-webhook)
 * [Check Webhook](#check-webhook)
 * [Test Integration](#test-integration)

## Create Telegram Bot

The bot is special user account created for automation and integration purposes. You can use an existing bot or create a new one.

* Search for the `BotFather` user in the Telegram client.
* Start a conversation with the [BotFather](https://telegram.me/botfather) user.

    ![](images/botfather.png)

* Send the `/newbot` command and follow the prompts to create a bot user and obtain its token. The bot's username must end with `_bot` and cannot contain dash `-` symbol.

```txt
    Use this token to access the HTTP API:
    5555555555:AAHrB1gmYKaSvzsXjhbyDypOJlfu_FgdwrE
```

* Copy the API token for future reference.

## Prepare Webhook URL

Prepare a request URL for accepting notifications from Telegram servers.

* Open the **Settings > Users > Create Webhook User** wizard in ATSD and create a [webhook](../../api/data/messages/webhook.md#webhook-user-wizard) user for accepting data from Telegram.

  ![](images/outgoing_webhook_telegram_user.png)

* Replace [user credentials](../../api/data/messages/webhook.md#authentication) and the DNS name of the target ATSD instance in the webhook URL below.

```elm
   https://telegram:12345678@atsd_host:8443/api/v1/messages/webhook/telegram?command.message=message.text
```

  The target ATSD server must be accessible on one of the supported ports (80, 88, 443, 8443).

## Set Webhook

Execute one of the following commands to setup a webhook.

* If ATSD has a CA-signed SSL certificate

  Set webhook by specifying the webhook URL

```sh
    curl -F "url=https://telegram:12345678@atsd_host:8443/api/v1/messages/webhook/telegram?command.message=message.text" \
      https://api.telegram.org/botBOT_TOKEN/setWebhook
```

* If ATSD runs on a self-signed SSL certificate

  Export the [self-signed](../../administration/ssl-self-signed.md) SSL certificate in [PEM format](https://core.telegram.org/bots/webhooks#a-self-signed-certificate):

```sh
  keytool -importkeystore -srckeystore /opt/atsd/atsd/conf/server.keystore -destkeystore /opt/atsd/atsd/conf/server.keystore.p12 -srcstoretype jks -deststoretype pkcs12
```

```
  openssl pkcs12 -in /opt/atsd/atsd/conf/server.keystore.p12 -out /opt/atsd/atsd/conf/server.keystore.pem -nokeys
```

    Set webhook by specifying the webhook URL and attaching the `server.keystore.pem` file.

```sh
    curl -F "url=https://telegram:12345678@atsd_host:8443/api/v1/messages/webhook/telegram?command.message=message.text" \
      -F "certificate=@/opt/atsd/atsd/conf/server.keystore.pem" \
      https://api.telegram.org/botBOT_TOKEN/setWebhook
```

## Check Webhook

Make sure that the `getWebhookInfo` method doesn't return any SSL errors:

```sh
curl "https://api.telegram.org/botBOT_TOKEN/getWebhookInfo"
```

```json
{
  "ok": true,
  "result": {
    "url": "https://telegram:12345678@atsd_host:8443/api/v1/messages/webhook/telegram?command.message=message.text",
    "has_custom_certificate": true,
    "pending_update_count": 0,
    "max_connections": 40
  }
}
```

## Test Integration

### Create/Import Rule

* Create a new rule or import an existing rule as described below.
* Download the file [rules_outgoing_webhook.xml](resources/rules_outgoing_webhook.xml).
* Open the **Alerts > Rules > Import** page.
* Check (enable) **Auto-enable New Rules**, attach the `rules_outgoing_webhook.xml` file, click **Import**.

### Configure Notification

* Open **Alerts > Rules** page and select a rule.
* Open the **Web Notifications** tab.
* Select the notification from the **Endpoint** drop-down.
* Enable the `OPEN`, `REPEAT` triggers.
* Customize the alert message using [placeholders](../placeholders.md) as necessary, for example:

```ls
  User ${tags.message.from.first_name} ${tags.message.from.last_name}/${tags.message.from.username} said "${message}"
```

* Save the rule by clicking on the **Save** button.

    ![](images/outgoing_webhook_telegram_1.png)

### Verify Webhook Delivery

* Go to the Telegram and send a direct message to the recently created bot.

    ![](images/outgoing_webhook_telegram_2.png)
    
* Open **Settings > Diagnostics > Webhook Requests** page and check that a request from Slack servers has been received.

    ![](images/outgoing_webhook_slack_18.png)
    
    ![](images/outgoing_webhook_slack_19.png)
    
* If the request is not visible, check **Settings > Diagnostics > Security Incidents** page which will display an error in case the user credentials are mis-configured.

    ![](images/outgoing_webhook_slack_20.png)
    
    ![](images/outgoing_webhook_slack_21.png)

* It may take a few seconds for the commands to arrive and to trigger the notifications. The rule will create new windows based on incoming `message` commands. You can open and refresh the **Alerts > Open Alerts** page to verify that an alert is open for your rule.

    ![](images/outgoing_webhook_telegram_3.png)  
