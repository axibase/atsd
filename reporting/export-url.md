# Export URL Format

##### Curl Command Request:

```
http://server:port/export?settings={"m":"metric","e":"entity","si":"1-WEEK","t":"DATA","f":"CSV"}
```

##### Example Encoded:

```
curl -u axibase:123456AX -o output.csv -v "http://101.101.101.101:8088/export?settings=%7B%22tags%22%3A%5B%7B%22k%22%3A%22command%22%2C%22v%22%3A%22*%22%7D%5D%2C%22m%22%3A%22proc_memory_used%22%2C%22e%22%3A%22awsswgvml001%22%2C%22si%22%3A%223-MINUTE%22%2C%22t%22%3A%22DATA%22%2C%22f%22%3A%22CSV%22%7D"
```

##### Example Parsed:

```
http://server:port/export?settings={"m":"cpu_used","e":"nurswgvml001","si":"1-WEEK","et":"date('2014-11-11 00:00:00')","t":"DATA","f":"CSV","ai":"1-HOUR","a":["P_99"],"i":"LINEAR"}
```

#### JSON Format:

| Field | Description | Example | 
| --- | --- | --- | 
|  <p>m</p>  |  <p>Metric name</p>  |  <p>“m”:”metric”</p>  | 
|  <p>e</p>  |  <p>Entity name</p>  |  <p>“e”:”entity”</p>  | 
|  <p>g</p>  |  <p>Entity group</p>  |  <p>“g”:”group”</p>  | 
|  <p>tags</p>  |  <p>Tags array</p>  |  <p>“tags”:[{“k”:”key1″,”v”:”value11″},{“k”:”key2″,”v”:”value2″}]</p>  | 
|  <p>si</p>  |  <p>Selection Interval</p>  |  <p>“si”:”1-WEEK”</p>  | 
|  <p>et</p>  |  <p>End time</p>  |  <p>“et”:”today”</p>  | 
|  <p>l</p>  |  <p>Limit</p>  |  <p>“l”:1000</p>  | 
|  <p>f</p>  |  <p>Export Format (CSV, HTML)</p>  |  <p>“f”:”CSV”</p>  | 
|  <p>t</p>  |  <p>Export Type (DATA, FORECAST)</p>  |  <p>“t”:”DATA”</p>  | 
|  <p>ai</p>  |  <p>Aggregation Interval</p>  |  <p>“ai”:”1-HOUR”</p>  | 
|  <p>a</p>  |  <p>Aggregation Functions</p>  |  <p>“a”:[“AVG”, “MIN”]</p>  | 
|  <p>i</p>  |  <p>Interpolation (LINEAR, STEP)</p>  |  <p>“i” : “LINEAR”</p>  | 


#### Aggregation Functions:


- AVG
- MIN
- MAX
- SUM
- COUNT
- STANDARD_DEVIATION
- WAVG
- WTAVG
- PERCENTILE_50
- PERCENTILE_75
- PERCENTILE_90
- PERCENTILE_95
- PERCENTILE_99
- PERCENTILE_995
- PERCENTILE_999


#### Interval Time Units:


- SECOND
- MINUTE
- HOUR
- DAY
- WEEK
- MONTH
- QUARTER
- YEAR


#### Interpolation Functions:

Interpolation functions can insert missing intervals in returned aggregated data:

| Function Name | Description | 
| --- | --- | 
|  <p>STEP</p>  |  <p>Missing value equals previous (last) value.</p>  | 
|  <p>LINEAR</p>  |  <p>Missing value is computed using linear interpolation between previous (last) and next available value.</p>  | 
|  <p>NONE</p>  |  <p>Missing values are not inserted.</p>  | 


If the interpolation function is not specified in the request, missing intervals are not created.
