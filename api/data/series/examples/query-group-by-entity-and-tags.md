# Series Query: Group by Entity and Tags

## Description

* Groups multiple input series by entity and tag name.
* Calculates aggregated series for each group.

This example demonstrates how series are grouped, what are the keys of aggregated series, and how information about grouped series is represented in the response. All series in this example have a single value `1`.

## Series

```ls
| metric | entity | tag-name-1  | tag-name-2  | datetime             | value |
|--------|--------|-------------|-------------|----------------------|-------|
| abc    | e-1    |             |             | 2019-04-01T00:00:00Z | 1     |
| abc    | e-1    | tag-value-1 |             | 2019-04-01T00:00:00Z | 1     |
| abc    | e-1    |             | tag-value-1 | 2019-04-01T00:00:00Z | 1     |
| abc    | e-1    | tag-value-1 | tag-value-2 | 2019-04-01T00:00:00Z | 1     |
| abc    | e-1    | tag-value-2 |             | 2019-04-01T00:00:00Z | 1     |
| abc    | e-2    |             |             | 2019-04-01T00:00:00Z | 1     |
| abc    | e-2    |             | tag-value-1 | 2019-04-01T00:00:00Z | 1     |
```

Series commands to insert test data:

```ls
series d:2019-04-01T00:00:00Z m:abc=1 e:e-1
series d:2019-04-01T00:00:00Z m:abc=1 e:e-1 t:tag-name-1=tag-value-1
series d:2019-04-01T00:00:00Z m:abc=1 e:e-1 t:tag-name-2=tag-value-1
series d:2019-04-01T00:00:00Z m:abc=1 e:e-1 t:tag-name-1=tag-value-1 t:tag-name-2=tag-value-2
series d:2019-04-01T00:00:00Z m:abc=1 e:e-1 t:tag-name-1=tag-value-2
series d:2019-04-01T00:00:00Z m:abc=1 e:e-2
series d:2019-04-01T00:00:00Z m:abc=1 e:e-2 t:tag-name-2=tag-value-1
```

## Series Grouped by Entity and `tag-name-1`

Four groups are generated.

Group 1.

```ls
| metric | entity | tag-name-1  | tag-name-2  | datetime             | value |
|--------|--------|-------------|-------------|----------------------|-------|
| abc    | e-1    |             |             | 2019-04-01T00:00:00Z | 1     |
| abc    | e-1    |             | tag-value-1 | 2019-04-01T00:00:00Z | 1     |
```

Aggregated series.

```ls
| metric | entity | tag-name-1  | datetime             | value |
|--------|--------|-------------|----------------------|-------|
| abc    | e-1    |             | 2019-04-01T00:00:00Z | 2     |
```

Group 2.

```ls
| metric | entity | tag-name-1  | tag-name-2  | datetime             | value |
|--------|--------|-------------|-------------|----------------------|-------|
| abc    | e-1    | tag-value-1 |             | 2019-04-01T00:00:00Z | 1     |
| abc    | e-1    | tag-value-1 | tag-value-2 | 2019-04-01T00:00:00Z | 1     |
```

Aggregated series.

```ls
| metric | entity | tag-name-1  | datetime             | value |
|--------|--------|-------------|----------------------|-------|
| abc    | e-1    | tag-value-1 | 2019-04-01T00:00:00Z | 2     |
```

Group 3.

```ls
| metric | entity | tag-name-1  | tag-name-2  | datetime             | value |
|--------|--------|-------------|-------------|----------------------|-------|
| abc    | e-1    | tag-value-2 |             | 2019-04-01T00:00:00Z | 1     |
```

Aggregated series.

```ls
| metric | entity | tag-name-1  | datetime             | value |
|--------|--------|-------------|----------------------|-------|
| abc    | e-1    | tag-value-2 | 2019-04-01T00:00:00Z | 1     |
```

Group 4.

```ls
| metric | entity | tag-name-1  | tag-name-2  | datetime             | value |
|--------|--------|-------------|-------------|----------------------|-------|
| abc    | e-2    |             |             | 2019-04-01T00:00:00Z | 1     |
| abc    | e-2    |             | tag-value-1 | 2019-04-01T00:00:00Z | 1     |
```

Aggregated series.

```ls
| metric | entity | tag-name-1  | datetime             | value |
|--------|--------|-------------|----------------------|-------|
| abc    | e-2    |             | 2019-04-01T00:00:00Z | 2     |
```

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[
  {
    "startDate": "2019-04-01T00:00:00Z",
    "endDate":   "2019-04-01T00:00:01Z",
    "metric": "abc",
    "entities": ["e-1", "e-2"],
    "group": {
      "groupByEntityAndTags": ["tag-name-1"],
      "type": "SUM"
    }
  }
]
```

## Response

### Payload

```json
[
  {
    "metric": "abc",
    "entity": "e-1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": ["GROUP"],
    "group": {
      "series": [
        {"entity": "e-1", "tags": {}, "label": "e-1"},
        {"entity": "e-1", "tags": {"tag-name-2": "tag-value-1"}, "label": "e-1:tag-name-2=tag-value-1"}
      ],
      "type": "SUM",
      "truncate": false
    },
    "data": [{"d": "2019-04-01T00:00:00.000Z", "v": 2}]
  },
  {
    "metric": "abc",
    "entity": "e-1",
    "tags": {"tag-name-1": "tag-value-1"},
    "type": "HISTORY",
    "transformationOrder": ["GROUP"],
    "group": {
      "series": [
        {"entity": "e-1", "tags": {"tag-name-1": "tag-value-1"}, "label": "e-1:tag-name-1=tag-value-1"},
        {"entity": "e-1", "tags": {"tag-name-1": "tag-value-1", "tag-name-2": "tag-value-2"}, "label": "e-1:tag-name-1=tag-value-1,tag-name-2=tag-value-2"}
      ],
      "type": "SUM",
      "truncate": false
    },
    "data": [{"d": "2019-04-01T00:00:00.000Z", "v": 2}]
  },
  {
    "metric": "abc",
    "entity": "e-1",
    "tags": {"tag-name-1": "tag-value-2"},
    "type": "HISTORY",
    "transformationOrder": ["GROUP"],
    "group": {
      "series": [
        {"entity": "e-1", "tags": {"tag-name-1": "tag-value-2"}, "label": "e-1:tag-name-1=tag-value-2"}
      ],
      "type": "SUM",
      "truncate": false
    },
    "data": [{"d": "2019-04-01T00:00:00.000Z", "v": 1}]
  },
  {
    "metric": "abc",
    "entity": "e-2",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": ["GROUP"],
    "group": {
      "series": [
        {"entity": "e-2", "tags": {}, "label": "e-2"},
        {"entity": "e-2", "tags": {"tag-name-2": "tag-value-1"}, "label": "e-2:tag-name-2=tag-value-1"}
      ],
      "type": "SUM",
      "truncate": false
    },
    "data": [{"d": "2019-04-01T00:00:00.000Z", "v": 2}]
  }
]
```
