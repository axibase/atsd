# Entity Filter Fields

* One of the below entity fields is **required**.
* Field precedence, from highest to lowest: `entity`, `entities`, `entityGroup`. Although multiple fields are allowed in the query object, only the field with higher precedence is applied.
* `entityExpression` is applied as an additional filter to the `entity`, `entities`, and `entityGroup` fields. For example, if both the `entityGroup` and `entityExpression` fields are specified, `entityExpression` is applied to members of the specified entity group.
* Entity name pattern supports asterisk (`*`) and question mark (`?`) as wildcard characters.

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| `entity`   | string | Entity name or entity name pattern.<br>Example: `"entity":"nur007"` or `"entity":"svl*"` |
| `entities` | array | Array of entity names or entity name patterns.<br>Example: `"entities":["nur007", "nur010", "svl*"]`|
| `entityGroup` | string | Entity group name. <br>Example: `"entityGroup":"nur-prod-servers"`.<br>Returns records for members of the specified group.<br>The result is empty if the group does not exist or is empty.|
| `entityExpression` | string | Matches entities by name, entity tag, and properties based on the specified [filter expression](#entityexpression-syntax). <br>Example: `"entityExpression":"tags.location = 'SVL'"`  |

## `entityExpression` Syntax

`entityExpression` returns boolean result based on evaluating an expression.

Supported fields:

* id
* name
* label
* enabled
* tags.tag-name or tags['tag-name']

### Supported Functions

* Property Functions
  * [`property`](../../configuration/functions-entity-groups-expression.md#property)
  * [`property_values`](../../configuration/functions-entity-groups-expression.md#property_values), access to returned objects is not supported
* Lookup Functions
  * [`entity_tags`](../../configuration/functions-entity-groups-expression.md#entity_tags)
* Collection Functions
  * [`collection`](../../configuration/functions-entity-groups-expression.md#collection)  
  * [`likeAll`](../../configuration/functions-entity-groups-expression.md#likeall)
  * [`likeAny`](../../configuration/functions-entity-groups-expression.md#likeany)
  * [`matches`](../../configuration/functions-entity-groups-expression.md#matches)  
  * [`collection_contains`](../../configuration/functions-entity-groups-expression.md#collection_contains)
  * [`contains`](../../configuration/functions-entity-groups-expression.md#contains)
  * [`size`](../../configuration/functions-entity-groups-expression.md#size)
  * [`isEmpty`](../../configuration/functions-entity-groups-expression.md#isempty)  
  * [`IN`](../../configuration/functions-entity-groups-expression.md#in)
* Text Functions
  * [`upper`](../../configuration/functions-entity-groups-expression.md#upper)
  * [`lower`](../../configuration/functions-entity-groups-expression.md#lower)
  * [`list`](../../configuration/functions-entity-groups-expression.md#list)
* Utility functions
  * [`memberOf`](../../configuration/functions-entity-groups-expression.md#memberof)
  * [`memberOfAll`](../../configuration/functions-entity-groups-expression.md#memberofall)

### Examples

#### Entity Name Match

```javascript
  /*
  Match entities with name starting with 'nurswgvml',
  for example 'nurswgvml001', 'nurswgvml772'.
  */
  name LIKE 'nurswgvml*'
```

#### Entity Label Match

```javascript
  /*
  Match entities whose label does not contain the 'nur' substring.
  */
  label NOT LIKE '*nur*'
```

#### Enabled/Disabled Entity Match

```javascript
  /* Match enabled entities. */
  enabled = true

  /* Match disabled entities. */
  enabled = false
```

#### Entity Tag Match

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

#### Property Match

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
