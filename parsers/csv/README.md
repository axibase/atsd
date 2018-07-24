# Uploading CSV Files

## Overview

[Upload CSV files](uploading-csv-files.md) via HTTP API or manually through the web interface.

![](./resources/csv.gif)

To process a CSV file, create a CSV Parser. The parser separates the file into rows and columns and then converts the information into `series`, `property`, and `message` commands.

### Configuration Settings

| Setting | Description |
| --- | --- |
|  `Enabled`  | The database discards CSV files which reference a disabled parser.  |
|  `Name`  |  Unique parser identifier.  |
|  `Command Type`  |  Data contents: `Series`, `Message`, or `Property`.  |
|  `Write Property`  |  Enable `Property` write during `Series` or `Message` upload.
|  `Entity Column`  |  Name of CSV column which contains entity name.<br>For example: `host` or `node`.<br>Specifiy multiple columns in the **Entity Column** field to concatenate their values into a composite entity name using a dash symbol `–` as a separation token.<br>Source CSV file:<br>`Year,Source,Destination,Travelers`<br>`1995,Moscow,Berlin,2000000`<br>Entity Columns:<br>`Source,Destination`<br>Resulting Entity:<br>`Moscow-Berlin`  |
|  `Entity Prefix`  |  Prefix to add to entity names.  |
|  `Default Entity`  |  Define a specific entity to which parser writes data.<br>Create a new entity or refer to one which exists.  |
|  `Replace Entities`  |  Replace entity names in the input file with aliases from the selected [Replacement Table](../../sql/examples/lookup.md#replacement-tables).|
|  `Process Events`  |  Process incoming data with [Rule Engine](../../rule-engine/README.md) in addition to database insert.  |
|  `Metric Prefix`  |  Prefix to add to metric names.  |
|  `Metric Name Column`  |  Column which contains metric names.  |
|  `Metric Value Column`  |  Column which contains metric values.  |
|  `Message Column`  |  Column which contains message text.  |
|  `Timestamp Columns`  |  Columns which contain the timestamp for each data sample.<br>ATSD handles [multi-column timestamps](https://axibase.com/use-cases/tutorials/irregular-timestamp/).<br>If two columns contain a timestamp, the parser concatenates them with a dash `-` in the **Timestamp Pattern** field.<br>Example Source CSV File:<br>`Date,Time,Sensor,Power`<br>`2015.05.15,09:15:00,sensor01,15`<br>Timestamp Columns:<br>`Date,Time`<br>Result:<br>`Date-Time`<br>`2015.05.15-09:15:00`<br>Timestamp Pattern Setting:<br>`yyyy.MM.dd-HH:mm:ss`  |
|  `Timestamp Type`  |  `Pattern`, `Seconds` (Unix Seconds), `Milliseconds` (Unix Milliseconds).  |
|  `Predefined Pattern`  |  Predefined timestamp formats.  |
|  `Timestamp Pattern`  |  Custom timestamp format, specified manually.<br>For example: `dd-MMM-yy HH:mm:ss`|
|  `Timezone Diff Column`  |  Column containing the time difference calculated from UTC.  |
|  `Time Zone`  |  Timestamp time zone.  |
|  `Filter`  |  Expression applied to row.<br>If expression returns `false`, the row is discarded.<br>Filter syntax:<br>**Fields**:<br>`timestamp`: Timestamp in milliseconds. Computed by parsing date from `Time` column with specified `Time Format` converted into milliseconds.<br>`row('columnName')`: Text value of cell in the specific column.<br>**Functions**:<br>`number('columnName')`: Returns numeric value of cell, or `NaN` if the cell contains non-numeric text.<br>`isNumber('columnName')`: Returns `true` if cell is a valid number.<br>`isBlank('columnName')`: Returns `true` is cell is empty string.<br>`upper('columnName')`: Converts cell text to uppercase.<br>`lower('columnName')`: Converts cell text to lowercase.<br>`date(endtime expression)`: Returns time in milliseconds.<br>**Filter examples**:<br>`number('columnName') > 0`<br>`isNumber('columnName')`<br>`row['columnName'] LIKE 'abc*'`<br>`upper(columnName) != 'INVALID'`<br>`timestamp > date('current_day')`<br>`timestamp > date(2015-08-15T00:00:00Z)`<br>`timestamp > date(now – 2 * year)`  |
|  `Tag Columns`  |  Columns which define series tags.  |
|  `Default Tags`  |  Predefined series tags, specified as `name=value` on multiple lines.  |
|  `Ignored Columns`  |  List of columns ignored in `METRIC` and `MESSAGE` commands.<br>These columns are retained in `PROPERTY` commands.  |
|  `Renamed Columns`  |  List of column names to substitute input column headers, one mapping per line.<br>Usage: `inputname=storedname`  |
|  `Header`  |  Header to use if the file contains no header. Alternatively, define a replacement header.  |
|  `Schema`  |  [Schema](csv-schema.md) which defines how to process cells based on position.  |

> Columns contained in the CSV file which are not specified in any parser field are imported as metrics by ATSD.

### Parse Settings

| Setting | Description |
| --- | --- |
|  `Delimiter`  |  Separator dividing values: comma `,`, semicolon `;`, or tab.  |
|  `Line Delimiter`  |  End-of-line symbol: `EOL (\n, \r\n)` or semicolon `;`  |
|  `Text Qualifier`  |  Escape character to differentiate separator as literal value.  |
|  `Comment Symbol`  |  Lines starting with comment symbol such as hash `#` are ignored by the parser.  |
|  `Padding Symbol`  |  Symbol appended to text values until all cells in the given column have the same width.<br>Applies to fixed-length formats such as `.dat` format.  |
|  `Decimal Separator`  |  Symbol used to mark the border between the integral and the fractional parts of a decimal numeral.<br>Default: `comma`.<br>Allowed values: `period`, `comma`.  |
|  `Grouping Separator`  |  Symbol used to group thousands within the number.<br>Default: `none`.<br>Allowed values: `none`, `period`, `comma`, `space`.  |
|  `Fields Lengths`  |  Width of columns in symbols. Padding symbols added to the end of the field to obey the fields lengths.<br>**For files in `.dat` format.**  |
|  `Discard NaN`  |  `NaN` values are discarded  |
|  `Ignore Line Errors`  |  If enabled, any errors encountered during file read are ignored including date parse errors, number parse errors, split errors, mismatch of rows, and header column counts.  |
|  `Ignore Header Lines`  |  Ignore top `n` lines from the file header  |

![](./resources/csv_parser_example.png)

### Column-based Examples

* [Weather Data](examples/weather.md)
* [Air Quality](examples/air-quality.md)

### Schema-based Parsing

In addition to column-based parsing described above, the database supports [schema-based](csv-schema.md) parsing using [RFC 7111](https://tools.ietf.org/html/rfc7111#section-2) selections:

```javascript
select("#row=2-*").select("#col=3-*").
addSeries().
metric(cell(1, col)).
entity(cell(row, 2)).
tag(cell(1, 3),cell(row, 3)).
timestamp(cell(row, 1));
```

Produced `series` commands:

```ls
series e:nurswgvml007 d:2015-11-15T00:00:00Z m:space_used_%=72.2 t:disk=/dev/sda
series e:nurswgvml007 d:2015-11-15T00:00:00Z m:space_used_%=14.5 t:disk=/dev/sdb
series e:nurswgvml001 d:2015-11-15T00:00:00Z m:space_used_%=14.4 t:disk=/dev/sda1
```

#### Schema-based Examples

* [Basic Example](examples/basic.md)
* [Columnar Format](examples/columnar-schema.md)
* [Columnar Period Format](examples/columnar-period-schema.md)
* [No Header](examples/no-header.md)
* [Multi-Column Timestamp](examples/multi-column-timestamp.md)
* [Multiple Metrics in Header](examples/multiple-metrics-in-header.md)
* [Metric Column](examples/metric-column-schema.md)
* [Messages](examples/message-schema.md)
* [Properties](examples/properties.md)
* [Messages with Filter](examples/message-with-filter-schema.md)
* [Series with Tags](examples/series-tags-schema.md)
* [`notEmptyUp`](examples/notemptyup-schema.md)
* [`notEmptyLeft`](examples/not-empty-left-schema.md)
* [Versioned Series](examples/versioned-series-schema.md)
* [Block-Appended](examples/block-appended-schema.md)