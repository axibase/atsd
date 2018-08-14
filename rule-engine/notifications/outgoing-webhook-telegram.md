# Telegram Outgoing Webhook

## Overview

The document describes how to relay messages addressed to a Telegram Bot into ATSD for subsequent processing. Typical use cases include replying to information requests and executing predefined actions.

The integration relies on the Telegram Bot API [`setWebhook`](https://core.telegram.org/bots/api#setwebhook) method to send messages and the ATSD [webhook](../../api/data/messages/webhook.md) endpoint to receive HTTP requests from Telegram servers and to convert them into `message` commands that are stored and processed by the rule engine.

## Reference

* [Create Telegram Bot](#create-telegram-bot)
* [Prepare Webhook URL](#prepare-webhook-url)
* [Set Webhook](#set-webhook)
* [Check Webhook](#check-webhook)
* [Test Integration](#test-integration)

## Create Telegram Bot

A bot is a special user account created for automation and integration purposes.

* Search for the `BotFather` user in Telegram client.
* Start a conversation with the [BotFather](https://telegram.me/botfather) user.

    ![](./images/botfather.png)

* Send the `/newbot` command and complete the guided process to create a bot user and obtain its token. The bot username must end with `_bot` and cannot contain dash `-` symbol.

```txt
Use this token to access the HTTP API:
5555555555:AAHrB1gmYKaSvzsXjhbyDypOJlfu_FgdwrE
```

* Copy the API token for future reference.

## Prepare Webhook URL

Prepare a request URL for accepting notifications from Telegram servers.

* Follow the path **Settings > Users > Create Webhook User** in ATSD and create a [webhook](../../api/data/messages/webhook.md#webhook-user-wizard) user for accepting data from Telegram.

  ![](../../administration/images/webhook-user.png)

* Replace [user credentials](../../api/data/messages/webhook.md#authentication) and the DNS name of the target ATSD instance in the webhook URL below.

```elm
https://username:password@atsd_hostname:8443/api/v1/messages/webhook/telegram?command.message=message.text
```

  The target ATSD server must be accessible on one of the supported ports: `80`, `88`, `443`, `8443`.

## Set Webhook

Set up a webhook based on the SSL certificate installed in ATSD.

* If ATSD has a CA-signed SSL certificate

  Set webhook by specifying the webhook URL

```bash
curl -F "url=https://username:password@atsd_hostname:8443/api/v1/messages/webhook/telegram?command.message=message.text" \
    https://api.telegram.org/botBOT_TOKEN/setWebhook
```

* If ATSD runs on a self-signed SSL certificate

  Export the [self-signed](../../administration/ssl-self-signed.md) SSL certificate in [PEM format](https://core.telegram.org/bots/webhooks#a-self-signed-certificate):

```sh
keytool -importkeystore -srckeystore /opt/atsd/atsd/conf/server.keystore -destkeystore /opt/atsd/atsd/conf/server.keystore.p12 -srcstoretype jks -deststoretype pkcs12
```

```sh
openssl pkcs12 -in /opt/atsd/atsd/conf/server.keystore.p12 -out /opt/atsd/atsd/conf/server.keystore.pem -nokeys
```

Set webhook by specifying the webhook URL and attaching the`server.keystore.pem` file.

```sh
curl -F "url=https://username:password@atsd_hostname:8443/api/v1/messages/webhook/telegram?command.message=message.text" \
    -F "certificate=@/opt/atsd/atsd/conf/server.keystore.pem" \
    https://api.telegram.org/botBOT_TOKEN/setWebhook
```

## Check Webhook

Ensure that the `getWebhookInfo` method does not return any SSL errors:

```sh
curl "https://api.telegram.org/botBOT_TOKEN/getWebhookInfo"
```

```json
{
  "ok": true,
  "result": {
    "url": "https://username:password@atsd_hostname:8443/api/v1/messages/webhook/telegram?command.message=message.text",
    "has_custom_certificate": true,
    "pending_update_count": 0,
    "max_connections": 40
  }
}
```

## Test Integration

### Create or Import Rule

* Create a new rule as described below or [import an existing rule](https://axibase.com/use-cases/tutorials/shared/import-rule.html).
* Download the file [`rules_outgoing_webhook.xml`](./resources/rules_outgoing_webhook.xml).
* Open the **Alerts > Rules > Import** page.
* Check **Auto-enable New Rules**, attach the `rules_outgoing_webhook.xml` file, click **Import**.

### Configure Webhook

* Navigate to **Alerts > Rules** and select the new or imported rule.
* Open **Webhooks** tab.
* Select the webhook from the **Endpoint** drop-down list.
* Enable the `OPEN`, `REPEAT` triggers.
* Customize the alert message using [placeholders](../placeholders.md) if needed, for example:

```bash
User ${tags.message.from.first_name} ${tags.message.from.last_name}/${tags.message.from.username} said "${message}"
```

* Click **Save**.

    ![](./images/outgoing_webhook_telegram_1.png)

### Verify Webhook Delivery

* Open the Telegram client and send a direct message to the newly created bot.

    ![](./images/outgoing_webhook_telegram_2.png)

* Open **Alerts > Incoming Webhooks** page and check that a request from Telegram servers has been received.

    ![](./images/outgoing_webhook_telegram_4.png)

* If the request is not visible, check **Settings > Diagnostics > Security Incidents** page which displays an error in case the user credentials are mis-configured.

    ![](./images/outgoing_webhook_slack_20.png)

    ![](./images/outgoing_webhook_slack_21.png)

* It can take a few seconds for the commands to arrive and trigger the notifications. The rule creates new windows based on incoming `message` commands. You can open and refresh the **Alerts > Open Alerts** page to verify that an alert is open for your rule.

    ![](./images/outgoing_webhook_telegram_3.png)
