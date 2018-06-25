# Date Format

## Supported Formats

|**Format**|**Description**|
|:---|:---|
|`yyyy-MM-dd'T'HH:mm:ss[.SSS]'Z'`|`Z` denotes UTC time zone. |
|`yyyy-MM-dd'T'HH:mm:ss[.SSS]±hh[:]mm`|Time zone offset.|

* `yyyy`: four digit year
* `mm`: two digit month starting with `01` for January (01-12).
* `dd`: two digit day of month starting with `01` (01-31).
* `HH`: two digit hour in day (00-23).
* `mm`: two digit minute in hour (00-59).
* `ss`: two digit second in minute (00-59).
* `S`: fractional second.

## Notes

* Time zone can be specified as `Z` for the UTC time zone or as UTC offset in hours or minutes: `±hh:mm`, `±hhmm`.
* Positive offset `+hh:mm`/`±hhmm` applies to time zones that are ahead of or in line with UTC. Negative offset `-hh:mm`/`-hhmm` applies if the time zone is behind UTC.
* The millisecond part `[.SSS]` is optional and can have a resolution of nanoseconds (up to **nine** (`9`) digits of a decimal fraction)). However only the milliseconds (three (`3`) digits) are retained in the database.

## Examples

* `2016-06-09T16:15:04.005Z`
* `2016-06-24T18:00:45Z`
* `2016-06-09T12:15:04.005-04:00`
* `2016-06-24T20:00:45+0200`
* `2016-06-24T20:00:45+02:00`
* `2016-06-24T20:00:45.003000005+00:00`
