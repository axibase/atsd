# Series with Tags

## Input File

```txt
Sensor Name,          Address,     City,  State,    Zip, Status,        model,        Date,    Temperature,    Humidity
Sensor-0001,  3109 N BROADWAY,  CHICAGO,     IL,  60657,     Ok, PV120000-XG1,  10/15/2015,           35.5,        40.0
Sensor-0020,  3109 N BROADWAY,  CHICAGO,     IL,  60657,     Ok, PV120000-XG1,  10/15/2015,           20.4,        60.8
```

## Parser Settings

`Timestamp Pattern:  MM/dd/yyyy`      # Used to parse Measurement Time column values

`Text Qualifier: Double Quote (")`      # Used to identify text

## Schema

```javascript
select('#row=2-*').select('#col=9-*').
addSeries().
metric(cell(1, col)).
entity(cell(row, 1)).
timestamp(cell(row, 8)).
forEach('#col=2-7').
tag(cell(1, col), cell(row, col));
```

## Commands

```ls
series e:sensor-0001 d:2015-10-15T00:00:00Z m:temperature=35.5 m:humidity=40.0 t:model=PV120000-XG1 t:address="3109 N BROADWAY" t:city=CHICAGO t:state=IL t:status=Ok t:zip=60657
series e:sensor-0020 d:2015-10-15T00:00:00Z m:temperature=20.4 m:humidity=60.8 t:model=PV120000-XG1 t:address="3109 N BROADWAY" t:city=CHICAGO t:state=IL t:status=Ok t:zip=60657
```