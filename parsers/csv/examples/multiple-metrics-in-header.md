# Multiple Metrics in Header

## Input File

<!-- markdownlint-disable MD107 -->

```txt
          rundate,  this_period,    last_period,                 group_name,           model,     sensor_name,  temperature,  humidity,    pressure,  precipitation
10-Nov-2014 09:00,       201410,         201310,    Other Reporting Sensors,    PV120000-XG1,     Sensor-0001,         35.5,      40.0,         760,             80
17-Nov-2015 09:00,       201510,         201410,    Other Reporting Sensors,    PV120000-XG1,     Sensor-0001,         20.4,      60.8,         745,             77
```

<!-- markdownlint-enable MD107 -->

## Parser Settings

`Timestamp Pattern:  yyyyMM`      # Used to parse Measurement Time column values

## Schema

```javascript
select('#row=2-*').select('#col=7-*').
addSeries().
metric(cell(1,col)).
entity(cell(row,6)).
timestamp(cell(row, 2)).
tag(cell(1,5), cell(row,5));
```

## Commands

```ls
series e:sensor-0001 d:2014-10-01T00:00:00Z m:temperature=35.5 m:humidity=40.0 m:pressure=760 m:precipitation=80 t:model=PV120000-XG1
series e:sensor-0001 d:2015-10-01T00:00:00Z m:temperature=20.4 m:humidity=60.8 m:pressure=745 m:precipitation=77 t:model=PV120000-XG1
```