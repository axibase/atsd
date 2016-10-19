# CSV Schema Settings

Schema Parser implements position-aware parsing of CSV files. Once the file is converted into a tabular model, each cell is assigned a unique address and its value can be retrieved using the `cell(rowIndex, columnIndex)` function. The schema parser reads rows and columns from top left to bottom right. The number of rows and columns to be processed is controlled with start/end index and step arguments in `select` functions.

The `select()` function implements [RFC 7111](https://tools.ietf.org/html/rfc7111) selections using URI Fragment Identifiers, including `row#`, `col#`, and `cell#` with a custom extension controlling iteration step. See extended ABNF syntax [here](#abnf).

The cell where the cursor is located is called the active cell. Its value is obtained with the `cell(row, col)` function where `row` and `col` arguments represent indexes of the current row and column. Values of other cells can be obtained using absolute or relative references. For example, `cell(1, col)` refers to the cell located in the 1st row and the same column as the active cell. `cell(row, col-1)` refers to the cell located in the same row to the left of the active cell.

Value retrieved with the `cell(rowIndex, columnIndex)` function can be used to set metric, entity, timestamp, and tag fields in order to assemble series, property, or message commands from the value of the active cell and referenced cells in the header and lead columns. JavaScript expressions are supported for modifying and filtering cell values.

Schema Parser example:

Input File:

```
            DateTime; sensor01;  Status; sensor02;  Status
2015-10-29T00:00:00Z;     19.2;  Provis;     11.3;      ok
2015-10-29T00:05:00Z;     19.8;      ok;     12.9;      ok
```

Schema:

```
select("#row=2-*!1").select("#col=2-*!2").
addSeries().
timestamp(cell(row, 1)).
entity(cell(1, col)).
metric('power_kwh').
tag('status', cell(row, col+1).toLowerCase());
```

Explanation:


- `select("#row=2-*")` – RFC7111 selection. Read rows starting with 2nd row with step 1 > `'2015-10-29T00:00:00Z; 19.2; provis; 11.3; ok'`.
- `select("#col=2-*!2")` – RFC7111 selection. Read columns in the current row starting with 2nd column with step 2: 2,4,6. etc. > `'19.2'`.
- `timestamp(cell(row, 1))` – Set time to `'2015-10-29T00:00:00Z'` which is the value of the cell located in the current row, 1st column.
- `entity(cell(1, col))` – Set entity to `'sensor01'` which is value of cell located in the 1st row, current column.
- `metric('power_kwh')` - Set metric name to a predefined value.
- `tag('status',cell(row, col+1).toLowerCase())` – Set tag `status` to `'provis'` which is the lowercased value of the cell located in the current row to the right of the current column `(col + 1)`.
- Iterate to the next column with step 2, `select("#col=2-*!2")`, to cell `'11.3'`. Repeat chained functions after `addSeries()`.


Commands:

```ls
series e:sensor01 m:power_kwh=19.2 d:2015-10-29T00:00:00Z t:status=provis
series e:sensor02 m:power_kwh=11.3 d:2015-10-29T00:00:00Z t:status=ok
series e:sensor01 m:power_kwh=19.8 d:2015-10-29T00:05:00Z t:status=ok
series e:sensor02 m:power_kwh=12.9 d:2015-10-29T00:05:00Z t:status=ok
```

If Schema parsing is enabled, only the following fields from the parser configuration are applied:


- Delimiter
- Line Delimiter
- Text Qualifier
- Comment Symbol
- Padding Symbol
- Decimal Separator
- Grouping Separator
- Fields Lengths
- Date fields: Time Pattern, Offset, Timezone
- Replace Entities
- Process Events
- Discard NaN
- Ignore Line Errors
- Renamed Columns
- Filter


### Schema Functions

#### Select and Filter Functions

| Name | Required | Description | 
| --- | --- | --- | 
|  <p>`select(expression)`</p>  |  <p>Yes</p>  |  <p>Selects rows, columns, or cell range to process using RFC 7111 selection syntax.</p>  | 
|  <p>`filter(condition)`</p>  |  <p>No</p>  |  <p>Optionally filter rows, columns and cells depending on rowText and cellText values, e.g. `rowText.indexOf('test')>=0`.</p>  | 


#### Initialize Command Functions

| Name | Required | Description | 
| --- | --- | --- | 
|  <p>`addSeries()`</p>  |  <p>No</p>  |  <p>Create Series command.</p>  | 
|  <p>`addProperty()`</p>  |  <p>No</p>  |  <p>Create Property command.</p>  | 
|  <p>`addMessage()`</p>  |  <p>No</p>  |  <p>Create Message command.</p>  | 


#### Set Command Field Functions

| Name | Required (addSeries) | Required (addProperty) | Required (addMessage) | Description | 
| --- | --- | --- | --- | --- | 
|  <p>`entity(entityName)`</p>  |  <p>Yes</p>  |  <p>Yes</p>  |  <p>Yes</p>  |  <p>Set entity name.</p>  | 
|  <p>`timestamp(timestampValue)`</p>  |  <p>Yes</p>  |  <p>Yes</p>  |  <p>Yes</p>  |  <p>Set timestamp.</p>  | 
|  <p>`metric(metricName)`</p>  |  <p>Yes</p>  |  <p>Unsupported</p>  |  <p>Unsupported</p>  |  <p>Set metric name.</p>  | 
|  <p>`tag(tagName, tagValue)`</p>  |  <p>No</p>  |  <p>No</p>  |  <p>No</p>  |  <p>Add tag with defined name and value.</p>  | 
|  <p>`key(keyName, keyValue)`</p>  |  <p>Unsupported</p>  |  <p>No</p>  |  <p>Unsupported</p>  |  <p>Add key with defined name and value.</p>  | 
|  <p>`type(typeName)`</p>  |  <p>Unsupported</p>  |  <p>Yes</p>  |  <p>Unsupported</p>  |  <p>Set property type.</p>  | 
|  <p>`value(value)`</p>  |  <p>No</p>  |  <p>Unsupported</p>  |  <p>Unsupported</p>  |  <p>Overrides series value (default value is current cell content).</p>  | 
|  <p>`messageText(text)`</p>  |  <p>Unsupported</p>  |  <p>Unsupported</p>  |  <p>No</p>  |  <p>Set message text.</p>  | 
|  <p>`appendText(text, delimiter)`</p>  |  <p>Unsupported</p>  |  <p>Unsupported</p>  |  <p>No</p>  |  <p>Append text to current message text.</p>  | 
|  <p>`forEach(expression)`</p>  |  <p>No</p>  |  <p>No</p>  |  <p>No</p>  |  <p>Accepts RFC 7111 #col= selector, iterates over matched cells in the current row and applies chained-after functions to each cell, e.g. `forEach('#col=5!2').tag(cell(row,col), cell(row,col+1));`</p>  | 


#### Pre-defined Variables

| Name | Type | Description | 
| --- | --- | --- | 
|  <p>`col`</p>  |  <p>Integer</p>  |  <p>Column index of the active cell.</p>  | 
|  <p>`row`</p>  |  <p>Integer</p>  |  <p>Row index of the active cell.</p>  | 
|  <p>`value, cellText`</p>  |  <p>String</p>  |  <p>Text content of the active cell.</p>  | 
|  <p>`rowText`</p>  |  <p>String</p>  |  <p>Current row full text.</p>  | 
|  <p>`columnCount`</p>  |  <p>Integer</p>  |  <p>Column count for current row.</p>  | 
|  <p>`fileName`</p>  |  <p>String</p>  |  <p>CSV file name being parsed, if available.</p>  | 


#### Lookup Functions

| Name | Type | Description | 
| --- | --- | --- | 
|  <p>`cell(rowIndex, colIndex)`</p>  |  <p>String</p>  |  <p>Return content from the specified cell.</p>  | 
|  <p>`notEmptyLeft(rowIndex, colIndex)`</p>  |  <p>String</p>  |  <p>Finds a non-empty cell located to the left from the specified cell.</p>  | 
|  <p>`notEmptyUp(rowIndex, colIndex)`</p>  |  <p>String</p>  |  <p>Finds a non-empty cell located in the current or prior row in the specified column.</p>  | 


#### Notes:


- Row and column indexes start with 1.
- Row index of the active cell can be referenced with the `row` parameter.
- Column index of the active cell can be referenced with the `col` parameter.
- Relative index is specified with `+/-`, for example `col+1`.
- Row index can be smaller or equal to the index of the current row due to the streaming nature of the parser.
- If index is not specified, the current index is used. Same as `+0` or `-0`.


#### RFC 7111 Step Extension Syntax:

ABNF Extension Syntax:

```
   singlespec  =  position [ "-" position  [ "!" step]]
   cellspec    =  cellrow "," cellcol [ "-" cellrow "," cellcol [ "!" steprow "," stepcol ] ]
   steprow    =  step
   stepcol    =  step
   step        =  number
```

RFC 7111 base syntax: [https://tools.ietf.org/html/rfc7111#section-3](https://tools.ietf.org/html/rfc7111#section-3)

Examples:


- `#row=1-*!2`                    – Select odd rows.
- `#col=10-*!3`             – Select every 3rd column starting with column 10.
- `#cell=1,2-5,*!1,2`     – Select even columns in the first 5 rows.


#### Schema-based Parser Examples:

- [Basic Example](examples/basic.md)
- [Columnar Format](examples/columnar-schema.md)
- [Columnar Period Format](examples/columnar-period-schema.md)
- [No Header](examples/no-header.md)
- [Multi-Column Timestamp](examples/multi-column-timestamp.md)
- [Multiple Metrics in Header](examples/multiple-metrics-in-header.md)
- [Metric Column](examples/metric-column-schema.md)
- [Messages](examples/message-schema.md)
- [Properties](examples/properties.md)
- [Messages with Filter](examples/message-with-filter-schema.md)
- [Series with Tags](examples/series-tags-schema.md)
- [notEmptyUp](examples/notemptyup-schema.md)
- [notEmptyLeft](examples/not-empty-left-schema.md)
- [Versioned Series](examples/versioned-series-schema.md)
- [Block-Appended](examples/block-appended-schema.md)
