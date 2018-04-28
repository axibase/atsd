# Columnar Schema Example

#### Input File

```txt
          , Sensor-0001, Sensor-0001, Sensor-0001, Sensor-0020, Sensor-0020, Sensor-0020
          ,PV120000-XG1,PV120000-XG1,PV120000-XG1,PV120000-XG1,PV120000-XG1,PV120000-XG1
2015-10-15, Temperature,    Humidity,    Pressure, Temperature,    Humidity,    Pressure
     00:00,        35.5,        40.0,         760,        20.4,        60.8,         745
     00:10,        35.6,        40.8,         750,        20.5,        60.5,         745
```

#### Parser Settings

`Timestamp Pattern: yyyy-MM-dd HH:mm`          # Used to parse timestamp values from 1st column

#### Schema

```javascript
select("#cell=4,2-*,*").
addSeries().
metric(cell(3, col)).
entity(cell(1, col)).
tag('model',cell(2, col)).
timestamp(cell(3, 1) + ' ' + cell(row, 1));
```

Adhere to the following points to convert the input file into a tabular model:
- For each cell in the cell range, starting with the 4th row and until the last row and starting from the 2nd column and until the last column;
- Set the metric name to value of the cell located in the 3rd row in the current column: Temperature, Humidity, Pressure (repeated);
- Set the entity name to the value of the cell located in the 2nd row in the current column;
- Set the tag 'model' to the value of the cell located in 3rd row in the current column;
- Set the timestamp to the value of the cell located in the 3rd row and 1st column (date part 2015-11-15) concatenated with the value of the cell located in the current row in the 1st column (hour part). The concatenated value will be parsed using the 'Timestamp Pattern';
- Set the series value to the value of the current cell.


#### Commands

```ls
series e:sensor-0001 d:2015-11-15T00:00:00Z m:temperature=35.5 m:humidity=40.0 m:pressure=760 t:model=PV120000-XG1
series e:sensor-0020 d:2015-11-15T00:00:00Z m:temperature=20.4 m:humidity=60.8 m:pressure=745 t:model=PV120000-XG1
series e:sensor-0001 d:2015-11-15T00:10:00Z m:temperature=35.6 m:humidity=40.8 m:pressure=750 t:model=PV120000-XG1
series e:sensor-0020 d:2015-11-15T00:10:00Z m:temperature=20.5 m:humidity=60.5 m:pressure=745 t:model=PV120000-XG1
```
