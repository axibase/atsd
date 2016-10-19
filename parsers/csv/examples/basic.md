# Basic Schema Field Example

#### Input File

```csv
Measurement Time,Sensor Name,Sensor Model,Temperature,Humidity,Pressure
2015-10-15 00:00,Sensor-0001,PV120000-XG1,       35.5,    40.0,     760
2015-10-15 00:00,Sensor-0020,PV120000-XG1,       20.4,    60.8,     745
```

#### Parser Settings

`Timestamp Pattern: yyyy-MM-dd HH:mm`          # Used to parse Measurement Time column values

#### Schema

```java
select("#row=2-*").select("#col=4-*").
addSeries().
metric(cell(1, col)).
entity(cell(row, 2)).
tag('model',cell(row, 3)).
timestamp(cell(row, 1));
```

Adhere to the following points to convert the CSV file into a tabular model:
- For each row starting with the 2nd row until the last row;
- For each column in the current row starting with the 4th column (Temperature) until the last column (Pressure);
- For each cell:
  - Set the metric name to the value of the cell located in the first row in the current column: Temperature, Humidity, Pressure;
  - Set the entity name to the value of the cell located in the current row, 2nd column (Sensor Name);
  - Set the tag ‘model’ to the value of cell located in the current row, 3rd column (Sensor Model);
  - Set the timestamp to the value of the cell located in the current row, 1st column (Measurement Time). The text value will be parsed using the ‘Timestamp Pattern’;
  - Set the series value to the value of the current cell.


#### Commands

```ls
series e:sensor-0001 d:2015-11-15T00:00:00Z m:temperature=35.5 m:humidity=40.0 m:pressure=760 t:model=PV120000-XG1
series e:sensor-0020 d:2015-11-15T00:00:00Z m:temperature=20.4 m:humidity=60.8 m:pressure=745 t:model=PV120000-XG1
```
