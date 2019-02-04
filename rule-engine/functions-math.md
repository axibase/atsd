# Math Functions

## Overview

These functions perform basic numeric operations on the input number and return a number as the result.

## Reference

* [`abs`](#abs)
* [`ceil`](#ceil)
* [`floor`](#floor)
* [`pow`](#pow)
* [`round`](#round)
* [`max`](#max)
* [`min`](#min)
* [`mod`](#mod)
* [`cbrt`](#cbrt)
* [`sqrt`](#sqrt)
* [`exp`](#exp)
* [`log`](#log)
* [`log10`](#log10)
* [`signum`](#signum)

## `abs`

```csharp
abs(double x) double
```

Returns the absolute value of `x`.

## `ceil`

```csharp
ceil(double x) long
```

Returns the smallest integer that is greater than or equal to `x`.

## `floor`

```csharp
floor(double x) long
```

Returns the largest integer that is less than or equal to `x`.

## `pow`

```csharp
pow(double x, double y) double
```

Returns `x` raised to the power of `y`.

## `round`

```csharp
round(double x[, int y]) long
```

Returns `x` rounded to `y` decimal places (precision).

The precision is `0` if omitted.

`round(x, 0)` rounds the number to the nearest integer.

If `y` is less than `0`, the number is rounded to the left of the decimal point by the indicated number of places.

## `max`

```csharp
max(double x, double y) double
```

Returns the greater of two numbers: `x` and `y`.

## `min`

```csharp
min(double x, double y) double
```

Returns the smallest of two numbers: `x` and `y`.

## `mod`

```csharp
min(number x, number y) double
```

Returns the remainder (modulus) of number `x` divided by number `y`.

This function provides an alternative to `x % y` syntax which is **not** supported.

## `cbrt`

```csharp
cbrt(double x) double
```

<!-- markdownlint-disable MD101 -->
Returns cube root ∛ of `x`.
<!-- markdownlint-enable MD101 -->

## `sqrt`

```csharp
sqrt(double x) double
```

Returns `√` of `x`.

## `exp`

```csharp
exp(double x) double
```

Returns Euler constant `e` (2.718281828459045) raised to the power of `x`.

## `log`

```csharp
log(double x) double
```

Returns the natural logarithm (base `e = 2.718281828459045`) of `x`.

## `log10`

```csharp
log10(double x) double
```

Returns the base 10 logarithm of `x`.

## `signum`

```csharp
signum(double x) int
```

Returns the `signum` function of the argument: `0` if the argument is `0`, `1` if the argument is greater than `1`, `-1` if the argument is less than `0`.