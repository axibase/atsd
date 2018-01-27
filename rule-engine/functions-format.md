# Formatting Functions

## Overview

The functions format numbers, dates, collections, and maps to strings according to the specified format.

## Reference

Number formatting functions:

* [formatNumber](#formatnumber)
* [convert](#convert)

Date formatting functions:

* [date_format](#date_format)
* [formatInterval](#formatinterval)
* [formatIntervalShort](#formatintervalshort)

Map and list formatting functions:

* [addTable for map](#addtable-for-map)
* [addTable for maps](#addtable-for-maps)
* [addTable for list](#addtable-for-list)

### `formatNumber`

```javascript
  formatNumber(double x, string s) string
```

Formats number `x` with the specified [DecimalFormat](https://docs.oracle.com/javase/7/docs/api/java/text/DecimalFormat.html) pattern `s` using the server locale (US/US).

Example:

  ```javascript
    // returns 3.14  
    formatNumber(3.14159, '#.##')
  ```

### `convert`

```javascript
  convert(double x, string s) string
```

Divides number `x` by the specified measurement unit `s` and formats the returned string with one fractional digit:

  * 'k' (1000)
  * 'Ki' (1024)
  * 'M' (1000^2)
  * 'Mi' (1024^2)
  * 'G' (1000^3)
  * 'Gi' (1024^3)

Example:

  ```javascript
    // returns 20.0
    // same as formatNumber(20480/1024, '#.#')
    convert(20480, 'Ki')
  ```

### `date_format`

```javascript
  date_format(long t, string p, string z) string
```

Converts timestamp `t` to string according to the specified [datetime pattern](http://joda-time.sourceforge.net/apidocs/org/joda/time/format/DateTimeFormat.html) `p` and the [timezone](../shared/timezone-list.md) `z`.

The input timestamp is specified as UNIX milliseconds.

Example:

```javascript
  /* Return formatted time string  "2018-01-09 15:23:40:000 Europe/Berlin" */
  date_format(milliseconds('2018-01-09T14:23:40Z'), "yyyy-MM-dd HH:mm:ss:SSS ZZZ", "Europe/Berlin")
```

Datetime Pattern reference:

  ```
   Symbol  Meaning                      Presentation  Examples
   ------  -------                      ------------  -------
   G       era                          text          AD
   C       century of era (>=0)         number        20
   Y       year of era (>=0)            year          1996

   x       weekyear                     year          1996
   w       week of weekyear             number        27
   e       day of week                  number        2
   E       day of week                  text          Tuesday; Tue

   y       year                         year          1996
   D       day of year                  number        189
   M       month of year                month         July; Jul; 07
   d       day of month                 number        10

   a       halfday of day               text          PM
   K       hour of halfday (0~11)       number        0
   h       clockhour of halfday (1~12)  number        12

   H       hour of day (0~23)           number        0
   k       clockhour of day (1~24)      number        24
   m       minute of hour               number        30
   s       second of minute             number        55
   S       fraction of second           number        978

   z       time zone                    text          Pacific Standard Time; PST
   Z       time zone offset/id          zone          -0800; -08:00; America/Los_Angeles

   '       escape for text              delimiter
   ''      single quote                 literal       '
  ```

### `formatInterval`

```javascript
  formatInterval(long interval) string
```

Converts interval in UNIX milliseconds to a formatted interval consisting of non-zero years, days, hours, minutes, and seconds.

Example:

```javascript
  /* Return formatted interval: 2y 139d 16h 47m 15s */
  formatInterval(75228435000L)
```

### `formatIntervalShort`

```javascript
  formatIntervalShort(long interval) string
```

Converts interval in UNIX milliseconds to a formatted interval consisting of up to two highest subsequent non-zero time units, where unit is one of years, days, hours, minutes, and seconds.

Examples:

```javascript
  /* Return formatted interval: 2y 139d */
  formatIntervalShort(75228435000L)

  /* Assuming current time of 2017-08-15T00:01:30Z, return short interval of elapsed time: 1m 30s */
  formatIntervalShort(elapsedTime("2017-08-15T00:00:00Z"))  
```  

### `addTable` for map

```javascript
   addTable([] m, string f) string
```

The function prints the input map `m` as a two-column table in the specified format `f`.

The first column in the table contains map keys, whereas the second column contains the corresponding map values.

The input map `m` typically references an existing field such as `tags`, `entity.tags`, or `variables`.

Supported formats:

* 'markdown'
* 'ascii'
* 'property'
* 'csv'
* 'html'

An empty string is returned if the map `m` is `null` or has no records.

Map records with empty or `null` values are ignored.

Numeric values are automatically rounded in web and email notifications and are printed `as is` in other cases.

The default table header is 'Name, Value'.

Examples:

* `markdown` format

```ls

```

* `csv` format

```javascript
  addTable(entity.tags, 'csv')
```

```ls
Name,Value
alias,007
app,ATSD
cpu_count,1
os,Linux
```

* `ascii` format

```javascript
  addTable(entity_tags(tags.host, true, true), 'ascii')
```

```ls

```

* `html` format

```javascript
  addTable(property_maps(entity, 'docker.container.state::*'), 'html')
```

```ls

```

* `property` format

```javascript
  addTable(excludeKeys(tags, ['image.id']) , 'property')
```

```ls

```


* `addTable` for maps

```javascript
  addTable([[] m], string f[, [string h]]) string
```

The function prints a collection of maps `m` as a multiple-column table in the specified format `f`, with optional header `h`.

The first column in the table contains unique keys from all maps in the collection, whereas the second and subsequent columns contain map values for the corresponding key in the first column.

The default table header is 'Name, Value-1, ..., Value-N'.

If the header argument `h` is specified as a collection of strings, it replaces the default header. The number of elements in the header collection must be the same as the number of maps plus `1`.

Example:

```javascript
addTable(property_maps('nurswgvml007','jfs::', 'today'), 'markdown')
```  

```markdown
| **Name** | **Value 1** | **Value 2**  |
|:---|:---|:--- |
| id | / | /boot |
| jfs_filespace_%used | 60.5 | 30.8 |
```

* `addTable` for list

```javascript
  addTable([[string]] c, string f[, [string] | boolean h]) string
```

The function prints a list of collections `c` as a multiple-column table in the specified format `f`. Each element in the list is serialized into its own row in the table.

The number of elements in each collection must be the same.

The default table header is 'Value-1, ..., Value-N'.

The header argument `h` can be used to customize the header.

If `h` is specified as a collection, its elements replace the default header. The size of the header collection must be the same as the number of cells in each row.

If `h` argument is specified as a boolean value `true`, the first row in the table will be used as a header.

An empty string is returned if the list `c` is empty.

Examples:

```javascript
query = 'SELECT datetime, value FROM http.sessions WHERE datetime > current_hour LIMIT 2'
//
addTable(executeSqlQuery(query), 'ascii', true)
```  

```ls
+--------------------------+-------+
| datetime                 | value |
+--------------------------+-------+
| 2018-01-26T13:00:14.098Z | 23    |
| 2018-01-26T13:00:29.110Z | 22    |
+--------------------------+-------+
```

```javascript
query = 'SELECT datetime, value FROM http.sessions WHERE datetime > current_hour LIMIT 2'
//
addTable(executeSqlQuery(query), 'csv', ['date', 'count'])
```

```ls
date,count
2018-01-25T19:00:12.346Z,10
2018-01-25T19:00:27.347Z,18
```
