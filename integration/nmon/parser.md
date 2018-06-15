# Parser

The nmon parser processes nmon files and converts them into time-series data and configuration properties.

## Parser Settings

| Setting | Description | Default Parser Settings |
| --- | --- | --- |
|  Name  |  Name of the current parser.  |  default  |
|  Metric Prefix  |  Prefix to be added before each nmon metric to distinguish and sort metrics with same or similar names. For example: using the prefix nmon converts the metric `cpu_total.busy` to `nmon.cpu_total.busy`.  |  nmon  |
|  Ignored  |  nmon metrics to be ignored. Metrics listed here are not imported. Acts as a filter.  |  none  |
|  Process TOP  |  Store `TOP` data.  |  Yes  |
|  Process UARG  |  Store user and arg columns.  |  Yes  |
|  Enable Properties  |  Store entity properties and configurations in ATSD from the nmon file.  |  Yes  |
|  Ignore Errors  |  Ignore all errors. Parses only known metrics and properties.  |  No  |
|  Retention Interval  |  How long the uploaded nmon file is stored on the ATSD server. 2 days by default.  |  2 days  |

![](./resources/nmon-parser-default.png)
