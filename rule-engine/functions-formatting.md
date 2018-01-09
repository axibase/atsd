# Formatting Functions

## Overview

The functions format numbers to strings according to the specified pattern.

## Reference

* [convert](#convert)
* [formatNumber](#formatnumber)

### `convert`

```javascript
  convert(double x, string s) string
```

Divides number `x` by the specified measurement unit `s`: 

* 'k' (1000)
* 'Ki' (1024)
* 'M' (1000^2)
* 'Mi' (1024^2)
* 'G' (1000^3)
* 'Gi' (1024^3)

Example: 

  ```javascript
    convert(20480, 'Ki')
    //returns 20.0
  ```

### `formatNumber`

```javascript
  formatNumber(double x, string s) string
```

Formats number `x` according to the specified [DecimalFormat](https://docs.oracle.com/javase/7/docs/api/java/text/DecimalFormat.html) pattern `s` using the default database locale.

Example:
 
  ```
    formatNumber(3.14159, '#.##')
        //returns 3.14
  ```
