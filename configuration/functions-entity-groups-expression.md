# Entity Groups Expression Functions

## Reference

* [collection](#collection)
* [list](#list)
* [likeAll](#likeall)
* [likeAny](#likeany)
* [matches](#matches)
* [startsWithAny](#startswithany)
* [collection_contains](#collection_contains)
* [collection_intersects](#collection_intersects)
* [upper](#upper)
* [lower](#lower)
* [property](#property)
* [properties](#properties)
* [property_values](#property_values)
* [hasMetric](#hasmetric)
* [memberOf](#memberof)
* [memberOfAll](#memberofall)
* [entity_tags](#entity_tags)
* [contains](#contains)
* [size](#size)
* [isEmpty](#isempty)
* [IN](#in)

### `collection`

```javascript
  collection(string s) [string]
```

Returns an array of strings which have been loaded with the specified string `s`.

The named collections are listed on the **Data > Named Collections** page.

To check the size of the collection, use the `.size()` method.

To access the n-th element in the collection, use square brackets as in `[index]` or the `get(index)` method (starting with 0 for the first element).

```javascript
label = collection('hosts')[0]

tags.request_ip = collection('ip_white_list').get(1)
```

### `list`

```javascript
  list(string s[, string p]) [string]
```

Splits string `s` using separator `p` (default is comma ',') into a collection of string values. The function discards duplicate items by preserving only the first occurrence of each element. 

To access the n-th element in the collection, use square brackets as in `[index]` or the `get(index)` method (starting with 0 for the first element).

Examples:

```javascript
name = list('atsd, nurswgvml007').get(0) 
```

### `likeAll`

```javascript
  likeAll(object s, [string] c) boolean
```

Returns `true`, if the first argument `s` matches **every** element in the collection of patterns `c`. The collection `c` can be specified inline as an array of strings or reference a named collection.

Examples:

```javascript

likeAll(tags.request_ip, ['10.50.*', '10.50.102.?'])
```

### `likeAny`

```javascript
  likeAny(object s, [string] c) boolean
```

Returns `true`, if the first argument `s` matches **at least one** element in the collection of patterns `c`. The collection `c` can be specified inline as an array of strings or reference a named collection.

Examples:

```javascript
likeAny(tags.os, ['Ubuntu*', 'Centos*'])

likeAny(tags.request_ip, collection('ip_white_list'))
```

### `matches`

```javascript
  matches(string p, [string] c) boolean
```

Returns `true` if one of the collection `c` elements matches (satisfies) the specified pattern `p`.

The pattern supports `?` and `*` wildcards.

Example:

```javascript
matches('*atsd*', property_values('docker.container::image'))
```  

### `startsWithAny`

```javascript
  startsWithAny(object s, [string] c) boolean
```

Returns `true`, if the first argument `s` starts with any of strings from collection `c`. The collection `c` can be specified inline as an array of strings or reference a named collection.

Examples:

```javascript
startsWithAny(name, ['a', 'nur'])
```

### `collection_contains`

```javascript
  collection_contains(object v, [] c) boolean
```

Returns `true`, if collection `c` contains object `v`. The collection `c` can be specified inline as an array of strings or reference a named collection.

Examples:

```javascript
NOT collection_contains(tags['os'], collection('ignore_os'))   
```

### `collection_intersects`

```javascript
  collection_intersects([] f, [] s) boolean
```
Returns `true`, if collection `f` has elements in common with collection `s`. The collections can be specified inline as an arrays of strings or reference a named collections.

Examples:

```javascript
collection_intersects(tags.values(), collection('ip_white_list'))
```

### `upper`

```javascript
  upper(string s) string
```

Converts `s` to uppercase letters.

### `lower`

```javascript
  lower(string s) string
```

Converts `s` to lowercase letters.

### `property`

```javascript
  property([string e, ]string s) string
```

Returns the first value in the list of strings returned by the `property_values(string s)` function for the specified [property search](../rule-engine/property-search.md) expression `s` and entity `e`. 

The function returns an empty string if no matching property records are found.

Examples:

```javascript
property('docker.container::image') = 'axibase/collector:latest'

name = property('nurswgvml007', 'docker.container::image')
```

### `properties`

```javascript
  properties(string t) map
```

Returns the most resent `tag=value` map for property type `t`. Tag value can be accessed via the dot notation.

Examples:

```javascript

properties('docker.container').image LIKE 'axibase/*' 

NOT properties('docker.container').isEmpty()
```

### `property_values`

```javascript
  property_values([string e, ]string s) [string]
```

Returns a list of property tag values for the given entity for the specified [property search](../rule-engine/property-search.md) expression `s`.

The function returns an empty list if the entity, property or tag is not found.

Examples:

```javascript
name IN property_values('nurswgvml007', 'docker.container::image')

property_values('linux.disk:fstype=ext4:mount_point').contains('/')
```

### `hasMetric`

```javascript
  hasMetric(string m[, integer n]) boolean
```

Returns `true` if the entity collects the specified metric `m`, regardless of tags.

If the optional hours `n` argument is specified, only rows inserted for the last `n` hours are evaluated. 

Examples:

```javascript
hasMetric('mpstat.cpu_busy')

hasMetric('mpstat.cpu_busy', 24*7)
```

### `memberOf`

```javascript  
  memberOf(string|[sring] g) boolean
```
Returns `true` if an entity belongs to **at least one** of the specified entity groups.

Examples:

```javascript
memberOf('all-linux-servers')

memberOf(['aws-ec2', 'aws-ebs'])

memberOf(collection('groups'))
```

### `memberOfAll`

```javascript
  memberOfAll([string] g) boolean
```
Returns `true` if an entity belongs to **every** of the specified entity groups.

Examples:

```javascript
memberOfAll(['aws-ec2', 'aws-ebs'])

memberOfAll(collection('groups'))   
```

### `entity_tags`

```javascript
  entity_tags(string e) map
```
Returns entity tags for entity `e` as a map.

If the entity is not found, an empty map is returned.

Examples:

```javascript
tags.file_system = entity_tags('nurswgml007').file_system
```

### `contains`

```javascript
  [string].contains(string s) boolean
```

Returns `true` if `s` is contained in the collection.

Example:

```javascript
collection('ip_white_list').contains(tags.request_ip)
```

### `size`

```javascript
  [].size() integer
```

Returns the number of elements in the collection.

> This function can be applied to collections of any type (string, number) as well as to maps.

Examples:

```javascript
collection('ip_white_list').size()
```    

### `isEmpty`

```javascript
  [].isEmpty() boolean
```

Returns `true` if the number of elements in the collection is zero.

> This function can be applied to collections of any type (string, number) as well as to maps.

Example:

```javascript
collection('ip_white_list').isEmpty()
```  

### `IN`

```javascript
  string s IN (string a[, string b[...]]) boolean
```

Returns `true` if `s` is contained in the collection of strings enclosed in round brackets.

Examples:

```javascript
name IN ('nurswgvml007', 'nurswgvml008')

tags.location IN ('NUR', 'SVL')
```  