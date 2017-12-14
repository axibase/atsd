# Amazon SQS Notification

## Overview

The `AWS SQS` [notification](../web-notifications.md) provides a way to send signed messages to an [Amazon SQS](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_SendMessage.html) queue on window status events.

## Notification Settings

|**Setting**|**Description**|
|---|---|
|Region|The [Amazon SQS Region](http://docs.aws.amazon.com/general/latest/gr/rande.html#sqs_region).|
|Access Key Id|[Access Key Id](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys)|
|Secret Access Key|[Secret Access Key](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys)|
|Queue Path|The path of the queue to which a message is sent.|
|Queue Type|The type of the queue to which a message is sent.|
|Message Group Id|The tag that specifies that a message belongs to a specific message group.|
|Message|The default text of the message to be sent.|

#### Queue Types

|**Setting**|**Description**|
|---|---|
|`Standard`|Standard queue offer maximum throughput, best-effort ordering, and at-least-once delivery.|
|`FIFO`|FIFO (first-in-first-out) queue is designed to guarantee that messages are processed exactly once, in the exact order that they are sent, with limited throughput.|

## Message

Each window status event can produce only one AWS SQS message.

The message is submitted to the specified AWS SQS endpoint using the `POST` method with `application/x-www-form-urlencoded` content type. The request includes additional AWS headers (Authorization, X-Amz-Date) and is signed with [AWS Signature Version 4](http://docs.aws.amazon.com/general/latest/gr/signature-version-4.html).

The default message uses the JSON format and includes all fields, including entity and metric metadata.

## Response

The response status code and response content is recorded in `atsd.log` if the `Log Response` setting is enabled.

## Configure AWS SQS Notification

* Open **Alerts > Web Notifications** page.
* Click the **Create** button and select the `AWS-SQS` type.
* Fill out the `Name`, `Region`, `Access Key Id`, and `Secret Access Key` fields.
* Enter the `Queue Path`.

  ![](images/aws_sqs_config.png)

* Click **Test**.

   ![](images/aws_sqs_test_request.png)

   ![](images/aws_sqs_test_response.png)

* If tests are passing OK, check **Enable**, click **Save**.

In order to test the actual payload, create a sample rule, and enable the `AWS-SQS` notification on the `Web Notifications` tab.

## Examples

* [Standard Queue Type](aws-sqs-standard.md)
* [FIFO Queue Type](aws-sqs-fifo.md)
