# Amazon SNS Webhook

## Overview

`AWS SNS` [webhook](../notifications/README.md) publishes signed messages to an [Amazon SNS](https://docs.aws.amazon.com/sns/latest/api/API_Publish.html) topic upon window status events.

## Webhook Settings

|**Setting**|**Description**|
|---|---|
|Region|The [Amazon SNS Region](https://docs.aws.amazon.com/general/latest/gr/rande.html#sns_region).|
|Access Key Id|[Access Key Id](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys)|
|Secret Access Key|[Secret Access Key](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys)|
|Topic ARN|Topic you want to publish messages to.|
|Subject|Default message subject.|
|Message Format|Default message format.|
|Message|Default message text.|

## Message

Each window status event can trigger only one AWS SNS message.

The message is submitted to the specified AWS SNS endpoint using the `POST` method with `application/x-www-form-urlencoded` content type. The request includes additional AWS headers (`Authorization`, `X-Amz-Date`) and is signed with [AWS Signature Version 4](https://docs.aws.amazon.com/general/latest/gr/signature-version-4.html).

The default message uses the JSON format and includes all fields, including entity and metric metadata.

### Message Formats

|**Setting**|**Description**|
|---|---|
|`RAW`|Send message as plain text.|
|`SNS_JSON`|Send [a custom message for each protocol](https://docs.aws.amazon.com/sns/latest/api/API_Publish.html) ([example](https://docs.aws.amazon.com/sns/latest/dg/mobile-push-send-custommessage.html)).|

## Response

The response status code and response content is recorded in `atsd.log` if the **Log Response** setting is enabled.

## Configure AWS SNS Webhook

* Open **Alerts > Outgoing Webhooks** page.
* Click **Create** and select the `AWS-SNS` type.
* Fill out the **Name**, **Region**, **Access Key Id**, and **Secret Access Key** fields.
* Enter the **Topic ARN**. The topic address is marked as an editable field which can be customized later in the rule editor. This configuration allows publishing messages to different topics using the same webhook.

  ![](./images/aws_sns_config.png)

* Click **Test**.

   ![](./images/aws_sns_test_request.png)

   ![](./images/aws_sns_test_response.png)

* If test is passed, check **Enable**, click **Save**.

To test the actual payload, create a sample rule, and enable the `AWS-SNS` webhook on the **Webhooks** tab.

## Examples

* [RAW Message Format](aws-sns-raw.md)
* [SNS JSON Message Format](aws-sns-json.md)
