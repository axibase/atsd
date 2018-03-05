# Portal Functions

## Overview

The `addPortal` function provides a way to attach custom portals to web notifications. For instance, the function can be invoked to attach a portal for an entity other than the entity in the current window.

## Syntax

```javascript
addPortal(string portal)
addPortal(string portal, string entity / List<?> entities)
addPortal(string portal, string entity / List<?> entities, string comment)
addPortal(string portal, string entity / List<?> entities, string comment, [] additionalParams)
```
* [**required**] `portal` - Name of the preconfigured portal. If asterisk `*` is specified, all portals for the given entity will be attached to the notification. If the portal is not found by the specified name, a case-insensitive match without non-alphanumeric characters is used, e.g. 'tcollector - Linux' becomes 'tcollectorlinux' and the function returns the first matching portal.
* `entity` or `entities` - Entities for which the portal will be generated. Required if the portal type is [template](../portals/portals-overview.md#template-portals).
  * `entity` - Entity name `string` is converted to `entity` url parameter (`&entity=test_e`). If entity is not found by name, it's matched by label (case insensitive match).
  * `entities` - `List<?>` are converted to `entities` url parameter as comma-separated list (`&entities=test_e,test_e1,test_e2`). If element type is `Entity`, entity.name would be substituted.
* `comment` - Chart caption. If not specified or empty, default caption is generated as `${portalName} for ${ifEmpty(entity_label, entity)}` and can be retrieved with special placeholder `$caption`. The default comment contains links to the portal, entity and rule for [Email](email.md), [Slack](notifications/slack.md) and [Discord](notifications/discord.md) notifications.
* `additionalParams` - Map with request parameters passed to the template portal.

The parameters may include literal values or window [placeholders](placeholders.md) such as the `entity` or `tag` value.

If `entity` or `portal` cannot be found, the function sends "Entity '`entity`' not found" or "Portal '`portal`' not found" messages instead.

## Supported Endpoints

The function is supported in:

* [Email](email.md)
* [Telegram](notifications/telegram.md)
* [Slack](notifications/slack.md)
* [Discord](notifications/discord.md)
* [Hipchat](notifications/hipchat.md)

Used with other configurations, the function will return an empty string.

## Examples

* Regular portal

```javascript
addPortal('ATSD')
```
![](images/functions-portal-1.png)


* Template Portal for Specific Entity

```javascript
addPortal('Linux nmon', 'nurswgvml007')
```
![](images/functions-portal-2.png)


* Custom Caption

```javascript
addPortal('collectd', 'nurswgvml007', '$caption | <@' + tags.event.user + '>')
```
![](images/functions-portal-3.png)
