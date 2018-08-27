# Messages

## Input File

```csv
2015-10-15 00:00;    Sensor-0001;      type;   application;    source; cron;   model;        PV120000-XG1;     temperature changed
2015-10-15 00:10;    Sensor-0001;      type;   application;    source; cron;   model;        PV120000-XG1;        humidity changed
```

## Parser Settings

`Timestamp Pattern:  dd.MM.yyyy HH:mm`      # Used to parse Measurement Time column values

`Delimiter: semi-colon (;)`      # Non-default delimiter

## Schema

```javascript
select('#row=1-*').select('#col=1').
addMessage().
entity(cell(row, 2)).
timestamp(cell(row,1)).
messageText(cell(row, columnCount)).
forEach('#col=3-8!2').
tag(value,cell(row, col + 1));
```

## Commands

```ls
message e:sensor-0001 d:2015-10-15T00:00:00Z t:type=application t:source=cron t:model=PV120000-XG1 m:"temperature changed"
message e:sensor-0001 d:2015-10-15T00:10:00Z t:type=application t:source=cron t:model=PV120000-XG1 m:"humidity changed"
```
