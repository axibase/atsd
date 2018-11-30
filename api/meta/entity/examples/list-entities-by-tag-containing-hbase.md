# List Entities Starting with `nur` and with Tag `app` Containing `hbase`

## Request

### URI

```elm
GET /api/v1/entities?timeFormat=iso&limit=2&tags=app&expression=name%20LIKE%20%27nur%27%20and%20lower%28tags.app%29%20LIKE%20%27hbase%27
```

### Expression

```javascript
name LIKE 'nur*' AND lower(tags.app) LIKE '*hbase*'
```

## Response

```json
[{
    "name": "nurswgvml006",
    "enabled": true,
    "lastInsertDate": "2015-09-04T15:43:36.000Z",
    "tags": {
        "app": "Hadoop/HBase"
    }
},
{
    "name": "nurswgvml203",
    "enabled": true,
    "tags": {
        "app": "Hadoop/HBase master node"
    }
}]
```

* `lower(text)` is a built-in string function.
* Java string functions can be used to modify the value, for example: `tags.app.toLowerCase()`
