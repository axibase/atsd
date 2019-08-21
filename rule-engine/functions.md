# Functions

## Overview

Functions are predefined procedures that calculate a value or perform a task. Functions are called by name with arguments passed in round brackets and separated by comma. Function names are **case-sensitive**.

```javascript
/* Returns true if the create_ms date is a working day. */
to_datetime(create_ms, 'US/Pacific').is_workday()
```

When invoked in expressions and placeholders, function definitions are replaced with the value returned by the function.

Functions can be referenced in a [filter expression](filters.md#filter-expression), user-defined [variables](variables.md), [condition](condition.md) statements and placeholders.

* **Filter Expression**:

    ```javascript
    lower(tags.location) = 'nur'
    ```

* **Condition**:

    ```javascript
    avg() > 80 && db_statistic('avg', '15 minute', 'metric-2')
    ```

* **Placeholder**:

    ```bash
    ${lookup('assets', entity)}
    ```

## Arguments

The parameters passed to the function in round brackets are called arguments.

Functions can accept arguments and return values in one of the following data types:

| **Notation** | **Name** | **Example** |
|---|:---|:---|
| `double` | double number | `percentile(99.5)` |
| `long` | long number | `elapsedTime(last_open().command_time)` |
| `int` | integer number | `round(avg(), 1)` |
| `number` | any number | `abs(value)` |
| `bool` | boolean | `formatBytes(avg(), true)` |
| `string` | string | `startsWith(entity, 'NUR')` |
| `[number]` | collection of numbers | `randomItem([1, 2, 3])` |
| `[string]` | collection of strings | `coalesce([tags.location, 'SVL'])` |
| `[k: v]` | key-value map | `randomKey(['john.doe': 0.8, 'mary.jones': 0.2])` |
| `map` | key-value map | `addTable(tags, 'html')`
| `object` | object | `to_timezone(now, 'US/Pacific')` |

Optional arguments are annotated with square brackets.

```csharp
date_format(long time [, string pattern]) string
```

If the argument can be of different data types, such types are enumerated with `|` symbol.

```csharp
db_last(string metric, string entity, string tags | map tags) number
```

## Collection

Name | Description
---|---
[`contains`](functions-collection.md#contains)| Returns `true` if string on the right is contained in the specified collection.
[`collection_contains`](functions-collection.md#collection_contains)| Returns `true` if the specified collection contains the value.
[`excludeKeys`](functions-collection.md#excludekeys)| Returns a copy of the input map without the keys in the input collection.
[`copyList`](functions-collection.md#copylist)| Copy a list.
[`copyMap`](functions-collection.md#copymap)| Copy a map.
[`createMap`](functions-collection.md#createmap)| Create a new map.
[`compareMaps`](functions-collection.md#comparemaps)| Compare two maps.
[`mergeMaps`](functions-collection.md#mergemaps)| Merge two maps.
[`flattenJson`](functions-json.md#flattenjson)| Converts the string representation of JSON document into a map.
[`IN`](functions-collection.md#in) | Returns `true` if string on the left is contained in the list of strings on the right.
[`isEmpty`](functions-collection.md#isempty)| Returns `true` if the number of elements in the collection is zero.
[`jsonPathFilter`](functions-json.md#jsonpathfilter)| Returns a list of objects matching the [`JSONPath` expression](https://github.com/json-path/JsonPath).
[`jsonToLists`](functions-json.md#jsontolists)| Returns a collection of string lists containing field values from the JSON.
[`jsonToMaps`](functions-json.md#jsontomaps)| Returns a collection of maps containing keys and values from the JSON.
[`LIKE`](functions-collection.md#like) | Returns `true` if string on the left matches any pattern in the list on the right.
[`likeAny`](functions-collection.md#likeany) | Returns `true` if string matches any element in the string collection.
[`matches`](functions-collection.md#matches)| Returns `true` if one of the elements in collection matches the given pattern.
[`matchList`](functions-collection.md#matchlist)| Returns `true` if string matches one of the elements in the collection.
[`size`](functions-collection.md#size)| Returns the number of elements in the collection.

## Content

### Tables

Name | Description
---|---
[`addTable for list`](functions-table.md#addtable-for-list)| Prints list of lists as a multi-column table in the specified format.
[`addTable for map`](functions-table.md#addtable-for-map)| Prints a key-value map as a two-column table in the specified format.
[`addTable for maps`](functions-table.md#addtable-for-maps)| Prints a collection of maps as a multi-column table in the specified format.
[`addTable for objects`](functions-table.md#addtable-for-objects)| Prints a collection of objects as a multi-column table in the specified format.
[`detailsTable`](details-table.md)| Prints a two-column table consisting of window and command fields in the specified format.

### Links

Name | Description
---|---
[`addLink`](functions-link.md#addlink)| Returns the URL with a formatted short name.
[`getEntityLink`](functions-link.md#getentitylink)| Returns the URL to the **Entity Editor** page for the specified entity.
[`getChartLink`](functions-link.md#getchartlink)| Returns the URL to the default portal for the current metric, entity, and tags.
[`getCsvExportLink`](functions-link.md#getcsvexportlink)| Returns the URL to the **CSV** file for the current metric, entity, and tags.
[`getPortalLink`](functions-link.md#getportallink)| Returns the URL to the portal and entity.
[`getHtmlExportLink`](functions-link.md#gethtmlexportlink)| Returns the URL to the **Export** page for the current metric, entity, and tags.
[`getPropertyLink`](functions-link.md#getpropertylink)| Returns the URL to the property table for the given entity and property type.
[`getRuleLink`](functions-link.md#getrulelink)| Returns the URL to the current rule.

### Portal

Name | Description
---|---
[`addPortal`](functions-portal.md#portal-functions) | Attaches portal screenshots to email and webhook notifications.

## Database

### Messages

Name | Description
---|---
[`db_message_count`](functions-message.md#db_message_count)| Returns the number of message records matching the specified parameters.
[`db_message_last`](functions-message.md#db_message_last)| Returns the most recent message record for the specified parameters.
[`db_messages`](functions-message.md#db_messages)| Returns a list of message records matching the specified parameters.

### Properties

Name | Description
---|---
[`getPropertyTypes`](functions-property.md#getpropertytypes)| Returns a sorted set of property types for the specified entity.
[`property`](functions-property.md#property)| Retrieves tag value for the given [property search](property-search.md) expression.
[`property_map`](functions-property.md#property_map)| Returns a map with keys and tags for the given [property search](property-search.md) expression.
[`property_maps`](functions-property.md#property_maps)| Returns a list of maps for the given property search expression.
[`property_values`](functions-property.md#property_values)| Returns a list of tag values for the given [property search](property-search.md) expression.
[`property_compare`](functions-property.md#property_compare)| Compares properties in the previous and the current `property` command.
[`property_compare_except`](functions-property.md#property_compare_except)| Compares properties in the previous and the current `property` command with name and value filters.

### Series

Name | Description
---|---
[`db_last`](functions-series.md#db_last)| Retrieves the most recent value stored in the database for the target series.
[`db_statistic`](functions-series.md#db_statistic)| Returns the result of a statistical function for historical values.
[`db_baseline`](functions-series.md#db_baseline)| Returns the expected (baseline) value for same periods in the past.

:::tip Related Functions
See [value](#value) functions.
:::

### Forecasts

Name | Description
---|---
[`forecast`](functions-forecast.md#forecast)| Returns forecast object for the entity, metric, and tags in the current window.
[`forecast_deviation`](functions-forecast.md#forecast_deviation)| Returns difference between a number and the interpolated forecast value, divided by the forecast standard deviation.
[`forecast_score_stdev`](functions-forecast.md#forecast_score_stdev)| Returns the standard deviation for forecast values from actual values within the scoring interval.
[`forecast_stdev`](functions-forecast.md#forecast_stdev)| Returns forecast standard deviation.
[`thresholdTime`](functions-forecast.md#thresholdtime)| Returns the estimated time when the forecast value is outside of the `(min, max)` range.

### Alert History

Name | Description
---|---
[`last_open`](functions-alert-history.md#last_open)| Retrieves the most recent Alert History record for the current window.

### SQL Query

Name | Description
---|---
[`executeSqlQuery`](functions-sql.md#executesqlquery)| Returns the result of SQL query.

### Lookup

Name | Description
---|---
[`collection`](functions-lookup.md#collection) | Returns an array of strings contained in Named Collection.
[`entity_label`](functions-lookup.md#entity_label)| Returns label for the specified entity.
[`entity_tag`](functions-lookup.md#entity_tag)| Returns value of the specified tag name for the specified entity.
[`entity_tags`](functions-lookup.md#entity_tags)| Returns entity tags for the specified entity as a map.
[`getEntities`](functions-lookup.md#getentities)| Returns a list of [Entity](entity-fields.md) **objects** matching the given parameters.
[`getEntity`](functions-lookup.md#getentity)| Retrieves an entity object by name.
[`getEntityCount`](functions-lookup.md#getentitycount)| Returns a count of [Entity](entity-fields.md) **objects** matching the given parameters.
[`getEntityName`](functions-lookup.md#getentityname)| Returns normalized (lowercase) entity name for the specified entity.
[`lookup`](functions-lookup.md#lookup)| Returns the value for the specified key from the replacement table.
[`lookup_row`](functions-lookup.md#lookup_row)| Returns the row object for the specified key from the replacement table of `CSV` type.
[`replacementTable`](functions-lookup.md#replacementtable)| Returns the Replacement Table as a key-value map.
[`get_group_emails`](functions-lookup.md#get_group_emails)| Returns the list of email addresses for the members of the specified user group.
[`subscribers`](functions-lookup.md#subscribers)| Returns the list of email addresses for topic subscribers.

## Date

Name | Description
---|---
[`add`](object-datetime.md#add-function) |Returns a [`DateTime`](object-datetime.md) object created by adding an interval.
[`date_format`](functions-date.md#date_format)| Converts Unix time in milliseconds or a [`DateTime`](object-datetime.md) object to a string.
[`DateFormatter`](functions-date.md#dateformatter)| Creates a formatter object to convert Unix times in milliseconds or [`DateTime`](object-datetime.md) objects to strings.
[`IntervalFormatter`](functions-date.md#intervalformatter)| Creates a formatter object to convert the interval between two dates to a string.
[`date_parse`](functions-date.md#date_parse)|  Parses the input string into a [`DateTime`](object-datetime.md) object.
[`elapsed_minutes`](functions-date.md#elapsed_minutes)|  Calculates the number of minutes between the current and specified time.
[`elapsedTime`](functions-date.md#elapsedtime)|  Calculates the number of milliseconds between the current and specified time.
[`formatInterval`](functions-date.md#formatinterval)| Converts milliseconds interval to a formatted interval.
[`formatIntervalShort`](functions-date.md#formatintervalshort)| Converts milliseconds interval to a formatted interval consisting of up to the two highest subsequent non-zero time units.
[`formatSecondOffset`](functions-date.md#formatsecondoffset)| Converts UTC offset in seconds to time zone pattern `±hh:mm`.
[`is_weekday`](object-datetime.md#is_weekday-function)|  Returns `true` if the [`DateTime`](object-datetime.md) object is a weekday.
[`is_weekend`](object-datetime.md#is_weekend-function)|  Returns `true` if the [`DateTime`](object-datetime.md) object is a weekend day.
[`is_workday`](object-datetime.md#is_workday-function)|  Returns `true` if the [`DateTime`](object-datetime.md) object is a working day.
[`is_exceptionday`](object-datetime.md#is_exceptionday-function)|  Returns `true` if the [`DateTime`](object-datetime.md) object is a working weekend or a holiday working day.
[`milliseconds`](functions-date.md#milliseconds)|  Parses the date string into Unix time in milliseconds.
[`now`](functions-date.md#now)|  Returns the current time as a [`DateTime`](object-datetime.md) object.
[`seconds`](functions-date.md#seconds)|  Parses the date string into Unix time in seconds.
[`to_datetime`](functions-date.md#to_datetime)|  Returns [`DateTime`](object-datetime.md) object in the server time zone from Unix milliseconds.
[`to_timezone`](object-datetime.md#to_timezone-function)|  Returns a new [`DateTime`](object-datetime.md) object modified to the specified [time zone](../shared/timezone-list.md).
[`today`](functions-date.md#today)|  Returns the current day at midnight, `00:00:00`, as a [`DateTime`](object-datetime.md) object.
[`tomorrow`](functions-date.md#tomorrow)|  Returns the following day at midnight, `00:00:00`, as a [`DateTime`](object-datetime.md) object.
[`window_length_count`](functions-date.md#window_length_count)|  Returns the length of a count-based window.
[`window_length_time`](functions-date.md#window_length_time)|  Returns the length of a time-based window in seconds.
[`windowStartTime`](functions-date.md#windowstarttime)|  Returns time when the first command is received by the window.
[`yesterday`](functions-date.md#yesterday)|  Returns the previous day at midnight, `00:00:00`, as a [`DateTime`](object-datetime.md) object.

## Formatting

Name | Description
---|---
[`convert`](functions-format.md#convert)| Divides the number by the unit and formats with one fractional digit.
[`formatBytes`](functions-format.md#formatbytes)| Returns the total number of bytes in human-readable format.
[`formatNumber`](functions-format.md#formatnumber)| Formats number with the specified [`DecimalFormat`](https://docs.oracle.com/javase/7/docs/api/java/text/DecimalFormat.html) using the server locale.
[`NumberFormatter`](functions-format.md#numberformatter)| Creates a formatter object to convert numbers to strings.

## Mathematical

<!-- markdownlint-disable MD101 -->

Name | Description
---|---
[`abs`](functions-math.md#abs)|  Returns the absolute value of the argument.
[`cbrt`](functions-math.md#cbrt)|  Returns cube root `∛` of the argument.
[`ceil`](functions-math.md#ceil)|  Returns the smallest integer that is greater than or equal to the argument.
[`exp`](functions-math.md#exp)|  Returns Euler constant `e` (2.7) raised to the power of the argument.
[`floor`](functions-math.md#floor)|  Returns the largest integer that is less than or equal to the argument.
[`log`](functions-math.md#log)|  Returns the natural logarithm (base `e = 2.7`) of the argument.
[`log10`](functions-math.md#log10)|  Returns the base 10 logarithm of the argument.
[`max`](functions-math.md#max)|  Returns the greater of two numbers.
[`min`](functions-math.md#min)|  Returns the smallest of two numbers.
[`pow`](functions-math.md#pow)|  Returns the first specified number raised to the power of the second number.
[`round`](functions-math.md#round)|  Returns the specified number rounded to the specified precision.
[`signum`](functions-math.md#signum)|  Returns the `signum` function of the argument.
[`sqrt`](functions-math.md#sqrt)|  Returns `√` of the argument.

<!-- markdownlint-enable MD101 -->

## Random

Name | Description
---|---
[`random`](functions-random.md#random)| Returns a uniformly distributed double number.
[`randomItem`](functions-random.md#randomitem)| Returns a random element from a collection or map.
[`randomKey`](functions-random.md#randomkey)| Returns a random element from the map of objects.
[`randomNormal`](functions-random.md#randomnormal)| Returns a normally distributed double number.

## Window

Name | Description
---|---
[`rule_open`](functions-rules.md#rule_open)| Checks if there is at least one open window for the specified arguments.
[`rule_window`](functions-rules.md#rule_window)| Returns the **first** matching [`Window`](window-fields.md#base-fields) object for the specified arguments.
[`rule_windows`](functions-rules.md#rule_windows)| Returns the collection of [`Window`](window.md#window-fields) objects for the specified arguments.

## Script

Name | Description
---|---
[`scriptOut`](functions-script.md)| Executes the predefined script and return its output.

## Security

Name | Description
---|---
[`userAllowEntity`](functions-security.md#userallowentity)| Returns `true` if the specified user has [`READ`](../administration/user-authorization.md#entity-permissions) permission for the given entity.
[`userAllowEntityGroup`](functions-security.md#userallowentitygroup)|  Returns `true` if the user has [`READ`](../administration/user-authorization.md#entity-permissions) permission to the given entity group.
[`userAllowPortal`](functions-security.md#userallowportal)| Returns `true` if the specified user has permissions to view the given portal.
[`userHasRole`](functions-security.md#userhasrole)| Returns `true` if the specified user has the specified [`role`](../administration/user-authorization.md#role-based-access-control).
[`userInGroup`](functions-security.md#useringroup)| Returns `true` if the specified user belongs to the specified user group.

## Statistical

:::warning Scope
[Statistical functions](functions-statistical.md) are not supported in the [filter expression](filters.md#filter-expression).
:::

Name | Description
---|---
[`avg`](functions-statistical.md#avg)| Calculates average value.
[`avgIf`](functions-statistical.md#avgif)| Calculates average of elements matching the specified condition.
[`count`](functions-statistical.md#count)| Value count.
[`countIf`](functions-statistical.md#countif)| Counts elements matching the specified condition.
[`delta`](functions-statistical.md#delta)| Calculates difference between `last` and `first` values.
[`diff`](functions-statistical.md#diff)| Calculates difference between `last` and `first` values.
[`first`](functions-statistical.md#first)| Returns first series value.
[`intercept`](functions-statistical.md#intercept)| Calculates linear regression intercept.
[`last`](functions-statistical.md#last)| Returns last value.
[`max`](functions-statistical.md#max)| Returns maximum value.
[`min`](functions-statistical.md#min)| Returns minimum value.
[`mean`](functions-statistical.md#mean)| Calculates average value.
[`median`](functions-statistical.md#median)| Returns 50% percentile (median).
[`new_maximum`](functions-statistical.md#new_maximum)| Returns `true` if last value is greater than any previous value.
[`new_minimum`](functions-statistical.md#new_minimum)| Returns `true` if last value is smaller than any previous value.
[`percentile`](functions-statistical.md#percentile)| Calculates `n`-th percentile.
[`rate_per_hour`](functions-statistical.md#rate_per_hour)| Calculates the hourly difference between last and first value input.
[`rate_per_minute`](functions-statistical.md#rate_per_minute)| Calculates the difference between last and first value per minute.
[`rate_per_second`](functions-statistical.md#rate_per_second)| Calculates the difference between last and first value per second.
[`slope`](functions-statistical.md#slope)| Calculates linear regression slope.
[`slope_per_hour`](functions-statistical.md#slope_per_hour)| Calculates `slope_per_second()/3600`.
[`slope_per_minute`](functions-statistical.md#slope_per_minute)| Calculates `slope_per_second()/60`.
[`slope_per_second`](functions-statistical.md#slope_per_second)| Calculates linear regression slope.
[`median_abs_dev`](functions-statistical.md#median_abs_dev)|Median absolute deviation.
[`stdev`](functions-statistical.md#stdev)| Standard deviation.
[`sum`](functions-statistical.md#sum)| Sums all included values.
[`sumIf`](functions-statistical.md#sumif)| Sums elements matching the specified condition.
[`threshold_linear_time`](functions-statistical.md#threshold_linear_time)| Forecasts the minutes until the value reaches the threshold based on linear extrapolation.
[`threshold_time`](functions-statistical.md#threshold_time)| Forecasts the minutes until the value reaches the threshold based on extrapolation of the difference between the last and first value.
[`variance`](functions-statistical.md#variance)| Calculates variance.
[`wavg`](functions-statistical.md#wavg)| Calculates weighted average.
[`wtavg`](functions-statistical.md#wtavg)| Calculates weighted time average.

## Text

Name | Description
---|---
[`abbreviate`](functions-text.md#abbreviate)| Truncates string using ellipses to hide extraneous text.
[`capFirst`](functions-text.md#capfirst)| Capitalizes the first letter in the string.
[`capitalize`](functions-text.md#capitalize)| Capitalizes the first letter in all words in the string.
[`coalesce`](functions-text.md#coalesce)| Returns first non-empty string from the collection of strings.
[`concat`](functions-text.md#concat)| Joins the elements of the collection into a single string.
[`concatLines`](functions-text.md#concatlines)| Joins the elements of the collection into a single string with line breaks `\n`.
[`countMatches`](functions-text.md#countmatches)| Counts how many times the substring appears in input string.
[`endsWith`](functions-text.md#endswith)| Returns `true` if string ends with the specified prefix.
[`htmlDecode`](functions-text.md#htmldecode)| Replaces HTML entities in string with their corresponding characters.
[`indexOf`](functions-text.md#indexof)| Returns the index of the first occurrence of substring in the target string.
[`jsonencode`](functions-text.md#jsonencode)| Escapes special JSON characters with a backslash.
[`keepAfter`](functions-text.md#keepafter)| Removes part of string before the first occurrence of the given substring.
[`keepAfterLast`](functions-text.md#keepafterlast)| Removes part of string before the last occurrence of the given substring.
[`keepBefore`](functions-text.md#keepbefore)| Removes part of string after the first occurrence of the given substring.
[`keepBeforeLast`](functions-text.md#keepbeforelast)| Removes part of string after the last occurrence of the given substring.
[`length`](functions-text.md#length)| Returns the length of string.
[`list`](functions-text.md#list)| Splits string into an array, discards duplicate items.
[`locate`](functions-text.md#locate)| Returns the index of the first occurrence of substring in the target string.
[`lower`](functions-text.md#lower)| Converts string to lowercase letters.
[`removeBeginning`](functions-text.md#removebeginning)| Removes substring from the beginning of the given string.
[`removeEnding`](functions-text.md#removeending)| Removes given substring from the end of the target string.
[`replace`](functions-text.md#replace)| Replaces all occurrences of the 1-st string in the original string with the 2-nd string.
[`split`](functions-text.md#split)| Splits string into a collection of strings using the specified separator.
[`startsWith`](functions-text.md#startswith)| Returns `true` if string starts with the specified prefix.
[`trim`](functions-text.md#trim)| Removes leading and trailing non-printable characters.
[`truncate`](functions-text.md#truncate)| Truncates string to the specified number of characters.
[`unquote`](functions-text.md#unquote)| Removes leading and trailing quotation marks from input string.
[`upper`](functions-text.md#upper)| Converts string to uppercase letters.
[`urlencode`](functions-text.md#urlencode)| Replaces special characters with URL-safe characters using percent-encoding.

## Utility

Name | Description
---|---
[`cancelAction`](control-flow.md#conditional-processing)| Cancel the current action based on a condition.
[`getURLHost`](functions-utility.md#geturlhost)| Retrieves the **host** from URL specified in string url.
[`getURLPath`](functions-utility.md#geturlpath)| Retrieves the **path** from URL string.
[`getURLPort`](functions-utility.md#geturlport)| Retrieves the **port** from URL string.
[`getURLProtocol`](functions-utility.md#geturlprotocol)| Retrieves the **protocol** from URL string.
[`getURLQuery`](functions-utility.md#geturlquery)| Retrieves the **query string** from URL string.
[`getURLUserInfo`](functions-utility.md#geturluserinfo)| Retrieves the user credential part `username:password` from URL string.
[`ifEmpty`](functions-text.md#ifempty)| Returns the second string if the first is either `null` or an empty string.
[`printObject`](functions-utility.md#printobject)| Prints the input object as a two-column table in the specified format.
[`samples`](functions-utility.md#samples)| Retrieves a map of the samples in the current window
[`values`](functions-utility.md#values)| Retrieves a list of the values of the samples in the current window
[`timestamps`](functions-utility.md#timestamps)| Retrieves a list of the dates of the samples in the current window
[`toBoolean`](functions-utility.md#toboolean)| Converts the input string or number to a boolean value.
[`toNumber`](functions-utility.md#tonumber)| Converts the input object to floating-point number.
[`check_range`](functions-utility.md#check_range)| Checks the input number is within the minimum and maximum range.
[`agent_to_host`](functions-utility.md#agent_to_host)| Extract hostname from ITM agent name.
[`sendTcpMessage`](functions-utility.md#sendtcpmessage)| Sends TCP message to a remote server.
[`sendTcpMessageReply`](functions-utility.md#sendtcpmessagereply)| Sends TCP message to a remote server and read a reply.
[`lock`](functions-utility.md#lock)| Acquire a named lock to prevent duplicate actions.

## Value

Name | Description
---|---
[`value`](functions-value.md) | Retrieves value for the metric in the same `series` command.

## Web Query

Name | Description
---|---
[`queryConfig`](functions-web-query.md#queryconfig)| Executes an HTTP request using a predefined [outgoing webhook](notifications/README.md).
[`queryGet`](functions-web-query.md#queryget)| Executes a `GET` request to the specified [request URL](functions-web-query.md#request-url).
[`queryPost`](functions-web-query.md#querypost)| Executes a `POST` request to the specified [request URL](functions-web-query.md#request-url).