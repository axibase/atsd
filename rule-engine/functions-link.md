# Link functions

## Overview

Return links contain URLs to ATSD pages based on the current [window](window.md) context and the `server.url` property.

The URLs are automatically [inlined](#inline-links) in email notifications and in web notifications that support inline links.

Can't be used in **Variables**.

## Reference

* [getEntityLink](#getentitylink)
* [getPropertyLink](#getpropertylink)
* [getRuleLink](#getrulelink)
* [getCsvExportLink](#getcsvexportlink)
* [getHtmlExportLink](#gethtmlexportlink)
* [getChartLink](#getchartlink)

### `getEntityLink`

```javascript
  getEntityLink(string e [, boolean m [, string f]]) string
```

Returns the URL to the entity `e` page on the target ATSD instance. The entity name is URL-encoded if necessary.

If match entity parameter `m` is set to true, entity will be matched by label if it's not found by name.

Optional parameter format `f` is one of 'html', 'markdown', and 'pipe' per [inline links](https://github.com/axibase/atsd/blob/master/rule-engine/links.md#inline-links).

Example:

```javascript
getEntityLink('nurswgvml007')
```

The returned link includes path to the entity page on the target ATSD:

```elm
https://atsd_host:8443/entities/nurswgvml007
```

The above URL could be assembled manually:

```javascript
serverLink + '/entity/' + urlencode(entity)
```

### `getPropertyLink`

```javascript
  getPropertyLink(string e, string t [, boolean m [, string f]])) string
```
Returns the URL to the property table for entity `e` and property type `t` on the target ATSD instance.

If match entity parameter `m` is set to true, entity will be matched by label if it's not found by name.

Format `f` is one of 'html', 'markdown', and 'pipe' per [inline links](https://github.com/axibase/atsd/blob/master/rule-engine/links.md#inline-links).

Displayed as type `t` in inline mode.

Example:

```javascript
getPropertyLink('nurswgvml007', 'configuration', false, 'markdown')
```
Returned:

```elm
[configuration](https://atsd_host:8443/entities/nurswgvml007/properties?type=configuration)
```

### `getRuleLink`

```javascript
  getRuleLink([string f]) string
```

Returns link to the current rule.

Optional parameter format `f` is one of 'html', 'markdown', and 'pipe' per [inline links](https://github.com/axibase/atsd/blob/master/rule-engine/links.md#inline-links).

Displayed as rule name in inline mode.

### `getCsvExportLink`

```javascript
  getCsvExportLink([string f]) string
```

Returns link to the **CSV** file with historical statistics for the current metric, entity, and tags.

Optional parameter format `f` is one of 'html', 'markdown', and 'pipe' per [inline links](https://github.com/axibase/atsd/blob/master/rule-engine/links.md#inline-links).

Displayed as 'CSV Export' link in inline mode.

> Available only in rules with `Series` data type.

### `getHtmlExportLink`

```javascript
  getHtmlExportLink([string f]) string
```
Returns link to the **Data > Export** page for the current metric, entity, and tags.

Optional parameter format `f` is one of 'html', 'markdown', and 'pipe' per [inline links](https://github.com/axibase/atsd/blob/master/rule-engine/links.md#inline-links).

Displayed as 'HTML Export' link in inline mode.

> Available only in rules with `Series` data type.

### `getChartLink`

```javascript
  getChartLink([string f]) string
```
Returns link to the default portal for the current metric, entity, and tags.

Optional parameter format `f` is one of 'html', 'markdown', and 'pipe' per [inline links](https://github.com/axibase/atsd/blob/master/rule-engine/links.md#inline-links).

Displayed as 'Default' link in inline mode.

> Available only in rules with `Series` data type.

Example:

```javascript
getChartLink('markdown')
```
Returned:

```elm
[Default](https://atsd_host:8443/portals/series?metric=docker&entity=nurswgvml007...)
```