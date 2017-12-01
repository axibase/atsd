# Jenkins Integration

## Overview

The following example demonstrates how to trigger a [Jenkins](https://jenkins.io/) job using a [`CUSTOM`](custom.md) web notification in the ATSD rule engine.

The integration relies on the [Jenkins API](https://wiki.jenkins.io/display/JENKINS/Remote+access+API) `'Job with parameters'` method for triggering a new build job.

## Configuration

Create a new `CUSTOM` web notification from scratch or import the [template](resources/custom-jenkins-notification.xml) used in this example. To import the XML template file, open the **Alerts > Web Notifications** page, select **Import** in the multi-action button located below the table and follow the prompts.

To create a new notification, open the **Alerts > Web Notifications** page and click **Create**.

### Parameters

Enter a name and specify the following parameters:

| **Name** | **Value** |
| :--- | :--- |
| Method | `POST`  |
| Content Type | `application/json` |
| Endpoint URL | `https://jenkins.example.org/job/${job_name}/build` |
| Headers | `Authorization: Basic AbC123B64` |

Replace `jenkins.example.org` in the `Endpoint URL` parameter with the actual Jenkins address.

Keep the `${job_name}` placeholder in the URL path so that one can customize it in the rule editor. This would allow you to trigger different jobs using the same web notification.

The `Authorization` header should contain authorization type `Basic` and base64-encoded credentials in the format `username:api_token`. 

The API token can be found in the Jenkins web interface on the `User Configuration` page.

![](images/jenkins_token_1.png)

Click `Show API Token` button.

![](images/jenkins_token_2.png)

Your token is displayed in the `API Token` field.

![](images/jenkins_token_3.png)

### Payload

If your Jenkins job is parameterized, you can send the additional parameters in the request payload. 

To inspect which parameters are exposed by the project, open the job configuration page in Jenkins.

![](images/jenkins_param_build_2.png)

The parameters will be displayed if `This project is parametrized` checkbox is enabled.

![](images/jenkins_param_build_3.png)

The web notification can be configured to send a JSON document to the Jenkins server in order to pass extended parameters.

In this case, use the `Body` field to enumerate the job parameters in a JSON document as follows:

```
{
  "parameter": [
    {"name":"timezone", "value":"${timezone}"},
    {"name":"run_extra_tests", "value":"${run_extra_tests}"}
  ]
}
```

You can leave the `Body` field empty for non-parameterized jobs.

![](images/jenkins_endpoint.png)

## Rule

Create a new rule or import the [rule template](resources/custom-jenkins-rule.xml) used in this example. To import the XML template file, open the **Alerts > Rules** page, select **Import** in the multi-action button located below the table and follow the prompts.

To create a new rule, open the **Alerts > Rules** page and click **Create**.

Specify the key settings on the **Overview** tab. 

| **Name** | **Value** |
| :-------- | :---- |
| Status | Enabled |
| Metric | test_m |
| Condition | `value > 1` |

![](images/rule_overview.png)

Open the **Web Notifications** tab.

Set **Enabled** to **Yes** and choose the previously created web notification from the **Endpoint** drop-down.

Enable **Open** and **Repeat** triggers. Set the **Repeat Interval** to **All**.

Specify the same settings for **Open** and **Repeat** triggers:

| **Name** | **Value** |
| :-------- | :---- |
| job_name  | atsd-api-test |
| run_extra_tests  | false |
| timezone | Etc/UTC |

![](images/jenkins_rule_notification.png)

Note that these three parameters are visible in the rule editor because their placeholders are present in the `Endpoint URL` and the JSON payload.

When the notification is executed, all placeholders will be resolved as follows:

`https://jenkins.example.org/job/atsd-api-test/build`

```json
{
  "parameter": [
    {"name":"timezone", "value":"Etc/UTC"},
    {"name":"run_extra_tests", "value":"false"}
  ]
}
```

If the placeholder is not found, it will be substituted with an empty string.

## Test

In order to test the integration, submit sample data for the `test_m` metric into ATSD. For example, open the **Data> Data Entry** page and submit the following command:

```
  series e:test_e m:test_m=2
```

![](images/rule_test_commands.png)

The value will cause the condition to evaluate to `true`, which in turn will trigger the notification.
To verify that an alert was raised, open **Alerts > Open Alerts** page and check that an alert for the `test_m` metric is present in the **Alerts** table.

![](images/jenkins_alert_open.png)

Check the Jenkins user interface to make sure the target build was triggered.

![](images/jenkins_test.png)
