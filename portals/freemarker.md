# Freemarker Expressions

Freemarker expressions are supported in portal creation.

## Freemarker Functions

##### `getTags`

```javascript
getTags('metric', 'entity', 'tagKey'[, hours])
```

Returns a string collection.

Tag values for metric, entity, and `tagKey`.
`[, hours]` is an optional parameter, which specifies the time interval (in hours) for searching unique tag values. The default interval is 24 hours.

```freemarker
<#assign cpus = getTags("nmon.cpu.idle%", "${entity}", "id") >      
<#list cpus as id>
    [series]
        label = ${id}
        entity = ${entity}
        metric = nmon.cpu.busy%
        #type = avg
        #interval = 5 minute
        [tag]
            name = id
            value = ${id}
</#list>
```

##### tag

```javascript
tag('entity', 'tagKey')
```

Returns a string.

Entity tag value.

```javascript
tag('nurswgvml007', 'location')
```

##### `groupTag`

```javascript
groupTag('entity', 'tagKey')
```

Returns a string collection.

Returns collection of tag values for `tagKey` of all entity groups to which the entity belongs to.

```javascript
groupTag('nurswgvml007', 'cpu_busy_avg_15_min')
```

##### `getMetrics`

```javascript
getMetrics('entity')
```

String collection.

Returns collected metrics for a particular entity.

```freemarker
<#assign metrics = getMetrics("${entity}") >      
<#list metrics as metric>
    [series]
        label = ${metric}
        entity = ${entity}
        metric = ${metric}
        statistic = avg
        period = 10 minute
</#list
```

```freemarker
<#assign metrics = getMetrics("${entity}") >      
<#list metrics as metric>
<#if metric?index_of("cpu") gte 0>
  [widget]
      type = chart
      timespan = 1 hour
    [series]
        label = ${metric}
        entity = ${entity}
        metric = ${metric}
        statistic = avg
        period = 5 minute
</#if>
</#list>
```

##### `isMetric`

```javascript
isMetric('metric')
```

Boolean.

Returns true if a metric exists.

```freemarker
<#if isMetric("nmon.processes.blocked") >
    [series]
        label = blocked
        entity = ${entity}
        metric = nmon.processes.blocked
</#if>
```

##### `isMetricCollected`

```javascript
`isMetricCollected('metric', 'entity')`
```

Boolean.

Returns true if there is some data for metric and entity inserted in the last 24 hours.

```freemarker
<#if isMetricCollected("nmon.processes.blocked", "${entity}") >
    [series]        
        label = blocked
        entity = ${entity}
        metric = nmon.processes.blocked
</#if>
```

##### `getProperty`

```javascript
getProperty('entity', 'property_type', 'tagKey')
```

Returns a string collection.

Retrieve a collection of property objects for a specified entity, property type, and tag.

```freemarker
<#if isMetricCollected("nmon.processes.blocked", "${entity}") >
    [series]        
        label = blocked
        entity = ${entity}
        metric = nmon.processes.blocked
</#if>
```

##### `getSeriesProperties`

```javascript
getSeriesProperties("{entity}", "{property_type}")
```

Returns property objects for a specified entity and property type.

Retrieve a collection of property objects for a specified entity and property type.
If no entity is specified, then the schema retrieves a collection of property objects for all entities with the specified property type.

```freemarker
<#assign ebs_volume_tags = getSeriesProperties(volume, "aws_ec2.attachmentset") >
<#list ebs_volume_tags as volume_tags>
  <#if volume_tags.entity == volume>
[series]
    label = ${volume}
    label = ${volume_tags.key.device}
    entity = ${volume}
    metric = aws_ebs.volumequeuelength.maximum
  </#if>
</#list>
```

##### `getTagMaps`

```javascript
getTagMaps('metric', 'entity'[, hours])
```

Returns collection of maps(string, string).

Retrieve a collection of unique tag maps for metric and entity.
`[, hours]` is an optional parameter, which specifies the time interval (in hours) for searching unique tag values. The default interval is 24 hours.

```freemarker
<#assign procMaps = getTagMaps("nmon.process.%cpu", "${entity}") >  
<#list procMaps as procMap>
    [series]
        label = ${procMap['command']}
        entity = ${entity}
        metric = nmon.process.%cpu  
        [tag]
            name = pid
            value = ${procMap['pid']}        
        [tag]
            name = command
            value = ${procMap['command']}
</#list>
```

##### atsd_last

```javascript
atsd_last("entity", "metric", "tag1=v1,tag2=v2")
```

Retrieves the last value (a number) for a specified entity, metric, and series tags. The value is searched for a timespan of 2 hours.

If the series has multiple tags, the last argument must include all tags.

```javascript
atsd_last("nurswgvml007", "disk_size", "mount_point=/,file_system=/dev/mapper/vg_nurswgvml007-lv_root")
```

If the series has no tags, the last argument may be omitted or set to empty string.

```javascript
atsd_last("nurswgvml007", "cpu_busy")
```

The returned value is formatted according to server locale. For example 13325 is formatted as 13,325. To remove formatting append `?c` at the end of the function or assigned variable.

```freemarker
<#assign total = atsd_last("nurswgvml007", "disk_size", "mount_point=/,file_system=/dev/mapper/vg_nurswgvml007-lv_root") >
  total-value = ${total?c}
```

##### `memberOf`

```javascript
memberOf('entity', 'group1', …, 'groupN')
```

Boolean.

Returns true if an entity belongs to any of the specified entity groups.

```freemarker
<#if memberOf("nurswgvml007", "aix-servers") >
    [series]        
        entity = ${entity}
        metric = lpar.used_units
</#if>
```

##### `memberOfAll`

```javascript
memberOfAll('entity', 'group1', …, 'groupN')
```

Boolean.

Returns true if an entity belongs to all of the entity groups.

```freemarker
<#if isMetricCollected("nmon.processes.blocked", "${entity}") >
    [series]
        label = blocked
        entity = ${entity}
        metric = nmon.processes.blocked
</#if>
```

##### `lastInsertTime` & `lastInsertDate`

```javascript
lastInsertTime('entity'[, ‘metric’])
```

```javascript
lastInsertDate('entity'[, ‘metric’])
```

Double.

Returns the last insert time for the entity or entity/metric combination in milliseconds (Time) or ISO format (Date). Metric is an optional parameter.

```freemarker
<#assign ebs_volume_tags = getSeriesProperties(volume, "aws_ec2.attachmentset") >
   <#list ebs_volume_tags as volume_tags>
      <#if volume_tags.entity == volume>
	[series]
		label = ${volume}
        label = ${volume_tags.key.device}
		entity = ${volume}
		metric = aws_ebs.volumequeuelength.maximum
      </#if>
   </#list
```

```javascript
lastInsertDate('nurswgvml007', 'cpu_busy')
```

##### `getEntitiesForGroup`

```javascript
getEntitiesForGroup('group')
```

```javascript
getEntitiesForGroup('group', 'hours')
```

Returns a string collection.

Finds all entities in a particular entity group. This can be useful when building portals that compare entities from the same entity group. The method returns group member that have inserted data over the last N hours.
If hours are not specified or are non-positive, all group members are returned.

```freemarker
<#assign servers = getEntitiesForGroup("VMware Hosts") >
<#list servers as server>
    [series]
        entity = ${server}
        metric = cpu.used
</#list>
<#list servers as server>
    [series]
        entity = ${server}
        metric = cpu.used
</#list>
```

##### `getEntitiesForTags`

```javascript
getEntitiesForTags(expression)
```

Returns a string collection.

Finds entities by expression, based on tags.

```freemarker
<#assign servers = getEntitiesForTags("", "(app == '${app}' OR '${app}' == '' AND app != '') AND 
                                            (dc == '${dc}' OR '${dc}' == '' AND dc != '')") >
<#list servers as server>
    [series]
        label = ${server}
        entity = ${server}
        metric = physical_cpu_units_used
</#list>
<#assign servers = getEntitiesForTags("", "application = '${entity}'") >   
<#list servers as server>
    [series]
        entity = ${server}
        metric = physical_cpu_units_used
</#list>
```

In the first example, we are searching for entities with two tags. The required value can be specified directly in the browser:

```elm
http://atsd.com/portal/1.xhtml?app=> value1&dc=> value2
```

All entities, for which the `app` tag is => `value1` and `dc` tag is => `value2`, will be loaded into the portal.

In the second example, we are searching for entities with a specific application tag. The required value can be specified directly in the browser:

```elm
http://atsd.com/portal/1.xhtml?application=> value
```

All entities, for which the application tag is > `value`, will be loaded into the portal.

Freemarker expressions can be used to customize the portal by searching for entity tags rather that specific entities. This gives extensive possibilities to create flexible portals.

The Freemarker search can be for any combination of tags. For example: > `application` > `data center` > `function`. Only entities that have all three specified tags will be loaded into the portal.

In the response, the `freemarker` [series] are substituted with the matching entities, creating [series] for each of them.

##### Example output of a `freemarker` [series]

```ls
[configuration]
title = CPU Used Portal
height-units = 1
width-units = 1
 
[group]
 
[widget]
type = chart
title = CPU Used
time-span = 1 hour
max-range = 100
 
[series]
label = host0987
entity = host0987
metric = cpu_used
 
[series]
label = host1040
entity = host1040
metric = cpu_used
 
[series]
label = host1299
entity = host1299
metric = cpu_used
 
[series]
label = host1786
entity = host1786
metric = cpu_used
```

Advanced functions and aggregations can be added to the Freemarker portals to enhance the resulting data prior to loading it into the portal. Below are two examples:

##### The `freemarker` [series] is given an alias, that can then be used to sum the loaded data

```freemarker
<#assign servers = getEntitiesForGroup("Linux") >
 <#list servers as server>
	[series]
		entity = ${server}
		metric = cpu_busy
		alias = cpuused_${server}
 </#list>
```

##### The `freemarker` [series] data can be aggregated by ATSD prior to loading into the portal

```ls
[series]
    label = P99 CPU Used
    value = 0 <#list servers as server> + percentile(99,'cpuused_${server}','1 day')</#list>
```

#### Freemarker Expressions Summary Table

| Name | Returns | Description | 
| --- | --- | --- | 
|  `atsd_last('entity', 'metric', 'tag1=v1,tag2=v2')`  |  Double  |  Last value for time series or null.  | 
|  `groupTag('entity', 'tagKey')`  |  string collection  |  Collection of tag values for `tagKey` of all entity groups an entity belongs to.  | 
|  `tag('entity', 'tagKey')`  |  string  |  Entity tag value.  | 
|  `memberOf('entity', 'group1', ..., 'groupN')`  |  boolean  |  Returns true if an entity belongs to any of specified entity groups.  | 
|  `memberOfAll('entity', 'group1', ..., 'groupN')`  |  boolean  |  Returns true if an entity belongs to all of the entity groups.  | 
|  `list('value' [, delimiter])`  |  string collection  |  Splits a string by a delimiter. Default delimiter is comma.  | 
|  `getTags('metric', 'entity', 'tagKey'[, hours])`  |  string collection  |  Tag values for metric, entity, and `tagKey`.<br>[, hours] is an optional parameter, which specifies the time interval (in hours) for searching unique tag values.<br>Default interval is 24 hours.  | 
|  `getEntitiesForTags(expression)`  |  string collection  |  Finds entities by expression.  | 
|  `getEntitiesForGroup(group)`  |  string collection  |  Finds all entities in a particular entity group. This is useful when building portals that compare entities from the same entity group.  | 
|  `getEntitiesForGroup(groupName, hours)`  |  string collection  |  Finds all entities in a particular entity group. This is useful when building portals that compare entities from the same entity group.<br>The method returns group members that have inserted data over the last N hours.<br>If hours are not specified or non-positive, all group members are returned.  | 
|  `getMetrics('entity')`  |  string collection  |  Retrieve all collected metrics for a particular entity.  | 
|  `isMetric('metric')`  |  boolean  |  Returns true if a metric exists.  | 
|  `isMetricCollected('metric', 'entity')`  |  boolean  |  Returns true if there is some data for metric and entity inserted in last 24 hours.  | 
|  `hasMetric('entity', 'metric' [,hours])`  |  boolean  |  Executes query for Last Insert Cache table. Returns true if the entity collects specified the metric, regardless of tags.<br>If the optional hours argument is specified, only rows inserted for the last N hours are evaluated.  | 
|  `getTagMaps('metric', 'entity'[, hours])`  |  collection of maps(string, string)  |  Collection of unique tag maps for metric and entity.<br>`[, hours]` is an optional parameter, which specifies the time interval (in hours) for searching unique tag values.<br>The default interval is 24 hours.  | 
|  `getProperty('entity', 'property_type', 'tagKey')`  |  string collection  |  Retrieves a collection of property objects for specified entity, property type, and tag.  | 
|  `getSeriesProperties("{entity}", "{property_type}")`  |  property objects for specified entity and property type  |  Retrieves a collection of property objects for a specified entity and property type.<br>If no entity is specified, then a collection of property objects for all entities with the specified property type is retrieved.  | 
|  `atsd_values(entity, metric, tags, type, interval, shift, duration)`  |  Aggregator object  |  See tables below.  | 
|  `lastInsertTime('entity'[, 'metric'])`  |  Double  |  Returns last insert time for the entity or entity/metric combination in milliseconds. Metric is an optional parameter.  | 
|  `lastInsertDate('entity'[, 'metric'])`  |  Double  |  Returns last insert date for the entity or entity/metric combination in ISO format. Metric is an optional parameter.  | 


#### atsd_values parameters

| Name | Description | 
| --- | --- | 
|  `entity`  |  Entity  | 
|  `metric`  |  Metric  | 
|  `tags`  |  Tags  | 
|  `type`  |  Aggregation Type  | 
|  `interval`  |  Aggregation Interval  | 
|  `shift`  |  Interval: `endTime = now – shift`  | 
|  `duration`  |  Selection interval: `startTime = endTime – duration`  | 

#### atsd_values parameters

| Name | Returns | 
| --- | --- | 
|  `min()`  |  Double  | 
|  `max()`  |  Double  | 
|  `sumOf()`  |  Double  | 
|  `average()`  |  Double  | 
|  `countOf()`  |  Integer  | 
|  `asList()`  |  Double collection  | 
