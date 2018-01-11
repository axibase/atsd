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
* [split](#split)
* [coalesce](#coalesce)
* [urlencode](#urlencode)
* [jsonencode](#jsonencode)
* [keepAfter](#keepafter)
* [keepAfterLast](#keepafterlast)
* [keepBefore](#keepbefore)
* [keepBeforeLast](#keepbeforelast)
* [replace](#replace)
* [capFirst](#capfirst)
* [capitalize](#capitalize)
* [removeBeginning](#removebeginning)
* [removeEnding](#removeending)

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
  contains(string s, string w) boolean
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

### `split`

```javascript
  split(string s, string p) [string]
```

Splits `s` into an array of strings using separator `p` while treating double quote as an escape character.

Examples:

  * Returns ['Hello', 'brave new world']

  ```java
    split('hello "brave new world"', ' ')
  ```

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

### `keepAfter`

```javascript
  keepAfter(string s, string p) string
```

Removes part of the string `s` before the first occurrence of the given substring `p`.

Example:

```javascript
  /* Return "cabc" */
  keepAfter("abcabc", "b") 
```

### `keepAfterLast`

```javascript
  keepAfterLast(string s, string p) string
```

Removes part of the string `s` before the last occurrence of the given substring `p`.

Example:

```javascript
  /* Return "c" */
  keepAfterLast("abcabc", "b") 
```

### `keepBefore`

```javascript
  keepBefore(string s, string p) string
```
Removes part of the string `s` that starts with the first occurrence of the given substring `p`.

Example:

```javascript
  /* Return "a" */
  keepBefore("abcabc", "b") 
```

### `keepBeforeLast`

```javascript
  keepBeforeLast(string s, string p) string
```
Removes part of the string `s` that starts with the last occurrence of the given substring `p`.

Example:

```javascript
  /* Return "abca" */
  KeepBeforeLast("abcabc", "b") 
```

### `replace`

```javascript
  replace(string s, string p, string r) string
```
Replace all occurrences of the given string `p` in the original string `s` with another string `r`.

Example:

```javascript
  /* Return "adcadc" */
  replace("abcabc", "b", "d")
```

### `capFirst`

```javascript
  capFirst(string s) string
```
Capitalize first word.

Example:

```javascript
  /* Return "AbC abC abC" */
  capFirst("abC abC abC")
```

### `capitalize`

```javascript
  capitalize(string s) string
```
Capitalize all words.

Example:

```javascript
  /* Return "Abc Abc Abc" */
  capitalize("abC abC abC")
```

### `removeBeginning`

```javascript
  removeBeginning(string s, string r) string
```
Removes the given substring `r` from the beginning of the string `s`.

Examples:

```javascript
  /* Return "bcabc" */
  removeBeginning("abcabc", "a")
  
  /* Return "abcabc" */
  removeBeginning("abcabc", "b")
```

### `removeEnding`

```javascript
  removeEnding(string s, string r) string
```
Removes the given substring `r` from the end of the string `s`.

Examples:

```javascript
  /* Return "abca" */
  removeEnding("abcabc", "bc")
  
  /* Return "abcabc" */
  removeEnding("abcabc", "ab")
```
