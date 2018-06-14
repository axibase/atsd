# Text Value Column

The difference between series tags and text values is that tag names/values are converted to unique identifiers when stored.

Series tags are part of each series composite primary key, whereas the text value is not.

Since the total number of unique tag value identifiers is [limited](../../api/network/README.md#schema) to `16,777,215`, series tag values are not well suited for values with high cardinality such as random values or continuously incrementing values (time, counters).

The text value, on the other hand, is stored `as is`, without converting it to an identifier. It can be used as an annotation, or order to describe a numeric observation without changing its primary key.

```ls
series d:2016-10-13T08:00:00Z e:sensor-1 m:temperature=20.3
series d:2016-10-13T08:15:00Z e:sensor-1 m:temperature=24.4 x:temperature="Provisional"
```

In this example, temperature reading at `2016-10-13T08:15:00Z` is characterized as `Provisional`. No new series (by key) is created.

The text value can also be used to record observations for series that contain only text values in which case their numeric values are set to `NaN` (not a number).

```ls
series d:2016-10-13T10:30:00Z e:sensor-1 x:status="Shutdown by adm-user, RFC-5434"
```

Unlike [message](../../api/network/message.md) commands, series text values are available for SQL querying using the `text` column.

```sql
SELECT entity, datetime, value, text
  FROM atsd_series
WHERE metric IN ('temperature', 'status') AND datetime >= '2016-10-13T08:00:00Z'
```

```ls
| entity   | datetime             | value | text                           |
|----------|----------------------|-------|--------------------------------|
| sensor-1 | 2016-10-13T08:00:00Z | 20.3  | null                           |
| sensor-1 | 2016-10-13T08:15:00Z | 24.4  | Provisional                    |
| sensor-1 | 2016-10-13T10:30:00Z | NaN   | Shutdown by adm-user, RFC-5434 |
```

## Multiple Metrics with Different Values (Numeric/Text)

### Data

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

### Query

```sql
SELECT entity, metric AS pitag, datetime, value, ISNULL(text, '') AS svalue,
  ISNULL(tags._index, '1') AS "_index", ISNULL(tags.status, '0') AS status, ISNULL(tags.status_text, 'Good') AS status_text,
  ISNULL(tags.questionable, 'false') AS questionable, ISNULL(tags.substituted, 'false') AS substituted, ISNULL(tags.annotated, 'false') AS annotated,
  ISNULL(tags.annotations, '') AS annotations
FROM atsd_series
  WHERE metric IN ('Memory_Avail_MBytes', 'BA:ACTIVE.1', 'CDEP158')
AND entity = 'default'
```

### Results

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

## Text Value and Interpolation

When interpolated with the `WITH INTERPOLATE` clause, the text value is interpolated using the `PREVIOUS` function irrespective of the interpolate function argument specified in the query.

### Query

```sql
SELECT datetime, text
FROM "BA:ACTIVE.1"
WHERE entity = 'default'
  AND datetime >= '2016-08-24T14:45:00Z' AND datetime <= '2016-08-24T16:45:00Z'
  AND tags.status IS NULL
WITH INTERPOLATE(15 MINUTE, LINEAR, OUTER, EXTEND)
  ORDER BY datetime
```

### Results

```ls
| datetime             | text     |
|----------------------|----------|
| 2016-08-24T14:45:00Z | null     |
| 2016-08-24T15:00:00Z | null     |
| 2016-08-24T15:15:00Z | Active   |
| 2016-08-24T15:30:00Z | Active   |
| 2016-08-24T15:45:00Z | Active   |
| 2016-08-24T16:00:00Z | Active   |
| 2016-08-24T16:15:00Z | Active   |
| 2016-08-24T16:30:00Z | Inactive |
| 2016-08-24T16:45:00Z | Inactive |
```

## Joining Multiple Metrics with Text and Numeric Values

### Data

```ls
series d:2016-10-04T01:58:12Z e:br-1470 m:SV6.PACK:R01=90.4
series d:2016-10-04T02:00:05Z e:br-1470 m:SV6.PACK:R01=97.7
series d:2016-10-04T02:00:35Z e:br-1470 m:SV6.PACK:R01=77.1
series d:2016-10-04T02:02:28Z e:br-1470 m:SV6.PACK:R01=84.2
series d:2016-10-04T02:04:15Z e:br-1470 m:SV6.PACK:R01=65.2
series d:2016-10-04T02:05:28Z e:br-1470 m:SV6.PACK:R01=50.3
series d:2016-10-04T02:07:42Z e:br-1470 m:SV6.PACK:R01=60.1
series d:2016-10-04T02:08:28Z e:br-1470 m:SV6.PACK:R01=80.3
series d:2016-10-04T02:09:16Z e:br-1470 m:SV6.PACK:R01=87.1
series d:2016-10-04T02:11:11Z e:br-1470 m:SV6.PACK:R01=99.9

series d:2016-10-04T02:00:14Z e:br-1470 m:SV6.PACK:R03=47.7
series d:2016-10-04T02:00:55Z e:br-1470 m:SV6.PACK:R03=37.1
series d:2016-10-04T02:02:18Z e:br-1470 m:SV6.PACK:R03=44.2
series d:2016-10-04T02:04:25Z e:br-1470 m:SV6.PACK:R03=35.2
series d:2016-10-04T02:05:18Z e:br-1470 m:SV6.PACK:R03=40.3
series d:2016-10-04T02:07:22Z e:br-1470 m:SV6.PACK:R03=42.1
series d:2016-10-04T02:08:28Z e:br-1470 m:SV6.PACK:R03=46.3
series d:2016-10-04T02:09:26Z e:br-1470 m:SV6.PACK:R03=27.1
series d:2016-10-04T02:10:11Z e:br-1470 m:SV6.PACK:R03=49.9

series d:2016-10-04T01:59:12Z e:br-1470 m:SV6.PACK:R04=20.0
series d:2016-10-04T02:00:14Z e:br-1470 m:SV6.PACK:R04=27.7
series d:2016-10-04T02:01:55Z e:br-1470 m:SV6.PACK:R04=17.1
series d:2016-10-04T02:02:38Z e:br-1470 m:SV6.PACK:R04=24.2
series d:2016-10-04T02:04:45Z e:br-1470 m:SV6.PACK:R04=25.2
series d:2016-10-04T02:05:08Z e:br-1470 m:SV6.PACK:R04=20.3
series d:2016-10-04T02:07:52Z e:br-1470 m:SV6.PACK:R04=22.1
series d:2016-10-04T02:08:18Z e:br-1470 m:SV6.PACK:R04=26.3
series d:2016-10-04T02:09:46Z e:br-1470 m:SV6.PACK:R04=17.1
series d:2016-10-04T02:10:21Z e:br-1470 m:SV6.PACK:R04=19.9

series d:2016-10-04T02:00:00Z e:br-1470 x:SV6.Elapsed_Time=475.0
series d:2016-10-04T02:01:00Z e:br-1470 x:SV6.Elapsed_Time=26.0
series d:2016-10-04T02:02:00Z e:br-1470 x:SV6.Elapsed_Time=35.0
series d:2016-10-04T02:03:00Z e:br-1470 x:SV6.Elapsed_Time=95.0
series d:2016-10-04T02:04:00Z e:br-1470 x:SV6.Elapsed_Time=155.0
series d:2016-10-04T02:05:00Z e:br-1470 x:SV6.Elapsed_Time=215.0
series d:2016-10-04T02:06:00Z e:br-1470 x:SV6.Elapsed_Time=275.0
series d:2016-10-04T02:07:00Z e:br-1470 x:SV6.Elapsed_Time=335.0
series d:2016-10-04T02:08:00Z e:br-1470 x:SV6.Elapsed_Time=395.0
series d:2016-10-04T02:09:00Z e:br-1470 x:SV6.Elapsed_Time=455.0
series d:2016-10-04T02:10:00Z e:br-1470 x:SV6.Elapsed_Time=51.0

series d:2016-10-04T01:52:05Z e:br-1470 x:SV6.Unit_BatchID="1413"
series d:2016-10-04T02:00:34Z e:br-1470 x:SV6.Unit_BatchID="Inactive"
series d:2016-10-04T02:01:25Z e:br-1470 x:SV6.Unit_BatchID="1414"
series d:2016-10-04T02:09:05Z e:br-1470 x:SV6.Unit_BatchID="Inactive"
series d:2016-10-04T02:09:09Z e:br-1470 x:SV6.Unit_BatchID="1415"

series d:2016-10-04T01:57:08Z e:br-1470 x:SV6.Unit_Procedure="1413-Proc3"
series d:2016-10-04T02:00:34Z e:br-1470 x:SV6.Unit_Procedure="Inactive"
series d:2016-10-04T02:01:25Z e:br-1470 x:SV6.Unit_Procedure="1414-Proc1"
series d:2016-10-04T02:04:15Z e:br-1470 x:SV6.Unit_Procedure="1414-Proc2"
series d:2016-10-04T02:07:52Z e:br-1470 x:SV6.Unit_Procedure="1414-Proc3"
series d:2016-10-04T02:09:05Z e:br-1470 x:SV6.Unit_Procedure="Inactive"
series d:2016-10-04T02:09:09Z e:br-1470 x:SV6.Unit_Procedure="1415-Proc1"
```

### Query

```sql
SELECT t1.datetime, t1.entity, t1.value, t2.value, t3.value, t4.value, t5.value, t5.text, t6.text
  FROM "SV6.PACK:R01" t1
  JOIN "SV6.PACK:R03" t2
  JOIN "SV6.PACK:R04" t3
  JOIN "SV6.Elapsed_Time" t4
  JOIN "SV6.Unit_BatchID" t5
  JOIN "SV6.Unit_Procedure" t6
WHERE t1.datetime >= '2016-10-04T02:00:00Z' AND t2.datetime <= '2016-10-04T02:10:00Z'
  AND entity = 'br-1470'
WITH INTERPOLATE(60 SECOND, AUTO, OUTER, EXTEND, START_TIME)
```

### Results

```ls
| t1.datetime          | t1.entity | t1.value | t2.value | t3.value | t4.value | t5.value | t5.text  | t6.text    |
|----------------------|-----------|----------|----------|----------|----------|----------|----------|------------|
| 2016-10-04T02:00:00Z | br-1470   | 97.4     | 47.7     | 26.0     | 475.0    | NaN      | 1413     | 1413-Proc3 |
| 2016-10-04T02:01:00Z | br-1470   | 78.7     | 37.5     | 22.9     | 26.0     | NaN      | Inactive | Inactive   |
| 2016-10-04T02:02:00Z | br-1470   | 82.4     | 42.7     | 17.9     | 35.0     | NaN      | 1414     | 1414-Proc1 |
| 2016-10-04T02:03:00Z | br-1470   | 78.5     | 41.2     | 24.4     | 95.0     | NaN      | 1414     | 1414-Proc1 |
| 2016-10-04T02:04:00Z | br-1470   | 67.9     | 37.0     | 24.8     | 155.0    | NaN      | 1414     | 1414-Proc1 |
| 2016-10-04T02:05:00Z | br-1470   | 56.0     | 38.6     | 22.0     | 215.0    | NaN      | 1414     | 1414-Proc2 |
| 2016-10-04T02:06:00Z | br-1470   | 52.6     | 40.9     | 20.9     | 275.0    | NaN      | 1414     | 1414-Proc2 |
| 2016-10-04T02:07:00Z | br-1470   | 57.0     | 41.8     | 21.5     | 335.0    | NaN      | 1414     | 1414-Proc2 |
| 2016-10-04T02:08:00Z | br-1470   | 68.0     | 44.5     | 23.4     | 395.0    | NaN      | 1414     | 1414-Proc3 |
| 2016-10-04T02:09:00Z | br-1470   | 84.8     | 35.7     | 21.9     | 455.0    | NaN      | 1414     | 1414-Proc3 |
| 2016-10-04T02:10:00Z | br-1470   | 92.0     | 44.3     | 18.2     | 51.0     | NaN      | 1415     | 1415-Proc1 |
```

### Filtered Query

The query may refer to the `text` column in the `WHERE` clause in order to filter rows by `text` column value.

```sql
SELECT t1.datetime, t1.entity, t1.value, t2.value, t3.value, t4.value, t5.value, t5.text, t6.text
  FROM "SV6.PACK:R01" t1
  JOIN "SV6.PACK:R03" t2
  JOIN "SV6.PACK:R04" t3
  JOIN "SV6.Elapsed_Time" t4
  JOIN "SV6.Unit_BatchID" t5
  JOIN "SV6.Unit_Procedure" t6
WHERE t1.datetime >= '2016-10-04T02:00:00Z' AND t2.datetime <= '2016-10-04T02:10:00Z'
  AND entity = 'br-1470'
  AND t5.text = '1414'
WITH INTERPOLATE(60 SECOND, AUTO, OUTER, EXTEND, START_TIME)
```

```ls
| t1.datetime          | t1.entity | t1.value | t2.value | t3.value | t4.value | t5.value | t5.text | t6.text    |
|----------------------|-----------|----------|----------|----------|----------|----------|---------|------------|
| 2016-10-04T02:02:00Z | br-1470   | 82.4     | 42.7     | 17.9     | 35.0     | NaN      | 1414    | 1414-Proc1 |
| 2016-10-04T02:03:00Z | br-1470   | 78.5     | 41.2     | 24.4     | 95.0     | NaN      | 1414    | 1414-Proc1 |
| 2016-10-04T02:04:00Z | br-1470   | 67.9     | 37.0     | 24.8     | 155.0    | NaN      | 1414    | 1414-Proc1 |
| 2016-10-04T02:05:00Z | br-1470   | 56.0     | 38.6     | 22.0     | 215.0    | NaN      | 1414    | 1414-Proc2 |
| 2016-10-04T02:06:00Z | br-1470   | 52.6     | 40.9     | 20.9     | 275.0    | NaN      | 1414    | 1414-Proc2 |
| 2016-10-04T02:07:00Z | br-1470   | 57.0     | 41.8     | 21.5     | 335.0    | NaN      | 1414    | 1414-Proc2 |
| 2016-10-04T02:08:00Z | br-1470   | 68.0     | 44.5     | 23.4     | 395.0    | NaN      | 1414    | 1414-Proc3 |
| 2016-10-04T02:09:00Z | br-1470   | 84.8     | 35.7     | 21.9     | 455.0    | NaN      | 1414    | 1414-Proc3 |
```

### Single Value Column

In situations where the `text` column is used to annotate a missing or an invalid numeric value, use the `ISNULL` function to return the consolidated value in one column.

The datatype of the `ISNULL` function is determined based on the datatypes of its arguments as follows:

* `ISNULL(string, string)`: `string`
* `ISNULL(number, number)`: `number`
* `ISNULL(string, number)`: `java_object`
* `ISNULL(number, string)`: `java_object`

If both arguments are numeric and their datatypes are different, the returned datatype is based on the argument with the higher numeric precedence.

#### Query

```sql
SELECT entity, datetime, value, text, ISNULL(value, text), ISNULL(text, value)
  FROM atsd_series
WHERE metric = 'temperature' AND datetime >= '2016-10-13T08:00:00Z'
```

#### Results

```ls
| entity   | datetime                 | value | text                           | ISNULL(value,text)             | ISNULL(text,value)             |
|----------|--------------------------|-------|--------------------------------|--------------------------------|--------------------------------|
| sensor-1 | 2016-10-13T08:00:00.000Z | 20.3  | null                           | 20.3                           | 20.3                           |
| sensor-1 | 2016-10-13T08:15:00.000Z | 24.4  | Provisional                    | 24.4                           | Provisional                    |
| sensor-1 | 2016-10-13T10:30:00.000Z | NaN   | Shutdown by adm-user, RFC-5434 | Shutdown by adm-user, RFC-5434 | Shutdown by adm-user, RFC-5434 |
```
