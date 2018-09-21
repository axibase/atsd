# Exporting Data

## Built-in Tools

ATSD provides the following built-in facilities to export data:

| **Type** | **Interface** | **Formats** | **Distribution** | **Compression** | **Scope** |
|---|---|---|---|---|---|
| [Ad Hoc](ad-hoc-exporting.md) | **Data > <br>Export**| CSV, HTML | Web Page<br>File Download | No | Single metric |
| [Scheduled](scheduled-exporting.md) | **Data > <br>Export Jobs** | CSV, Excel | File System<br> Email | Optional | Single metric |
| [Scheduled SQL](../sql/scheduled-sql.md) |  **SQL > <br>Scheduled Queries** | CSV, Excel | File System<br> Email<br> Publish to URL | No | Any number of metrics with [SQL JOINs](../sql/README.md#joins) |
| [URL](export-url.md) | Command Prompt | CSV, HTML | Web Page<br>File Download| `GZIP` | Single metric

## Reporting Tools

* [Alteryx Designer](../integration/alteryx/README.md)
* [IBM SPSS Modeler](../integration/spss/modeler/README.md)
* [IBM SPSS Statistics](../integration/spss/statistics/README.md)
* [MatLab](../integration/matlab/README.md)
* [Pentaho Data Integration](../integration/pentaho/data-integration/README.md)
* [Pentaho Report Designer](../integration/pentaho/report-designer/README.md)
* [Stata](../integration/stata/README.md)
* [Tableau](../integration/tableau/README.md)
* [TIBCO Spotfire](../integration/spotfire/README.md)
* Other tools supporting [JDBC](https://github.com/axibase/atsd-jdbc) or [ODBC-JDBC](../integration/odbc/README.md) connectivity.