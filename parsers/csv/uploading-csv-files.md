# Uploading CSV Files

## CSV File Upload

```sh
wget --header="Content-type: text/csv" --post-file=file.csv 'http://atsd_hostname:port/csv?config=${config_name}'
```

### Processing

The CSV parser accepts single CSV files, as well as archives containing multiple CSV files for bulk import. Supported archive formats include `.zip`, `.tar`, `.tar.gz`, and `.tar.bz2`.

Parsing of CSV files occurs asynchronously in the background. The status of each upload task can be controlled on the **Data > CSV Parsers > CSV Tasks** page.

#### Request Parameters

| Name | Default | Description | Example |
| --- | --- | --- | --- |
|  `config`  |  |  [**Required**] CSV parser configuration name from the **Data > CSV Parsers** page.  |  `?config=KLZCPU`  |
|  `encoding`  |  UTF8  |  File encoding.  |  `?encoding=UTF8`  |
|  `rules`  |  `true`  |  Send metrics into the rule engine.  |  `?rules=false`  |
|  `wait`  |  `true`  |  Enable synchronous processing. Wait until file is parsed to process errors, if any.  |  `?wait=false`  |
|  `test`  |  `false`  |  Parse and validate data without inserting metrics or processing them in the rule engine. `test=true` triggers `wait=true` and `rules=false`.  |  `?test=true`  |
|  `time`  |  |  Timestamp applied to records contained in the file.<br>Parameter value must be URL-encoded.<br>time format – `yyyy-MM-dd’T’HH:mm:ss’Z’`<br>If the `time` parameter is specified in the URL but is empty, the time is assumed to be current time.  |  `?time=2015-01-16T19%3A20%3A30.45%2B01%3A00`  |
|  `metric-prefix`  |  |  Overwrites metric prefix in parser configuration.  |  `?metric-prefix=nmon`.  |
|  `default-entity`  |  |  Overwrites default entity in parser configuration.  |  `?entity-prefix=oracle.`  |
|  `timezone`  |  |  Overwrites default time zone in parser configuration.  |  `?timezone=UTC`  |