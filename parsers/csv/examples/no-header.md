# No Header

#### Input File

```csv
2015.10.15 00:00;   PV120000-XG1;   35.5;   40.0
2015.10.15 00:10;   PV120000-XG1;   35.6;   40.8
```

#### Parser Settings

`Timestamp Pattern: yyyy.MM.dd HH:mm`      # Used to parse Measurement Time column values
`Delimiter: Semicolon (;)`                     # Non-default delimiter

#### Schema

```javascrit
var metrics = ['temperature', 'humidity'];
select("#row=1-*").select("#col=3-4").
addSeries().
metric(metrics[col-3]).
entity('Sensor-0001').
timestamp(cell(row, 1)).
tag('model', cell(row, 2));
```

#### Commands

```ls
series e:sensor-0001 d:2015-10-15T00:00:00Z m:temperature=35.5 m:humidity=40.0 t:model=PV120000-XG1
series e:sensor-0001 d:2015-10-15T00:10:00Z m:temperature=35.6 m:humidity=40.8 t:model=PV120000-XG1
```
