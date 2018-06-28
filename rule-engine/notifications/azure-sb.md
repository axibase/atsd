# Azure Service Bus Webhook

## Overview

`AZURE SB` [webhook](../notifications/README.md) sends messages to an [Azure Service Bus](https://docs.microsoft.com/en-us/rest/api/servicebus/send-message-to-queue) queue or topic upon window status events.

## Webhook Settings

|**Setting**|**Description**|
|---|---|
|Key Name|The authorization rule key name.|
|Primary Key|The primary key for the authorization rule.|
|Headers|Custom request headers|
|Service Bus Namespace|The name of the Service Bus namespace.|
|Queue/Topic|The default queue or topic you want to publish messages to.|
|Path Parameters| The encoded path parameters.|
|Message|The default text of the message to be sent.|

## Message

Each window status event can produce only one message.

The message is submitted to the specified Azure SB endpoint using the `POST` method with `application/atom+xml;type=entry;charset=utf-8` content type. The request uses [SAS authentication](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-sas).

The default message includes all fields, including entity and metric metadata.

## Response

The response status code and response content is recorded in `atsd.log` if the **Log Response** setting is enabled.

## Placeholders

[Placeholders](../placeholders.md) are supported in the request parameter values.

Placeholders are substituted with actual field values when the request is initiated.

If the placeholder does not exist, the placeholder is substituted with an empty string.

## Examples

* [Send a message to a Service Bus queue](azure-sb-message.md)
* [Send a new event to an Event Hub](azure-sb-event.md)
