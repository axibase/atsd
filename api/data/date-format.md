# Date Format

## Supported Date Formats

|**Format**|**Example**|**Description**|
|:---|:---|:---|
|`yyyy-MM-dd'T'HH:mm:ss[.SSS]'Z'`|2016-06-09T16:15:04.005Z<br>2016-06-24T18:00:45Z|ISO 8601 date. UTC time zone (Z). |
|`yyyy-MM-dd'T'HH:mm:ss[.SSS]±hh[:]mm`|2016-06-09T12:15:04.005-04:00<br>2016-06-24T20:00:45+02:00<br>2016-06-24T20:00:45+0200|ISO 8601 date. <br>Time zone offset of `+hh:mm` ahead of UTC or `-hh:mm` behind UTC.|

* Time zone can be specified as UTC offset `±hh:mm`, `±hhmm`, or as **Z** for UTC time zone in its canonical representation.
* Milliseconds are optional.
