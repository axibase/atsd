# Functions

## Overview

Functions are predefined procedures that calculate a value or perform a task. Functions are called by name with arguments passed in brackets and separated by comma. Function names are case-**sensitive**.

```javascript
/* Returns true if the create_ms date is a working day. */
to_datetime(create_ms, 'US/Pacific').is_workday()
```

When invoked in expressions and placeholders, function definitions are replaced with the value returned by the function.

Functions can be referenced in the [filter expression](filters.md#filter-expression), user-defined [variables](variables.md), [condition](condition.md) statement and in placeholders.

* Filter Expression:

    ```javascript
    lower(tags.location) = 'nur'
    ```

    > [Filter expression](filters.md#filter-expression) cannot include [statistical functions](functions-statistical.md) which require access to the window object.

* Condition:

    ```javascript
    avg() > 80
    ```

* Placeholder:

    ```bash
    ${lookup('assets', entity)}
    ```

## Arguments

The parameters passed to the function in brackets are called arguments.

Functions can accept arguments and return values in one of the following data types:

| **Notation** | **Name** | **Example** |
|---|:---|:---|
| `double` | double number | `percentile(99.5)` |
| `long` | long number | `elapsedTime(1515758392702)` |
| `integer` | integer number | `round(value, 1)` |
| `boolean` | boolean | `scriptOut('dsk.sh', [true])` |
| `string` | string | `startsWith(entity, 'NUR')` |
| `[]` | collection | `randomItem([1, 2, 3])` |
| `[string]` | collection of strings | `coalesce([tags.location, 'SVL'])` |
| `[k: v]` | key-value map | `randomKey(['john.doe': 0.8, 'mary.jones': 0.2])` |
| `object` | object | `rule_window('disk_check').status` |

## Collection

Collection functions and operators check if the collection contains the specified element.

* [`IN`](functions-collection.md#in)
* [`LIKE`](functions-collection.md#like)
* [`likeAny`](functions-collection.md#likeany)
* [`matchList`](functions-collection.md#matchlist)
* [`matches`](functions-collection.md#matches)
* [`contains`](functions-collection.md#contains)
* [`size`](functions-collection.md#size)
* [`isEmpty`](functions-collection.md#isempty)
* [`collection`](functions-collection.md#collection)
* [`excludeKeys`](functions-collection.md#excludekeys)

## Database Message

Message functions retrieve message counts or specific messages from the database.

* [`db_message_count`](functions-message.md#db_message_count)
* [`db_message_last`](functions-message.md#db_message_last)
* [`db_messages`](functions-message.md#db_messages)

## Database Series

Series functions retrieve series values from the database whereas the series can be different from the series in the current window.

* [`db_last`](functions-series.md#db_laststring-m)
* [`db_statistic`](functions-series.md#db_statistic)

## Alert History

* [`last_open`](functions-alert-history.md#last_open)

## Database SQL

SQL functions return the results of user-defined SQL queries.

* [`executeSqlQuery`](functions-sql.md#executesqlquery)

## Date

Date functions perform various operations on dates, timestamps and intervals.

* [`now`](functions-date.md#now)
* [`window_length_time`](functions-date.md#window_length_time)
* [`window_length_count`](functions-date.md#window_length_count)
* [`windowStartTime`](functions-date.md#windowstarttime)
* [`elapsedTime`](functions-date.md#elapsedtime)
* [`elapsed_minutes`](functions-date.md#elapsed_minutes)
* [`milliseconds`](functions-date.md#milliseconds)
* [`seconds`](functions-date.md#seconds)
* [`date_parse`](functions-date.md#date_parse)

## Distribution

* [`random`](functions-random.md#random)
* [`randomNormal`](functions-random.md#randomnormal)
* [`randomItem`](functions-random.md#randomitem)
* [`randomKey`](functions-random.md#randomkey)

## Forecast

Forecast functions retrieve forecast values and variance from the database.

* [`forecast`](functions-forecast.md#forecast)
* [`forecast_stdev`](functions-forecast.md#forecast_stdev)
* [`forecast_deviation`](functions-forecast.md#forecast_deviation)
* [`thresholdTime`](functions-forecast.md#thresholdtime)

## Formatting

These functions format dates and numbers to strings according to the specified pattern.

* [`convert`](functions-format.md#convert)
* [`formatNumber`](functions-format.md#formatnumber)
* [`formatBytes`](functions-format.md#formatbytes)
* [`date_format`](functions-format.md#date_format)
* [`formatInterval`](functions-format.md#formatinterval)
* [`formatIntervalShort`](functions-format.md#formatintervalshort)

## Link

* [`getEntityLink`](functions-link.md#getentitylink)
* [`getPropertyLink`](functions-link.md#getpropertylink)
* [`getRuleLink`](functions-link.md#getrulelink)
* [`getCsvExportLink`](functions-link.md#getcsvexportlink)
* [`getHtmlExportLink`](functions-link.md#gethtmlexportlink)
* [`getChartLink`](functions-link.md#getchartlink)
* [`addLink`](functions-link.md#addlink)

## Lookup

Lookup functions retrieve records from replacement tables, collections, and other entities.

* [`entity_tag`](functions-lookup.md#entity_tag)
* [`entity_tags`](functions-lookup.md#entity_tags)
* [`entity_label`](functions-lookup.md#entity_label)
* [`getEntity`](functions-lookup.md#getentity)
* [`getEntities`](functions-lookup.md#getentities)
* [`getEntityCount`](functions-lookup.md#getentitycount)
* [`getEntityName`](functions-lookup.md#getentityname)
* [`collection`](functions-lookup.md#collection)
* [`lookup`](functions-lookup.md#lookup)
* [`replacementTable`](functions-lookup.md#replacementtable)

## Mathematical

Math functions perform basic numeric operations on the input number and return a number as the result.

* [`abs`](functions-math.md#abs)
* [`ceil`](functions-math.md#ceil)
* [`floor`](functions-math.md#floor)
* [`pow`](functions-math.md#pow)
* [`round`](functions-math.md#round)
* [`max`](functions-math.md#max)
* [`min`](functions-math.md#min)
* [`sqrt`](functions-math.md#sqrt)
* [`cbrt`](functions-math.md#cbrt)
* [`exp`](functions-math.md#exp)
* [`log`](functions-math.md#log)
* [`log10`](functions-math.md#log10)
* [`signum`](functions-math.md#signum)

## Portal

Portal functions allow attaching custom portals to email and outgoing webhooks.

* [`addPortal`](functions-portal.md#portal-functions)

## Property

Property functions retrieve and compare property keys and tags.

* [`property`](functions-property.md#property)
* [`property_values`](functions-property.md#property_values)
* [`property_compare_except`](functions-property.md#property_compare_except)
* [`property_map`](functions-property.md#property_map)
* [`property_maps`](functions-property.md#property_maps)
* [`getPropertyTypes`](functions-property.md#getpropertytypes)

## Rule

The rule functions check the status of windows created by other rules.

* [`rule_open`](functions-rules.md#rule_open)
* [`rule_window`](functions-rules.md#rule_window)
* [`rule_windows`](functions-rules.md#rule_windows)

## Script

Execute the predefined script and return its output.

* [`scriptOut`](functions-script.md)

## Security

* [`userInGroup`](functions-security.md#useringroup)
* [`userHasRole`](functions-security.md#userhasrole)
* [`userAllowEntity`](functions-security.md#userallowentity)
* [`userAllowEntityGroup`](functions-security.md#userallowentitygroup)
* [`userAllowPortal`](functions-security.md#userallowportal)

## Statistical

Univariate statistical functions listed below perform a calculation on the array of numeric values stored in the window.

* [`avg`](functions-statistical.md#avg)
* [`mean`](functions-statistical.md#mean)
* [`sum`](functions-statistical.md#sum)
* [`min`](functions-statistical.md#min)
* [`max`](functions-statistical.md#max)
* [`wavg`](functions-statistical.md#wavg)
* [`wtavg`](functions-statistical.md#wtavg)
* [`count`](functions-statistical.md#count)
* [`percentile`](functions-statistical.md#percentile)
* [`median`](functions-statistical.md#median)
* [`variance`](functions-statistical.md#variance)
* [`stdev`](functions-statistical.md#stdev)
* [`intercept`](functions-statistical.md#intercept)
* [`first`](functions-statistical.md#first)
* [`last`](functions-statistical.md#last)
* [`diff`](functions-statistical.md#diff)
* [`delta`](functions-statistical.md#delta)
* [`new_maximum`](functions-statistical.md#new_maximum)
* [`new_minimum`](functions-statistical.md#new_minimum)
* [`threshold_time`](functions-statistical.md#threshold_time)
* [`threshold_linear_time`](functions-statistical.md#threshold_linear_time)
* [`rate_per_second`](functions-statistical.md#rate_per_second)
* [`rate_per_minute`](functions-statistical.md#rate_per_minute)
* [`rate_per_hour`](functions-statistical.md#rate_per_hour)
* [`slope`](functions-statistical.md#slope)
* [`slope_per_second`](functions-statistical.md#slope_per_second)
* [`slope_per_minute`](functions-statistical.md#slope_per_minute)
* [`slope_per_hour`](functions-statistical.md#slope_per_hour)
* [`countIf`](functions-statistical.md#countif)
* [`avgIf`](functions-statistical.md#avgif)
* [`sumIf`](functions-statistical.md#sumif)

## Table

* [`addTable for map`](functions-table.md#addtable-for-map)
* [`addTable for maps`](functions-table.md#addtable-for-maps)
* [`addTable for list`](functions-table.md#addtable-for-list)
* [`jsonPathFilter`](functions-table.md#jsonpathfilter)
* [`jsonToMaps`](functions-table.md#jsontomaps)
* [`jsonToLists`](functions-table.md#jsontolists)
* [`flattenJson`](functions-table.md#flattenjson)

## Text

Text functions transform and compare strings.

* [`upper`](functions-text.md#upper)
* [`lower`](functions-text.md#lower)
* [`truncate`](functions-text.md#truncate)
* [`startsWith`](functions-text.md#startswith)
* [`endsWith`](functions-text.md#endswith)
* [`split`](functions-text.md#split)
* [`list`](functions-text.md#list)
* [`ifEmpty`](functions-text.md#ifempty)
* [`coalesce`](functions-text.md#coalesce)
* [`keepAfter`](functions-text.md#keepafter)
* [`keepAfterLast`](functions-text.md#keepafterlast)
* [`keepBefore`](functions-text.md#keepbefore)
* [`keepBeforeLast`](functions-text.md#keepbeforelast)
* [`replace`](functions-text.md#replace)
* [`capFirst`](functions-text.md#capfirst)
* [`capitalize`](functions-text.md#capitalize)
* [`removeBeginning`](functions-text.md#removebeginning)
* [`removeEnding`](functions-text.md#removeending)
* [`urlencode`](functions-text.md#urlencode)
* [`jsonencode`](functions-text.md#jsonencode)
* [`htmlDecode`](functions-text.md#htmldecode)
* [`unquote`](functions-text.md#unquote)
* [`countMatches`](functions-text.md#countmatches)
* [`abbreviate`](functions-text.md#abbreviate)
* [`indexOf`](functions-text.md#indexof)
* [`locate`](functions-text.md#locate)
* [`trim`](functions-text.md#trim)
* [`length`](functions-text.md#length)
* [`concat`](functions-text.md#concat)
* [`concatLines`](functions-text.md#concatlines)

## Utility

* [`ifEmpty`](functions-utility.md#ifempty)
* [`toBoolean`](functions-utility.md#toboolean)
* [`toNumber`](functions-utility.md#tonumber)
* [`printObject`](functions-utility.md#printobject)
* [`getURLHost`](functions-utility.md#geturlhost)
* [`getURLPort`](functions-utility.md#geturlport)
* [`getURLProtocol`](functions-utility.md#geturlprotocol)
* [`getURLPath`](functions-utility.md#geturlpath)
* [`getURLQuery`](functions-utility.md#geturlquery)
* [`getURLUserInfo`](functions-utility.md#geturluserinfo)

## Value

[Value](functions-value.md) functions retrieve values for other metrics contained in the same command.

## Web Query

Web Query functions allow to perform requests to external web services.

* [`queryConfig`](functions-web-query.md#queryconfig)
* [`queryGet`](functions-web-query.md#queryget)
* [`queryPost`](functions-web-query.md#querypost)