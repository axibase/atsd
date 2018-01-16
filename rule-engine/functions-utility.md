# Utility Functions

## Overview

### `ifEmpty`

```javascript
  ifEmpty(object a, object b) object
```

The function returns `b` if `a` is `null` or an empty string.

Example:

  ```javascript
    /* Returns 2 */  
    ifEmpty(null, 2)
    
    /* Returns hello */  
    ifEmpty('hello', 'world')
  ```
