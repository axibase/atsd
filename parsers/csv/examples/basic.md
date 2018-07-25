# Basic Schema Field

## Example File

```csv
Measurement Time,Sensor Name,Sensor Model,Temperature,Humidity,Pressure
2015-10-15 00:00,Sensor-0001,PV120000-XG1,       35.5,    40.0,     760
2015-10-15 00:00,Sensor-0020,PV120000-XG1,       20.4,    60.8,     745
```

## Parser Settings

### Timestamp Pattern

Define the pattern with which to read `Measurement Time` column values.

`Timestamp Pattern: yyyy-MM-dd HH:mm`

### Schema

```java
# select parameters
select("#row=2-*").select("#col=4-*").
addSeries().

# series parameters
metric(cell(1, col)).
entity(cell(row, 2)).
tag('model',cell(row, 3)).
timestamp(cell(row, 1));
```

The above schema converts the CSV file into a tabular model. A row-by-row explanation of the schema is provided below:

**`select` Parameters**:

* `select` each row starting with the second row until the last row `"#row=2-*"`.
* `select` each column in the second row starting with the forth column until the last column `"#col=4-*"`.

**`series` Parameters**

> `cell` selection is defined by the pattern `(row,col)`

* `metric` name is located in each selected column of the first row: `Temperature`, `Humidity`, `Pressure`.
  * `(1,col)`
* `entity` name is located in each selected row of the second column: `Sensor-0001`, `Sensor-0020`.
  * `(row,2)`
* `tag` value is located in each selected row of the third column: `PV120000-XG1`. `tag` name is defined by the first argument: `model`
  * `(row, 3)`
* Timestamp is located in each selected row of the first column: `Measurement Time`. The text value is parsed using the [**Timestamp Pattern**](#timestamp-pattern).

## Commands

The series commands produced by the above schema and inserted in the database are shown below.

```ls
series e:sensor-0001 d:2015-11-15T00:00:00Z m:temperature=35.5 m:humidity=40.0 m:pressure=760 t:model=PV120000-XG1
series e:sensor-0020 d:2015-11-15T00:00:00Z m:temperature=20.4 m:humidity=60.8 m:pressure=745 t:model=PV120000-XG1
```
