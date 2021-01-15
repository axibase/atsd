# Expression Syntax

## Variables

| Name | Description |
|:---|:---|
| `name` | Entity or metric name. |
| `label` | Entity or metric label. |
| `{field-name}` | Entity or metric field by name, such as `createdDate` or `retentionDays`. |
| `tags.{name}` | Value of tag with name `name`, for example, `tags.location` or `tags.table`. |
| `message`| Message text in the [messages methods](../../api/data/messages/README.md).|
| `severity`|Message severity [code](../../shared/severity.md) in the [messages methods](../../api/data/messages/README.md).|

* All tags are string variables.
* Tag names are case-**insensitive**, for example, `tags.location` and `tags.Location` are equal.
* If the tag `tag-name` is not defined, the `tags.{tag-name}` variable returns an empty string.
* String literals must be enclosed in single or double quotes.

## Operators

Comparison operators: `=`, `==`, `!=`, `LIKE`, `REGEX`

Logical operators: `AND`, `OR`, `NOT` as well as `&&` , `||`, `!`

Collections operator: `IN`, for example `tags.location IN ('SVL', 'NUR')`

## Wildcards

The wildcards apply to `LIKE` operator and function patterns except where regex is used.

Wildcard `*` means zero or more characters.

Wildcard `?` means any character.

## Examples

* Returns records with name equal to `nurswgvml003`

```javascript
name = 'nurswgvml003'
```

* Returns records with name starting with `nur`

```javascript
name LIKE 'nur*'
```

* Returns records that have the `location` tag defined

```javascript
tags.location != ''
```

* Returns records with name that starts with `nur` and with the tag `os` equal to `Linux`

```javascript
name LIKE 'nur*' AND tags.os = 'Linux'
```

* Returns records with `location` tag matching one of the specified patterns.

```javascript
NOT likeAny(tags.location, ['nur*', 'sv?', '*dbl*'])
```

* Returns records with the tag `ip` starting with `192.` and ending with `1`

```javascript
tags.ip LIKE '192.*1'
```

* Returns records that match the IP v4 address

```javascript
tags.ip REGEX '^(\d{1,3}\.?){3}\d{1,3}$'
```

* Returns records with the tag `ip` starting with `192.` and ending with `1`

```javascript
regexAny(tags.ip, ['^192\.(\d{1,3}\.?){2}\d{1,3}$', '^127\.(\d{1,3}\.?){2}\d{1,3}$'])
```

* Returns records with the tag `location` equal to one of the listed strings.

```javascript
tags.location IN ('NUR', 'SVL')
```

* Returns records with `primary_board` tag in the `security_definitions` property equal to `INAV`.

```javascript
properties('security_definitions').primary_board = 'INAV'
```

## Utility Functions

| **Function**   | **Description**  |
|:---|:---|
| `list`       | `list('svl,nyc,sfo')`<br>Returns a collection of strings. <br>Splits a string by delimiter (default is comma).          |
| `likeAll`    | `likeAll(entity.hostname, collection('hostname_ignore'))`<br>Returns `true` if every element in the collection of patterns matches the first string argument.        |
| `likeAny`    | `likeAny(entity.location, list('svl,nyc,sfo'))`<br>Returns `true` if at least one element in the collection of patterns matches the first string argument. |
| `matches`    | `matches('*00*5*', [tags.location])`<br>Returns `true` if at least one element in the collection matches the pattern in the first string argument. |
| `startsWithAny` | `startsWithAny(name, ['a', 'b'])`<br>Returns `true` if the first argument starts with one of the strings in the collection. |
| `regexAny`    | `regexAny(name, ['.*a(bc){2,3}$'])`<br>Returns `true` if the first string argument matches at least one of the **regex** patterns in the collection. |
| `properties` | `properties('def').site = 'XSD'` | Returns `tag=value` map for property of the specified type. |
| `upper`      | `upper('svl')`<br>Converts the argument to upper case.  |
| `lower`      | `lower('SFO')`<br>Converts the argument to lower case.  |
| `collection` | `collection('ip_address_ignore')`<br>Returns a pre-defined named collection by name.  |
