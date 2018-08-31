<!-- markdownlint-disable MD101 -->

# Functions Reference

Name | Type | Description
---|---|---
[`abs`](functions-math.md#abs)| Mathematical | Returns the absolute value of the argument.
[`abbreviate`](functions-text.md#abbreviate)| Text | Truncates string using ellipses to hide extraneous text.
[`add`](object-datetime.md#add-function) |Date| Returns a [`DateTime`](object-datetime.md) object created by adding an interval.
[`addLink`](functions-link.md#addlink)| Link | Returns the URL with a formatted short name.
[`addPortal`](functions-portal.md#portal-functions) | Portal | Attaches custom portals to outgoing webhooks.
[`addTable for list`](functions-table.md#addtable-for-list)| Table | Prints list of lists as a multi-column table in the specified format.
[`addTable for map`](functions-table.md#addtable-for-map)| Table | Prints the input key-value map as a two-column table in the specified format.
[`addTable for maps`](functions-table.md#addtable-for-maps)| Table | Prints a collection of maps as a multi-column table in the specified format.
[`avg`](functions-statistical.md#avg)| Statistical | Calculates average value.
[`avgIf`](functions-statistical.md#avgif)| Statistical | Calculates average of elements matching the specified condition.
[`capFirst`](functions-text.md#capfirst)| Text | Capitalizes the first letter in the string.
[`capitalize`](functions-text.md#capitalize)| Text | Capitalizes the first letter in all words in the string.
[`cbrt`](functions-math.md#cbrt)| Mathematical | Returns cube root ∛ of the argument.
[`ceil`](functions-math.md#ceil)| Mathematical | Returns the smallest integer that is greater than or equal to the argument.
[`coalesce`](functions-text.md#coalesce)| Text | Returns first non-empty string from the collection of strings.
[`collection`](functions-collection.md#collection) | Collection, Lookup | Returns an array of strings contained in Named Collection.
[`concat`](functions-text.md#concat)| Text | Joins the elements of the collection into a single string.
[`concatLines`](functions-text.md#concatlines)| Text | Joins the elements of the collection into a single string with line breaks `\n`.
[`contains`](functions-collection.md#contains)| Collection | Returns `true` if string on the right is contained in the specified collection.
[`convert`](functions-format.md#convert)| Formatting | Divides the number by the unit and formats with one fractional digit.
[`count`](functions-statistical.md#count)| Statistical | Value count.
[`countIf`](functions-statistical.md#countif)| Statistical | Counts elements matching the specified condition.
[`countMatches`](functions-text.md#countmatches)| Text | Counts how many times the substring appears in input string.
[`date_format`](functions-format.md#date_format)| Formatting | Converts Unix time in milliseconds to a string.
[`date_parse`](functions-date.md#date_parse)| Date | Parses the input string into a [`DateTime`](object-datetime.md) object.
[`db_last`](functions-series.md#db_last)| Database Series | Retrieves the most recent value stored in the database for the target series.
[`db_statistic`](functions-series.md#db_statistic)| Database Series | Returns the result of a statistical function for historical values.
[`db_message_count`](functions-message.md#db_message_count)| Database Message | Returns the number of message records matching the specified parameters.
[`db_message_last`](functions-message.md#db_message_last)| Database Message | Returns the most recent message record for the specified parameters.
[`db_messages`](functions-message.md#db_messages)| Database Message | Returns a list of message records matching the specified parameters.
[`delta`](functions-statistical.md#delta)| Statistical | Calculates difference between `last` and `first` values.
[`detailsTable`](details-table.md)| Table | Assembles a table consisting of window and command fields.
[`diff`](functions-statistical.md#diff)| Statistical | Calculates difference between `last` and `first` values.
[`elapsed_minutes`](functions-date.md#elapsed_minutes)| Date | Calculates the number of minutes between the current and specified time.
[`elapsedTime`](functions-date.md#elapsedtime)| Date | Calculates the number of milliseconds between the current and specified time.
[`endsWith`](functions-text.md#endswith)| Text | Returns `true` if string ends with the specified prefix.
[`entity_label`](functions-lookup.md#entity_label)| Lookup | Returns label for the specified entity.
[`entity_tag`](functions-lookup.md#entity_tag)| Lookup | Returns value of the specified tag name for the specified entity.
[`entity_tags`](functions-lookup.md#entity_tags)| Lookup | Returns entity tags for the specified entity as a map.
[`excludeKeys`](functions-collection.md#excludekeys)| Collection | Returns a copy of the input map without the keys in the input collection.
[`executeSqlQuery`](functions-sql.md#executesqlquery)| SQL Query | Returns the result of SQL query.
[`exp`](functions-math.md#exp)| Mathematical | Returns Euler constant `e` (2.7) raised to the power of the argument.
[`first`](functions-statistical.md#first)| Statistical | Returns first series value.
[`flattenJson`](functions-table.md#flattenjson)| Table | Converts the string representation of JSON document into a map.
[`floor`](functions-math.md#floor)| Mathematical | Returns the largest integer that is less than or equal to the argument.
[`forecast`](functions-forecast.md#forecast)| Forecast | Returns forecast value for the entity, metric, and tags in the current window.
[`forecast_deviation`](functions-forecast.md#forecast_deviation)| Forecast | Returns difference between a number and the forecast value, divided by the forecast standard deviation.
[`forecast_stdev`](functions-forecast.md#forecast_stdev)| Forecast | Returns forecast standard deviation.
[`formatBytes`](functions-format.md#formatbytes)| Formatting | Returns the total number of bytes in human-readable format.
[`formatInterval`](functions-format.md#formatinterval)| Formatting | Converts milliseconds interval to a formatted interval.
[`formatIntervalShort`](functions-format.md#formatintervalshort)| Formatting | Converts milliseconds interval to a formatted interval consisting of up to the two highest subsequent non-zero time units.
[`formatNumber`](functions-format.md#formatnumber)| Formatting | Formats number with the specified [`DecimalFormat`](https://docs.oracle.com/javase/7/docs/api/java/text/DecimalFormat.html) using the server locale.
[`getEntities`](functions-lookup.md#getentities)| Lookup | Returns a list of [Entity](entity-fields.md) **objects** matching the given parameters.
[`getEntity`](functions-lookup.md#getentity)| Lookup | Retrieves an entity object by name.
[`getEntityCount`](functions-lookup.md#getentitycount)| Lookup | Returns a count of [Entity](entity-fields.md) **objects** matching the given parameters.
[`getEntityLink`](functions-link.md#getentitylink)| Link | Returns the URL to the **Entity Editor** page for the specified entity.
[`getEntityName`](functions-lookup.md#getentityname)| Lookup | Returns normalized (lowercase) entity name for the specified entity.
[`getChartLink`](functions-link.md#getchartlink)| Link | Returns the URL to the default portal for the current metric, entity, and tags.
[`getCsvExportLink`](functions-link.md#getcsvexportlink)| Link | Returns the URL to the **CSV** file for the current metric, entity, and tags.
[`getHtmlExportLink`](functions-link.md#gethtmlexportlink)| Link | Returns the URL to the **Export** page for the current metric, entity, and tags.
[`getPropertyLink`](functions-link.md#getpropertylink)| Link | Returns the URL to the property table for the given entity and property type.
[`getPropertyTypes`](functions-property.md#getpropertytypes)| Property | Returns a sorted set of property types for the specified entity.
[`getRuleLink`](functions-link.md#getrulelink)| Link | Returns the URL to the current rule.
[`getURLHost`](functions-utility.md#geturlhost)| Utility | Retrieves the **host** from URL specified in string url.
[`getURLPath`](functions-utility.md#geturlpath)| Utility | Retrieves the **path** from URL string.
[`getURLPort`](functions-utility.md#geturlport)| Utility | Retrieves the **port** from URL string.
[`getURLProtocol`](functions-utility.md#geturlprotocol)| Utility | Retrieves the **protocol** from URL string.
[`getURLQuery`](functions-utility.md#geturlquery)| Utility | Retrieves the **query string** from URL string.
[`getURLUserInfo`](functions-utility.md#geturluserinfo)| Utility | Retrieves the user credential part `username:password` from URL string.
[`htmlDecode`](functions-text.md#htmldecode)| Text | Replaces HTML entities in string with their corresponding characters.
[`ifEmpty`](functions-text.md#ifempty)| Text, Utility | Returns the second string if the first is either `null` or an empty string.
[`IN`](functions-collection.md#in) | Collection | Returns `true` if string on the left is contained in the list of strings on the right.
[`indexOf`](functions-text.md#indexof)| Text | Returns the index of the first occurrence of substring in the target string.
[`intercept`](functions-statistical.md#intercept)| Statistical | Calculates linear regression intercept.
[`isEmpty`](functions-collection.md#isempty)| Collection | Returns `true` if the number of elements in the collection is zero.
[`is_weekday`](object-datetime.md#is_weekday-function)| Date | Returns `true` if the [`DateTime`](object-datetime.md) object is a weekday.
[`is_weekend`](object-datetime.md#is_weekend-function)| Date | Returns `true` if the [`DateTime`](object-datetime.md) object is a weekend day.
[`is_workday`](object-datetime.md#is_workday-function)| Date | Returns `true` if the [`DateTime`](object-datetime.md) object is a working day.
[`jsonencode`](functions-text.md#jsonencode)| Text | Escapes special JSON characters with a backslash.
[`jsonPathFilter`](functions-table.md#jsonpathfilter)| Table | Returns a list of objects matching the [`JSONPath` expression](https://github.com/json-path/JsonPath).
[`jsonToLists`](functions-table.md#jsontolists)| Table | Returns a collection of string lists containing field values from the JSON.
[`jsonToMaps`](functions-table.md#jsontomaps)| Table | Returns a collection of maps containing keys and values from the JSON.
[`keepAfter`](functions-text.md#keepafter)| Text | Removes part of string before the first occurrence of the given substring.
[`keepAfterLast`](functions-text.md#keepafterlast)| Text | Removes part of string before the last occurrence of the given substring.
[`keepBefore`](functions-text.md#keepbefore)| Text | Removes part of string after the first occurrence of the given substring.
[`keepBeforeLast`](functions-text.md#keepbeforelast)| Text | Removes part of string after the last occurrence of the given substring.
[`last`](functions-statistical.md#last)| Statistical | Returns last value.
[`last_open`](functions-alert-history.md#last_open)| Alert History | Retrieves the most recent open AlertHistory record for the current window.
[`length`](functions-text.md#length)| Text | Returns the length of string.
[`LIKE`](functions-collection.md#like) | Collection | Returns `true` if string on the left matches any pattern in the list on the right.
[`likeAny`](functions-collection.md#likeany) | Collection | Returns `true` if string matches any element in the string collection.
[`list`](functions-text.md#list)| Text | Splits string into an array, discards duplicate items.
[`locate`](functions-text.md#locate)| Text | Returns the index of the first occurrence of substring in the target string.
[`log`](functions-math.md#log)| Mathematical | Returns the natural logarithm (base `e = 2.7`) of the argument.
[`log10`](functions-math.md#log10)| Mathematical | Returns the base 10 logarithm of the argument.
[`lookup`](functions-lookup.md#lookup)| Lookup | Returns the value for the the specified key from the Replacement Table.
[`lower`](functions-text.md#lower)| Text | Converts string to lowercase letters.
[`matches`](functions-collection.md#matches)| Collection | Returns `true` if one of the elements in collection matches the given pattern.
[`matchList`](functions-collection.md#matchlist)| Collection | Returns `true` if string matches one of the elements in the collection.
[`max`](functions-math.md#max)| Mathematical | Returns the greater of two numbers.
[`max`](functions-statistical.md#max)| Statistical | Returns maximum value.
[`min`](functions-math.md#min)| Mathematical | Returns the smallest of two numbers.
[`min`](functions-statistical.md#min)| Statistical | Returns minimum value.
[`mean`](functions-statistical.md#mean)| Statistical | Calculates average value.
[`median`](functions-statistical.md#median)| Statistical | Returns 50% percentile (median).
[`milliseconds`](functions-date.md#milliseconds)| Date | Parses the date string into Unix time in milliseconds.
[`new_maximum`](functions-statistical.md#new_maximum)| Statistical | Returns `true` if last value is greater than any previous value.
[`new_minimum`](functions-statistical.md#new_minimum)| Statistical | Returns `true` if last value is smaller than any previous value.
[`now`](functions-date.md#now)| Date | Returns the current time as a [`DateTime`](object-datetime.md) object.
[`percentile`](functions-statistical.md#percentile)| Statistical | Calculates `n`-th percentile.
[`pow`](functions-math.md#pow)| Mathematical | Returns the first specified number raised to the power of the second number.
[`printObject`](functions-utility.md#printobject)| Utility | Prints the input object as a two-column table in the specified format.
[`property`](functions-lookup.md#property)| Lookup, Property | Retrieves tag value for the given [property search](property-search.md) expression.
[`property_compare_except`](functions-property.md#property_compare_except)| Property | Compares properties in the previous and the current `property` command.
[`property_map`](functions-property.md#property_map)| Property | Returns a map with keys and tags for the given [property search](property-search.md) expression.
[`property_maps`](functions-property.md#property_maps)| Property | Returns a list of maps for the given property search expression.
[`property_values`](functions-property.md#property_values)| Property | Returns a list of tag values for the given [property search](property-search.md) expression.
[`queryConfig`](functions-web-query.md#queryconfig)| Web Query | Executes an HTTP request using a predefined [outgoing webhook](notifications/README.md).
[`queryGet`](functions-web-query.md#queryget)| Web Query | Executes a `GET` request to the specified [request URL](functions-web-query.md#request-url).
[`queryPost`](functions-web-query.md#querypost)| Web Query | Executes a `POST` request to the specified [request URL](functions-web-query.md#request-url).
[`random`](functions-random.md#random)| Random | Returns a uniformly distributed double number.
[`randomItem`](functions-random.md#randomitem)| Random | Returns a random element from a collection or map.
[`randomKey`](functions-random.md#randomkey)| Random | Returns a random element from the map of objects.
[`randomNormal`](functions-random.md#randomnormal)| Random | Returns a normally distributed double number.
[`rate_per_hour`](functions-statistical.md#rate_per_hour)| Statistical | Calculates the hourly difference between last and first value input.
[`rate_per_minute`](functions-statistical.md#rate_per_minute)| Statistical | Calculates the difference between last and first value per minute.
[`rate_per_second`](functions-statistical.md#rate_per_second)| Statistical | Calculates the difference between last and first value per second.
[`removeBeginning`](functions-text.md#removebeginning)| Text | Removes substring from the beginning of the given string.
[`removeEnding`](functions-text.md#removeending)| Text | Removes given substring from the end of the target string.
[`replace`](functions-text.md#replace)| Text | Replaces all occurrences of the 1-st string in the original string with the 2-nd string.
[`replacementTable`](functions-collection.md#replacementtable)| Collection, Lookup | Retrieves the Replacement Table as a key-value map.
[`round`](functions-math.md#round)| Mathematical | Returns the specified number rounded to the specified precision.
[`rule_open`](functions-rules.md#rule_open)| Rule | Checks if there is at least one open window for the specified arguments.
[`rule_window`](functions-rules.md#rule_window)| Rule | Returns the **first** matching [`Window`](window-fields.md#base-fields) object for the specified arguments.
[`rule_windows`](functions-rules.md#rule_windows)| Rule | Returns the collection of [`Window`](window.md#window-fields) objects for the specified arguments.
[`scriptOut`](functions-script.md)| Script | Executes the predefined script and return its output.
[`seconds`](functions-date.md#seconds)| Date | Parses the date string into Unix time in seconds.
[`signum`](functions-math.md#signum)| Mathematical | Returns the `signum` function of the argument.
[`size`](functions-collection.md#size)| Collection | Returns the number of elements in the collection.
[`slope`](functions-statistical.md#slope)| Statistical | Calculates linear regression slope.
[`slope_per_hour`](functions-statistical.md#slope_per_hour)| Statistical | Calculates `slope_per_second()/3600`.
[`slope_per_minute`](functions-statistical.md#slope_per_minute)| Statistical | Calculates `slope_per_second()/60`.
[`slope_per_second`](functions-statistical.md#slope_per_second)| Statistical | Calculates linear regression slope.
[`split`](functions-text.md#split)| Text | Splits string into a collection of strings using the specified separator.
[`sqrt`](functions-math.md#sqrt)| Mathematical | Returns `√` of the argument.
[`startsWith`](functions-text.md#startswith)| Text | Returns `true` if string starts with the specified prefix.
[`stdev`](functions-statistical.md#stdev)| Statistical | Standard deviation.
[`sum`](functions-statistical.md#sum)| Statistical | Sums all included values.
[`sumIf`](functions-statistical.md#sumif)| Statistical | Sums elements matching the specified condition.
[`threshold_linear_time`](functions-statistical.md#threshold_linear_time)| Statistical | Forecasts the minutes until the value reaches the threshold based on linear extrapolation.
[`threshold_time`](functions-statistical.md#threshold_time)| Statistical | Forecasts the minutes until the value reaches the threshold based on extrapolation of the difference between the last and first value.
[`thresholdTime`](functions-forecast.md#thresholdtime)| Forecast | Returns time when the [forecast value](../forecasting/README.md) is outside of the `(min, max)` range.
[`to_datetime`](functions-date.md#to_datetime)| Date | Returns [`DateTime`](object-datetime.md) object in the server time zone from Unix milliseconds.
[`to_timezone`](object-datetime.md#to_timezone-function)| Date | Returns a new [`DateTime`](object-datetime.md) object modified to the specified [time zone](../shared/timezone-list.md).
[`toBoolean`](functions-utility.md#toboolean)| Utility | Converts the input string or number to a boolean value.
[`today`](functions-date.md#today)| Date | Returns the current day at midnight, `00:00:00`, as a [`DateTime`](object-datetime.md) object.
[`tomorrow`](functions-date.md#tomorrow)| Date | Returns the following day at midnight, `00:00:00`, as a [`DateTime`](object-datetime.md) object.
[`toNumber`](functions-utility.md#tonumber)| Utility | Converts the input object to floating-point number.
[`trim`](functions-text.md#trim)| Text | Removes leading and trailing non-printable characters.
[`truncate`](functions-text.md#truncate)| Text | Truncates string to the specified number of characters.
[`unquote`](functions-text.md#unquote)| Text | Removes leading and trailing quotation marks from input string.
[`upper`](functions-text.md#upper)| Text | Converts string to uppercase letters.
[`urlencode`](functions-text.md#urlencode)| Text | Replaces special characters with URL-safe characters using percent-encoding.
[`userAllowEntity`](functions-security.md#userallowentity)| Security | Returns `true` if the specified user has [`READ`](../administration/user-authorization.md#entity-permissions) permission for the given entity.
[`userAllowEntityGroup`](functions-security.md#userallowentitygroup)| Security |  Returns `true` if the user has [`READ`](../administration/user-authorization.md#entity-permissions) permission to the given entity group.
[`userAllowPortal`](functions-security.md#userallowportal)| Security | Returns `true` if the specified user has permissions to view the given portal.
[`userHasRole`](functions-security.md#userhasrole)| Security | Returns `true` if the specified user has the specified [`role`](../administration/user-authorization.md#role-based-access-control).
[`userInGroup`](functions-security.md#useringroup)| Security | Returns `true` if the specified user belongs to the specified user group.
[`value`](functions-value.md) | Value | Retrieves the value for the metric received.
[`variance`](functions-statistical.md#variance)| Statistical | Calculates variance.
[`wavg`](functions-statistical.md#wavg)| Statistical | Calculates weighted average.
[`window_length_count`](functions-date.md#window_length_count)| Date | Returns the length of a count-based window.
[`window_length_time`](functions-date.md#window_length_time)| Date | Returns the length of a time-based window in seconds.
[`windowStartTime`](functions-date.md#windowstarttime)| Date | Returns time when the first command is received by the window.
[`wtavg`](functions-statistical.md#wtavg)| Statistical | Calculates weighted time average.
[`yesterday`](functions-date.md#yesterday)| Date | Returns the previous day at midnight, `00:00:00`, as a [`DateTime`](object-datetime.md) object.