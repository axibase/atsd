# Formatting Functions

## Overview

The functions format numbers and dates to strings according to the specified pattern.

## Reference

Number formatting functions:

* [formatNumber](#formatnumber)
* [convert](#convert)

Date formatting functions:

* [date_format](#date_format)
* [formatInterval](#formatinterval)
* [formatIntervalShort](#formatintervalshort)

Map formatting functions:

* [addTable](#addtable)

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

### `addTable`

The functions are not accessible when declaring **Variables**.

* `addTable([] m, string f)`

```javascript
  addTable([] m, string f) string
```
Returns the input map `m` in the specified format `f`. Map `m` is a key/value map, such as entity.tags, tags or variables.

`f` is one of the supported formats: 'markdown', 'ascii', 'property', 'csv', 'html'.

If the key or value is null, the row for such map.entry is omitted from the table.

The numbers in the map can be rounded depending on context.

The function returns an empty string if the map `m` is empty.

Example:

```javascript
addTable(getEntity('nurswgvml007').tags, 'csv')
```
The following table is returned:

```css
Name,Value
alias,007
app,ATSD
cpu_count,1
os,Linux
```

* `addTable([[] m], string f[, [string h]])`  

```javascript
  addTable([[] m], string f[, [string h]]) string
```
The function accepts a collection of maps `m` and creates one table with multiple columns (one value column for each map).

If headers provided and headers list `h` is not empty, it's values used as header, otherwise first column is 'Name', others are 'Value {n - 1}', where n is column index starting with 1.

Example:

```javascript
addTable(property_maps('nurswgvml007','jfs::', 'today'), 'markdown')
```  
The following table is returned:

```markdown
| **Name** | **Value 1** | **Value 2**  |
|:---|:---|:--- |
| id | / | /boot |
| jfs_filespace_%used | 60.5 | 30.8 |
```

* `addTable([[string]] m, string f[, [string h] | boolean r])`

```javascript
  addTable([[string]] m, string f[, [string h] | boolean r]) string
```
The function accepts a collection of collections of strings `m` and creates one table with multiple columns.

If headers provided and headers list `h` is not empty, it's values used as header, otherwise headers will be Value {n}, where n is column index starting with 1.

If `r` is true, first row used as header and others as value rows. If collection of strings `m` is empty, empty string is returned. Otherwise headers will be Value {n}.

Examples:

```javascript
query = 'SELECT datetime, value FROM http.sessions WHERE datetime > current_hour LIMIT 2'
addTable(executeSqlQuery(query), 'ascii', true)
```  
The following table is returned:

```css
+--------------------------+-------+
| datetime                 | value |
+--------------------------+-------+
| 2018-01-26T13:00:14.098Z | 23    |
| 2018-01-26T13:00:29.110Z | 22    |
+--------------------------+-------+
```

```javascript
addTable([['2018-01-25T19:00:12.346Z', '1'], ['2018-01-25T19:00:27.347Z', '1']], 'ascii', ['date', 'count'])
```
The following table is returned:

```css
+--------------------------+-------+
| date                     | count |
+--------------------------+-------+
| 2018-01-25T19:00:12.346Z | 10    |
| 2018-01-25T19:00:27.347Z | 18    |
+--------------------------+-------+
```