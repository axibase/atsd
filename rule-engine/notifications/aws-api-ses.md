# Integration with Amazon SES

## Overview

The following example demonstrates how to send an email via [Amazon SES](https://aws.amazon.com/ses) using a [`AWS API`](aws-api.md) web notification.

The request is automatically signed with **AWS Signature, v4**, implemented by this notification type, which allows submitting requests to **any** AWS endpoint that accepts **AWS Signature, v4**.

The example invokes the [Amazon SES API](https://docs.aws.amazon.com/ses/latest/APIReference/API_SendEmail.html) `SendEmail` action.

## Configuration

Create a new `AWS API` web notification or import the [template](resources/aws-api-ses-notification.xml) used in this example. To import the XML template file, open the **Alerts > Web Notifications** page, select **Import** in the multi-action button located below the table and follow the prompts.

To create a new notification, open the **Alerts > Web Notifications** page and click **Create**.

### Parameters

Enter a name and specify the following parameters:

| **Name** | **Value** |
| :--- | :--- |
| Endpoint URL | `https://email.<AWS_REGION>.amazonaws.com` |
| Method | `POST` |
| Content Type | `application/x-www-form-urlencoded` |
| Access Key Id | `<AWS_ACCESS_KEY_ID>` |
| Secret Access Key | `<AWS_SECRET_ACCESS_KEY>` |
| Action | `SendEmail` |

Modify the `Endpoint URL` by replacing the `<AWS_REGION>` value with your [Amazon SES region](https://docs.aws.amazon.com/general/latest/gr/rande.html#ses_region), for example:

```elm
https://email.us-east-1.amazonaws.com
```

Enter the AWS key id into the `Access Key Id` field and the secret key into the `Secret Access Key` field.

Add required parameters for `SendMessage` action:

| **Name** | **Value** |
| :--- | :--- |
| Destination.ToAddresses.member.1 | `<DESTINATION_EMAIL>` |
| Source | `<SOURCE_EMAIL>` |
| Message.Body.Text.Data | `<MESSAGE_TEXT>` |
| Message.Subject.Data | `ATSD Alert` |

Modify the `Destination.ToAddresses.member.1` and `Source` by replacing the `<DESTINATION_EMAIL>` and `<SOURCE_EMAIL>` values with your text.

Modify the `Message.Body.Text.Data` by replacing the `<MESSAGE_TEXT>` value with your text, for example:

```json
{
  "status": "${status}",
   "entity": "${entity}",
   "rule": "${rule}",
   "tags": "${tags}",
   "message": ""
}
```

The `MessageBody` text contains placeholders that will be substituted with actual values when the notification is triggered. The placeholders specified in the payload and the URL are visible as editable parameters in the rule editor.

![](images/aws_api_ses_notification_config.png)

## Rule

Create a new rule or import the [rule template](resources/aws-api-ses-rule.xml) used in this example. To import the XML template file, open the **Alerts > Rules** page, select **Import** in the multi-action button located below the table and follow the prompts.

To create a new rule, open the **Alerts > Rules** page and click **Create**.

Specify the key settings on the **Overview** tab. 

| **Name** | **Value** |
| :-------- | :---- |
| Status | Enabled |
| Metric | test_m |
| Condition | `value > 1` |

![](images/aws_api_rule_overview.png)

Open the **Web Notifications** tab.

Set **Enabled** to **Yes** and choose the previously created web notification from the **Endpoint** drop-down.

Enable **Open**, **Repeat** and **Cancel** triggers.

Specify the text into the `Message.Body.Text.Data` and `Message.Subject.Data` parameters for all triggers.

![](images/aws_api_ses_rule_notification.png)

## Test

Test the integration by submitting a sample `series` command on the **Data > Data Entry** page.

```ls
  series e:test_e m:test_m=2
```

![](images/rule_test_commands.png)

The value will cause the condition to evaluate to `true`, which in turn will trigger the notification.
To verify that an alert was raised, open **Alerts > Open Alerts** page and check that an alert for the `test_m` metric is present in the **Alerts** table.

![](images/aws_api_ses_alert_open.png)

Check the Amazon SES statistics to make sure the new messages were sent:

![](images/aws_api_ses_test.png)

Email messages:

![](images/aws_api_ses_test_email_1.png)

![](images/aws_api_ses_test_email_2.png)

![](images/aws_api_ses_test_email_3.png)
