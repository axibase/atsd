Weekly Change Log: February 27 - March 5, 2017
==============================================

### ATSD

| Issue| Category        | Type    | Subject                                                                              |
|------|-----------------|---------|--------------------------------------------------------------------------------------|
| [3940](#issue-3940) | client          | Feature | Added the `sendCommands` method to the [Python API client](https://github.com/axibase/atsd-api-python).                                                                |
| 3918 | api-rest        | Bug     | Removed the `last` parameter in [series](../../api/data/series/query.md) queries. Use [`limit=1`](../../api/data/series/query.md#control-filter-fields) instead.                                            |

### Collector

| Issue| Category        | Type    | Subject                                                                              |
|------|-----------------|---------|--------------------------------------------------------------------------------------|  
| [3977](#issue-3977) | UI              | Feature | Display linked job configurations for HTTP Pools, [Database Configurations](https://github.com/axibase/axibase-collector/blob/master/jobs/jdbc-data-source.md), and [Replacement Tables](https://github.com/axibase/axibase-collector/blob/master/collections.md#replacement-tables). |
| [3976](#issue-3976) | collection      | Feature | Added an option to specify executable script text on the Item List configuration page.                        |
| 3974 | http-pool       | Bug     | Fixed an error when deleting an HTTP Pool.                                 |
| 3969 | json            | Bug     | Fixed a conflict between `Included Fields` and `Metric Name & Value` fields.     |
| 3967 | collection      | Bug     | Speed up Item List (type `SCRIPT`) retrieval times by checking script presence and caching items.           |
| 3949 | json            | Bug     | Fixed incorrect inclusion of the `Entity` field as a metric field.                                             |
| 3933 | json            | Bug     | Fixed inconsistent specification for the `Custom Tags` field.                                                   |
| [3932](#issue-3932) | json            | Feature | Allowed for [JSON Path](https://github.com/jayway/JsonPath#operators) expressions in `Custom Tags` field.                          |
| 3829 | scheduler       | Bug     | Disabled `Run` button if a job if running.                                 |
| [3817-a](#issue-3817-a) | socrata         | Feature | Added an option to skip resending of already processed data.                         |
| [3817-b](#issue-3817-b) | socrata         | Feature | Added the `Query Filter` field to filter rows in a resultset.                         |

### Charts

| Issue| Category        | Type    | Subject                                                                              |
|------|-----------------|---------|--------------------------------------------------------------------------------------|
| 3970 | treemap         | Bug     | Fixed `display = false` behavior.                                                         |
| 3964 | table           | Bug     | Made calculated alert values available in the `hide-columns` function.                                      |
| [3961](#issue-3961) | treemap         | Feature | Implemented new `mode` settings: row, column, auto.                                                                     |
| 3960 | time-chart      | Bug     | Fixed legend visibility for wildcard series requested for multiple entities or an entity group.                                 |
| [3959](#issue-3959) | api             | Feature | Removed support for `last` setting due to ATSD API changes.                              |
| [3941](#issue-3941) | widget-settings | Feature | Implemented functions to retrieve entity and metric tags in `threshold` and other calculations. |
| 3927 | core            | Bug     | Fixed the order of widget content geometry calculation.                                |

## ATSD

### Issue 3940
--------------

New `sendCommands` method:

```python
import atsd_client
from atsd_client.services import CommandsService
conn = atsd_client.connect()
commandsService = CommandsService(conn)
commands_to_send = ["metric m:stat.step p:integer",
                    "series e:process m:stat.step=0 x:stat.step=initial"]
commandsService.send_commands(commands_to_send)

```

## Collector

### Issue 3977
--------------

The configuration pages for Databases, HTTP Pools, and Replacement Tables now display linked jobs.

<img src="Images/Figure1.png" width="300px"/>

For the HTTP pool, the linked task configurations, item lists, and ATSD configurations are now shown.

<img src="Images/Figure2.png" width="300px"/>

For the Replacement table, the linked task configurations are shown.

<img src="Images/Figure3.png" width="300px"/>

### Issue 3976
--------------
The old `Command` field containing the path to the executable script has been renamed to `Path to the script`.
The new `Command` field allows entering commands returning the Item List elements, one Item per line.
The commands from the text area are copied to a file in the `$AXIBASE_COLLECTOR_HOME/conf/scripts` directory and executed as a script.
You must set `script.text.execute.allow=true` in the `$AXIBASE_COLLECTOR_HOME/conf/server.properties` file in order to enable this feature.

![](Images/Figure4.png)

### Issue 3932
--------------

![](Images/Figure5.png)

### Issue 3817-a
--------------

The new checkbox `Skip Old Data` has been introduced. If the setting is enabled, the last data row from the target dataset is stored by the Collector. When the task is executed next time, only new rows are sent into ATSD as series.

![](Images/Figure6.png)
![](Images/Figure7.png)

### Issue 3817-b
--------------

The new field `Query Filter` has been introduced to allow applying a filter expression as part of a request.

![](Images/Figure8.png)
![](Images/Figure9.png)

## Charts

### Issue 3961
--------------

The new settings introduced in Treemap configurations:

| Setting | Description | Available options |
|------|-------------|-------------------|
| mode | Layout mode to control how rectangles are positioned. |– `default` <BR> – `row` (align rectangles as rows) <BR> – `column` (align rectangles as columns) <BR> – `auto` (switch between row and column modes depending on widget size)


https://apps.axibase.com/chartlab/fc68bae4/7/

![](Images/Figure10.png)

### Issue 3959
--------------

`last = true` is deprecated. Replace it with `limit: 1`.

https://apps.axibase.com/chartlab/25551747

### Issue 3941
--------------

Functions `meta()`, `entityTag()`, and `metricTag()`, which return entity or metric tags retrieved from the server, are now available in widget settings:  

```python
meta('alias') – returns ‘meta’ object for series with alias ‘alias’.
meta() – returns ‘meta’ object for the current series.
entityTag('alias', 'tag_name') – return entity tag value for series with the specified alias
entityTag('tag_name') – return entity tag value for the current series
metricTag('alias', 'tag_name') – return metric tag value for series with the specified alias
metricTag('tag_name') – return metric tag value for the current series
```

Refer to [metadata](https://axibase.com/products/axibase-time-series-database/visualization/widgets/metadata/) documentation for additional examples.

https://apps.axibase.com/chartlab/2b15e6f9

https://apps.axibase.com/chartlab/c4c1f7b8

https://apps.axibase.com/chartlab/c9bd5eb5
