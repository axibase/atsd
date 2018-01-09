# Text Functions

## Overview

The functions transform or compare strings.

The functions return `null` or `false` if one of the inputs is `null`.

The functions return a new string with the original input string left unchanged.

## Reference

* [upper](#upper)
* [lower](#lower)
* [truncate](#truncate)
* [contains](#contains)
* [startsWith](#startsWith)
* [endsWith](#endsWith)
* [coalesce](#coalesce)
* [urlencode](#urlencode)
* [jsonencode](#jsonencode)

### `upper`

```javascript
  upper(string s) string
```

Converts `s` to upper case.

### `lower`

```javascript
  lower(string s) string
```

Converts `s` to lower case.

### `truncate`

```javascript
  truncate(string s, integer i) string
```

If `s` length exceeds `i` characters, truncates `s` to the specified number of characters and returns it as a result.

### `contains`

```javascript
  truncate(string s, string w) boolean
```

Returns `true` if `s` contains `w`.

### `startsWith`

```javascript
  startsWith(string s, string w) boolean
```

Returns `true` if `s` starts with `w`.

### `endsWith`

```javascript
  endsWith(string s, string w) boolean
```

Returns `true` if `s` ends with `w`.

### `coalesce`

```javascript
  coalesce([string] c) string
```

Returns first non-empty string from the collection (array) of strings `c`. The function returns an empty string if all elements of `c` are null or empty.

Examples:

  * Returns 'string-3'.

  ```java
    coalesce(['', null, 'string-3'])
  ```

  * Returns `tags.location` if it is not empty and not `null`, otherwise 'SVL' will be returned.

  ```java
    coalesce([tags.location, 'SVL'])
  ```

  * Returns a non-empty tag.

  ```java
    coalesce([entity.label, entity])
  ```

  Returns the value of the `entity.label` placeholder if it is not an empty string, otherwise the value of the `entity` placeholder will be returned.
  If both placeholders are empty, then an empty string is returned.

### `urlencode`

```javascript
  urlencode(string s) string
```

Encodes `s` into the URL format by replacing unsafe characters with "%" followed by 2 digits.

### `jsonencode`

```javascript
  jsonencode(string s) string
```

Escapes special symbols such as double-quote with backslash to safely use the input string within a JSON object.
