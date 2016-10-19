# Columnar Period Schema Example

#### Input File

```csv
2015-10-15, Sensor-0001,      Status, Sensor-0020,      Status
     00:00,        35.5,      provis,        20.4,          ok
     00:10,        35.6,          ok,        20.5,          ok
```

#### Parser Settings

`Timestamp Pattern: yyyy-MM-dd HH:mm`          # Used to parse timestamp values from 1st column

#### Schema

```javascript
select("#cell=2,2-*,*!1,2").
addSeries().
metric('temperature').
entity(cell(1, col)).
tag('status',cell(row, col+1)).
timestamp(cell(1, 1) + ' ' + cell(row, 1));
```

Adhere to the following points to convert the CSV file into a tabular model:
- For each cell in the cell range, starting with the 4th row and until the last row, and starting from the 2nd column and until the last column, iterating over EVEN columns (2 + step 2);
- Set the metric name to a constant (temperature);
- Set the entity name to the value of the cell located in the 2nd row in the current column;
- Set the tag ‘status’ to the value of the cell located in the current row to the right of the current column (column + 1);
- Set the timestamp to the value of the cell located in the 3rd row and 1st column (date part 2015-11-15) concatenated with the value of the cell located in the current row in the 1st column (hour part). The concatenated value will be parsed using the ‘Timestamp Pattern’;
- Set the series value to the value of the current cell.


#### Commands

```ls
series e:sensor-0001 d:2015-11-15T00:00:00Z m:temperature=35.5 t:status=provis
series e:sensor-0020 d:2015-11-15T00:00:00Z m:temperature=20.4 t:status=ok
series e:sensor-0001 d:2015-11-15T00:10:00Z m:temperature=35.6 t:status=ok
series e:sensor-0020 d:2015-11-15T00:10:00Z m:temperature=20.5 t:status=ok
```
