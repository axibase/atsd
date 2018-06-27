# `picomp2` Command

## Description

Accepts archived data retrieved from the `picomp2` table using CSV format with a pre-defined column order.

The uploaded data is stored as a series. If the PI Point data type is `string`, `digital`, or `timestamp`, their values are stored in the `x:` text field.

## Syntax

```bash
picomp2 z:${timezone} e:${entity} i:${ignore-defaults} t:${tag-name}=${tag-value}
... pointtypex, picomp2 column values ...
```

### Fields

| **Name** | **Type** | **Description** |
|:---|:---|:---|
| `e`         | string       | [**Required**] Default entity name. |
| `i`         | boolean      | Ignore default values: `status` = `0`, `status_test` = `GOOD`, `flags` = `false`, `annotations` = `null` or empty. <br>Default: `true` (ignore defaults).|
| `z`         | string       | [Time Zone](../../shared/timezone-abnf.md) applied when parsing dates, for example EST.<br>Default time zone: UTC.<br>Default date format:  `yyyy-MM-dd HH:mm:ss`.|
| `t`         | string       | One or multiple series or message tag `key=value` pairs, for example: `t:location=SVL`. |

### Columns

1. `pointtypex`
2. `tag`
3. `time`
4. `_index`
5. `value`
6. `status`
7. `status_text`
8. `questionable`
9. `substituted`
10. `annotated`
11. `annotations`

### Data Types

The following data types are supported for the value column.

* String
* Digital
* Int16
* Int32
* Float16
* Float32
* Float64
* Timestamp

### PI Query

The order of [columns](#columns) in the uploaded content corresponds to results of the following query.

```sql
SELECT TOP 10 TAGTYPE(tag) as pointtypex,
        tag,
        time,
        _index,
        CASE TAGTYPE(tag)
          WHEN 'digital' THEN CAST(DIGSTRING(CAST(value as Int32)) as VARIANT)
          ELSE value
        END AS value,
        status,
        DIGSTRING(status) AS status_text,
        questionable, substituted, annotated, annotations
FROM piarchive..picomp2
WHERE tag = 'sinusoid'
  ORDER BY time
```

```ls
| pointtypex | tag      | time                | _index | value | status | status_text | questionable | substituted | annotated | annotations |
|------------|----------|---------------------|--------|-------|--------|-------------|--------------|-------------|-----------|-------------|
| float64    | sinusoid | 2016-08-24 17:43:44 | 1      | 0.92  | 0      | Good        | false        | false       | false     | null        |
```

* An `_index` column, which represents a sample order for a given timestamp, is ignored if `<= 1`. If `_index` exceeds `1`, the column is added as series tag.
* `tag`, `value`, and `annotations` column values must be properly escaped if the value contains a comma, double quote, or line break.
* Numbers must be formatted using dot (`.`) as the decimal separator and without the grouping separator.
* Empty fields and fields with literal `null` values are ignored.

## `series` Command Mappings

| **Command Field** | **Input Field** |
|:---|:---|
| Metric Name | `tag` column. Whitespace characters contained in the tag name replaced with underscore. |
| Entity Name | `e` entity field.  |
| Time        | `time` column.     |
| Value       | `value` column if numeric.|
| Text          | `value` column if text. |
| Series Tags | `status` and `status_text` columns if not default.<br>`_index` column if `>= 1`.<br>`questionable`, `substituted`, `annotated` columns if not `false`.<br>`annotations` column if not null/empty. |

### ABNF Syntax

Rules inherited from [Base ABNF](base-abnf.md).

```elm
command = "picomp2" MSP entity [MSP timezone] [MSP ignore-defaults] *(MSP tag)
entity = "e:" NAME
ignore-defaults = "i:" BOOLEAN
timezone = "z:" TIMEZONE
tag = "t:" NAME "=" VALUE
```

## Example - Store All Fields

```ls
picomp2 e:default t:environment=prod
Float64,sinusoid,2016-10-09 17:43:44,1,0.92,0,false,false,false,
Float64,sinusoid,2016-10-09 17:43:58,1,0.97,0,false,false,false,
```

## Example - Store Base Fields

```ls
picomp2 e:default t:environment=prod
Float64,sinusoid,2016-10-09 17:43:44,,0.92,,,,,
Float64,sinusoid,2016-10-09 17:43:58,,0.97,,,,,
```

## picomp2 Query Results

```ls
| pointtypex | tag                          | time                | _index | value    | raw_value | status_string | status | questionable | substituted | annotated | annotations |
|------------|------------------------------|---------------------|--------|----------|-----------|---------------|--------|--------------|-------------|-----------|-------------|
| Float32    | Memory_Avail MBytes          | 2016-09-20 12:57:49 | 1      | null     | null      | Pt Created    | -253   | false        | false       | false     | null        |
| Float32    | Memory_Avail MBytes          | 2016-10-11 15:38:00 | 1      | 6139.0   | 6139.0    | Good          | 0      | false        | false       | false     | null        |
| Float32    | Memory_Avail MBytes          | 2016-10-11 15:38:00 | 2      | 6139.1   | 6139.1    | Good          | 0      | false        | false       | false     | null        |
| Float32    | Memory_Avail MBytes          | 2016-10-11 15:38:00 | 3      | 6139.2   | 6139.2    | Good          | 0      | false        | false       | false     | null        |
| Float32    | Memory_Avail MBytes          | 2016-10-11 15:38:01 | 1      | 6141.0   | 6141.0    | Good          | 0      | false        | false       | false     | null        |
| Digital    | BA:ACTIVE.1                  | 2016-08-24 15:02:55 | 1      | null     | null      | Pt Created    | -253   | false        | false       | false     | null        |
| Digital    | BA:ACTIVE.1                  | 2016-08-24 15:03:17 | 1      | Inactive | -65536    | Good          | 0      | false        | false       | false     | null        |
| Digital    | BA:ACTIVE.1                  | 2016-08-24 15:04:17 | 1      | Active   | -65537    | Good          | 0      | false        | false       | false     | null        |
| Digital    | BA:ACTIVE.1                  | 2016-08-24 16:15:17 | 1      | Inactive | -65536    | Good          | 0      | false        | false       | false     | null        |
| Int32      | CDEP158                      | 2016-08-24 15:01:09 | 1      | null     | null      | Shutdown      | -254   | false        | false       | false     | null        |
| Int32      | CDEP158                      | 2016-08-24 15:03:17 | 1      | 0        | 0         | Good          | 0      | false        | false       | false     | null        |
| Int32      | CDEP158                      | 2016-08-24 15:43:17 | 1      | 12       | 12        | Good          | 0      | false        | false       | false     | null        |
| Int32      | CDEP158                      | 2016-08-24 16:21:20 | 1      | null     | null      | Shutdown      | -254   | false        | false       | false     | null        |
| Int32      | CDEP158                      | 2016-08-24 16:23:30 | 1      | 1        | 1         | Good          | 0      | false        | false       | false     | null        |
| Int32      | CDEP158                      | 2016-08-24 22:28:30 | 1      | 43       | 43        | Good          | 0      | false        | false       | false     | null        |
|------------|------------------------------|---------------------|--------|----------|-----------|---------------|--------|--------------|-------------|-----------|-------------|
```

## picomp2 Commands

```ls
series e:default d:2016-09-20T12:57:49Z m:Memory_Avail_MBytes=NaN t:status_text="Pt Created" t:status=-253
series e:default d:2016-10-11T15:38:00Z m:Memory_Avail_MBytes=6139.0
series e:default d:2016-10-11T15:38:00Z m:Memory_Avail_MBytes=6139.1 t:_index=2
series e:default d:2016-10-11T15:38:00Z m:Memory_Avail_MBytes=6139.2 t:_index=3
series e:default d:2016-10-11T15:38:01Z m:Memory_Avail_MBytes=6141.0
series e:default d:2016-08-24T15:02:55Z x:BA:ACTIVE.1="" t:status_text="Pt Created" t:status=-253
series e:default d:2016-08-24T15:03:17Z x:BA:ACTIVE.1=Inactive
series e:default d:2016-08-24T15:04:17Z x:BA:ACTIVE.1=Active
series e:default d:2016-08-24T16:15:17Z x:BA:ACTIVE.1=Inactive
series e:default d:2016-08-24T15:01:09Z m:CDEP158=NaN t:status_text="Shutdown" t:status=-254
series e:default d:2016-08-24T15:03:17Z m:CDEP158=0
series e:default d:2016-08-24T15:43:17Z m:CDEP158=12
series e:default d:2016-08-24T16:21:20Z m:CDEP158=NaN t:status_text="Shutdown" t:status=-254
series e:default d:2016-08-24T16:23:30Z m:CDEP158=1
series e:default d:2016-08-24T22:28:30Z m:CDEP158=43
```

```sql
SELECT entity, metric AS pitag, datetime, value, ISNULL(text, '') AS svalue,
  ISNULL(tags._index, '1') AS '_index', ISNULL(tags.status, '0') AS status, ISNULL(tags.status_text, 'Good') AS status_text,
  ISNULL(tags.questionable, 'false') AS questionable, ISNULL(tags.substituted, 'false') AS substituted, ISNULL(tags.annotated, 'false') AS annotated,
  ISNULL(tags.annotations, '') AS annotations
FROM atsd_series
  WHERE metric IN ('Memory_Avail_MBytes', 'BA:ACTIVE.1', 'CDEP158')
AND entity = 'default'
```

```ls
| entity  | pitag               | datetime             | value  | svalue   | _index | status | status_text | questionable | substituted | annotated | annotations |
|---------|---------------------|----------------------|--------|----------|--------|--------|-------------|--------------|-------------|-----------|-------------|
| default | memory_avail_mbytes | 2016-09-20T12:57:49Z | NaN    |          | 1      | -253   | Pt Created  | false        | false       | false     |             |
| default | memory_avail_mbytes | 2016-10-11T15:38:00Z | 6139.0 |          | 1      | 0      | Good        | false        | false       | false     |             |
| default | memory_avail_mbytes | 2016-10-11T15:38:00Z | 6139.1 |          | 2      | 0      | Good        | false        | false       | false     |             |
| default | memory_avail_mbytes | 2016-10-11T15:38:00Z | 6139.2 |          | 3      | 0      | Good        | false        | false       | false     |             |
| default | memory_avail_mbytes | 2016-10-11T15:38:01Z | 6141.0 |          | 1      | 0      | Good        | false        | false       | false     |             |
| default | ba:active.1         | 2016-08-24T15:02:55Z | NaN    |          | 1      | -253   | Pt Created  | false        | false       | false     |             |
| default | ba:active.1         | 2016-08-24T15:03:17Z | NaN    | Inactive | 1      | 0      | Good        | false        | false       | false     |             |
| default | ba:active.1         | 2016-08-24T15:04:17Z | NaN    | Active   | 1      | 0      | Good        | false        | false       | false     |             |
| default | ba:active.1         | 2016-08-24T16:15:17Z | NaN    | Inactive | 1      | 0      | Good        | false        | false       | false     |             |
| default | cdep158             | 2016-08-24T15:01:09Z | NaN    |          | 1      | -254   | Shutdown    | false        | false       | false     |             |
| default | cdep158             | 2016-08-24T15:03:17Z | 0.0    |          | 1      | 0      | Good        | false        | false       | false     |             |
| default | cdep158             | 2016-08-24T15:43:17Z | 12.0   |          | 1      | 0      | Good        | false        | false       | false     |             |
| default | cdep158             | 2016-08-24T16:21:20Z | NaN    |          | 1      | -254   | Shutdown    | false        | false       | false     |             |
| default | cdep158             | 2016-08-24T16:23:30Z | 1.0    |          | 1      | 0      | Good        | false        | false       | false     |             |
| default | cdep158             | 2016-08-24T22:28:30Z | 43.0   |          | 1      | 0      | Good        | false        | false       | false     |             |
```
