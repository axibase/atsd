# Math Functions

## Overview

Math functions perform basic numeric operations on the input number and return a number as the result.

## Reference

* [abs](#abs)
* [ceil](#ceil)
* [floor](#floor)
* [pow](#pow)
* [round](#round)
* [max](#max)
* [min](#min)
* [cbrt](#cbrt)
* [sqrt](#sqrt)
* [exp](#exp)
* [log](#log)
* [log10](#log10)
* [signum](#signum)

### `abs`

```javascript
  abs(double x) double
```

Returns the absolute value of `x`.

### `ceil`

```javascript
  ceil(double x) long
```

Returns the smallest integer that is greater than or equal to `x`.

### `floor`

```javascript
  floor(double x) long
```

Returns the largest integer that is less than or equal to `x`.

### `pow`

```javascript
  pow(double x, double y) double
```

Return `x` raised to the power of `y`.

### `round`

```javascript
  round(double x[, int y]) long
```

Returns `x` rounded to `y` decimal places (precision). 

The precision is 0 if omitted.

`round(x, 0)` rounds the number to the nearest integer.

If `y` is less than 0, the number is rounded to the left of the decimal point by the indicated number of places.

### `max`

```javascript
  max(double x, double y) double
```

Returns the greater of two numbers: `x` and `y`.

### `min`

```javascript
  min(double x, double y) double
```

Returns the smallest of two numbers: `x` and `y`.

### `cbrt`

```javascript
  cbrt(double x) double
```

Returns the cube root of `x`. 

### `sqrt`

```javascript
  sqrt(double x) double
```

Returns the square root of `x`.

### `exp`

```javascript
  exp(double x) double
```

Returns Euler's constant `e` (2.718281828459045) raised to the power of `x`.

### `log`

```javascript
  log(double x) double
```

Returns the natural logarithm (base `e` = 2.718281828459045) of `x`.

### `log10`

```javascript
  log10(double x) double
```

Returns the base 10 logarithm of `x`.

### `signum`

```javascript
  signum(double x) integer
```

Returns the signum function of the argument: `0` if the argument is `0`, `1` if the argument is greater than `1`, `-1` if the argument is less than `0`.

 	





