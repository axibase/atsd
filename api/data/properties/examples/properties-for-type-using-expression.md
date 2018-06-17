# Properties for Type Using `keyTagExpression` Example

## Request

### URI

```elm
POST /api/v1/properties/query
```

### Payload

```json
[
    {
        "type": "manager2",
        "entity": "host2",
        "keyTagExpression": "key3 LIKE 'nur*'",
        "startDate": "now - 1 * DAY",
        "endDate": "now",
    }
]
```
