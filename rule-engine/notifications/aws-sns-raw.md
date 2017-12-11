## RAW Message Format Example

Create a `AWS SNS` notification with `Message Format = RAW`, for example:

![](images/aws_sns_web_notification_config_raw.png)

Create a new rule and open the **Web Notifications** tab.
* Select `[AWS-SNS] test` from the **Endpoint** drop-down.
* Enable the `OPEN`, `REPEAT`, and `CANCEL` triggers.
* Customize the alert messages using [placeholders](../placeholders.md) as necessary, for example:

   - OPEN:

       ```json
       {
          "status": "${status}",
           "entity": "${entity}",
           "rule": "${rule}",
           "tags": "${tags}",
           "message": "The rule is open"
       }
       ```

   - REPEAT:

       ```json
       {
           "status": "${status}",
           "entity": "${entity}",
           "rule": "${rule}",
           "tags": "${tags}",
           "repeatCount": "${repeat_count}",
           "message": "The rule is still open"
       }
       ```

   - CANCEL:

       ```json
       {
           "status": "${status}",
           "entity": "${entity}",
           "rule": "${rule}",
           "tags": "${tags}",
           "repeatCount": "${repeat_count}",
           "message": "The rule is cancel"
       }
       ```

  ![](images/aws_sns_web_notification_raw.png)

* Save the rule by clicking on the **Save** button.

* The rule will create new windows based on incoming data.
It may take a few seconds for the first commands to arrive and to trigger the notifications. You can open and refresh the **Alerts > Open Alerts** page to verify that an alert is open for your rule.

## Test

The AWS SNS Subscriptions:

![](images/aws_sns_subscriptions.png)

## Notifications examples:

### Email protocol:

![](images/aws_sns_web_notification_raw_test_1.png)

![](images/aws_sns_web_notification_raw_test_2.png)

![](images/aws_sns_web_notification_raw_test_3.png)

### Http protocol:

The `HTTP` subscription with parameter `raw message delivery = false`:

![](images/aws_sns_web_notification_raw_test_4.png)

![](images/aws_sns_web_notification_raw_test_5.png)

![](images/aws_sns_web_notification_raw_test_6.png)

### Http protocol:

The `HTTP` subscription with parameter `raw message delivery = true`:

![](images/aws_sns_web_notification_raw_test_7.png)

![](images/aws_sns_web_notification_raw_test_8.png)

![](images/aws_sns_web_notification_raw_test_9.png)
