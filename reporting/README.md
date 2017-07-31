# Exporting Data

## Built-in Tools

ATSD provides the following built-in facilities to export data:

| **Type** | **Interface** | **Formats** | **Distribution** | **Compression** | **Scope** |
|---|---|---|---|---|---|
| [Adhoc](ad-hoc-exporting.md) | **Export** tab | CSV, HTML | - Web Page<br>- File Download | No | Single metric |
| [Scheduled](scheduled-exporting.md) | **Configuration > <br>Export Jobs** tab | CSV, Excel | - File System<br>- Email | Optional | Single metric |
| [Scheduled SQL](../api/sql/scheduled-sql.md) |  **Configuration > <br>SQL Queries** tab | CSV, Excel | - File System<br>- Email<br>- Publish to URL | No | Customize with [SQL](../api/sql/README.md) |

## Reporting Tools

* [Alteryx Designer](../integration/alteryx/README.md)
* [IBM SPSS Modeler](../integration/spss/modeler/README.md)
* [IBM SPSS Statistics](../integration/spss/statistics/README.md)
* [MatLab](../integration/matlab/README.md)
* [Pentaho Data Integration](../integration/pentaho/data-integration/README.md)
* [Pentaho Report Designer](../integration/pentaho/report-designer/README.md)  
* [Stata](../integration/stata/README.md)
* [Tableau](../integration/tableau/README.md)
* Other tools supporting [JDBC](https://github.com/axibase/atsd-jdbc) or [ODBC-JDBC](../integration/odbc/README.md) connectivity.

