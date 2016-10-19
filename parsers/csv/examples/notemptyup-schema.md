# notEmptyUp

#### Input File

```csv
2015.10.15 00:00:00;    Sensor-0001;        measurements;  model;        PV120000-XG1
                   ;    Sensor-0020;        measurements;  model;        PV120000-XG1
                   ;    Sensor-0300;        measurements;  model;        PV120000-XG1
2015.10.15 00:10:00;    Sensor-0001;        measurements;  model;        PV120000-XG1
```

#### Parser Settings

`Timestamp Pattern:  yyyy.MM.dd HH:mm:ss`      # Used to parse Measurement Time column values
`Delimiter: Semicolon (;)`                         # Non-default delimiter

#### Schema

```javascipt
select('#row=1-*').select('#col=1').
addProperty().
type(cell(row, 3)).
entity(cell(row, 2)).
timestamp(notEmptyUp(row, 1)).
forEach('#col=4-*!2').
tag(cell(row, col), cell(row, col+1));
```

#### Commands

```ls
property e:sensor-0001 d:2015-10-15T00:00:00Z t:measurements t:model=PV120000-XG1
property e:sensor-0020 d:2015-10-15T00:00:00Z t:measurements t:model=PV120000-XG1
property e:sensor-0300 d:2015-10-15T00:00:00Z t:measurements t:model=PV120000-XG1
property e:sensor-0001 d:2015-10-15T00:10:00Z t:measurements t:model=PV120000-XG1
```
