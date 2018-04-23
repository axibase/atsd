# Text Functions

## Overview

Text functions compare and transform strings.

The functions are `null`-safe - they return `null` or `false` if one of the inputs is `null`.

## Reference

* [`upper`](#upper)
* [`lower`](#lower)
* [`truncate`](#truncate)
* [`startsWith`](#startsWith)
* [`endsWith`](#endsWith)
* [`split`](#split)
* [`list`](#list)
* [`coalesce`](#coalesce)
* [`keepAfter`](#keepafter)
* [`keepAfterLast`](#keepafterlast)
* [`keepBefore`](#keepbefore)
* [`keepBeforeLast`](#keepbeforelast)
* [`replace`](#replace)
* [`capFirst`](#capfirst)
* [`capitalize`](#capitalize)
* [`removeBeginning`](#removebeginning)
* [`removeEnding`](#removeending)
* [`urlencode`](#urlencode)
* [`jsonencode`](#jsonencode)
* [`htmlDecode`](#htmldecode)
* [`unquote`](#unquote)
* [`countMatches`](#countmatches)
* [`abbreviate`](#abbreviate)
* [`indexOf`](#indexof)
* [`locate`](#locate)
* [`trim`](#trim)
* [`length`](#length)
* [`concat`](#concat)
* [`concatLines`](#concatlines)

### `upper`

```javascript
  upper(string s) string
```

Converts string `s` to uppercase letters.

### `lower`

```javascript
  lower(string s) string
```

Converts string `s` to lowercase letters.

### `truncate`

```javascript
  truncate(string s, integer i) string
```

If string `s` length exceeds `i` characters, this function truncates `s` to the specified number of characters and returns it as the result.

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

Splits string `s` into a collection of strings using separator `p`.

```javascript
    // Returns ['Hello', 'world']
    split('Hello world', ' ')
```

Use double quotes (`"escaped_text"`) as escape characters.

```javascript
    // Returns ['Hello', 'new world']
    split('hello "new world"', ' ')
```

To check the size of the returned collection, use the `.size()` method.

To access the n-th element in the collection, use square brackets `[index]` or `get(index)` method (starting with `0` for the first element).

```javascript
    authors = split(tags.authors, ',')
    authors.size() == 0 ? 'n/a' : authors[0]
```

### `list`

```javascript
  list(string s[, string p]) [string]
```

Splits string `s` using separator `p` (default is comma ',') into an array of string values. The function discards duplicate items by retaining only the first occurrence of each element.

Unlike the `split()` function, `list()` doesn't support double quotes as escape characters.

Example:

```javascript
  // Returns ['hello', '"brave', 'new', 'world"']
  list('hello "brave new world" hello', ' ')
```

### `coalesce`

```javascript
  coalesce([string] c) string
```

Returns first non-empty string from the collection or array of strings `c`. 

The function returns an empty string if all elements of `c` are null or empty.

Examples:

```javascript
    // Returns 'string-3'.
    coalesce(['', null, 'string-3'])
```

```javascript
    // Returns the value of `location` tag if it is a non-empty string, otherwise 'SVL' is returned.
    coalesce([tags.location, 'SVL'])
```

```javascript
    /*
    Returns the value of the entity label if it is a non-empty string, otherwise the entity name is returned.
    If both fields are empty, an empty string is returned.
    */
    coalesce([entity.label, entity])
```

### `keepAfter`

```javascript
  keepAfter(string s, string p) string
```

Removes part of the string `s` before the first occurrence of the given substring `p`.

If `p` is empty or `null` or if it's not found, the function will return the original string `s` unchanged.

Example:

```javascript
  // Returns 'new.world'
  keepAfter("hello.new.world", ".")
```

### `keepAfterLast`

```javascript
  keepAfterLast(string s, string p) string
```

Removes the part of string `s` before the last occurrence of the given substring `p`.

If `p` is empty, `null`, or unable to be found, the function will return the original string `s` unchanged.

Example:

```javascript
  // Returns 'world'
  keepAfterLast("hello.new.world", ".")
```

### `keepBefore`

```javascript
  keepBefore(string s, string p) string
```

Removes part of the string `s` that starts with the first occurrence of the given substring `p`.

If `p` is empty, `null`, or unable to be found, the function will return the original string `s` unchanged.

Example:

```javascript
  // Returns 'hello'
  keepBefore("hello.new.world", ".")
```

### `keepBeforeLast`

```javascript
  keepBeforeLast(string s, string p) string
```

Removes part of the string `s` that starts with the last occurrence of the given substring `p`.

If `p` is empty, `null`, or unable to be found, the function will return the original string `s` unchanged.

Example:

```javascript
  // Returns 'hello.new'
  keepBeforeLast("hello.new.world", ".")
```

### `replace`

```javascript
  replace(string s, string p, string r) string
```

Replaces all occurrences of the given substring `p` in the original string `s` with a second substring `r`.

If `p` is empty, `null`, or unable to be found, the function will return the original string `s` unchanged.

Examples:

```javascript
  // Returns 'hello.ne2.2orld'
  replace("hello.new.world", "w", "2")
```

### `capFirst`

```javascript
  capFirst(string s) string
```

Capitalizes the first letter in the string.

Example:

```javascript
  // Returns 'Hello world'
  capFirst("hello world")
```

### `capitalize`

```javascript
  capitalize(string s) string
```

Capitalizes the first letter in all words in the string.

Example:

```javascript
  // Returns 'Hello World'
  capitalize("hello world")
```

### `removeBeginning`

```javascript
  removeBeginning(string s, string r) string
```

Removes substring `r` from the beginning of string `s`.

Examples:

```javascript
  // Returns 'llo world'
  removeBeginning("hello world", "he")
```

```javascript
  // Returns 'hello world'
  removeBeginning("hello world", "be")
```

### `removeEnding`

```javascript
  removeEnding(string s, string r) string
```

Removes given substring `r` from the end of string `s`.

```javascript
  // Returns 'hello wor'
  removeEnding("hello world", "ld")
```

```javascript
  // Returns 'hello world'
  removeEnding("hello world", "LD")
```

### `urlencode`

```javascript
  urlencode(string s) string
```

Replaces special characters in string `s` with URL-safe characters using percent-encoding ("%" followed by 2 digits).

```javascript
  // Returns 'hello%20world'
  urlencode("hello world")
```

### `jsonencode`

```javascript
  jsonencode(string s) string
```

Escapes special JSON characters in string `s` such as double quotes with a backslash to safely include the string within a JSON object.

### `htmlDecode`

```javascript
  htmlDecode(string s) string
```

Replace HTML entities in string `s` with their corresponding characters.

Example:

```javascript
  // Returns 'hello > world'
  htmlDecode("hello &gt; world")
```

### `unquote`

```javascript
  unquote(string s) string
```

Removes leading and trailing double and single quotation marks from string `s`.

```javascript
  // Returns 'hello world'
  unquote('"hello world"')
```

### `countMatches`

```javascript
  countMatches(string s, string p) int
```

Counts how many times the substring `p` appears in input string `s`.

Example:

```javascript
  // Return 2
  countMatches("hello world", "o")
```

### `abbreviate`

```javascript
  abbreviate(string s, integer n) string
```

Truncates string `s` using ellipses to hide extraneous text. `n` is the desired length of the output string.

The minimum length of the output string is `4` characters: `1` character is string `s` plus `3` characters used for ellipses (`...`).

Integer `n` must be set greater than 3 otherwise an exception is raised.

```javascript
  // Returns 'hel...'
  abbreviate("hello world", 6)
```

```javascript
  // Returns 'hello...'
  abbreviate("hello world", 8)
```

```javascript
  // Returns 'hello world'
  abbreviate("hello world", 100)
```

```javascript
  // IllegalArgumentException
  abbreviate("abcdefg", 3)
```

### `indexOf`

```javascript
  indexOf(string s, string p[, int i]) integer
```

Returns the integer index starting with `0` of the first occurrence of substring `p` contained in string `s` starting with index `i`.

If the substring `p` is not found, `-1` is returned.

Examples:

```javascript
  // Returns 0
  indexOf("hello world", "h")
```

```javascript
  // Returns -1
  indexOf("hello world", "Z")
```

```javascript
  // Returns 8
  indexOf("hello world", "o", 5)
```

```javascript
  // Returns -1
  indexOf("hello world", "o", 10)
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

```javascript
  // Returns 'hello world'
  trim(" hello world    ")
```

### `length`

```javascript
  length(string s) string
```

Returns the length of string `s`. If string `s` is `null`, function returns -1.

### `concat`

```javascript
  concat([string] c [, string s]) string
```

Joins the elements of the collection `c` into a single string containing the elements separated by the optional delimiter `s`.

* The default delimiter is comma (`,`).
* The delimiter is inserted between the elements.
* `null` objects or empty strings within the collection are represented by empty strings.

```javascript
  // Returns 'a:b'
  concat(['a', 'b'], ':')
```

```javascript
  // Returns 'a--b'
  concat(['a', null, 'b'], '-')
```

### `concatLines`

```javascript
  concatLines([string] c) string
```

Joins the elements of the collection `c` into a single string containing the elements separated by line breaks `\n`.

* `null` objects or empty strings within the collection are represented by empty lines.

```javascript
  /*
    For entity.tags map containing {"location": "NUR", "state": "CA"},
    the function returns text consisting of two lines:
      NUR
      CA
  */
  concatLines(entity.tags.values())
```

```javascript
  /*
    For entity.tags map containing {"location": "NUR", "state": "CA"},
    the function returns text consisting of two lines:
      location
      state
  */
  concatLines(entity.tags.keys())
```
