# ORDER By String (Collation)

Ordering of strings is based on their Unicode value, with `NULL` having the lowest value.

## Query - Ascending Order

`NULL` is listed at the beginning of the result set.

```sql
SELECT tags.'tag-1' AS "Tag Value", tags.'tag-unicode-1' AS "unicode-1", tags.'tag-unicode-2' AS "unicode-2", tags.'tag-unicode-7' AS "unicode-7"
  FROM "m-order"
WHERE entity = 'e-1'
  ORDER BY tags.'tag-1' ASC
```

### Results

```ls
| Tag Value | unicode-1 | unicode-2 | unicode-7 |
|-----------|-----------|-----------|-----------|
| null      | null      | null      | null      |
| .         | U+002E    | null      | null      |
| 01        | U+0030    | U+0031    | null      |
| 1         | U+0031    | null      | null      |
| 10        | U+0031    | U+0030    | null      |
| 11        | U+0031    | U+0031    | null      |
| 2         | U+0032    | null      | null      |
| 20        | U+0032    | U+0030    | null      |
| 3         | U+0033    | null      | null      |
| 30        | U+0033    | U+0030    | null      |
| A         | U+0041    | null      | null      |
| AB        | U+0041    | U+0042    | null      |
| B         | U+0042    | null      | null      |
| Resumes   | U+0052    | U+0065    | U+0073    |
| Résumé    | U+0052    | U+00E9    | null      |
| a         | U+0061    | null      | null      |
| a¨b       | U+0061    | U+00A8    | null      |
| resume    | U+0072    | U+0065    | null      |
| resumes   | U+0072    | U+0065    | U+0073    |
| résumé    | U+0072    | U+00E9    | null      |
| résumés   | U+0072    | U+00E9    | U+0073    |
| á         | U+00E1    | null      | null      |
| ä         | U+00E4    | null      | null      |
| äa        | U+00E4    | U+0061    | null      |
| äb        | U+00E4    | U+0062    | null      |
| äc        | U+00E4    | U+0063    | null      |
| é         | U+00E9    | null      | null      |
| ÿ         | U+00FF    | null      | null      |
| ā         | U+0101    | null      | null      |
| ǎ         | U+01CE    | null      | null      |
| α         | U+03B1    | null      | null      |
| а         | U+0430    | null      | null      |
```

## Query - Descending Order With `LIMIT`

`NULL` is listed at the end of the result set.

```sql
SELECT tags.'tag-1' AS "Tag Value", tags.'tag-unicode-1' AS "unicode-1", tags.'tag-unicode-2' AS "unicode-2", tags.'tag-unicode-7' AS "unicode-7"
  FROM "m-order"
WHERE entity = 'e-1'
  ORDER BY tags.'tag-1' DESC
LIMIT 10
```

### Results

```ls
| Tag Value | unicode-1 | unicode-2 | unicode-7 |
|-----------|-----------|-----------|-----------|
| а         | U+0430    | null      | null      |
| α         | U+03B1    | null      | null      |
| ǎ         | U+01CE    | null      | null      |
| ā         | U+0101    | null      | null      |
| ÿ         | U+00FF    | null      | null      |
| é         | U+00E9    | null      | null      |
| äc        | U+00E4    | U+0063    | null      |
| äb        | U+00E4    | U+0062    | null      |
| äa        | U+00E4    | U+0061    | null      |
| ä         | U+00E4    | null      | null      |
```

## Data

```ls
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=" ." t:tag-unicode-1=U+002E
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=1  t:tag-unicode-1=U+0031
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=01 t:tag-unicode-1=U+0030 t:tag-unicode-2=U+0031
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=11 t:tag-unicode-1=U+0031 t:tag-unicode-2=U+0031
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=10 t:tag-unicode-1=U+0031 t:tag-unicode-2=U+0030
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=2  t:tag-unicode-1=U+0032
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=20 t:tag-unicode-1=U+0032 t:tag-unicode-2=U+0030
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=3  t:tag-unicode-1=U+0033
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=30 t:tag-unicode-1=U+0033 t:tag-unicode-2=U+0030
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=A  t:tag-unicode-1=U+0041
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=B  t:tag-unicode-1=U+0042
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=AB t:tag-unicode-1=U+0041 t:tag-unicode-2=U+0042
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=a  t:tag-unicode-1=U+0061
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=á  t:tag-unicode-1=U+00E1
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=ä  t:tag-unicode-1=U+00E4
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=é  t:tag-unicode-1=U+00E9
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=ÿ  t:tag-unicode-1=U+00FF
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=ǎ  t:tag-unicode-1=U+01CE
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=ā  t:tag-unicode-1=U+0101
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=а  t:tag-unicode-1=U+0430
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=α  t:tag-unicode-1=U+03B1
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=resume  t:tag-unicode-1=U+0072 t:tag-unicode-2=U+0065
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=résumé  t:tag-unicode-1=U+0072 t:tag-unicode-2=U+00E9
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=Résumé  t:tag-unicode-1=U+0052 t:tag-unicode-2=U+00E9
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=Resumes t:tag-unicode-1=U+0052 t:tag-unicode-2=U+0065 t:tag-unicode-7=U+0073
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=resumes t:tag-unicode-1=U+0072 t:tag-unicode-2=U+0065 t:tag-unicode-7=U+0073
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=résumés t:tag-unicode-1=U+0072 t:tag-unicode-2=U+00E9 t:tag-unicode-7=U+0073
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=a¨b t:tag-unicode-1=U+0061 t:tag-unicode-2=U+00A8
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=äb  t:tag-unicode-1=U+00E4 t:tag-unicode-2=U+0062
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=äa  t:tag-unicode-1=U+00E4 t:tag-unicode-2=U+0061
series e:e-1 m:m-order=1 d:2016-08-01T00:00:00Z t:tag-1=äc  t:tag-unicode-1=U+00E4 t:tag-unicode-2=U+0063
```
