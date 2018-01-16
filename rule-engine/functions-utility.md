# Utility Functions

## Overview

### `ifEmpty`

```javascript
  ifEmpty(object f, object s) object
```

Returns the 2nd argument if the 1st is null or empty string.

Example:

  ```javascript
    /* Returns 2 */  
    ifEmpty(null, 2)
    
    /* Returns 1 */  
    ifEmpty(1, 2)
  ```
