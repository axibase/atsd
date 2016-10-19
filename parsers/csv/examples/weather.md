# Weather CSV Example

#### Original CSV File:

```
"Station Name","HALIFAX INTL A"
"Province","NOVA SCOTIA"
"Latitude","44.88"
"Longitude","-63.51"
"Elevation","145.40"
"Climate Identifier","8202251"
"WMO Identifier","71395"
"TC Identifier","YHZ"
 
"Legend"
"A","Accumulated"
"C","Precipitation occurred, amount uncertain"
"E","Estimated"
"F","Accumulated and estimated"
"L","Precipitation may or may not have occurred"
"M","Missing"
"N","Temperature missing but known to be > 0"
"S","More than one occurrence"
"T","Trace"
"Y","Temperature missing but known to be < 0"
"[empty]","No data available"
"^","The value displayed is based on incomplete data"
"†","Data for this day has undergone only preliminary quality checking"
"‡","Partner data that is not subject to review by the National Climate Archives"
 
"Date/Time","Year","Month","Day","Data Quality","Max Temp (°C)","Max Temp Flag","Min Temp (°C)","Min Temp Flag","Mean Temp (°C)","Mean Temp Flag","Heat Deg Days (°C)","Heat Deg Days Flag","Cool Deg Days (°C)","Cool Deg Days Flag","Total Rain (mm)","Total Rain Flag","Total Snow (cm)","Total Snow Flag","Total Precip (mm)","Total Precip Flag","Snow on Grnd (cm)","Snow on Grnd Flag","Dir of Max Gust (10s deg)","Dir of Max Gust Flag","Spd of Max Gust (km/h)","Spd of Max Gust Flag"
"2015-01-01","2015","01","01","‡","-2.2","","-14.9","","-8.6","","26.6","","0.0","","0.0","","1.6","","1.6","","0","","","M","<31",""
"2015-01-02","2015","01","02","‡","1.3","","-10.2","","-4.5","","22.5","","0.0","","0.0","","0.4","","0.4","","1","","","M","70",""
"2015-01-03","2015","01","03","‡","-10.0","","-14.8","","-12.4","","30.4","","0.0","","0.0","","0.0","T","0.0","T","1","","","M","54",""
"2015-01-04","2015","01","04","‡","8.1","","-13.4","","-2.7","","20.7","","0.0","","8.2","","12.8","","21.0","","8","","","M","70",""
"2015-01-05","2015","01","05","‡","8.2","","-12.7","","-2.3","","20.3","","0.0","","6.6","","0.0","T","6.6","","1","","","M","91",""
"2015-01-06","2015","01","06","‡","-12.6","","-16.2","","-14.4","","32.4","","0.0","","0.0","","1.6","","1.6","","0","","","M","67",""
"2015-01-07","2015","01","07","‡","-11.6","","-19.4","","-15.5","","33.5","","0.0","","0.0","","0.8","","0.8","","0","","","M","<31",""
"2015-01-08","2015","01","08","‡","-13.1","","-17.9","","-15.5","","33.5","","0.0","","0.0","","0.0","T","0.0","T","0","","","M","43",""
"2015-01-09","2015","01","09","‡","3.6","","-16.8","","-6.6","","24.6","","0.0","","3.2","","2.6","","5.8","","0","","","M","70",""
"2015-01-10","2015","01","10","‡","-5.3","","-10.6","","-8.0","","26.0","","0.0","","0.0","","0.6","","0.6","","2","","","M","43",""
"2015-01-11","2015","01","11","‡","-4.2","","-10.6","","-7.4","","25.4","","0.0","","0.0","","0.0","T","0.0","T","2","","","M","35",""
"2015-01-12","2015","01","12","‡","3.9","","-4.2","","-0.2","","18.2","","0.0","","2.4","","6.0","","8.4","","2","","","M","44",""
"2015-01-13","2015","01","13","‡","-3.0","","-17.3","","-10.2","","28.2","","0.0","","0.0","","2.6","","2.6","","8","","","M","57",""
"2015-01-14","2015","01","14","‡","-6.0","","-18.1","","-12.1","","30.1","","0.0","","0.0","","0.0","T","0.0","T","8","","","M","<31",""
"2015-01-15","2015","01","15","‡","-2.2","","-12.1","","-7.2","","25.2","","0.0","","0.0","","0.0","T","0.0","T","7","","","M","<31",""
"2015-01-16","2015","01","16","‡","2.1","","-11.7","","-4.8","","22.8","","0.0","","1.0","","3.0","","4.0","","9","","","M","59",""
"2015-01-17","2015","01","17","‡","-11.7","","-16.8","","-14.3","","32.3","","0.0","","0.0","","4.8","","4.8","","10","","","M","63",""
"2015-01-18","2015","01","18","‡","5.4","","-16.9","","-5.8","","23.8","","0.0","","0.0","","0.0","","0.0","","10","","","M","56",""
"2015-01-19","2015","01","19","‡","7.5","","1.0","","4.3","","13.7","","0.0","","24.8","","0.0","","24.8","","4","","","M","93",""
"2015-01-20","2015","01","20","‡","2.4","","-7.9","","-2.8","","20.8","","0.0","","0.0","","0.0","T","0.0","T","","","","M","65",""
"2015-01-21","2015","01","21","‡","-6.4","","-12.1","","-9.3","","27.3","","0.0","","0.0","","0.0","T","0.0","T","","","","M","48",""
"2015-01-22","2015","01","22","‡","-5.0","","-13.1","","-9.1","","27.1","","0.0","","0.0","","1.0","","1.0","","1","","","M","50",""
"2015-01-23","2015","01","23","‡","-3.5","","-7.3","","-5.4","","23.4","","0.0","","0.0","","0.0","T","0.0","T","1","","","M","48",""
"2015-01-24","2015","01","24","‡","9.8","","-3.5","","3.2","","14.8","","0.0","","35.0","","2.4","","37.4","","0","","","M","78",""
"2015-01-25","2015","01","25","‡","8.6","","-9.9","","-0.7","","18.7","","0.0","","0.0","","0.0","T","0.0","T","","","","M","70",""
"2015-01-26","2015","01","26","‡","-6.7","","-11.9","","-9.3","","27.3","","0.0","","0.0","","0.0","","0.0","","","","","M","50",""
"2015-01-27","2015","01","27","‡","-3.4","","-10.5","","-7.0","","25.0","","0.0","","1.0","","13.0","","14.0","","2","","","M","72",""
"2015-01-28","2015","01","28","‡","1.3","","-10.4","","-4.6","","22.6","","0.0","","0.0","","6.0","","6.0","","13","","","M","54",""
"2015-01-29","2015","01","29","‡","-4.8","","-12.3","","-8.6","","26.6","","0.0","","0.0","","0.0","","0.0","","17","","","M","32",""
"2015-01-30","2015","01","30","‡","-2.8","","-9.6","","-6.2","","24.2","","0.0","","0.0","","0.0","T","0.0","T","16","","","M","32",""
"2015-01-31","2015","01","31","‡","0.9","","-5.6","","-2.4","","20.4","","0.0","","","M","","M","","M","4","","","M","<31",""
```

#### Parser Configuration Screenshot:

![](resources/csv_halifax_config.png)

#### Parser Configuration Description:

| Field | Setting | Reason | 
| --- | --- | --- | 
|  <p>Enabled</p>  |  <p>Set to true</p>  |  <p>Enable parsing of CSV files using this.</p>  <p>Also allows use of this parser configuration in Axibase Collector.</p>  | 
|  <p>Name</p>  |  <p>Unique name – Halifax Weather.</p>  |  <p>Unique name to distinguish this parser from others.</p>  <p>Useful when working with Axibase Collector, as parser configurations are referred to by their unique name.</p>  | 
|  <p>Put Type</p>  |  <p>Metric</p>  |  <p>The CSV file in question contains time series (metrics) weather data.</p>  | 
|  <p>Delimiter</p>  |  <p>Comma</p>  |  <p>A comma is used to separate columns.</p>  | 
|  <p>Default Entity</p>  |  <p>Unique entity name – Halifax</p>  |  <p>All data will be written to this unique entity, making it easy to distinguish from others.</p>  | 
|  <p>Metric Prefix</p>  |  <p>Unique entity prefix- halifax</p>  |  <p>Prefix added at the start of metric name, used to distinguish between metrics with similar or identical names.</p>  | 
|  <p>Timestamp Columns</p>  |  <p>Date</p>  |  <p>The `Date` column contains the timestamp.</p>  | 
|  <p>Timestamp Pattern</p>  |  <p>`yyyy-MM-dd`</p>  |  <p>Timestamp Pattern must correspond to the original timestamp in the CSV file: `2015-01-01`.</p>  | 
|  <p>Filter</p>  |  <p>`timestamp > 0`</p>  |  <p>Only import data that has a timestamp greater than 0 in epoch milliseconds.</p>  <p>Timestamps earlier than `1970-01-01T00:00:00Z` will not be imported.</p>  | 
|  <p>Ignored Columns</p>  |  <p>`Year`</p>  <p>`Month`</p>  <p>`Day`</p>  <p>`Data Quality`</p>  <p>`Max Temp Flag`</p>  <p>`Min Temp Flag`</p>  <p>`Mean Temp Flag`</p>  <p>`Heat Deg Days Flag`</p>  <p>`Cool Deg Days Flag`</p>  <p>`Total Rain Flag`</p>  <p>`Total Snow Flag`</p>  <p>`Total Precip Flag`</p>  <p>`Snow on Grnd Flag`</p>  <p>`Dir of Max Gust (10s deg)`</p>  <p>`Dir of Max Gust Flag`</p>  <p>`Spd of Max Gust (kmh)`</p>  <p>`Spd of Max Gust Flag`</p>  |  <p>Columns that will not be imported.</p>  <p>Year, Month, Day are irrelevant because Date column is imported as the timestamp.</p>  <p>Other listed columns do not contain valuable data or often contain empty values, so its best to discard them.</p>  | 
