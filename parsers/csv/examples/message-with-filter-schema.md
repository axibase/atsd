# Messages with Filter

## Input File

```txt
2015-10-15;    Sensor-0001;     "temperature changed";      type;   application
2015-10-16;    Sensor-0002;        "humidity changed";      type;   application;    source; cron;   model; PV120000-XG1
```

## Parser Settings

`Timestamp Pattern:  yyyy-MM-dd`      # Used to parse Measurement Time column values

`Text Qualifier: Double Quote (")`      # Used to identify text

## Schema

```javascript
select('#row=1-*').select('#col=1').filter(columnCount>5).
addMessage().
entity(cell(row, 2)).
timestamp(cell(row,1)).
messageText(cell(row, 3)).
forEach('#col=4-*!2').
tag(value,cell(row, col + 1));
```

## Commands

```ls
message e:sensor-0002 d:2015-10-16T00:00:00Z t:type=application t:source=cron t:model=PV120000-XG1 m:"humidity changed"
```