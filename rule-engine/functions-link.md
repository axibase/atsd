# Link Functions

## Overview

The functions return URLs to ATSD pages based on the database URL (set the `server.url` property) and the current [window](window.md) context.

The URLs are automatically [inlined](links.md#inline-links) in email notifications and in web notifications that support inline links.

The inline links can be also assembled manually using the syntax supported by the notification channel:
	
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

* [getEntityLink](#getentitylink)
* [getPropertyLink](#getpropertylink)
* [getRuleLink](#getrulelink)
* [getCsvExportLink](#getcsvexportlink)
* [getHtmlExportLink](#gethtmlexportlink)
* [getChartLink](#getchartlink)
* [addLink](#addlink)

### `getEntityLink`

```javascript
  getEntityLink(string e [, boolean m [, string f]]) string
```

Returns the URL to the entity `e` page on the target ATSD instance. The entity name is URL-encoded if necessary.

If match entity parameter `m` is set to `true`, the entity will be matched by label if it's not found by name.

Optional `f` parameter creates an [inline link](links.md#inline-links) in one of supported formats: 'html', 'markdown', and 'pipe' (used by Slack).

Example:

```javascript
getEntityLink('nurswgvml007')
```

The returned link includes path to the entity page on the target database server:

```elm
https://atsd_host:8443/entities/nurswgvml007
```

The above URL could also be assembled manually:

```javascript
serverLink + '/entity/' + urlencode(entity)
```

### `getPropertyLink`

```javascript
  getPropertyLink(string e, string t [, boolean m [, string f]])) string
```

Returns the URL to the property table for entity `e` and property type `t` on the target database server.

If match entity parameter `m` is set to `true`, the entity will be matched by label if it's not found by name.

Optional `f` parameter creates an [inline link](links.md#inline-links) in one of supported formats: 'html', 'markdown', and 'pipe' (used by Slack).

Displayed as the value of type `t` in inline mode.

Example:

```javascript
getPropertyLink('nurswgvml007', 'configuration', false, 'markdown')
```

Returned inline link:

```elm
[configuration](https://atsd_host:8443/entities/nurswgvml007/properties?type=configuration)
```

### `getRuleLink`

```javascript
  getRuleLink([string f]) string
```

Returns the URL to the current rule.

Optional `f` parameter creates an [inline link](links.md#inline-links) in one of supported formats: 'html', 'markdown', and 'pipe' (used by Slack).

Displayed as rule name in inline mode.

### `getCsvExportLink`

```javascript
  getCsvExportLink([string f]) string
```

Returns the URL to the **CSV** file with historical statistics for the current metric, entity, and tags.

Optional `f` parameter creates an [inline link](links.md#inline-links) in one of supported formats: 'html', 'markdown', and 'pipe' (used by Slack).

Displayed as 'CSV Export' link in inline mode.

> Available only in rules with `Series` data type.

### `getHtmlExportLink`

```javascript
  getHtmlExportLink([string f]) string
```

Returns the URL to the **Data > Export** page for the current metric, entity, and tags.

Optional `f` parameter creates an [inline link](links.md#inline-links) in one of supported formats: 'html', 'markdown', and 'pipe' (used by Slack).

Displayed as 'HTML Export' link in inline mode.

> Available only in rules with `Series` data type.

### `getChartLink`

```javascript
  getChartLink([string f]) string
```

Returns the URL to the default portal for the current metric, entity, and tags.

Optional `f` parameter creates an [inline link](links.md#inline-links) in one of supported formats: 'html', 'markdown', and 'pipe' (used by Slack).

Displayed as 'Default' link in inline mode.

> Available only in rules with `Series` data type.

Example:

```javascript
getChartLink('markdown')
```
The following inline link is returned:

```elm
[Default](https://atsd_host:8443/portals/series?metric=docker&entity=nurswgvml007...)
```

### `addLink`

```javascript
  addLink(string l, string u) string
```

Returns the url `u` with a short name `l` based on the current endpoint settings.

If no settings are available, the function returns the original url `u`.

Examples:

* `markdown` (Telegram):

```javascript
addLink('Error Messages', serverLink + '/messages?entity=' + entity)
```

The following inline link is returned:

```markdown
[Error Messages](https://atsd_host:8443/messages?entity=nurswgvml007)
```

* `pipe` (Slack):

```javascript
addLink('Error Messages', serverLink + '/messages?entity=' + entity)
```

The following inline link is returned:

```ls
<https://atsd_host:8443/messages?entity=nurswgvml007|Error Messages>
```

* `html` (Email, HipChat, Discord):

```javascript
addLink('Error Messages', serverLink + '/messages?entity=' + entity)
```

The following inline link is returned:

```html
<a href="https://atsd_host:8443/messages?entity=nurswgvml007">Error Messages</a>
```
