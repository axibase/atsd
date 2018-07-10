# SQL Functions

## Overview

Returns the results of a user-defined SQL query.

## Reference

* [`executeSqlQuery`](#executesqlquery)

## `executeSqlQuery`

```javascript
  executeSqlQuery(string q) collection[collection[string]]
```

Returns the result of SQL query `q`. The first row contains headers consisting of column labels.

The response is limited to 1,000 rows.

If query `q` is empty or not valid, an error is thrown.

Examples:

```javascript
executeSqlQuery('SELECT datetime, value FROM http.sessions WHERE datetime > current_hour LIMIT 2')
```

```css
  [
    [datetime, value],
    [2018-01-25T19:00:12.346Z, 1],
    [2018-01-25T19:00:27.347Z, 1]
  ]
```

```javascript
executeSqlQuery("SELECT entity, avg(value) AS \"Average Value\" FROM jvm_memory_used WHERE datetime > current_hour GROUP BY entity")
```

```css
  [
    [entity, Average Value],
    [atsd, 467675162.105]
  ]
```

```javascript
query = 'SELECT datetime, value FROM http.sessions WHERE datetime > current_hour LIMIT 2'
//
addTable(executeSqlQuery(query), 'ascii', true)
```

```ls
+--------------------------+-------+
| datetime                 | value |
+--------------------------+-------+
| 2018-01-26T13:00:14.098Z | 23    |
| 2018-01-26T13:00:29.110Z | 22    |
+--------------------------+-------+
```
