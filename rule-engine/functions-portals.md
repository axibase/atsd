# Portal Functions

## Overview

The `addPortal` function provides a way to enrich notifications with any predefined portals, if the web service configuration supports sending screenshots.

## Common Use Cases

* Generate a portal for entity outside of current window context
* Supply portal screenshot with significant description

## Syntax

```java
addPortal(String portalName)
addPortal(String portalName, String entity)
addPortal(String portalName, String entity, S comment)
addPortal(String portalName, String entity, S comment, Map additionalParams)
```

* [**required**] `portalName` - Name of the preconfigured portal. If asterisk (*) is specified, all portals for the given entity will be attached to notification.
* `entity` - entity for which the portal will be generated. Required if the portal type is template.
* `comment` - provide a description for the chart. If not specified or empty, default comment is generated as `${portalName} for ${ifEmpty(entity_label, entity)}` 
* `additionalParams` - a map to be provided to portal configuration template.

The parameters may include literal values or window [placeholders](placeholders.md) such as the `entity` or `tag` value.

## Supported endpoints

The function is supported by following configurations:
* [Email](email.md)
* [Telegram](notifications/telegram.md)
* [Slack](notifications/slack.md)
* [Discord](notifications/discord.md)
* [Hipchat](notifications/hipchat.md)

Used with other configurations, the function will evaluate to an empty string.
