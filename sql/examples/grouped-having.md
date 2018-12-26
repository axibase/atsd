# Grouping and Having Filter

In this example the "not equal" operator `!=` is used to exclude grouped rows with aggregation function delta equal to zero from the results.

## Query

```sql
SELECT t1.entity, t2.tags.mount_point AS mp, t2.tags.file_system AS FS,
  MIN(t2.value), MAX(t2.value),  FIRST_VALUE(t2.value), LAST_VALUE(t2.value),
  DELTA(t2.value), COUNT(t2.value), round(AVG(t1.value), 2) AS "AVG"
FROM "mpstat.cpu_busy" t1
  JOIN USING ENTITY "df.disk_used" t2
WHERE t1.datetime > now - 1*HOUR
  GROUP BY t1.entity, t2.tags.mount_point, t2.tags.file_system
HAVING DELTA(t2.value) != 0
  ORDER BY DELTA(t2.value) DESC
```

## Results

```ls
| t1.entity    | mp               | FS                   | min(t2.value) | max(t2.value) | first_value(t2.value) | last_value(t2.value) | delta(t2.value) | count(t2.value) |   AVG |
|--------------|------------------|----------------------|---------------|---------------|-----------------------|----------------------|-----------------|-----------------|-------|
| nurswgvml010 | /app             | /dev/sdb1            |      19545904 |      20726928 |              20377284 |             20726928 |          349644 |              14 | 13.33 |
| nurswgvml010 | /                | /dev/sda1            |       5865444 |       6095936 |               5865444 |              6095936 |          230492 |              14 | 13.33 |
| nurswgvml006 | /media/datadrive | /dev/sdb1            |      39338988 |      39503088 |              39338988 |             39497996 |          159008 |              15 |  2.76 |
| nurswgvml501 | /                | /dev/sda1            |       5715952 |       5716612 |               5715952 |              5716612 |             660 |              15 |  6.74 |
| nurswgvml006 | /                | /dev/mapper/vg__root |       5315716 |       5316204 |               5315716 |              5316204 |             488 |              15 |  2.76 |
| nurswgvml502 | /                | /dev/sda1            |      32268516 |      32268904 |              32268516 |             32268904 |             388 |              15 | 11.13 |
| nurswgvml301 | /                | /dev/sda1            |       2867820 |       2867856 |               2867820 |              2867856 |              36 |               4 |  3.26 |
| nurswgvml007 | /                | /dev/sda1            |       9550508 |       9637628 |               9625532 |              9616576 |           -8956 |              14 | 16.32 |
```
