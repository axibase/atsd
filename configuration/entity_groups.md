# Entity Groups

## Overview

Entity Groups provide a way to organize similar entities into cohesive collections that can be re-used when managing user permissions, filtering data, calculating aggregations etc.

![](images/entity-groups.png)

## Members

An entity group can be composed by manually specifying names of the entities that should be included as members.

It can be also created by specifying a criteria against which all entities that exist in the database will be evaluated. Those entities that match the criteria will be added as members automatically and the group will be continuously updated in the background.

The entity group editor provides the following options for managing entities:

### List

Copy a list of entity names, one per line, into the text area. The names are case-insensitive.

If 'Create Entities' option is checked, new entities will be automatically created when the form is saved. Otherwise, names for which there are no existing entities found, will be ignored.

### Selector

Select one or multiple existing entities in the right pane and click 'Add' to add members.

Select current members in the left pane and click 'Remove' to delete members from the group.

### Expression

Specify a boolean expression to add/remove entities automatically. 

The expression can include the following fields and supports wildcards in field values:

    * `name`
    * `label`
    * `enabled`
    * `tags.{name}` or `tags['name']`

The expression may refer to entity properties and [functions](#supported-functions) in order to find matching entities.

> Expression-based groups are continuously updated by the server at a frequency specified with the `entity.group.update.schedule` setting.

#### Supported Functions

* Property Functions

   * [property](functions-entity-groups-expression.md#property)
   * [properties](functions-entity-groups-expression.md#properties)
   * [property_values](functions-entity-groups-expression.md#property_values), access to returned objects isn't supported

* Lookup Functions

   * [entity_tags](functions-entity-groups-expression.md#entity_tags)
   
* Collection Functions

   * [collection](functions-entity-groups-expression.md#collection)
   * [likeAll](functions-entity-groups-expression.md#likeall)
   * [likeAny](functions-entity-groups-expression.md#likeany)
   * [matches](functions-entity-groups-expression.md#matches)
   * [collection_contains](functions-entity-groups-expression.md#collection_contains)
   * [collection_intersects](functions-entity-groups-expression.md#collection_intersects)   
   * [contains](functions-entity-groups-expression.md#contains)
   * [size](functions-entity-groups-expression.md#size)
   * [isEmpty](functions-entity-groups-expression.md#isempty)
   * [IN](functions-entity-groups-expression.md#in)
  
* Text Functions

   * [upper](functions-entity-groups-expression.md#upper)
   * [lower](functions-entity-groups-expression.md#lower)
   * [list](functions-entity-groups-expression.md#list)
   * [startsWithAny](functions-entity-groups-expression.md#startswithany)
   
* Utility functions

   * [hasMetric](functions-entity-groups-expression.md#hasmetric)
   * [memberOf](functions-entity-groups-expression.md#memberof)
   * [memberOfAll](functions-entity-groups-expression.md#memberofall)
   
#### Examples:

* Entity name contains the specified string

	```java
	name LIKE 'nur*vml*'
	```

* Entity has the specified entity tag

	```java
	tags.docker-type != ''
	```

* Entity has an entity tag equal to the specified value

	```java
	tags.docker-type = 'container'
	```

* Entity has entity tags equal to the specified values

	```java
	tags.docker-type = 'container' && tags.status != 'deleted'
	```

* Entity collects the specified property type

	```java
	properties('oem.oracle_database').size() > 0
	```

* Entity collects the specified metric

	```java
	hasMetric('mpstat.cpu_busy')
	```

* Entity collected the specified metric within N hours

	```java
	hasMetric('mpstat.cpu_busy', 24*7)
	```

* Entity property tag value matches the given expression

	```java
	properties('cfg').prog != '' && properties('cfg').prog NOT LIKE 'topas*'
	```

* Entity is a member of another group

    ```java
	 memberOf('all-linux-servers') && tags.location = 'SVL'
    ```