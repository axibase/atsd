# AWS API Notification

## Overview

`AWS API` [notifications](../web-notifications.md) integrate the ATSD rule engine with [Amazon Web Services] (https://aws.amazon.com/) that support HTTP or HTTPs protocol.

## Notification Settings

|**Setting**|**Description**|
|---|---|
|Endpoint URL|AWS url|
|Method|The HTTP method|
|Access Key Id|[Access Key Id](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys)|
|Secret Access Key|[Secret Access Key](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys)|
|Action|The service action|

## Supported HTTP Methods

| Method | Payload Allowed |
|---|---|
| GET | No |
| HEAD | No |
| POST | Yes |
| PUT | Yes |
| PATCH | Yes |
| DELETE | No |

## Request

Each window status event can produce only one AWS request.

The request is submitted to the specified AWS endpoint using the selected method with `application/x-www-form-urlencoded` content type. The request includes additional AWS headers (`Authorization`, `X-Amz-Date`) and is signed with [AWS Signature Version 4](https://docs.aws.amazon.com/general/latest/gr/signature-version-4.html).

## Response

The response status code and response content are recorded in `atsd.log` if the `Log Response` setting is enabled.

## Placeholders

[Placeholders](../placeholders.md) are supported in the Endpoint URL, request parameter names, and values.

Placeholders are substituted with actual field values when the request is initiated.

If the placeholder doesn't exist, it is substituted with an empty string.

Placeholder values are automatically URL-encoded if they're included in the request URL.

## Parameters

If the checkbox on the left is disabled, the parameter is fixed and cannot be modified in the rule editor.

Otherwise, if the checkbox enabled, the parameter will be displayed on the 'Web Notifications' tab in the rule editor.

Both fixed and editable parameter values can include placeholders.

## Examples

* [Integration with Amazon CWE](aws-api-cwe.md)
* [Integration with Amazon SES](aws-api-ses.md)
* [Integration with Amazon SQS](aws-api-sqs.md)
* [Integration with AWS Batch](aws-api-batch.md)
