# SQL Functions

## Overview

These functions return the results of a user-defined SQL query.

## Reference

* [`executeSqlQuery`](#executesqlquery)
* [`queryToMap`](#querytomap)

### `executeSqlQuery`

```csharp
executeSqlQuery(string query) collection[collection[string]]
```

Returns the result of SQL `query`. The first row consists of column labels. The function results are typically passed to [`addTable`](./functions-table.md) function for rendering.

The response is limited to **1,000** rows. An exception is thrown if row count exceeds the limit.

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
executeSqlQuery("SELECT entity, avg(value) AS \"Average Value\" " +
                "FROM jvm_memory_used WHERE datetime > current_hour GROUP BY entity")
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

### `queryToMap`

```csharp
queryToMap(string query, string keyColumn) map
```

Returns the result of SQL `query` as a map where key is `keyColumn` value and value is a map consisting of other columns' values. Value datatypes are based on SQL data types. 

The response is limited to **1,000** rows. An exception is thrown if row count exceeds the limit.

Examples:

```javascript
Map qr = queryToMap('SELECT entity, AVG(value) AS av, MAX(value) AS mv FROM cpu_busy WHERE datetime > current_hour GROUP BY entity');

// The map can be used in Initialization or Event Script
if (qr.size() > 0 && toNumber(qr['nurswgvml007']['av']) > 10) {
 //
}
```

```java
{ 
  'nurswgvml007': { 'av': 10.2, 'mv': 16.0 },
  'nurswgvml010': { 'av': 24.2, 'mv': 32.4 },
  'nurswgvml012': { 'av': 15.0, 'mv': 20.0 }
}
```
