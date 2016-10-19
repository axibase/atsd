# Uploading CSV Files

### CSV File Upload

```sh
wget --header="Content-type: text/csv" --post-file=file.csv 'http://atsd_server:port/csv?config=${config_name}'
```

### Processing

The CSV parser accepts single CSV files, as well as archives containing multiple CSV files for bulk import. Supported archive formats include zip, tar, tar.gz, and tar.bz2.

Parsing of CSV files occurs asynchronously in the background. The status of each upload task can be controlled on the Admin: CSV Parsers: CSV Tasks page.

#### Request Parameters

| Name | Default | Description | Example | 
| --- | --- | --- | --- | 
|  <p>config*</p>  |  |  <p>CSV parser configuration name from the Admin:CSV Parsers page.</p>  |  <p>?config=KLZCPU</p>  | 
|  <p>encoding</p>  |  <p>UTF8</p>  |  <p>File encoding.</p>  |  <p>?encoding=UTF8</p>  | 
|  <p>rules</p>  |  <p>true</p>  |  <p>Send metrics into the rule engine.</p>  |  <p>?rules=false</p>  | 
|  <p>wait</p>  |  <p>true</p>  |  <p>Enable synchronous processing. Wait until file is parsed to process errors, if any.</p>  |  <p>?wait=false</p>  | 
|  <p>test</p>  |  <p>false</p>  |  <p>Parse and validate data without inserting metrics or processing them in the rule engine. `test=true` triggers `wait=true` and `rules=false`.</p>  |  <p>?test=true</p>  | 
|  <p>time**</p>  |  |  <p>Timestamp applied to records contained in the file.</p>  <p>Parameter value must be URL-encoded.</p>  <p>If the `time=` parameter is specified in the url but is empty, the time is assumed to be current time.</p>  |  <p>?time=2015-01-16T19%3A20%3A30.45%2B01%3A00</p>  | 
|  <p>metric-prefix</p>  |  |  <p>Overwrites metric prefix in parser configuration.</p>  |  <p>?metric-prefix=nmon.</p>  | 
|  <p>default-entity</p>  |  |  <p>Overwrites default entity in parser configuration.</p>  |  <p>?entity-prefix=oracle.</p>  | 
|  <p>timezone</p>  |  |  <p>Overwrites default Timezone in parser configuration.</p>  |  <p>?timezone=UTC</p>  | 


> *required

**time format – yyyy-MM-dd’T’HH:mm:ss’Z’
e.g. 2015-01-16T19:20:30.45+01:00
