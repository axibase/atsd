# Formatting Functions

## Overview

The functions format numbers, dates, collections, and maps to strings according to the specified format.

## Reference

Number formatting functions:

* [formatNumber](#formatnumber)
* [formatBytes](#formatbytes)
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
  
### `formatBytes`
  
```javascript
  formatBytes(number x, boolean si) string
```

Display number of bytes `x` in a human-readable format. The function identifies the largest possible unit (from Byte to Exabyte) such that the number `x` is equal or exceeds 1 such unit. Units are decimal-based (1000) if the `si` parameter is set to `true`, and binary (1024) otherwise.

For example, if the unit is `1000` (`si` set to `true`):

```
 999 -> 999.0 B  (unit is byte)
1000 ->   1.0 kB (unit is kilobyte)
```

The formatted number always contains one fractional digit.

Examples:

```
                        si=false    si=true
                   0:        0 B        0 B
                  27:       27 B       27 B
                 999:      999 B      999 B
                1000:     1.0 kB     1000 B
                1023:     1.0 kB     1023 B
                1024:     1.0 kB    1.0 KiB
                1728:     1.7 kB    1.7 KiB
              110592:   110.6 kB  108.0 KiB
             7077888:     7.1 MB    6.8 MiB
           452984832:   453.0 MB  432.0 MiB
         28991029248:    29.0 GB   27.0 GiB
       1855425871872:     1.9 TB    1.7 TiB
```

> If the `x` argument is a string or an object that cannot be parsed into a number, its value is returned 'as is'.

### `convert`

```javascript
  convert(number x, string s) string
```

Divides number `x` by the specified measurement unit `s` and formats the returned string with one fractional digit. 

The unit prefix is case-insensitive and should be one of:

  * 'K', 'Kb' (1000)
  * 'Ki', 'KiB' (1024)
  * 'M', 'Mb' (1000^2)
  * 'Mi', 'MiB' (1024^2)
  * 'G', 'Gb' (1000^3)
  * 'Gi', 'GiB' (1024^3)
  * 'T', 'Tb' (1000^4)
  * 'Ti', 'TiB' (1024^4)
  * 'P', 'Pb' (1000^5)
  * 'Pi', 'PiB' (1024^5)
  * 'E', 'Eb' (1000^6)
  * 'Ei', 'EiB' (1024^6)
  
Examples:

  ```javascript
    // returns 20.0
    // same as formatNumber(20480/1024, '#.#')
    convert(20480, 'KiB') // 20.0
    convert(1000 * 1000, 'M') // 1.0
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

The input map `m` typically refers to map fields such as `tags`, `entity.tags`, or `variables`.

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

```javascript
  addTable(property_map('nurswgvml007','disk::', 'today'), 'markdown')
```

```ls
| **Name** | **Value**  |
|:---|:--- |
| id | sda5 |
| disk_%busy | 0.6 |
| disk_block_size | 16.1 |
| disk_read_kb/s | 96.8 |
| disk_transfers_per_second | 26.0 |
| disk_write_kb/s | 8.1 |
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
+-------------+------------+
| Name        | Value      |
+-------------+------------+
| alias       | 007        |
| app         | ATSD       |
| cpu_count   | 1          |
| os          | Linux      |
+-------------+------------+
```

* `html` format

The HTML format includes the response rendered as a `<table>` node with inline CSS styles for better compatibility with legacy email clients such as Microsoft Outlook.

```javascript
  addTable(property_map('nurswgvml007', 'cpu::*'), 'html')
```

```html
<table style="font-family: monospace, consolas, sans-serif; border-collapse: collapse; font-size: 12px; margin-top: 5px"><tbody><tr><th bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">Name</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Value</th></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">id</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">1</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">cpu.idle%</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">91.5</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">cpu.steal%</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">0.0</td></tr>
</tbody></table>
```

* `property` format

```javascript
  addTable(excludeKeys(entity.tags, ['ip', 'loc_code', 'loc_area']), 'property')
```

```ls
alias=007
app=ATSD
cpu_count=1
os=Linux
```

### `addTable` for maps

```javascript
  addTable([[] m], string f[, [string h]]) string
```

The function prints a collection of maps `m` as a multiple-column table in the specified format `f`, with optional header `h`.

The first column in the table contains unique keys from all maps in the collection, whereas the second and subsequent columns contain map values for the corresponding key in the first column.

The default table header is 'Name, Value-1, ..., Value-N'.

If the header argument `h` is specified as a collection of strings, it replaces the default header. The number of elements in the header collection must be the same as the number of maps plus `1`.

Examples:

`property_maps('nurswgvml007','jfs::', 'today')` returns following collection:

```ls
[
  {id=/, jfs_filespace_%used=12.8}, 
  {id=/dev, jfs_filespace_%used=0.0}, 
  {id=/mnt/u113452, jfs_filespace_%used=34.9}, 
  {id=/run, jfs_filespace_%used=7.5}, 
  {id=/var/lib/lxcfs, jfs_filespace_%used=0.0}
  ]
```

* `markdown` format

```javascript  
  addTable(property_maps('nurswgvml007','jfs::', 'today'), 'markdown')
```

```markdown
| **Name** | **Value 1** | **Value 2** | **Value 3** | **Value 4** | **Value 5**  |
|:---|:---|:---|:---|:---|:--- |
| id | / | /dev | /mnt/u113452 | /run | /var/lib/lxcfs |
| jfs_filespace_%used | 12.8 | 0.0 | 34.9 | 7.5 | 0.0 |
```

* `csv` format

```javascript  
  addTable(property_maps('nurswgvml007','jfs::', 'today'), 'csv')
```

```ls
Name,Value 1,Value 2,Value 3,Value 4,Value 5
id,/,/dev,/mnt/u113452,/run,/var/lib/lxcfs
jfs_filespace_%used,12.7,0.0,34.9,7.5,0.0
```

* `ascii` format

```javascript
  addTable(property_maps('nurswgvml007','jfs::', 'today'), 'ascii', ['property', 'root', 'dev', 'mount', 'run', 'var'])
```

```ls
+---------------------+------+------+--------------+------+----------------+
| property            | root | dev  | mount        | run  | var            |
+---------------------+------+------+--------------+------+----------------+
| id                  | /    | /dev | /mnt/u113452 | /run | /var/lib/lxcfs |
| jfs_filespace_%used | 12.8 | 0.0  | 34.9         | 7.5  | 0.0            |
+---------------------+------+------+--------------+------+----------------+
```

* `html` format

```javascript
  addTable(property_maps('nurswgvml007','jfs::', 'today'), 'html')
```

```ls
<table style="font-family: monospace, consolas, sans-serif; border-collapse: collapse; font-size: 12px; margin-top: 5px"><tbody><tr><th bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">Name</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Value 1</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Value 2</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Value 3</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Value 4</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Value 5</th></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">id</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">/</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">/dev</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">/mnt/u113452</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">/run</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">/var/lib/lxcfs</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">jfs_filespace_%used</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">12.8</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">0.0</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">34.9</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">7.5</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">0.0</td></tr>
</tbody></table>
```

* `property` format

```javascript
  addTable(property_maps('nurswgvml007','jfs::', 'today'), 'property')
```

```ls
id=/=/dev=/mnt/u113452=/run=/var/lib/lxcfs
jfs_filespace_%used=12.8=0.0=34.9=7.5=0.0
```

### `addTable` for list

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
```

`executeSqlQuery(query)` returns following collection:

```ls
[[datetime, value], [2018-01-31T12:00:13.242Z, 37], [2018-01-31T12:00:28.253Z, 36]]
```

* `markdown` format

```javascript
  addTable(executeSqlQuery(query), 'markdown', true)
```

```ls
| **datetime** | **value**  |
|:---|:--- |
| 2018-01-31T12:00:13.242Z | 37 |
| 2018-01-31T12:00:28.253Z | 36 |
```

* `csv` format

```javascript
  addTable([['2018-01-31T12:00:13.242Z', '37'], ['2018-01-31T12:00:28.253Z', '36']], 'csv', ['date', 'count'])
```

```ls
date,count
2018-01-31T12:00:13.242Z,37
2018-01-31T12:00:28.253Z,36
```

* `ascii` format

```javascript
  addTable(executeSqlQuery(query), 'ascii', true)
```  

```ls
+--------------------------+-------+
| datetime                 | value |
+--------------------------+-------+
| 2018-01-31T12:00:13.242Z | 37    |
| 2018-01-31T12:00:28.253Z | 36    |
+--------------------------+-------+
```

* `html` format

```javascript
  addTable(executeSqlQuery(query), 'html', true)
```

```html
<table style="font-family: monospace, consolas, sans-serif; border-collapse: collapse; font-size: 12px; margin-top: 5px"><tbody><tr><th bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">datetime</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">value</th></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">2018-01-31T12:00:13.242Z</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">37</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">2018-01-31T12:00:28.253Z</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">36</td></tr>
</tbody></table>
```

* `property` format

```javascript
  addTable(executeSqlQuery(query), 'property')
```
```ls
datetime=value
2018-01-31T12:00:13.242Z=37
2018-01-31T12:00:28.253Z=36
```

```javascript
  addTable(executeSqlQuery(query), 'property', true)
```
```ls
2018-01-31T12:00:13.242Z=37
2018-01-31T12:00:28.253Z=36
```

```javascript
  addTable(executeSqlQuery(query), 'property', false)
```
```ls
datetime=value
2018-01-31T12:00:13.242Z=37
2018-01-31T12:00:28.253Z=36
```
