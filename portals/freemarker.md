# Freemarker Expressions

Freemarker expressions are supported in portal creation.

#### Freemarker Functions

##### getTags

```javascript
getTags('metric', 'entity', 'tagKey'[, hours])
```

Returns a string collection.

Tag values for metric, entity, and tagKey.
`[, hours]` is an optional parameter, which specifies the time interval (in hours) for searching unique tag values. The default interval is 24 hours.

```
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

##### groupTag

```javascript
groupTag('entity', 'tagKey')
```

Returns a string collection.

Returns collection of tag values for tagKey of all entity groups to which the entity belongs to.

```javascript
groupTag('nurswgvml007', 'cpu_busy_avg_15_min')
```

##### getMetrics

```javascript
getMetrics('entity')
```

String collection.

Returns collected metrics for a particular entity.

```
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

```
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

##### isMetric

```javascript
isMetric('metric')
```

Boolean.

Returns true if a metric exists.

```
<#if isMetric("nmon.processes.blocked") >
    [series]        
        label = blocked
        entity = ${entity}
        metric = nmon.processes.blocked
</#if>   
```
##### isMetricCollected

```javascript
isMetricCollected('metric', 'entity')
```

Boolean.

Returns true if there is some data for metric and entity inserted in the last 24 hours.

```
<#if isMetricCollected("nmon.processes.blocked", "${entity}") >
    [series]        
        label = blocked
        entity = ${entity}
        metric = nmon.processes.blocked
</#if>  
```
##### getProperty

```javascript
getProperty('entity', 'property_type', 'tagKey')
```

Returns a string collection.

Retrieve a collection of property objects for a specified entity, property type, and tag.


```
<#if isMetricCollected("nmon.processes.blocked", "${entity}") >
    [series]        
        label = blocked
        entity = ${entity}
        metric = nmon.processes.blocked
</#if>
```
##### getSeriesProperties

```javascript
getSeriesProperties("{entity}", "{property_type}")
```

Returns property objects for a specified entity and property type.

Retrieve a collection of property objects for a specified entity and property type.
If no entity is specified, then the schema retrieves a collection of property objects for all entities with the specified property type.

```
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

##### getTagMaps

```javascript
getTagMaps('metric', 'entity'[, hours])
```

Returns collection of maps(string, string).

Retrieve a collection of unique tag maps for metric and entity.
`[, hours]` is an optional parameter, which specifies the time interval (in hours) for searching unique tag values. The default interval is 24 hours.

```
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

```javascript
<#assign total = atsd_last("nurswgvml007", "disk_size", "mount_point=/,file_system=/dev/mapper/vg_nurswgvml007-lv_root") >
  total-value = ${total?c}
```

##### memberOf

```javascript
memberOf('entity', 'group1', …, 'groupN')
```

Boolean.

Returns true if an entity belongs to any of the specified entity groups.

```
<#if memberOf("nurswgvml007", "aix-servers") >
    [series]        
        entity = ${entity}
        metric = lpar.used_units
</#if> 
```

##### memberOfAll

```javascript
memberOfAll('entity', 'group1', …, 'groupN')
```

Boolean.

Returns true if an entity belongs to all of the entity groups.

```
<#if isMetricCollected("nmon.processes.blocked", "${entity}") >
    [series]        
        label = blocked
        entity = ${entity}
        metric = nmon.processes.blocked
</#if>
```

##### lastInsertTime & lastInsertDate

```javascript
lastInsertTime('entity'[, ‘metric’])
```

```javascript
lastInsertDate('entity'[, ‘metric’])
```

Double.

Returns the last insert time for the entity or entity/metric combination in milliseconds (Time) or ISO format (Date). Metric is an optional parameter.

```
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

```
lastInsertDate('nurswgvml007', 'cpu_busy')
```

##### getEntitiesForGroup:

```javascript
getEntitiesForGroup('group')
```

```javascript
getEntitiesForGroup('group', 'hours')
```

Returns a string collection.

Finds all entities in a particular entity group. This can be useful when building portals that compare entities from the same entity group. The method returns group member that have inserted data over the last N hours.
If hours are not specified or are non-positive, all group members are returned.

```
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

##### getEntitiesForTags:

```javascript
getEntitiesForTags(expression)
```

Returns a string collection.

Finds entities by expression, based on tags.

```
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

http://atsd.com/portal/1.xhtml?app=> value1&dc=> value2

All entities, for which the `app` tag is => `value1` and `dc` tag is => `value2`, will be loaded into the portal.

In the second example, we are searching for entities with a specific application tag. The required value can be specified directly in the browser:

http://atsd.com/portal/1.xhtml?application=> value

All entities, for which the application tag is > `value`, will be loaded into the portal.

A single line of freemarker code can be used to easily customize the results of the portal by searching for entity tags rather that specific entities. This gives extensive possibilities to create flexible portals.

The freemarker search can be for any combination of tags. For example: > `application` > `data center` > `function`. Only entities that have all three specified tags will be loaded into the portal.

In the response, the `freemarker` [series] are substituted with the matching entities, creating [series] for each of them.

##### Example output of a `freemarker` [series]:

```
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

Advanced functions and aggregations can be added to the freemarker portals to enhance the resulting data prior to loading it into the portal. Below are two examples:

##### The `freemarker` [series] is given an alias, that can then be used to sum the loaded data:

```
<#assign servers = getEntitiesForGroup("Linux") >
 <#list servers as server>
	[series]
		entity = ${server}
		metric = cpu_busy
		alias = cpuused_${server}
 </#list>
```

##### The `freemarker` [series] data can be aggregated by ATSD prior to loading into the portal:

```
[series]
    label = P99 CPU Used
    value = 0 <#list servers as server> + percentile(99,'cpuused_${server}','1 day')</#list>
```

#### Freemarker Expressions Summary Table

| Name | Returns | Description | 
| --- | --- | --- | 
|  <p>`atsd_last('entity', 'metric', 'tag1=v1,tag2=v2')`</p>  |  <p>Double</p>  |  <p>Last value for time series or null.</p>  | 
|  <p>`groupTag('entity', 'tagKey')`</p>  |  <p>string collection</p>  |  <p>Collection of tag values for tagKey of all entity groups an entity belongs to.</p>  | 
|  <p>`tag('entity', 'tagKey')`</p>  |  <p>string</p>  |  <p>Entity tag value.</p>  | 
|  <p>`memberOf('entity', 'group1', ..., 'groupN')`</p>  |  <p>boolean</p>  |  <p>Returns true if an entity belongs to any of specified entity groups.</p>  | 
|  <p>`memberOfAll('entity', 'group1', ..., 'groupN')`</p>  |  <p>boolean</p>  |  <p>Returns true if an entity belongs to all of the entity groups.</p>  | 
|  <p>`list('value' [, delimiter])`</p>  |  <p>string collection</p>  |  <p>Splits a string by a delimeter. Default delimiter is comma character.</p>  | 
|  <p>`getTags('metric', 'entity', 'tagKey'[, hours])`</p>  |  <p>string collection</p>  |  <p>Tag values for metric, entity, and tagKey.</p>  <p>[, hours] is an optional parameter, which specifies the time interval (in hours) for searching unique tag values.</p>  <p>Default interval is 24 hours.</p>  | 
|  <p>`getEntitiesForTags(expression)`</p>  |  <p>string collection</p>  |  <p>Finds entities by expression.</p>  | 
|  <p>`getEntitiesForGroup("group")`</p>  |  <p>string collection</p>  |  <p>Finds all entities in a particular entity group. This is useful when building portals that compare entities from the same entity group.</p>  | 
|  <p>`getEntitiesForGroup(groupName, hours)`</p>  |  <p>string collection</p>  |  <p>Finds all entities in a particular entity group. This is useful when building portals that compare entities from the same entity group.</p>  <p>The method returns group members that have inserted data over the last N hours.</p>  <p>If hours are not specified or non-positive, all group members are returned.</p>  | 
|  <p>`getMetrics('entity')`</p>  |  <p>string collection</p>  |  <p>Retrieve all collected metrics for a particular entity.</p>  | 
|  <p>`isMetric('metric')`</p>  |  <p>boolean</p>  |  <p>Returns true if a metric exists.</p>  | 
|  <p>`isMetricCollected('metric', 'entity')`</p>  |  <p>boolean</p>  |  <p>Returns true if there is some data for metric and entity inserted in last 24 hours.</p>  | 
|  <p>`hasMetric('entity', 'metric' [,hours])`</p>  |  <p>boolean</p>  |  <p>Executes query for Last Insert Cache table. Returns true if the entity collects specified the metric, regardless of tags.</p>  <p>If the optional hours argument is specified, only rows inserted for the last N hours are evaluated.</p>  | 
|  <p>`getTagMaps('metric', 'entity'[, hours])`</p>  |  <p>collection of maps(string, string)</p>  |  <p>Collection of unique tag maps for metric and entity.</p>  <p>`[, hours]` is an optional parameter, which specifies the time interval (in hours) for searching unique tag values.</p>  <p>The default interval is 24 hours.</p>  | 
|  <p>`getProperty('entity', 'property_type', 'tagKey')`</p>  |  <p>string collection</p>  |  <p>Retrieves a collection of property objects for specified entity, property type, and tag.</p>  | 
|  <p>`getSeriesProperties("{entity}", "{property_type}")`</p>  |  <p>property objects for specified entity and property type</p>  |  <p>Retrieves a collection of property objects for a specified entity and property type.</p>  <p>If no entity is specified, then a collection of property objects for all entities with the specified property type is retrieved.</p>  | 
|  <p>`atsd_values(entity, metric, tags, type, interval, shift, duration)`</p>  |  <p>Aggregator object</p>  |  <p>See tables below.</p>  | 
|  <p>`lastInsertTime('entity'[, ‘metric’])`</p>  |  <p>Double</p>  |  <p>Returns last insert time for the entity or entity/metric combination in milliseconds. Metric is an optional parameter.</p>  | 
|  <p>`lastInsertDate('entity'[, ‘metric’])`</p>  |  <p>Double</p>  |  <p>Returns last insert date for the entity or entity/metric combination in ISO format. Metric is an optional parameter.</p>  | 


#### atsd_values parameters

| Name | Description | 
| --- | --- | 
|  <p>entity</p>  |  <p>Entity</p>  | 
|  <p>metric</p>  |  <p>Metric</p>  | 
|  <p>tags</p>  |  <p>Tags</p>  | 
|  <p>type</p>  |  <p>Aggregation Type</p>  | 
|  <p>interval</p>  |  <p>Aggregation Interval</p>  | 
|  <p>shift</p>  |  <p>Interval: endTime = now – shift</p>  | 
|  <p>duration</p>  |  <p>Selection interval: startTime = endTime – duration</p>  | 


#### atsd_values parameters

| Name | Returns | 
| --- | --- | 
|  <p>min()</p>  |  <p>Double</p>  | 
|  <p>max()</p>  |  <p>Double</p>  | 
|  <p>sumOf()</p>  |  <p>Double</p>  | 
|  <p>average()</p>  |  <p>Double</p>  | 
|  <p>countOf()</p>  |  <p>Integer</p>  | 
|  <p>asList()</p>  |  <p>Double collection</p>  | 
