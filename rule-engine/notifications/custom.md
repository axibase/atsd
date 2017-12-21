# Custom Notification

## Overview

The `CUSTOM` [notification](../web-notifications.md) provides a flexible mechanism to integrate the ATSD rule engine with external HTTP services.

The integration enables sending HTTP requests with customized content to the specified HTTP endpoint on window status events.

## Examples

* Register service incident in [PagerDuty](custom-pagerduty.md)
* Update [Github issue](custom-github.md)
* Post comment to [Zendesk ticket](custom-zendesk.md)
* Send SMS message via [IFTTT](custom-ifttt.md)
* Trigger [CircleCI project build](custom-circlecpi.md)
* Start [Jenkins job](custom-jenkins.md)

## Supported HTTP Methods

| Method | Payload Allowed |
|---|---|
| GET | No |
| HEAD | No |
| POST | Yes |
| PUT | Yes |
| PATCH | Yes |
| DELETE | No |

## Supported Content Types

* `application/json`
* `application/x-www-form-urlencoded`

If the selected HTTP method such as `GET` doesn't allow payload, the request parameters specified in the Parameters section are appended to the Endpoint URL a a query string.

## Supported Authentication Mechanisms

| Type | Description |
|---|---|
| Basic | User name and password are sent as base64 encoded text. |

For other token-based authentication mechanisms, add a request header containing the token.

```ls
Authorization: Token OAUTH-TOKEN
```

```ls
Authorization: Bearer YOUR_JWT
```

![](images/custom-token.png)

## Placeholders

The [placeholders](../placeholders.md) are supported in the Endpoint URL, request parameter names and values, request headers, and the payload content.

The placeholders are substituted with actual field values when the request is initiated.

If the placeholder doesn't exist, it is substituted with an empty string.

Placeholder values are automatically URL-encoded if they're included in the request URL.

## Parameters

The parameters section is displayed when the content type is set to `application/x-www-form-urlencoded`.

If the checkbox on the left is disabled, the parameter is fixed and cannot be modified in the rule editor.

Otherwise, if the checkbox enabled, the parameter will be displayed on the 'Web Notifications' tab in the rule editor.

Both fixed and editable parameter values can include placeholders.

![](images/custom_editable.png)

![](images/custom-editable-editor.png)

## Example

![](images/custom-json.png)
