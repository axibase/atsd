# Select: Escape Quotes in Column Names

Inner double quotes contained in column names and aliases can be escaped by repeating the quotes:

* double"quote -> "double""quote"

## Data

```ls
series e:e-eq-1 m:m-eq-1=12.4 t:"double""quote"=tv1 t:single'quote=tv2 t:"both'quo""tes"=tv3
```

```json
[{
    "entity": "e-eq-1",
    "metric": "m-eq-1",
    "tags": {    
      "double\"quote": "tv1",
      "single'quote":  "tv2",
	  "both'quo\"tes": "tv3"
    },
    "data": [ { "d": "2016-07-27T22:41:50.407Z", "v": 12.4 } ]
}]
```

## Query

```sql
SELECT tags.* 
  FROM "m-eq-1"
WHERE datetime > '2016-07-27T22:40:00.000Z' 
```

```ls
| tags.both'quo"tes | tags.double"quote | tags.single'quote | 
|-------------------|-------------------|-------------------| 
| tv3               | tv1               | tv2               | 

```

## Query with Escaped Column Names

```sql
SELECT tags."double""quote",
       tags."single'quote",
       tags."both'quo""tes"
  FROM "m-eq-1"
WHERE datetime > '2016-07-27T22:40:00.000Z' 
```

```ls
| tags.double"quote | tags.single'quote | tags.both'quo"tes | 
|-------------------|-------------------|-------------------| 
| tv1               | tv2               | tv3               | 
```

## Query with Escaped Column Names in `WHERE` and `ORDER BY` Clauses

```sql
SELECT tags."double""quote",
       tags."single'quote",
       tags."both'quo""tes"
  FROM "m-eq-1"
WHERE tags."double""quote" = 'tv1'  
  AND tags."both'quo""tes" IS NOT NULL
  AND tags."single'quote" LIKE '%2'
ORDER BY tags."single'quote"
```

```ls
| tags.double"quote | tags.single'quote | tags.both'quo"tes | 
|-------------------|-------------------|-------------------| 
| tv1               | tv2               | tv3               | 
```
