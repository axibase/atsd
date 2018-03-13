# Text Functions

## Overview

These functions transform and compare strings.

These functions return `null` or `false` if one of the inputs is `null`.

These functions return a new string and the unaltered input string.

## Reference

* [upper](#upper)
* [lower](#lower)
* [truncate](#truncate)
* [startsWith](#startsWith)
* [endsWith](#endsWith)
* [split](#split)
* [list](#list)
* [coalesce](#coalesce)
* [keepAfter](#keepafter)
* [keepAfterLast](#keepafterlast)
* [keepBefore](#keepbefore)
* [keepBeforeLast](#keepbeforelast)
* [replace](#replace)
* [capFirst](#capfirst)
* [capitalize](#capitalize)
* [removeBeginning](#removebeginning)
* [removeEnding](#removeending)
* [urlencode](#urlencode)
* [jsonencode](#jsonencode)
* [htmlDecode](#htmldecode)
* [unquote](#unquote)
* [countMatches](#countmatches)
* [abbreviate](#abbreviate)
* [indexOf](#indexof)
* [locate](#locate)
* [trim](#trim)
* [length](#length)

### `upper`

```javascript
  upper(string s) string
```

Converts `s` to uppercase letters.

### `lower`

```javascript
  lower(string s) string
```

Converts `s` to lowercase letters.

### `truncate`

```javascript
  truncate(string s, integer i) string
```

If `s` length exceeds `i` characters, this function truncates `s` to the specified number of characters and returns it as the result.

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

Splits `s` into a collection of strings using separator `p`. Quotation marks (`"escaped_text"`) are used as escape characters.

Example:

  * Returns ['Hello', 'brave new world']

  ```javascript
    split('hello "brave new world"', ' ')
  ```
  
To check the size of the collection, use the `.size()` method.

To access the n-th element in the collection, use square brackets `[index]` or `get(index)` method (starting with 0 for the first element).

  ```javascript
    authors = split(tags.authors, ',')
    authors.size() == 0 ? 'n/a' : authors[0]
  ```

### `list`

```javascript
  list(string s[, string p]) [string]
```

Splits string `s` using separator `p` (default is comma ',') into an array of string values. The function discards duplicate items by preserving only the first occurrence of each element. 

Unlike the `split()` function, `list()` doesn't handle quotes, but treats them as regular characters.

Example:

```javascript
  /* Returns ['hello', '"brave', 'new', 'world"'] */
  list('hello "brave new world" hello', ' ')
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

Returns the value of the `entity.label` field if it is not an empty string, otherwise the value of the `entity` field will be returned.
If both fields are empty, an empty string is returned.

### `keepAfter`

```javascript
  keepAfter(string s, string p) string
```

Removes part of the string `s` before the first occurrence of the given substring `p`. 

If the parameter string `p` is empty `''`/ null / not found, it will return the original string `s` unchanged.

Example:

```javascript
  /* Returns "cabc" */
  keepAfter("abcabc", "b") 
```

### `keepAfterLast`

```javascript
  keepAfterLast(string s, string p) string
```

Removes part of the string `s` before the last occurrence of the given substring `p`.

If the parameter string `p` is empty `''`/ null / not found, it will return the original string `s` unchanged.

Example:

```javascript
  /* Returns "c" */
  keepAfterLast("abcabc", "b") 
```

### `keepBefore`

```javascript
  keepBefore(string s, string p) string
```
Removes part of the string `s` that starts with the first occurrence of the given substring `p`.

If the parameter string `p` is empty `''`/ null / not found, the function will return the original string `s` unchanged.

Example:

```javascript
  /* Returns "a" */
  keepBefore("abcabc", "b") 
```

### `keepBeforeLast`

```javascript
  keepBeforeLast(string s, string p) string
```
Removes part of the string `s` that starts with the last occurrence of the given substring `p`.

If the parameter string `p` is empty `''`/ null / not found, it will return the original string `s` unchanged.

Example:

```javascript
  /* Returns "abca" */
  keepBeforeLast("abcabc", "b") 
```

### `replace`

```javascript
  replace(string s, string p, string r) string
```
Replace all occurrences of the given string `p` in the original string `s` with another string `r`.

If the `p` parameter is empty `''`/ null / not found, the function will return the original string `s` unchanged.

Examples:

```javascript
  /* Returns "adcadc" */
  replace("abcabc", "b", "d")
```

### `capFirst`

```javascript
  capFirst(string s) string
```
Capitalizes the first letter in the string.

Example:

```javascript
  /* Returns "AbC abC abC" */
  capFirst("abC abC abC")
```

### `capitalize`

```javascript
  capitalize(string s) string
```
Capitalizes the first letter of all words in the string.

Example:

```javascript
  /* Returns "Abc Abc Abc" */
  capitalize("abC abC abC")
```

### `removeBeginning`

```javascript
  removeBeginning(string s, string r) string
```
Removes the given substring `r` from the beginning of the string `s`.

Examples:

```javascript
  /* Returns "bcabc" */
  removeBeginning("abcabc", "a")
  
  /* Returns "abcabc" */
  removeBeginning("abcabc", "b")
```

### `removeEnding`

```javascript
  removeEnding(string s, string r) string
```
Removes the given substring `r` from the end of the string `s`.

Examples:

```javascript
  /* Returns "abca" */
  removeEnding("abcabc", "bc")
  
  /* Returns "abcabc" */
  removeEnding("abcabc", "ab")
```

### `urlencode`

```javascript
  urlencode(string s) string
```

Encodes `s` into URL format by replacing unsafe characters with "%" followed by 2 digits.

### `jsonencode`

```javascript
  jsonencode(string s) string
```

Escapes special symbols such as double-quotes with a backslash to safely use the input string within a JSON object.

### `htmlDecode`

```javascript
  htmlDecode(string s) string
```
Returns a new string with HTML entities in string `s`, replaced with the corresponding characters.

Example:

```javascript
  /* Returns 'World > city' */
  htmlDecode("World &gt; city")
```

### `unquote`

```javascript
  unquote(string s) string
```

Removes leading and trailing double and single quotation marks from the string `s`.

Example:

```javascript
  /* Returns 'Hello, Brave New World!' */ 
  unquote('"Hello, Brave New World!"')
```  

### `countMatches`

```javascript
  countMatches(string s, string p) int
```
Counts how many times the substring `p` appears in input string `s`.

Example:

```javascript
  /* Return 2 */
  countMatches("abba", "a")
```

### `abbreviate`

```javascript
  abbreviate(string s, integer n) string
```

Abbreviates string `s` using ellipses in order to truncate extraneous text. `n` is the desired length of the result string. The minimum length of any result string is 4 characters: 1 in string `s` plus 3 as ellipses (`...`). Input parameter integer must be `n` >= 4 otherwise an IllegalExceptionError will be thrown.

Examples:

```javascript
  /* Returns "abc..." */
  abbreviate("abcdefg", 6)
  
  /* Returns "abcd..." */
  abbreviate("abcdefghi", 7)
  
  /* IllegalArgumentException */
  abbreviate("abcdefg", 3)  
```

### `indexOf`

```javascript
  indexOf(string s, string p[, int i]) integer
```

Returns non-negative index starting with 0 of the first occurrence of substring `p` contained in the string `s` starting with index `i`.

If the substring `p` is not found, `-1` is returned.

Examples:

```javascript
  /* Returns 1 */
  indexOf("abcabc", "b")
  
  /* Returns -1 */
  indexOf("abcabc", "z")
  
  /* Returns 4 */
  indexOf("abcabc", "b", 2) 
  
  /* Returns -1 */
  indexOf("abcabc", "a", 4) 
```

### `locate`

```javascript
  locate(string s, string p[, int i]) integer
```

Same as `indexOf()`.

### `trim`

```javascript
  trim(string s) string
```

Removes leading and trailing non-printable characters.

### `length`

```javascript
  length(string s) string
```

Returns length of the string `s`. If the `s` is null, returns -1.
