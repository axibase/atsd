# Entity Filter Fields

* One of the below entity fields is **required**.
* Field precedence, from high to low: `entity`, `entities`, `entityGroup`. Although multiple fields are allowed in the query object, only the field with higher precedence will be applied.
* `entityExpression` is applied as an additional filter to the `entity`, `entities`, and `entityGroup` fields. For example, if both the `entityGroup` and `entityExpression` fields are specified, `entityExpression` is applied to members of the specified entity group.
* Entity name pattern supports `?` and `*` wildcards.

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| entity   | string | Entity name or entity name pattern.<br>Example: `"entity":"nur007"` or `"entity":"svl*"` |
| entities | array | Array of entity names or entity name patterns.<br>Example: `"entities":["nur007", "nur010", "svl*"]`|
| entityGroup | string | Entity group name. <br>Example: `"entityGroup":"nur-prod-servers"`.<br>Returns records for members of the specified group.<br>The result is empty if the group doesn't exist or is empty.|
| entityExpression | string | Matches entities by name, entity tag, and properties based on the specified [filter expression](#entityexpression-syntax). <br>Example: `"entityExpression":"tags.location = 'SVL'"`  |

## `entityExpression` Syntax

`entityExpression` returns boolean result based on evaluating an expression.

Supported fields:

* id (entity id)
* name (entity id)
* label
* enabled
* tags.tag-name or tags['tag-name']

### Supported Functions

* Property Functions

   * [property(string s)](../../rule-engine/functions-property.md#property)
   * [property_values(string s)](../../rule-engine/functions-property.md#property_values), access to returned objects isn't supported
   * [properties](./series/examples/query-entity-expr-entity-properties.md#description)

* Lookup Functions

   * [entity_tags(string e)](../../rule-engine/functions-lookup.md#entity_tags)
   * [collection](../../rule-engine/functions-lookup.md#collection)
   
* Collection Functions

   * [collection](../../rule-engine/functions-collection.md#collection)
   * [IN](../../rule-engine/functions-collection.md#in)
   * [likeAny](../../rule-engine/functions-collection.md#likeany)
   * [matches](../../rule-engine/functions-collection.md#matches)
   * [contains](../../rule-engine/functions-collection.md#contains)
   * [size](../../rule-engine/functions-collection.md#size)
   * [isEmpty](../../rule-engine/functions-collection.md#isempty)
  
* Text Functions

   * [upper](../../rule-engine/functions-collection.md#upper)
   * [lower](../../rule-engine/functions-collection.md#lower)
   * [list](../../rule-engine/functions-collection.md#list)
   
## Examples

### Entity Name Match

```javascript
  /*
  Match entities with name starting with 'nurswgvml', 
  for example 'nurswgvml001', 'nurswgvml772'.
  */
  id LIKE 'nurswgvml*'
```

### Entity Label Match

```javascript
  /*
  Match entities whose label does not contain the 'nur' substring.
  */
  label NOT LIKE '*nur*'
```

### Enabled/Disabled Entity Match

```javascript
  /* Match enabled entities. */
  enabled = true
  
  /* Match disabled entities. */
  enabled = false
  
```

### Entity Tag Match

```javascript
  /*
  Match entities with entity tag 'environment' equal to 'production'.
  */
  tags.environment = 'production'

  /*
  Match entities with entity tag 'location' starting with 'SVL', 
  for example 'SVL', 'SVL02'.
  */
  tags.location LIKE 'SVL*'

  /*
  Match entities with entity tag 'container_label.com.axibase.code' equal to 'collector'.
  */
  tags.container_label.com.axibase.code = 'collector'

  /*
  Match entities with entity tag 'docker-host' contained in the collection.
  */
  tags.docker-host IN ('dock1', 'dock2')
```

### Property Match

```javascript
  /*
  Match entities with a 'java_home' stored in 'docker.container.config.env' 
  equal to '/usr/lib/jvm/java-8-openjdk-amd64/jre'.
  */
  property('docker.container.config.env::java_home') = '/usr/lib/jvm/java-8-openjdk-amd64/jre'
  
  /*
  Match entities which have a '/opt' file_system stored in 'nmon.jfs' property type.
  */
  property_values('nmon.jfs::file_system').contains('/opt')

  /*
  Match entities with a 'file_system' which name includes 'ora', 
  stored in 'nmon.jfs' property type.
  */
  matches('*ora*', property_values('nmon.jfs::file_system'))

  /*
  Match entities with non-empty 'java_home' in 'docker.container.config.env' property type.
  */
  !property_values('docker.container.config.env::java_home').isEmpty()

  /*
  Match entities without 'java_home' in 'docker.container.config.env' property type.
  */
  property_values('docker.container.config.env::java_home').size() == 0
```
