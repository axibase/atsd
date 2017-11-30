# CircleCI Integration

## Overview

The following documentation demonstrates starting CircleCI build using [CircleCI API](https://circleci.com/docs/api/v1-reference/) and ATSD custom web notifications.

[Documentation](https://circleci.com/docs/api/v1-reference/#new-build-branch) for method used in tutorial.

Web notification and rule configuration can be imported from following xml files

## Configuration

You can import prepared web notification configuration from this [file](resources/custom-circleci-notification.xml)

Replace `<CIRCLE_USER_TOKEN>` in Endpoint URL with CircleCI user token and `<GITHUB_USER>` with github user name.

Endpoint URL should looks like `https://circleci.com/api/v1.1/project/github/axibase/${project_name}/tree/${branch}?circle-token=462089cad85044e9823a07b19f4cc1d33ba527bb`


| Parameter | Value |
| :-------- | :---- |
| Method | POST  |
| Content Type | application/json |
| Endpoint URL | `https://circleci.com/api/v1.1/project/github/<GITHUB_USER>/${project_name}/tree/${branch}?circle-token=<CIRCLE_USER_TOKEN>` |
| Headers | Accept: application/json |

Body:

```
{
  "parallel": ${parallel},
  "build_parameters": { 
    "RUN_EXTRA_TESTS": ${run_extra_tests}
  }
}
```

![](images/circle_endpoint.png)

## Rule

You can import prepared rule configuration from this [file](resources/custom-circleci-rule.xml)

Base test rule settings:

| Parameter | Value |
| :-------- | :---- |
| Metric | test_m |
| Condition | value > 1 |

![](images/circle_rule_overview.png)

Enable **Web Notifications**

Enable **Open** and **Repeat**, set **Repeat Interval** to **All**

Set same settings for **Open** and **Repeat**:

| Parameter | Value |
| :-------- | :---- |
| branch | master |
| parallel | 4 |
| project_name | atsd-api-java |
| run_extra_tests  | true |


![](images/circle_rule_notification.png)

## Test

In order to test rule, open and close it using following series commands:

```
series e:test_e m:test_m=2
```

![](images/rule_test_commands.png)

Ensure that your build has been started at CircleCI

![](images/circle_test.png)