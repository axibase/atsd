# Formatting Functions

## Overview

These functions format numbers, dates, collections, and maps to strings according to the specified format.

## Reference

Number formatting functions:

* [formatNumber](#formatnumber)
* [formatBytes](#formatbytes)
* [convert](#convert)

Date formatting functions:

* [date_format](#date_format)
* [formatInterval](#formatinterval)
* [formatIntervalShort](#formatintervalshort)

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

The function returns the total number of bytes `x` in a human-readable format. The function identifies the largest possible unit (from Byte to Exabyte) such that the number `x` is equal to or exceeds 1 such unit. Units are decimal-based (1000) if the `si` parameter is set to `true`, and binary (1024) otherwise.

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

The function divides the number `x` by the specified measurement unit `s` and formats the returned string with one fractional digit.

The unit prefix is case-insensitive and should be one of the following:

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

Converts timestamp `t` to a string according to the specified [datetime pattern](http://joda-time.sourceforge.net/apidocs/org/joda/time/format/DateTimeFormat.html) `p` and the [timezone](../shared/timezone-list.md) `z`.

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

Converts interval in UNIX milliseconds to a formatted interval consisting of up to the two highest subsequent non-zero time units, where the unit comprises years, days, hours, minutes, and seconds.

Examples:

```javascript
  /* Return formatted interval: 2y 139d */
  formatIntervalShort(75228435000L)

  /* Assuming current time of 2017-08-15T00:01:30Z, returns a short interval of elapsed time: 1m 30s */
  formatIntervalShort(elapsedTime("2017-08-15T00:00:00Z"))  
```  

