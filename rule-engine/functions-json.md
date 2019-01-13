# JSON Functions

## Overview

Table functions perform various operations on JSON documents.

## Reference

* [`jsonPathFilter`](#jsonpathfilter)
* [`jsonToMaps`](#jsontomaps)
* [`jsonToLists`](#jsontolists)
* [`flattenJson`](#flattenjson)

## `jsonPathFilter`

```csharp
jsonPathFilter(string s, string jp) [object]
```

Parses input string `s` into a JSON document and returns a list of objects matching the [`JSONPath` expression](https://github.com/json-path/JsonPath).

Examples:

```json
{
  "data": [
    { "d": "2018-04-24", "v": 1 },
    { "d": "2018-04-25", "v": 2 }
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
    { "d": "2018-04-24", "v": 1 },
    { "d": "2018-04-25", "v": 2 }
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

```json
{
  "chat_1": { "d": "2018-04-24", "v": "a" },
  "chat_2": { "d": "2018-04-25", "v": "b" }
}
```

Output:

```json
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

Parses string `inStr` as a JSON document and converts it to a collection of lists. The first list is the **header** with field names, the remaining lists contain field values from the JSON document. Field values are returned as strings.

The first list in the collection contains all possible key names in the leaf objects and their parents.

The key names are created by concatenating the current field name with field names of its parents using `.` as a separator and `[i]` as an index suffix for array elements.

The function attempts to shorten key names by removing any common prefix.

The subsequent lists in the collection contain field values of the associated leaf object itself as well as field values from the parent objects ordered by keys in the first list. If the key specified in the first list is absent in the iterated object, the list on the given index contains an empty string.

Examples:

* Common prefix `data.` is discarded

```json
{
  "data": [
    { "d": "2018-04-24", "v": 1 },
    { "d": "2018-04-25", "v": 2 }
  ]
}
```

Output is a collection of **three** lists even though the input document contains an array with **two** elements. The first list is the header.

```ls
[
  [d, v],
  [2018-04-24, 1],
  [2018-04-25, 2]
]
```

* No prefix is discarded

```json
{
  "chat_1": { "d": "2018-04-24", "v": "a" },
  "chat_2": { "d": "2018-04-25", "v": "b" }
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
