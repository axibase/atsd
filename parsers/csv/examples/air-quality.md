# Air Quality CSV Example

#### Original CSV File:

```
"36.785378","-119.773206","2015-07-09T00:00","CO","0.12","PPM"
"36.785378","-119.773206","2015-07-09T00:00","NO2","2.0","PPB"
"36.785378","-119.773206","2015-07-09T00:00","OZONE","48.0","PPB"
"36.785378","-119.773206","2015-07-09T00:00","PM10","37.0","UG/M3"
"36.785378","-119.773206","2015-07-09T00:00","PM2.5","7.5","UG/M3"
"36.785378","-119.773206","2015-07-09T00:00","SO2","1.0","PPB"
"36.785378","-119.773206","2015-07-09T01:00","CO","0.12","PPM"
"36.785378","-119.773206","2015-07-09T01:00","NO2","2.0","PPB"
"36.785378","-119.773206","2015-07-09T01:00","OZONE","46.0","PPB"
"36.785378","-119.773206","2015-07-09T01:00","PM10","37.0","UG/M3"
"36.785378","-119.773206","2015-07-09T01:00","PM2.5","7.4","UG/M3"
"36.785378","-119.773206","2015-07-09T01:00","SO2","1.0","PPB"
"36.785378","-119.773206","2015-07-09T02:00","CO","0.12","PPM"
"36.785378","-119.773206","2015-07-09T02:00","NO2","3.0","PPB"
"36.785378","-119.773206","2015-07-09T02:00","OZONE","44.0","PPB"
"36.785378","-119.773206","2015-07-09T02:00","PM10","37.0","UG/M3"
"36.785378","-119.773206","2015-07-09T02:00","PM2.5","7.3","UG/M3"
"36.785378","-119.773206","2015-07-09T02:00","SO2","1.0","PPB"
"36.785378","-119.773206","2015-07-09T03:00","CO","0.14","PPM"
"36.785378","-119.773206","2015-07-09T03:00","NO2","4.0","PPB"
"36.785378","-119.773206","2015-07-09T03:00","OZONE","41.0","PPB"
"36.785378","-119.773206","2015-07-09T03:00","PM10","37.0","UG/M3"
"36.785378","-119.773206","2015-07-09T03:00","PM2.5","7.1","UG/M3"
"36.785378","-119.773206","2015-07-09T03:00","SO2","1.0","PPB"
"36.785378","-119.773206","2015-07-09T04:00","CO","0.13","PPM"
"36.785378","-119.773206","2015-07-09T04:00","NO2","3.0","PPB"
"36.785378","-119.773206","2015-07-09T04:00","OZONE","37.0","PPB"
"36.785378","-119.773206","2015-07-09T04:00","PM10","36.0","UG/M3"
"36.785378","-119.773206","2015-07-09T04:00","PM2.5","7.0","UG/M3"
"36.785378","-119.773206","2015-07-09T04:00","SO2","0.0","PPB"
```

#### Parser Configuration Screenshot:

![](resources/air_quality_csv_parser.png)

#### Parser Configuration Description

| Field | Setting | Reason | 
| --- | --- | --- | 
|  <p>Enabled</p>  |  <p>Set to true</p>  |  <p>Enables parsing of CSV files.</p>  <p>Use of this parser configuration is allowed in Axibase Collector.</p>  | 
|  <p>Name</p>  |  <p>Unique name – airnow-fresno</p>  |  <p>Unique name to distinguish a particular parser from others.</p>  <p>Useful when working with Axibase Collector, as parser configurations are referred to by their unique name.</p>  | 
|  <p>Put Type</p>  |  <p>Metric</p>  |  <p>The CSV file in question contains time series (metrics) environmental data.</p>  | 
|  <p>Delimiter</p>  |  <p>Comma</p>  |  <p>A comma is used to separate columns.</p>  | 
|  <p>Default Entity</p>  |  <p>Unique entity name – `060190011`</p>  |  <p>No entity name is present in the CSV file; it is assigned manually to the ID of the monitoring station.</p>  <p>All data will be written to this unique entity, making it easy to distinguish from others.</p>  | 
|  <p>Metric Name Column</p>  |  <p>Parameter</p>  |  <p>Parameter column contains all metric names: CO, NO2, OZONE, PM10, PM2.5, SO2.</p>  | 
|  <p>Metric Value Column</p>  |  <p>Concentration</p>  |  <p>Concentration column contains the values for the above metrics.</p>  <p>Note that values for all metrics are contained in a single column.</p>  | 
|  <p>Timestamp Column</p>  |  <p>Time</p>  |  <p>Time column contains the timestamp, which will be used to import the time series.</p>  | 
|  <p>Timestamp Pattern</p>  |  <p>`yyyy-MM-dd'T'HH:mm`</p>  |  <p>Pattern matching the one contained in the original CSV file: `2015-07-09T00:00`.</p>  | 
|  <p>Filter</p>  |  <p>`number('Concentration') >= 0`</p>  |  <p>Used to import data points that contain actual values that are greater than 0 (not empty).</p>  | 
|  <p>Ignored Columns</p>  |  <p>`Latitude`</p>  <p>`Longitude`</p>  <p>`Unit`</p>  |  <p>Columns that will be not be imported.</p>  <p>For example: Latitude, Longitude, and Unit do not add any value to the time series.</p>  <p>Can be added as metric tags using the API or user interface.</p>  | 
|  <p>Header</p>  |  <p>`"Latitude"`</p>  <p>`"Longitude"`</p>  <p>`"Time"`</p>  <p>`"Parameter"`</p>  <p>`"Concentration"`</p>  <p>`"Unit"`</p>  |  <p>Since the source CSV file does not have column headers, they are assigned and then referenced in the configuration.</p>  | 
