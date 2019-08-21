# Link Functions

## Overview

These functions return URLs to ATSD pages based on database URL, set the `server.url` property, and the current [window](window.md) context.

URLs are automatically [inlined](links.md#inline-links) for email notifications and webhooks that support inline links.

Alternatively, manually assemble inline links using syntax supported by the webhook target.

* `markdown`

```markdown
[Error Messages](${serverLink}/messages?entity=${entity})
```

* `pipe` (used by Slack)

```ls
<${serverLink}/messages?entity=${entity}|Error Messages>
```

* `html`

```html
<a href="${serverLink}/messages?entity=${entity}">Error Messages</a>
```

## Reference

* [`getEntityLink`](#getentitylink)
* [`getPortalLink`](#getportallink)
* [`getPropertyLink`](#getpropertylink)
* [`getRuleLink`](#getrulelink)
* [`getCsvExportLink`](#getcsvexportlink)
* [`getHtmlExportLink`](#gethtmlexportlink)
* [`getChartLink`](#getchartlink)
* [`addLink`](#addlink)

### `getEntityLink`

```csharp
getEntityLink(string entity [, bool matchLabel [, string format]]) string
```

Returns the URL to the **Entity Editor** page for entity `entity` on the target ATSD instance. The function URL encoded the entity name if necessary.

If the match entity parameter `matchLabel` is set to `true`, the entity is matched by label if it cannot found by name.

Optional `format` parameter creates an [inline link](links.md#inline-links) in one of supported formats: `html`, `markdown`, and `pipe` (used by Slack).

Example:

```javascript
getEntityLink('nurswgvml007')
```

Returns URL to the **Entity Editor** for the specified entity.

```elm
https://atsd_hostname:8443/entities/nurswgvml007
```

Alternatively assemble the above URL manually:

```javascript
serverLink + '/entity/' + urlencode(entity)
```

### `getPropertyLink`

```csharp
getPropertyLink(string entity, string type [, bool matchLabel [, string format]]) string
```

Returns the URL to the property table for entity `entity` and property type `type` on the target database server.

If the match entity parameter `matchLabel` is set to `true`, the entity is matched by label if it cannot be found by name.

Optional `format` parameter creates an [inline link](links.md#inline-links) in one of supported formats: `html`, `markdown`, and `pipe` (used by Slack).

The link name is set to property type `type` in inline mode.

Example:

```javascript
getPropertyLink('nurswgvml007', 'configuration', false, 'markdown')
```

Returned inline link:

```elm
[configuration](https://atsd_hostname:8443/entities/nurswgvml007/properties?type=configuration)
```

### `getPortalLink`

```csharp
getPortalLink(string portalName, string entityName) string
```

Returns the URL to the specified portal for the given entity.

```javascript
getPortalLink('vm-stats', 'nurswgvml007')
```

The link name is set to portal name in inline mode.

### `getRuleLink`

```csharp
getRuleLink([string format]) string
```

Returns the URL to the current rule.

Optional `format` parameter creates an [inline link](links.md#inline-links) in one of supported formats: `html`, `markdown`, and `pipe` (used by Slack).

The link name is set to rule name in inline mode.

### `getCsvExportLink`

```csharp
getCsvExportLink([string format]) string
```

Returns the URL to the **CSV** file with historical statistics for the current metric, entity, and tags.

Optional `format` parameter creates an [inline link](links.md#inline-links) in one of supported formats: `html`, `markdown`, and `pipe` (used by Slack).

The link name is set to **CSV Export** link in inline mode.

:::tip Note
Supported only in rules with `Series` data type.
:::

### `getHtmlExportLink`

```csharp
getHtmlExportLink([string format]) string
```

Returns the URL to the **Data > Export** page for the current metric, entity, and tags.

Optional `format` parameter creates an [inline link](links.md#inline-links) in one of supported formats: `html`, `markdown`, and `pipe` (used by Slack).

Displayed as **HTML Export** link in inline mode.

:::tip Note
Supported only in rules with `Series` data type.
:::

### `getChartLink`

```csharp
getChartLink([string format]) string
```

Returns the URL to the default portal for the current metric, entity, and tags.

Optional `format` parameter creates an [inline link](links.md#inline-links) in one of supported formats: `html`, `markdown`, and `pipe` (used by Slack).

Displayed as **Default** link in inline mode.

:::tip Note
Supported only in rules with `Series` data type.
:::

Example:

```javascript
getChartLink('markdown')
```

The following inline link is returned:

```elm
[Default](https://atsd_hostname:8443/portals/series?metric=docker&entity=nurswgvml007...)
```

### `addLink`

```csharp
addLink(string label, string url) string
```

Returns the URL `url` with a short name `label`, formatted based on the current endpoint settings.

If the endpoint settings are not available, the function returns the original URL `url`.

Examples:

* `markdown` (Telegram):

```javascript
addLink('Error Messages', serverLink + '/messages?entity=' + entity)
```

The following inline link is returned:

```markdown
[Error Messages](https://atsd_hostname:8443/messages?entity=nurswgvml007)
```

* `pipe` (Slack):

```javascript
addLink('Error Messages', serverLink + '/messages?entity=' + entity)
```

The following inline link is returned:

```ls
<https://atsd_hostname:8443/messages?entity=nurswgvml007|Error Messages>
```

* `html` (Email, HipChat, Discord):

```javascript
addLink('Error Messages', serverLink + '/messages?entity=' + entity)
```

The following inline link is returned:

```html
<a href="https://atsd_hostname:8443/messages?entity=nurswgvml007">Error Messages</a>
```
