# Date Format

## Supported Formats

ATSD supports [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html) as a universally recognized format when parsing dates.

|**Format**|**Description**|
|:---|:---|
|`yyyy-MM-dd'T'HH:mm:ss[.S]'Z'`|`Z` denotes UTC time zone. |
|`yyyy-MM-dd'T'HH:mm:ss[.S]±hh[:]mm`|Time zone offset.|

* `yyyy`: four digit year
* `mm`: two digit month starting with `01` for January (`01`-`12`).
* `dd`: two digit day of month starting with `01` (`01`-`31`).
* `HH`: two digit hour in day (`00`-`23`).
* `mm`: two digit minute in hour (`00`-`59`).
* `ss`: two digit second in minute (`00`-`59`).
* `S`: fractional seconds, up to nine (`9`) digits.
* `hh`: two digit UTC time zone offset in hours (`00`-`11`).

## Time Zone

* Time zone must be specified as `Z` for the UTC time zone or as UTC offset in hours and minutes: `±hh:mm`, `±hhmm`. The colon (`:`) separator is optional.
* Positive offset `+hh:mm` applies to time zones that are **ahead** of or in line with UTC. Negative offset `-hh:mm` applies if the time zone is **behind** UTC.
* For example, Japan Standard Time (JST) has an offset of `+09:00` from UTC (ahead). The Pacific Standard Time (PST) has an offset of `-07:00` from UTC (behind).

## Time Precision

The fractional second part `[.S]` is optional and can have a resolution of nanoseconds (up to **nine** (`9`) digits of a decimal fraction)).

However only the milliseconds (three (`3`) digits) are retained in the database.

* `2016-06-24T20:00:45.003000005+00:00` is stored as `2016-06-24T20:00:45.003+00:00`.

## Examples

Valid timestamps:

* `2016-06-09T16:15:04.005Z`
* `2016-06-24T18:00:45Z`
* `2016-06-09T12:15:04.005-04:00`
* `2016-06-24T20:00:45+0200`
* `2016-06-24T20:00:45+02:00`
* `2016-06-24T20:00:45.003000005+00:00`

Invalid timestamps that cause a parsing error:

* `2016-06-09T16:15:04` - Time zone is missing.
* `2016-06-09T16:15Z` - Seconds are missing.
* `2016-06-09 16:15:04Z` - `T` separator is missing.
* `2016-06-09 16:15:04` - Time zone and `T` separator are missing.
* `2016-06-09T16:15:04PST` - Time zone [names](./timezone-list.md) are not supported.