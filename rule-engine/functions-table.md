# Table Functions

## Overview

Table functions perform various operations on strings, lists, and maps to create tabular representations.

## Reference

* [`addTable` for map](#addtable-for-map)
* [`addTable` for maps](#addtable-for-maps)
* [`addTable` for list](#addtable-for-list)
* [`jsonPathFilter`](#jsonpathfilter)
* [`jsonToMaps`](#jsontomaps)
* [`jsonToLists`](#jsontolists)
* [`flattenJson`](#flattenjson)
* [Examples](#examples)

## `addTable` for map

```csharp
addTable(map, string format) string
```

Prints the input key-value `map` as a two-column table in the specified `format`.

The first column in the table contains map keys, whereas the second column contains their corresponding map values.

The input `map` typically consists of maps such as `tags`, `entity.tags`, or `variables`.

Supported formats:

* `markdown`
* `ascii`
* `property`
* `csv`
* `html`

Returns an empty string if `map` is `null` or has no records.

Ignores map records with empty or `null` values.

Automatically rounds numeric values in web and email notifications or prints without modifications in other cases.

The default table headers are `Name` and `Value`.

Examples:

* `markdown` format

```javascript
addTable(property_map('nurswgvml007','disk::', 'today'), 'markdown')
```

```ls
| **Name** | **Value**  |
|:---|:--- |
| id | sda5 |
| disk_%busy | 0.6 |
| disk_block_size | 16.1 |
| disk_read_kb/s | 96.8 |
| disk_transfers_per_second | 26.0 |
| disk_write_kb/s | 8.1 |
```

* `csv` format

```javascript
addTable(entity.tags, 'csv')
```

```ls
Name,Value
alias,007
app,ATSD
cpu_count,1
os,Linux
```

* `ascii` format

```javascript
addTable(entity_tags(tags.host, true, true), 'ascii')
```

```ls
+-------------+------------+
| Name        | Value      |
+-------------+------------+
| alias       | 007        |
| app         | ATSD       |
| cpu_count   | 1          |
| os          | Linux      |
+-------------+------------+
```

* `html` format

The HTML format includes the response rendered as a `<table>` node with inline CSS styles for better compatibility with legacy email clients such as Microsoft Outlook.

```javascript
addTable(property_map('nurswgvml007', 'cpu::*'), 'html')
```

```html
<table style="font-family: monospace, consolas, sans-serif; border-collapse: collapse; font-size: 12px; margin-top: 5px"><tbody><tr><th bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">Name</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Value</th></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">id</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">1</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">cpu.idle%</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">91.5</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">cpu.steal%</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">0.0</td></tr>
</tbody></table>
```

* `property` format

```javascript
addTable(excludeKeys(entity.tags, ['ip', 'loc_code', 'loc_area']), 'property')
```

```ls
alias=007
app=ATSD
cpu_count=1
os=Linux
```

## `addTable` for maps

```csharp
addTable([map], string format[, [string header]]) string
```

Prints a collection of maps `map` as a multi-column table in the specified `format`, with optional `header`.

The first column in the table contains unique keys from all maps in the collection, whereas the second and subsequent columns contain map values for the corresponding key in the first column.

The default table header is 'Name, Value-1, ..., Value-N'.

If the header argument `h` is specified as a collection of strings, it replaces the default header. The number of elements in the header collection must be the same as the number of maps plus `1`.

Examples:

`property_maps('nurswgvml007','jfs::', 'today')` returns the following collection:

```ls
[
  {id=/, jfs_filespace_%used=12.8},
  {id=/dev, jfs_filespace_%used=0.0},
  {id=/mnt/u113452, jfs_filespace_%used=34.9},
  {id=/run, jfs_filespace_%used=7.5},
  {id=/var/lib/lxcfs, jfs_filespace_%used=0.0}
]
```

* `markdown` format

```javascript
addTable(property_maps('nurswgvml007','jfs::', 'today'), 'markdown')
```

```markdown
| **Name** | **Value 1** | **Value 2** | **Value 3** | **Value 4** | **Value 5**  |
|:---|:---|:---|:---|:---|:--- |
| id | / | /dev | /mnt/u113452 | /run | /var/lib/lxcfs |
| jfs_filespace_%used | 12.8 | 0.0 | 34.9 | 7.5 | 0.0 |
```

* `csv` format

```javascript
addTable(property_maps('nurswgvml007','jfs::', 'today'), 'csv')
```

```ls
Name,Value 1,Value 2,Value 3,Value 4,Value 5
id,/,/dev,/mnt/u113452,/run,/var/lib/lxcfs
jfs_filespace_%used,12.7,0.0,34.9,7.5,0.0
```

* `ascii` format

```javascript
addTable(property_maps('nurswgvml007','jfs::', 'today'), 'ascii', ['property', 'root', 'dev', 'mount', 'run', 'var'])
```

```ls
+---------------------+------+------+--------------+------+----------------+
| property            | root | dev  | mount        | run  | var            |
+---------------------+------+------+--------------+------+----------------+
| id                  | /    | /dev | /mnt/u113452 | /run | /var/lib/lxcfs |
| jfs_filespace_%used | 12.8 | 0.0  | 34.9         | 7.5  | 0.0            |
+---------------------+------+------+--------------+------+----------------+
```

* `html` format

```javascript
addTable(property_maps('nurswgvml007','jfs::', 'today'), 'html')
```

```html
<table style="font-family: monospace, consolas, sans-serif; border-collapse: collapse; font-size: 12px; margin-top: 5px"><tbody><tr><th bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">Name</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Value 1</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Value 2</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Value 3</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Value 4</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Value 5</th></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">id</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">/</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">/dev</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">/mnt/u113452</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">/run</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">/var/lib/lxcfs</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">jfs_filespace_%used</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">12.8</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">0.0</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">34.9</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">7.5</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">0.0</td></tr>
</tbody></table>
```

* `property` format

```javascript
addTable(property_maps('nurswgvml007','jfs::', 'today'), 'property')
```

```ls
id=/=/dev=/mnt/u113452=/run=/var/lib/lxcfs
jfs_filespace_%used=12.8=0.0=34.9=7.5=0.0
```

## `addTable` for list

```csharp
addTable([[string]] strList, string format[, [string] header | bool addHeader]) string
```

Prints list of lists `strList` as a multi-column table in the specified `format`. Each nested list in the parent list `strList` is serialized into a separate row in the table.

The number of elements in each collection must be the same.

The default table header is `Value-1, ..., Value-N`.

Use header arguments to customize the header.

If the third argument is specified as a collection of strings, its elements replace the default header. The size of the header collection must be the same as the number of cells in each row.

If `addHeader` argument is specified as a boolean value `true`, the first row in the table is used as a header.

The function returns an empty string if `strList` is empty.

Examples:

```javascript
query = 'SELECT datetime, value FROM http.sessions WHERE datetime > current_hour LIMIT 2'
```

`executeSqlQuery(query)` returns a list consisting of the header row followed by data rows.

```ls
[[datetime, value], [2018-01-31T12:00:13.242Z, 37], [2018-01-31T12:00:28.253Z, 36]]
```

* `markdown` format

```javascript
addTable(executeSqlQuery(query), 'markdown', true)
```

```ls
| **datetime** | **value**  |
|:---|:--- |
| 2018-01-31T12:00:13.242Z | 37 |
| 2018-01-31T12:00:28.253Z | 36 |
```

* `csv` format

```javascript
addTable([['2018-01-31T12:00:13.242Z', '37'], ['2018-01-31T12:00:28.253Z', '36']], 'csv', ['date', 'count'])
```

```csv
date,count
2018-01-31T12:00:13.242Z,37
2018-01-31T12:00:28.253Z,36
```

* `ascii` format

```javascript
addTable(executeSqlQuery(query), 'ascii', true)
```

```ls
+--------------------------+-------+
| datetime                 | value |
+--------------------------+-------+
| 2018-01-31T12:00:13.242Z | 37    |
| 2018-01-31T12:00:28.253Z | 36    |
+--------------------------+-------+
```

* `html` format

```javascript
addTable(executeSqlQuery(query), 'html', true)
```

```html
<table style="font-family: monospace, consolas, sans-serif; border-collapse: collapse; font-size: 12px; margin-top: 5px"><tbody><tr><th bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">datetime</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">value</th></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">2018-01-31T12:00:13.242Z</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">37</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">2018-01-31T12:00:28.253Z</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">36</td></tr>
</tbody></table>
```

* `property` format

```javascript
addTable(executeSqlQuery(query), 'property')
```

```ls
datetime=value
2018-01-31T12:00:13.242Z=37
2018-01-31T12:00:28.253Z=36
```

```javascript
addTable(executeSqlQuery(query), 'property', true)
```

```ls
2018-01-31T12:00:13.242Z=37
2018-01-31T12:00:28.253Z=36
```

```javascript
addTable(executeSqlQuery(query), 'property', false)
```

```ls
datetime=value
2018-01-31T12:00:13.242Z=37
2018-01-31T12:00:28.253Z=36
```

## `jsonPathFilter`

```csharp
jsonPathFilter(string s, string jp) [object]
```

Parses input string `s` into a JSON document and returns a list of objects matching the [`JSONPath` expression](https://github.com/json-path/JsonPath).

Examples:

```json
{
  "data": [
    {
      "d": "2018-04-24",
      "v": 1
    },
    {
      "d": "2018-04-25",
      "v": 2
    }
  ]
}
```

```javascript
jsonPathFilter(s, "$.data[*].v")
```

Output:

```ls
[1,2]
```

```javascript
jsonPathFilter(s, "$.data[?(@.d > '2018-04-24')]")
```

Output:

```ls
[{
  "d":"2018-04-25",
  "v":2
}]
```

See additional [examples](#examples).

## `jsonToMaps`

```csharp
jsonToMaps(string inStr) [map]
```

Parses string `inStr` into a JSON document and returns a collection of maps containing keys and values from the JSON document.

The collection contains as many maps as there are leaf objects in the JSON document. Each map contains keys and values of the leaf object itself as well as keys and values from the parent objects.

Key names are created by concatenating the current field name with field names of its parents using `.` as a separator and `[i]` as an index suffix for array elements.

Attempts to shorten key names by removing any common prefix.

Examples:

* Common prefix `data.` is discarded:

```javascript
{
  "data": [
    {
      "d": "2018-04-24",
      "v": 1
    },
    {
      "d": "2018-04-25",
      "v": 2
    }
  ]
}
```

Output:

```ls
[
 {d=2018-04-24, v=1},
 {d=2018-04-25, v=2}
]
```

* No prefix is discarded:

```javascript
{
  "chat_1": {
    "d": "2018-04-24",
    "v": "a"
  },
  "chat_2": {
    "d": "2018-04-25",
    "v": "b"
  }
}
```

Output:

```ls
[
  {"chat_1.d":"2018-04-24", "chat_1.v":"a",
   "chat_2.d":"2018-04-25", "chat_2.v":"b"}
]
```

See additional examples [below](#examples).

## `jsonToLists`

```csharp
jsonToLists(string inStr) [[string]]
```

Parses string `inStr` into a JSON document and returns a collection of string lists of the same size containing field values from this JSON document.

The first list in the collection contains all possible key names in the leaf objects and their parents.

The key names are created by concatenating the current field name with field names of its parents using `.` as a separator and `[i]` as an index suffix for array elements.

Attempts to shorten key names by removing any common prefix.

The subsequent lists in the collection contain field values of the associated leaf object itself as well as field values from the parent objects ordered by keys in the first list. If the key specified in the first list is absent in the iterated object, the list on the given index contains an empty string.

Examples:

* Common prefix `data.` is discarded

```javascript
{
  "data": [
    {
      "d": "2018-04-24",
      "v": 1
    },
    {
      "d": "2018-04-25",
      "v": 2
    }
  ]
}
```

Output lists:

```ls
[[d, v],
 [2018-04-24, 1],
 [2018-04-25, 2]]
```

* No prefix is discarded

```javascript
{
  "chat_1": {
    "d": "2018-04-24",
    "v": "a"
  },
  "chat_2": {
    "d": "2018-04-25",
    "v": "b"
  }
}
```

Output:

```ls
[
 [chat_1.d,   chat_1.v, chat_2.d,   chat_2.v],
 [2018-04-24, a,        2018-04-25, b       ]
]
```

See additional examples [below](#examples).

## `flattenJson`

```csharp
flattenJson(string jsonStr) map
```

Converts the string representation of JSON document `jsonStr` into a map consisting of keys and values.

Processing rules:

* String `jsonStr` is parsed into a JSON object. If `jsonStr` is not a valid JSON document, the function raises an exception.
* The JSON object is traversed to locate fields with primitive data types: `number`, `string`, and `boolean`.
* The field value is added to the map with a key set to its full name, created by appending the field local name to the full name of its parent object using `.` as a separator.
* If the field is an array element, its local name is set to element index `[i]` (index `i` starts with `0`).
* Fields with `null`, empty string, empty array, and empty object values are ignored.

Input JSON document:

```json
{
  "event": "commit",
  "merged": true,
  "type": null,
  "repo": {
    "name": "atsd",
    "Full Name": "Axibase TSD",
    "authors": [
      "john.doe",
      "mary.jones",
      ""
    ]
  }
}
```

Output map:

```json
{
  "event": "commit",
  "merged": true,
  "repo.name": "atsd",
  "repo.Full Name": "Axibase TSD",
  "repo.authors[0]": "john.doe",
  "repo.authors[1]": "mary.jones"
}
```

## Examples

The examples below are based on the following JSON document which represents output of a GraphQL query:

```json
{
  "data": {
    "repository": {
      "pullRequests": {
        "nodes": [
          {
            "url": "https://github.com/axibase/atsd-api-test/pull/487",
            "author": {
              "login": "may_jones"
            },
            "mergeable": "MERGEABLE",
            "baseRefName": "master",
            "headRefName": "5208-series-tag-query-with-wildcard-without-entity",
            "title": "5208: Series tags query with wildcard without entity"
          },
          {
            "url": "https://github.com/axibase/atsd-api-test/pull/406",
            "author": {
              "login": "john_doe"
            },
            "mergeable": "MERGEABLE",
            "baseRefName": "master",
            "headRefName": "john_doe-4397",
            "title": "Test #4397"
          }
        ]
      }
    }
  }
}
```

```javascript
jsonToMaps(json)
```

```json
[ {
  "url" : "https://github.com/axibase/atsd-api-test/pull/487",
  "author.login" : "may_jones",
  "mergeable" : "MERGEABLE",
  "baseRefName" : "master",
  "headRefName" : "5208-series-tag-query-with-wildcard-without-entity",
  "title" : "5208: Series tags query with wildcard without entity"
}, {
  "url" : "https://github.com/axibase/atsd-api-test/pull/406",
  "author.login" : "john_doe",
  "mergeable" : "MERGEABLE",
  "baseRefName" : "master",
  "headRefName" : "john_doe-4397",
  "title" : "Test #4397"
} ]
```

```javascript
jsonToLists(json)
```

```json
[
  [ "url", "author.login", "mergeable", "baseRefName", "headRefName", "title" ],
  [ "https://github.com/axibase/atsd-api-test/pull/487", "may_jones", "MERGEABLE", "master", "5208-series-tag-query-with-wildcard-without-entity", "5208: Series tags query with wildcard without entity" ],
  [ "https://github.com/axibase/atsd-api-test/pull/406", "john_doe", "MERGEABLE", "master", "john_doe-4397", "Test #4397" ]
]
```

```javascript
addTable(jsonToLists(json), 'ascii', true)
```

```txt
+---------------------------------------------------+-----------------+-----------+-------------+----------------------------------------------------+--------------------------------------------------------------+
| url                                               | author.login    | mergeable | baseRefName | headRefName                                        | title                                                        |
+---------------------------------------------------+-----------------+-----------+-------------+----------------------------------------------------+--------------------------------------------------------------+
| https://github.com/axibase/atsd-api-test/pull/487 | may_jones      | MERGEABLE | master      | 5208-series-tag-query-with-wildcard-without-entity | 5208: Series tags query with wildcard without entity         |
| https://github.com/axibase/atsd-api-test/pull/406 | john_doe           | MERGEABLE | master      | john_doe-4397                                         | Test #4397                                                   |
+---------------------------------------------------+-----------------+-----------+-------------+----------------------------------------------------+--------------------------------------------------------------+
```

```javascript
flattenJson(json)
```

```json
{
  "data.repository.pullRequests.nodes[0].url" : "https://github.com/axibase/atsd-api-test/pull/487",
  "data.repository.pullRequests.nodes[0].author.login" : "may_jones",
  "data.repository.pullRequests.nodes[0].mergeable" : "MERGEABLE",
  "data.repository.pullRequests.nodes[0].baseRefName" : "master",
  "data.repository.pullRequests.nodes[0].headRefName" : "5208-series-tag-query-with-wildcard-without-entity",
  "data.repository.pullRequests.nodes[0].title" : "5208: Series tags query with wildcard without entity",
  "data.repository.pullRequests.nodes[1].url" : "https://github.com/axibase/atsd-api-test/pull/406",
  "data.repository.pullRequests.nodes[1].author.login" : "john_doe",
  "data.repository.pullRequests.nodes[1].mergeable" : "MERGEABLE",
  "data.repository.pullRequests.nodes[1].baseRefName" : "master",
  "data.repository.pullRequests.nodes[1].headRefName" : "john_doe-4397",
  "data.repository.pullRequests.nodes[1].title" : "Test #4397"
}
```

```javascript
jsonPathFilter(json, "$..pullRequests.nodes[*][?(@.mergeable == 'MERGEABLE')]['url','author','title']")
```

```json
[{
  "url" : "https://github.com/axibase/atsd-api-test/pull/487",
  "author":{"login":"may_jones"},
  "title":"5208: Series tags query with wildcard without entity"
}, {
  "url":"https://github.com/axibase/atsd-api-test/pull/406",
  "author":{"login":"john_doe"},
  "title":"Test #4397"
}]
```
