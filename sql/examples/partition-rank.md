# Partition - Rank

## Overview

* Row numbers are unique for each partition
* Rank is the same for rows with the same values in ordered columns. In this case, rank is assigned based on `round(value)` result. Rank contains gaps and is not consecutive.
* Dense rank is the same for rows with the same values in ordered columns. Dense rank is assigned based on `round(value)` result. Dense rank is continuously incrementing and has no gaps.

### Query

```sql
SELECT entity, round(value), row_number(), rank(), dense_rank()
  FROM "mpstat.cpu_busy"
  WHERE entity IN ('nurswgvml010', 'nurswgvml007')
  AND datetime >= CURRENT_HOUR
  WITH ROW_NUMBER(entity ORDER BY round(value) DESC) <= 6
ORDER BY entity, round(value) DESC
```

### Results

```ls
| entity        | round(value)  | row_number()  | rank()  | dense_rank() |
|---------------|---------------|---------------|---------|--------------|
| nurswgvml007  | 23            | 1             | 1       | 1            | Partition for entity nurswgvml007
| nurswgvml007  | 23            | 2             | 1       | 1            |  Partition for entity nurswgvml007
| nurswgvml007  | 22            | 3             | 3       | 2            |   Partition for entity nurswgvml007
| nurswgvml007  | 22            | 4             | 3       | 2            |    Partition for entity nurswgvml007
| nurswgvml007  | 22            | 5             | 3       | 2            |     Partition for entity nurswgvml007
| nurswgvml007  | 21            | 6             | 6       | 3            |      Partition for entity nurswgvml007
...
| nurswgvml010  | 25            | 1             | 1       | 1            | Partition for entity nurswgvml010
| nurswgvml010  | 25            | 2             | 1       | 1            |  Partition for entity nurswgvml010
| nurswgvml010  | 25            | 3             | 1       | 1            |   Partition for entity nurswgvml010
| nurswgvml010  | 23            | 4             | 4       | 2            |    Partition for entity nurswgvml010
| nurswgvml010  | 18            | 5             | 5       | 3            |     Partition for entity nurswgvml010
| nurswgvml010  | 14            | 6             | 6       | 4            |       Partition for entity nurswgvml010
```