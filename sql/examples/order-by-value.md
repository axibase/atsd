# ORDER By Value

## Query

```sql
SELECT entity, avg(value)
 FROM "mpstat.cpu_busy"
WHERE datetime >= now - 1 * HOUR
 GROUP BY entity
ORDER BY avg(value) DESC
```

## Results

```ls
| entity       | avg(value) |
|--------------|------------|
| nurswgvml006 | 19         |
| nurswgvml007 | 16         |
| nurswgvml010 | 16         |
| nurswgvml009 | 15         |
| nurswgvml011 | 6          |
| nurswgvml502 | 6          |
| nurswgvml102 | 1          |
```
