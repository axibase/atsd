# Block-Appended

## Input File

```txt
2015-10-15, Sensor-0001, model, PV120000-XG1, temperature, 35.5, 2015-10-15, Sensor-0020, model, PV120000-XG1, humidity, 40.0
```

## Parser Settings

`Timestamp Pattern:  yyyy-MM-dd`      # Used to parse Measurement Time column values

## Schema

```javascript
select('#row=1-*').select('#col=1-*!6').
addSeries().
metric(cell(row,col+4)).
entity(cell(row,col+1)).
timestamp(cell(row, col)).
value(cell(row, col+5)).
tag(cell(row,col+2),cell(row,col+3));
```

## Commands

```ls
series e:sensor-0001 d:2015-11-15T00:00:00Z m:temperature=35.5  t:model=PV120000-XG1
series e:sensor-0020 d:2015-11-15T00:00:00Z m:humidity=40.0     t:model=PV120000-XG1
```