# Versioned Series

## Input File

```txt
"Station Name","HALIFAX INTL A"
"Province","NOVA SCOTIA"
      Date,   Temperature, "Temperature Flag",    Humidity, "Humidity Flag",  Pressure, "Pressure Flag"
2015-10-15,          32.5,                  1,        60.0,               1,        -1,               0
```

## Parser Settings

`Timestamp Pattern:  yyyy-MM-dd`      # Used to parse Measurement Time column values

## Schema

```javascript
select('#row=4-*').select('#col=2-*!2').
addSeries().
metric(cell(3, col)).
entity('nova_scotia').
timestamp(cell(row, 1)).
tag('$version_status', cell(row, col+1));
```

## Commands

```ls
series e:nova_scotia d:2015-10-15T00:00:00Z m:temperature=32.5 t:$version_status=1
series e:nova_scotia d:2015-10-15T00:00:00Z m:humidity=60.0 t:$version_status=1
series e:nova_scotia d:2015-10-15T00:00:00Z m:pressure=-1 t:$version_status=0
```