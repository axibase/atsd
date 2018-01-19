# Functions

## Reference

* [Statistical Functions](#statistical-functions)
* [Statistical Forecast Functions](#statistical-forecast-functions)
* [Value Functions](#value-functions)
* [Database Functions](#database-functions)
* [Mathematical Functions](#mathematical-functions)
* [Text Functions](#text-functions)
* [Formatting Functions](#formatting-functions)
* [Collection Functions](#collection-functions)
* [Lookup Functions](#lookup-functions)
* [Random Distribution Functions](#random-distribution-functions)
* [Time Functions](#time-functions)
* [Property Functions](#property-functions)
* [Script Functions](#script-functions)
* [Rule Functions](#rule-functions)
* [Utility Functions](#rule-functions)
* [Link Functions](#link-functions)

## Overview

Functions are predefined procedures that perform a task or calculate a value.

They can be included by name in the condition and filter expressions as well as in placeholders.

```javascript
  avg() > 80
```

```javascript
  lower(tags.location) == 'nur'
```

```javascript
  ${upper(tags.location)}
```

Function names are case-**sensitive**.

Functions are invoked when the expression is evaluated and replaced with the value returned by the function.

## Arguments

The parameters passed to the function in brackets are called arguments.

Functions can accept arguments and return value in one of the following data types:

| **Notation** | **Name** | **Example** |
|---|:---|:---|
| `double` | double number | `percentile(99.5)` |
| `long` | long number | `elapsedTime(1515758392702)` |
| `integer` | integer number | `round(value, 1)` |
| `boolean` | boolean | `scriptOut('dsk.sh', [true])` |
| `string` | string | `startsWith(entity, 'NUR')` |
| `[]` | collection | `randomItem([1, 2, 3])` |
| `[string]` | collection of strings | `coalesce([tags.location, 'SVL'])` |
| `[k: v]` | key-value map | `randomKey(['john': 0.8, 'sam': 0.2])` |
| `object` | object | `rule_window('disk_check').status` |

## Statistical Functions

Univariate statistical functions listed below perform a calculation on the array of numeric values stored in the window.

* [avg](functions-statistical.md#avg)
* [mean](functions-statistical.md#mean)
* [sum](functions-statistical.md#sum)
* [min](functions-statistical.md#min)
* [max](functions-statistical.md#max)
* [wavg](functions-statistical.md#wavg)
* [wtavg](functions-statistical.md#wtavg)
* [count](functions-statistical.md#count)
* [percentile](functions-statistical.md#percentile)
* [median](functions-statistical.md#median)
* [variance](functions-statistical.md#variance)
* [stdev](functions-statistical.md#stdev)
* [intercept](functions-statistical.md#intercept)
* [first](functions-statistical.md#first)
* [last](functions-statistical.md#last)
* [diff](functions-statistical.md#diff)
* [delta](functions-statistical.md#delta)
* [new_maximum](functions-statistical.md#new_maximum)
* [new_minimum](functions-statistical.md#new_minimum)
* [threshold_time](functions-statistical.md#threshold_time)
* [threshold_linear_time](functions-statistical.md#threshold_linear_time)
* [rate_per_second](functions-statistical.md#rate_per_second)
* [rate_per_minute](functions-statistical.md#rate_per_minute)
* [rate_per_hour](functions-statistical.md#rate_per_hour)
* [slope](functions-statistical.md#slope)
* [slope_per_second](functions-statistical.md#slope_per_second)
* [slope_per_minute](functions-statistical.md#slope_per_minute)
* [slope_per_hour](functions-statistical.md#slope_per_hour)

### Conditional Functions

* [countIf](functions-statistical.md#countif)
* [avgIf](functions-statistical.md#avgif)
* [sumIf](functions-statistical.md#sumif)

## Statistical Forecast Functions

* [forecast](functions-forecast.md#forecast)
* [forecast_stdev](functions-forecast.md#forecast_stdev)
* [forecast_deviation](functions-forecast.md#forecast_deviation)

## Value Functions

The value functions provide a way to retrieve values for other metrics contained in the same command.

* [value](functions-value.md)

## Database Functions

The [database](functions-db.md) functions provide a way to retrieve data from the database for complex comparisons and correlation.

### Database Series Functions

The functions retrieve values for a series which may be different from the series in the current window.

* [db_last](functions-db.md#db_laststring-m)
* [db_statistic](functions-db.md#db_statistic)

### Database Message Functions

The functions retrieve message counts or specific messages.

* [db_message_count](functions-db.md#db_message_count)
* [db_message_last](functions-db.md#db_message_last)

## Mathematical Functions

The math functions perform basic numeric operations on the input number and return a number as the result.

* [abs](functions-math.md#abs)
* [ceil](functions-math.md#ceil)
* [floor](functions-math.md#floor)
* [pow](functions-math.md#pow)
* [round](functions-math.md#round)
* [max](functions-math.md#max)
* [min](functions-math.md#min)
* [sqrt](functions-math.md#sqrt)
* [cbrt](functions-math.md#cbrt)
* [exp](functions-math.md#exp)
* [log](functions-math.md#log)
* [log10](functions-math.md#log10)
* [signum](functions-math.md#signum)

## Text Functions

The text functions transform and compare strings.

* [upper](functions-text.md#upper)
* [lower](functions-text.md#lower)
* [truncate](functions-text.md#truncate)
* [contains](functions-text.md#contains)
* [startsWith](functions-text.md#startswith)
* [endsWith](functions-text.md#endswith)
* [split](functions-text.md#split)
* [coalesce](functions-text.md#coalesce)
* [keepAfter](functions-text.md#keepafter)
* [keepAfterLast](functions-text.md#keepafterlast)
* [keepBefore](functions-text.md#keepbefore)
* [keepBeforeLast](functions-text.md#keepbeforelast)
* [replace](functions-text.md#replace)
* [capFirst](functions-text.md#capfirst)
* [capitalize](functions-text.md#capitalize)
* [removeBeginning](functions-text.md#removebeginning)
* [removeEnding](functions-text.md#removeending)
* [urlencode](functions-text.md#urlencode)
* [jsonencode](functions-text.md#jsonencode)
* [unquote](functions-text.md#unquote)
* [countMatches](functions-text.md#countmatches)
* [abbreviate](functions-text.md#abbreviate)
* [indexOf](functions-text.md#indexof)
* [locate](functions-text.md#locate)

## Formatting Functions

The functions format dates and numbers to strings according to the specified pattern.

* [convert](functions-format.md#convert)
* [formatNumber](functions-format.md#formatnumber)
* [date_format](functions-format.md#date_format)
* [formatInterval](functions-format.md#formatinterval)
* [formatIntervalShort](functions-format.md#formatintervalshort)

## Collection Functions

The collection functions return information about the collection or check it for the presence of the specified element.

* [collection](functions-collection.md#collection)
* [IN](functions-collection.md#in)
* [likeAny](functions-collection.md#likeany)
* [matchList](functions-collection.md#matchlist)
* [matches](functions-collection.md#matches)
* [excludeKeys](functions-collection.md#excludekeys)

## Lookup Functions

The lookup functions retrieve records from replacement tables, collections, and other entities.

* [entity_tag](functions-lookup.md#entity_tag)
* [entity_tags](functions-lookup.md#entity_tags)
* [getEntity](functions-lookup.md#getentity)
* [collection](functions-lookup.md#collection)
* [lookup](functions-lookup.md#lookup)
* [replacementTable](functions-lookup.md#replacementtable)

## Random Distribution Functions

* [random](functions-random.md#random)
* [randomNormal](functions-random.md#randomnormal)
* [randomItem](functions-random.md#randomitem)
* [randomKey](functions-random.md#randomkey)

## Time Functions

Time functions perform various operations on dates, timestamps and intervals.

* [window_length_time](functions-time.md#window_length_time)
* [window_length_count](functions-time.md#window_length_count)
* [windowStartTime](functions-time.md#windowstarttime)
* [elapsedTime](functions-time.md#elapsedtime)
* [milliseconds](functions-time.md#milliseconds)
* [seconds](functions-time.md#seconds)
* [date_parse](functions-time.md#date_parse)

## Property Functions

Property functions retrieve and compare property keys and tags.

* [property](functions-property.md#property)
* [property_values](functions-property.md#property_values)
* [property_compare_except](functions-property.md#property_compare_except)
* [property_map](functions-property.md#property_map)
* [property_maps](functions-property.md#property_maps)

## Script Functions

Execute the predefined script and return its output.

* [scriptOut](functions-script.md)

## Rule Functions

The rule functions provide a way to check the status of windows created by other rules.

* [rule_open](functions-rules.md#rule_open)
* [rule_window](functions-rules.md#rule_window)

## Utility Functions

* [ifEmpty](functions-utility.md#ifempty)
