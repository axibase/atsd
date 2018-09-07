# Text Functions

## Overview

These functions compare and transform strings, `null`-safe: returns `null` or `false` if one of the inputs is `null`.

## Reference

* [`upper`](#upper)
* [`lower`](#lower)
* [`truncate`](#truncate)
* [`startsWith`](#startswith)
* [`endsWith`](#endswith)
* [`split`](#split)
* [`list`](#list)
* [`ifEmpty`](#ifempty)
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

## `upper`

```csharp
upper(string s) string
```

Converts string `s` to uppercase letters.

## `lower`

```csharp
lower(string s) string
```

Converts string `s` to lowercase letters.

## `truncate`

```csharp
truncate(string s, int maxLength) string
```

Truncates `s` to the specified number of characters and returns the string as the result if string `s` length exceeds `maxLength` characters.

## `startsWith`

```javascript
startsWith(string s, string pfx) bool
```

Returns `true` if `s` starts with `pfx` prefix.

## `endsWith`

```javascript
endsWith(string s, string sfx) bool
```

Returns `true` if `s` ends with `sfx`.

## `split`

```csharp
split(string s, string sep) [string]
```

Splits string `s` into a collection of strings using separator `sep`.

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

To access the `n`-th element in the collection, use square brackets `[index]` or `get(index)` method, starting with `0` for the first element.

```javascript
authors = split(tags.authors, ',')
authors.size() == 0 ? 'n/a' : authors[0]
```

## `list`

```csharp
list(string s[, string sep]) [string]
```

Splits string `s` using separator `sep` (default is comma ',') into an array of string values, discards duplicate items by retaining only the first occurrence of each element.

Unlike the `split()` function, `list()` does not support double quotes as escape characters.

Example:

```javascript
// Returns ['hello', '"brave', 'new', 'world"']
list('hello "brave new world" hello', ' ')
```

## `ifEmpty`

```csharp
ifEmpty(string a, string b) object
```

Returns `b` if `a` is either `null` or an empty string.

:::tip Accepted data types
The function also accepts arguments of any data type, such as objects and numbers.
:::

Examples:

```javascript
/* Returns 'N/A' if tags.location is null or empty. Otherwise returns the value of `location` tag. */
ifEmpty(tags.location, 'N/A')
```

## `coalesce`

```csharp
coalesce([string] strColl) string
```

Returns first non-empty string from the collection of strings `strColl`.

Returns an empty string if all elements of `strColl` are `null` or empty.

Examples:

```javascript
// Returns 'string-3'.
coalesce(['', null, 'string-3'])
```

```javascript
// Returns the value of `location` tag if the tag value is not empty, otherwise 'SVL' is returned.
coalesce([tags.location, 'SVL'])
```

```javascript
/* Returns the value of the entity label if the label is not empty, otherwise the entity name is returned.
If both fields are empty, an empty string is returned. */
coalesce([entity.label, entity])
```

## `keepAfter`

```csharp
keepAfter(string s, string sub) string
```

Removes part of the string `s` before the first occurrence of the given substring `sub`.

Returns the original string `s` unchanged, if `sub` is empty or `null` or if `sub` is not found.

Example:

```javascript
// Returns 'new.world'
keepAfter('hello.new.world', '.')
```

## `keepAfterLast`

```csharp
keepAfterLast(string s, string sub) string
```

Removes the part of string `s` before the last occurrence of the given substring `sub`.

Returns the original string `s` unchanged, if `sub` is empty or `null` or if `sub` is not found.

Example:

```javascript
// Returns 'world'
keepAfterLast('hello.new.world', '.')
```

## `keepBefore`

```csharp
keepBefore(string s, string sub) string
```

Removes part of the string `s` that starts with the first occurrence of the given substring `sub`.

Returns the original string `s` unchanged, if `sub` is empty or `null` or if `sub` is not found.

Example:

```javascript
// Returns 'hello'
keepBefore('hello.new.world', '.')
```

## `keepBeforeLast`

```csharp
keepBeforeLast(string s, string sub) string
```

Removes part of the string `s` that starts with the last occurrence of the given substring `sub`.

Returns the original string `s` unchanged, if `sub` is empty or `null` or if `sub` is not found.

Example:

```javascript
// Returns 'hello.new'
keepBeforeLast('hello.new.world', '.')
```

## `replace`

```csharp
replace(string s, string sub, string rep) string
```

Replaces all occurrences of the given substring `sub` in the original string `s` with a second substring `rep`.

Returns the original string `s` unchanged, if `sub` is empty or `null` or if `sub` is not found.

Examples:

```javascript
// Returns 'hello.ne2.2orld'
replace('hello.new.world', 'w', '2')
```

## `capFirst`

```csharp
capFirst(string s) string
```

Capitalizes the first letter in the string.

Example:

```javascript
// Returns 'Hello world'
capFirst('hello world')
```

## `capitalize`

```csharp
capitalize(string s) string
```

Capitalizes the first letter in all words in the string.

Example:

```javascript
// Returns 'Hello World'
capitalize('hello world')
```

## `removeBeginning`

```csharp
removeBeginning(string s, string pfx) string
```

Removes substring `pfx` from the beginning of string `s`.

Examples:

```javascript
// Returns 'llo world'
removeBeginning('hello world', 'he')
```

```javascript
// Returns 'hello world'
removeBeginning('hello world', 'be')
```

## `removeEnding`

```csharp
removeEnding(string s, string sfx) string
```

Removes given substring `sfx` from the end of string `s`.

```javascript
// Returns 'hello wor'
removeEnding('hello world', 'ld')
```

```javascript
// Returns 'hello world'
removeEnding('hello world', 'LD')
```

## `urlencode`

```csharp
urlencode(string s) string
```

Replaces special characters in string `s` with URL-safe characters using percent-encoding (`%` followed by `2` digits).

```javascript
// Returns 'hello%20world'
urlencode('hello world')
```

## `jsonencode`

```csharp
jsonencode(string s) string
```

Escapes special JSON characters in string `s` such as double quotes with a backslash to safely include the string within a JSON object.

## `htmlDecode`

```csharp
htmlDecode(string s) string
```

Replaces HTML entities in string `s` with their corresponding characters.

Example:

```javascript
// Returns 'hello > world'
htmlDecode('hello &gt; world')
```

## `unquote`

```csharp
unquote(string s) string
```

Removes leading and trailing double and single quotation marks from string `s`.

```javascript
// Returns 'hello world'
unquote('"hello world"')
```

## `countMatches`

```csharp
countMatches(string s, string sub) int
```

Counts how many times the substring `sub` appears in input string `s`.

Example:

```javascript
// Returns 2
countMatches('hello world', 'o')
```

## `abbreviate`

```csharp
abbreviate(string s, int maxLength) string
```

Truncates string `s` using ellipses to hide extraneous text. `maxLength` is the maximum length of the output string.

The minimum length of the output string is `4` characters: `1` character is string `s` plus `3` characters used for ellipses (`...`).

Integer `maxLength` must be set greater than `3` otherwise an exception is raised.

```javascript
// Returns 'hel...'
abbreviate('hello world', 6)
```

```javascript
// Returns 'hello...'
abbreviate('hello world', 8)
```

```javascript
// Returns 'hello world'
abbreviate('hello world', 100)
```

```javascript
// IllegalArgumentException
abbreviate('abcdefg', 3)
```

## `indexOf`

```csharp
indexOf(string s, string sub[, int index]) int
```

Returns the integer index starting with `0` of the first occurrence of substring `sub` contained in string `s` starting with `index`.

Returns `-1` if the substring `sub` is not found.

Examples:

```javascript
// Returns 0
indexOf('hello world', 'h')
```

```javascript
// Returns -1
indexOf('hello world', 'Z')
```

```javascript
// Returns 8
indexOf('hello world', 'o', 5)
```

```javascript
// Returns -1
indexOf('hello world', 'o', 10)
```

## `locate`

```csharp
locate(string s, string sub[, int index]) int
```

Returns the integer index starting with `0` of the first occurrence of substring `sub` contained in string `s` starting with `index`.

Returns `-1` if the substring `sub` is not found.

## `trim`

```csharp
trim(string s) string
```

Removes leading and trailing non-printable characters.

```javascript
// Returns 'hello world'
trim(" hello world    ")
```

## `length`

```csharp
length(string s) string
```

Returns the length of string `s`. If string `s` is `null`, function returns -1.

## `concat`

```csharp
concat([string] strColl [, string sep]) string
```

Joins the elements of the collection `strColl` into a single string containing the elements separated by the optional separator `sep`.

* The default separator is comma (`,`).
* The separator is inserted between the elements.
* `null` objects or empty strings within the collection are represented by empty strings.

```javascript
// Returns 'a:b'
concat(['a', 'b'], ':')
```

```javascript
// Returns 'a--b'
concat(['a', null, 'b'], '-')
```

## `concatLines`

```csharp
concatLines([string] strColl) string
```

Joins the elements of the collection `strColl` into a single string containing the elements separated by line breaks `\n`.

* `null` objects or empty strings within the collection are represented by empty lines.

```javascript
/* For entity.tags map containing {"location": "NUR", "state": "CA"},
the function returns text consisting of two lines:
      NUR
      CA */
concatLines(entity.tags.values())
```

```javascript
/*For entity.tags map containing {"location": "NUR", "state": "CA"},
the function returns text consisting of two lines:
      location
      state*/
concatLines(entity.tags.keys())
```
