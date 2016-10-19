# notEmptyLeft

#### Input File

```csv
Date;        Sensor Name;   Measurement;    10:00;  10:15;  10:30;   10:45
2015-10-15;  Sensor-0001;   temperature;     35.5;   20.4;   35.6;    20.5
2015-10-15;  Sensor-0020;      humidity;     40.0;   60.8;       ;
```

#### Parser Settings

`Timestamp Pattern:  yyyy-MM-ddHH:mm`      # Used to parse Measurement Time column values
`Delimiter: Semicolon (;)`                     # Non-default delimiter

#### Schema

```javascript
select('#row=2-*').select('#col=4-*').
addSeries().
metric(cell(row, 3)).
entity(cell(row, 2)).
timestamp(cell(row, 1) + cell(1, col)).
value(notEmptyLeft(row, col));
```

#### Commands

```ls
series e:sensor-0001 d:2015-10-15T10:00:00Z m:temperature=35.5
series e:sensor-0001 d:2015-10-15T10:15:00Z m:temperature=20.4
series e:sensor-0001 d:2015-10-15T10:30:00Z m:temperature=35.6
series e:sensor-0001 d:2015-10-15T10:45:00Z m:temperature=20.5
series e:sensor-0020 d:2015-10-15T10:00:00Z m:humidity=40.0
series e:sensor-0020 d:2015-10-15T10:15:00Z m:humidity=60.8
series e:sensor-0020 d:2015-10-15T10:30:00Z m:humidity=60.8
series e:sensor-0020 d:2015-10-15T10:45:00Z m:humidity=60.8
```
