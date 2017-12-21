# AWS API Notification

## Overview

The `AWS API` [notification](../web-notifications.md) provides a way to integrate the ATSD rule engine with [Amazon Web Service](https://aws.amazon.com/) that supports the HTTP or HTTPs protocol.

## Notification Settings

|**Setting**|**Description**|
|---|---|
|Endpoint URL|The service url|
|Method|The HTTP method|
|Access Key Id|[Access Key Id](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys)|
|Secret Access Key|[Secret Access Key](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys)|
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

The request is submitted to the specified AWS endpoint using the selected method with `application/x-www-form-urlencoded` content type. The request includes additional AWS headers (Authorization, X-Amz-Date) and is signed with [AWS Signature Version 4](http://docs.aws.amazon.com/general/latest/gr/signature-version-4.html).

## Response

The response status code and response content is recorded in `atsd.log` if the `Log Response` setting is enabled.

## Placeholders

The [placeholders](../placeholders.md) are supported in the Endpoint URL, request parameter names and values.

The placeholders are substituted with actual field values when the request is initiated.

If the placeholder doesn't exist, it is substituted with an empty string.

Placeholder values are automatically URL-encoded if they're included in the request URL.

## Parameters

If the checkbox on the left is disabled, the parameter is fixed and cannot be modified in the rule editor.

Otherwise, if the checkbox enabled, the parameter will be displayed on the 'Web Notifications' tab in the rule editor.

Both fixed and editable parameter values can include placeholders.

## Examples

* [Integration with SQS](aws-api-sqs.md)