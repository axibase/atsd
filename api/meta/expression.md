
# Expression Syntax

## Variables

`name` - name of the record, such as entity name or metric name

`tags.{tag-name}` - value of tag with name `tag-name`, for example, `tags.location` or `tags.table`

* All the variables are string variables.
* Tag names are case-insensitive, for example, `tags.location` and `tags.Location` are equal.
* If the tag `tag-name` is not defined, the `tags.{tag-name}` variable returns an empty string.

## Operators

Comparison operators: `=`, `==`, `!=`, `LIKE`

Logical operators: `AND`, `OR`, `NOT` as well as `&&` , `||`, `!`

Collections operator: `IN`, for example `tags.location IN ('SVL', 'NUR')`

## Wildcards

Wildcard `*` means zero or more characters. 

Wildcard `?` means any character.

## Examples

* Returns record with name equal to `nurswgvml003`

```sql
name = 'nurswgvml003'
```

* Returns records with name starting with `nur`

```sql
name LIKE 'nur*'
```

* Returns records that have the `location` tag defined

```sql
name tags.location != ''
```

* Returns records with name that starts with `nur` and with the tag `os` equal to 'Linux'

```sql
name LIKE 'nur*' AND tags.os = 'Linux'
```

* Returns records with the tag `ip` starting with `10.` and ending with `22`

```sql
tags.ip LIKE '10.*22'
```

## Extended Functions

* Collection list(String value);
* Collection list(String value, String delimiter);
* boolean likeAll(Object message, Collection values);
* boolean likeAny(Object message, Collection values);
* String upper(Object value);
* String lower(Object value);
* Collection collection(String name);

| **Function**   | **Description**                                                                         |
|:------------|:-------------------------------------------------------------------------------------|
| list       | Splits a string by delimiter. Default delimiter is comma                            |
| likeAll    | returns true, if every element in the collection of patterns matches message        |
| likeAny    | returns true, if at least one element in the collection of patterns matches message |
| upper      | converts the argument to upper case                                                 |
| lower      | converts the argument to lower case                                                 |
| collection | returns ATSD named collection                                                       |
