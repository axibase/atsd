# Properties

## Input File

```txt
2015.10.15 00:00:00;    Sensor-0001;        measurements;  model; PV120000-XG1
2015.10.15 00:10:00;    Sensor-0002;        measurements;  model; PV120000-XG1
```

## Parser Settings

`Timestamp Pattern:  dd.MM.yyyy HH:mm`      # Used to parse Measurement Time column values

`Delimiter: semi-colon (;)`      # Non-default delimiter

## Schema

```javascript
select('#row=1-*').select('#col=1').
addProperty().
type(cell(row,3)).
entity(cell(row,2)).
timestamp(cell(row,1)).
forEach('#col=4-*!2').
tag(cell(row,col),cell(row,col+1));
```

## Commands

```ls
property e:sensor-0001 d:2015-10-15T00:00:00Z t:measurements t:model=PV120000-XG1
property e:sensor-0002 d:2015-10-15T00:10:00Z t:measurements t:model=PV120000-XG1
```