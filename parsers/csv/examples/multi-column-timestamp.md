# Multi-Column Timestamp

## Input File

```txt
2015,10,15, 2015.83,    35.5,   40.0,   760
2015,10,16, 2015.83,    20.4,   60.8,   745
```

## Parser Settings

`Timestamp Pattern:  yyyy-MM-dd`      # Used to parse Measurement Time column values

## Schema

```javascript
var metrics = ['temperature', 'humidity', 'pressure'];
select('#row=1-*').select('#col=5-7').
addSeries().
metric(metrics[col-5]).
entity('Sensor-0001').
timestamp(cell(row, 1) + "-" + cell(row,2) + "-" + cell(row,3));
```

## Commands

```ls
series e:sensor-0001 d:2015-10-15T00:00:00Z m:temperature=35.5 m:humidity=40.0 m:pressure=760
series e:sensor-0001 d:2015-10-16T00:00:00Z m:temperature=20.4 m:humidity=60.8 m:pressure=745
```