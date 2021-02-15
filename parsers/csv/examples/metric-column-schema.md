# Metric Column

## Input File

```txt
Measurement Time,   Sensor Name,     Measurement,   Value
2015-10-15 00:00,   Sensor-0001,     Temperature,    35.5
2015-10-15 00:00,   Sensor-0001,        Humidity,    40.0
```

## Parser Settings

`Timestamp Pattern:  yyyy-MM-dd HH:mm`      # Used to parse Measurement Time column values

## Schema

```javascript
select("#row=2-*").select("#col=4").
addSeries().
metric(cell(row,3)).
entity(cell(row,2)).
timestamp(cell(row, 1));
```

## Commands

```ls
series e:sensor-0001 d:2015-11-15T00:00:00Z m:temperature=35.5
series e:sensor-0001 d:2015-11-15T00:00:00Z    m:humidity=40.0
```