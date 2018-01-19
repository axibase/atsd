# Link functions

## Overview

### `getEntityLink`

```javascript
  getEntityLink(string e) string
```

Returns the URL to the entity `e` page on the target ATSD instance. The entity name is URL-encoded if necessary.

Entity will be matched by label if it's not found by name.

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
