# Pentaho Report Designer

* [Prerequisites](#prerequisites)
* [Configure Database Connection](#configure-database-connection)
* [Verify Connection](#verify-connection)
* [View Schema](#view-schema)
* [Import Data](#import-data)

## Prerequisites

### Install PRD

* Install Pentaho Report Designer 7.1

### Install ATSD Driver

* Download ATSD [JDBC driver](https://github.com/axibase/atsd-jdbc/releases) with dependencies
* Copy the driver JAR file into the `lib/jdbc` directory in the Report Designer installation directory
* Restart the Report Designer

### Load Sample Data

To complete this exercise, load sample data into your ATSD instance.

1. Log into the ATSD web interface
2. Open **Metrics > Data Entry**, select the **Commands** tab.
3. Copy the [`series` commands](./resources/commands.txt) into the form and click **Submit**.

![](./resources/metrics_entry.png)

The commands contain the Consumer Price Index (CPI) for each category of items in a consumer basket as well as a weight for each category in the CPI basket. The weights are stored as fractions of 1000. The CPI is tracked from 2013 to 2017 and uses Year 2016 values as the baseline. Weight values are available only for 2017. The underlying data is available in the following [Excel file](./resources/eng_e02.xls).

To calculate a weighted inflation index we need to multiply the CPI of each category by its weight divided by 1000 and sum the products.

## Configure Database Connection

* Select the **Data** tab in the properties pane on the right.

![](./resources/data_pane.png)

* Select **Add Data Sources** in the toolbar, click **JDBC**.
* Select **Add a new connection** (green plus icon).

![](./resources/new_connection.png)

* Click **General** in the left menu
* Select **Generic database** in **Connection Type**
* Select **Native (JDBC)** in **Access**

### Configure ATSD connection properties

* Enter JDBC URL into the `Custom Connection URL` field, for example:

  `jdbc:atsd://atsd_hostname:8443;tables=inflation%;expandTags=true`

> `atsd_hostname` is the hostname of the target ATSD instance
> Review ATSD JDBC [URL parameters](https://github.com/axibase/atsd-jdbc/blob/master/README.md) for additional details.

* Set Custom Driver Class Name field to `com.axibase.tsd.driver.jdbc.AtsdDriver`
* Set `User Name` and `Password` fields to your ATSD Username and Password
* Set `Connection Name` to `ATSD Connection`

![](./resources/atsd_connection.png)

## Verify Connection

ATSD connection can be verified using the `SELECT 1` query.

Example of `SELECT 1` test query:

* Select **Add a new connection** (green plus icon).
* Input query row `SELECT 1` to the **SQL Query Designer**.
* Click **Preview**.

![](./resources/select_1.png)

Result of `SELECT 1` test query:

![](./resources/select_1_preview.png)

## View Schema

* Edit `Custom Connection URL` field in ATSD Connection properties
* Edit `tables=TABLE_NAME_FILTER` in `Custom Connection URL` field
* SET `TABLE_NAME_FILTER` to your table name filter

`TABLE_NAME_FILTER` is a list of comma-separated metrics or metric expressions to be displayed as tables in the Pentaho Report Designer.

`TABLE_NAME_FILTER` examples:

* `%java%` for metrics that contains word `java`
* `custom.metric%` for metrics whose name starts with `custom.metric`
* `%2017` for metrics whose name ends with `2017`

ATSD Schema can be viewed in SQL Query Designer tool:

![](./resources/query_text.png)

`SQL Query Designer` tool interface:

![](./resources/sql_query_designer.png)

`SQL Query Designer` is used for visual building of a Query:

* Double-click the table that you want to include to Query. The table is shown in right pane of **SQL Query Designer**.
* Select fields inside the table (these fields are included in `SELECT` clause of a Query)
* Optionally add `WHERE`, `GROUP BY` and `HAVING` or `ORDER BY`
* Click **OK** so your Query is built and shown in text field
> Remove new line symbol after `SELECT` keyword
> Remove quotes around column names

## Import Data

* Select **Data** tab in the properties pane on the right
* Select **Add Data Sources** button in the toolbar and choose `JDBC`
* Click **ATSD Connection**
* Click **Add Query** in the **Available Queries** list

![](./resources/add_query.png)

* Enter an SQL query in the Query editor, for example `SELECT datetime, entity, value FROM jvm_memory_used LIMIT 10`
* Click **Preview** to review the resultset.

![](./resources/preview.png)

* Build a Query using the `SQL Query Designer`

* Click **OK**. The list of queries is added to the **Data** pane.
* Right-click the query and choose **Select Query**. The tree view displays query results and fields.

![](./resources/data_pane_updated.png)

* Drag and drop these field into the report canvas.
* Click **Preview** in the top left corner (the eye icon) to view query results.

![](./resources/report.png)

Example of report preview:

![](./resources/report_preview.png)

[File with example report](./resources/report.prpt)
