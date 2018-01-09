# Formatting Functions

## Overview

The formatting functions perform conversion according to specified unit or pattern.

## Reference

* [convert](#convert)
* [formatNumber](#formatnumber)

### `convert`

```javascript
  convert(double x, string s) double
```

Convert value to given unit, where unit is one of 'k', 'Ki', 'M', 'Mi', 'G', 'Gi'.

Example: 

`convert(20480, 'Ki')` returns to `20.0`

### `formatNumber`

```javascript
  formatNumber(double x, string s) double
```

Format given number by applying specified DecimalFormat pattern.

Example:
 
`formatNumber(3.14159, '#.##')` returns to `'3.14'

