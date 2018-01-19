# Link functions

## Overview

### `getEntityLink`

```javascript
  getEntityLink(string e) string
```

Returns the URL to the entity `e` page in the target ATSD instance. The entity name is URL-encoded if necessary.

Entity will be matched by label if it's not found by name.

Example:

```javascript
getEntityLink('nurswgvml007')
```

Result, assuming ATSD is listening on `https://atsd_host:8443`:

```elm
https://atsd_host:8443/entities/nurswgvml007
```
