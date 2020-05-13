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
| `createdDate` | Entity creation date. Represented as `ISO8601` string. Empty string for not specified date. |

* All tags are string variables.
* Tag names are case-**insensitive**, for example, `tags.location` and `tags.Location` are equal.
* If the tag `tag-name` is not defined, the `tags.{tag-name}` variable returns an empty string.
* String literals must be enclosed in single or double quotes.

## Operators

Comparison operators: `=`, `==`, `!=`, `LIKE`

Logical operators: `AND`, `OR`, `NOT` as well as `&&` , `||`, `!`

Collections operator: `IN`, for example `tags.location IN ('SVL', 'NUR')`

## Wildcards

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

* Returns records with the tag `ip` starting with `192.` and ending with `1`

```javascript
tags.ip LIKE '192.*1'
```

* Returns records with `createdDate` later than `2020-05-01T00:00:00Z`.

```javascript
createdDate > '2020-05-01T00:00:00Z'
```


## Utility Functions

| **Function**   | **Description**  |
|:---|:---|
| `list`       | `list('svl,nyc,sfo')`<br>Returns a collection of strings. <br>Splits a string by delimiter (default is comma).          |
| `likeAll`    | `likeAll(entity.hostname, collection('hostname_ignore'))`<br>Returns `true`, if every element in the collection of patterns matches the first string argument.        |
| `likeAny`    | `likeAny(entity.location, list('svl,nyc,sfo'))`<br>Returns `true`, if at least one element in the collection of patterns matches the first string argument. |
| `upper`      | `upper('svl')`<br>Converts the argument to upper case.  |
| `lower`      | `lower('SFO')`<br>Converts the argument to lower case.  |
| `collection` | `collection('ip_address_ignore')`<br>Returns a pre-defined named collection by name.  |
