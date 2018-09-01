# Table Functions

## Overview

Table functions perform various operations on strings, lists, and maps to create tabular representations.

## Reference

* [`addTable` for map](#addtable-for-map)
* [`addTable` for maps](#addtable-for-maps)
* [`addTable` for list](#addtable-for-list)

## `addTable` for map

```csharp
addTable(map, string format) string
```

Prints the input key-value `map` as a two-column table in the specified `format`.

The first column in the table contains map keys, whereas the second column contains their corresponding map values.

The input `map` typically consists of maps such as `tags`, `entity.tags`, or `variables`.

Supported formats:

* `markdown`
* `ascii`
* `property`
* `csv`
* `html`

Returns an empty string if `map` is `null` or has no records.

Ignores map records with empty or `null` values.

Automatically rounds numeric values in web and email notifications or prints without modifications in other cases.

The default table headers are `Name` and `Value`.

Examples:

* `markdown` format

```javascript
addTable(property_map('nurswgvml007','disk::', 'today'), 'markdown')
```

```ls
| **Name** | **Value**  |
|:---|:--- |
| id | sda5 |
| disk_%busy | 0.6 |
| disk_block_size | 16.1 |
| disk_read_kb/s | 96.8 |
| disk_transfers_per_second | 26.0 |
| disk_write_kb/s | 8.1 |
```

* `csv` format

```javascript
addTable(entity.tags, 'csv')
```

```ls
Name,Value
alias,007
app,ATSD
cpu_count,1
os,Linux
```

* `ascii` format

```javascript
addTable(entity_tags(tags.host, true, true), 'ascii')
```

```ls
+-------------+------------+
| Name        | Value      |
+-------------+------------+
| alias       | 007        |
| app         | ATSD       |
| cpu_count   | 1          |
| os          | Linux      |
+-------------+------------+
```

* `html` format

The HTML format includes the response rendered as a `<table>` node with inline CSS styles for better compatibility with legacy email clients such as Microsoft Outlook.

```javascript
addTable(property_map('nurswgvml007', 'cpu::*'), 'html')
```

```html
<table style="font-family: monospace, consolas, sans-serif; border-collapse: collapse; font-size: 12px; margin-top: 5px"><tbody><tr><th bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">Name</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Value</th></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">id</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">1</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">cpu.idle%</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">91.5</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">cpu.steal%</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">0.0</td></tr>
</tbody></table>
```

* `property` format

```javascript
addTable(excludeKeys(entity.tags, ['ip', 'loc_code', 'loc_area']), 'property')
```

```ls
alias=007
app=ATSD
cpu_count=1
os=Linux
```

## `addTable` for maps

```csharp
addTable([map], string format[, [string header]]) string
```

Prints a collection of maps `map` as a multi-column table in the specified `format`, with optional `header`.

The first column in the table contains unique keys from all maps in the collection, whereas the second and subsequent columns contain map values for the corresponding key in the first column.

The default table header is 'Name, Value-1, ..., Value-N'.

If the header argument `h` is specified as a collection of strings, it replaces the default header. The number of elements in the header collection must be the same as the number of maps plus `1`.

Examples:

`property_maps('nurswgvml007','jfs::', 'today')` returns the following collection:

```ls
[
  {id=/, jfs_filespace_%used=12.8},
  {id=/dev, jfs_filespace_%used=0.0},
  {id=/mnt/u113452, jfs_filespace_%used=34.9},
  {id=/run, jfs_filespace_%used=7.5},
  {id=/var/lib/lxcfs, jfs_filespace_%used=0.0}
]
```

* `markdown` format

```javascript
addTable(property_maps('nurswgvml007','jfs::', 'today'), 'markdown')
```

```markdown
| **Name** | **Value 1** | **Value 2** | **Value 3** | **Value 4** | **Value 5**  |
|:---|:---|:---|:---|:---|:--- |
| id | / | /dev | /mnt/u113452 | /run | /var/lib/lxcfs |
| jfs_filespace_%used | 12.8 | 0.0 | 34.9 | 7.5 | 0.0 |
```

* `csv` format

```javascript
addTable(property_maps('nurswgvml007','jfs::', 'today'), 'csv')
```

```ls
Name,Value 1,Value 2,Value 3,Value 4,Value 5
id,/,/dev,/mnt/u113452,/run,/var/lib/lxcfs
jfs_filespace_%used,12.7,0.0,34.9,7.5,0.0
```

* `ascii` format

```javascript
addTable(property_maps('nurswgvml007','jfs::', 'today'), 'ascii', ['property', 'root', 'dev', 'mount', 'run', 'var'])
```

```ls
+---------------------+------+------+--------------+------+----------------+
| property            | root | dev  | mount        | run  | var            |
+---------------------+------+------+--------------+------+----------------+
| id                  | /    | /dev | /mnt/u113452 | /run | /var/lib/lxcfs |
| jfs_filespace_%used | 12.8 | 0.0  | 34.9         | 7.5  | 0.0            |
+---------------------+------+------+--------------+------+----------------+
```

* `html` format

```javascript
addTable(property_maps('nurswgvml007','jfs::', 'today'), 'html')
```

```html
<table style="font-family: monospace, consolas, sans-serif; border-collapse: collapse; font-size: 12px; margin-top: 5px"><tbody><tr><th bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">Name</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Value 1</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Value 2</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Value 3</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Value 4</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Value 5</th></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">id</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">/</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">/dev</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">/mnt/u113452</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">/run</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">/var/lib/lxcfs</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">jfs_filespace_%used</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">12.8</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">0.0</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">34.9</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">7.5</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">0.0</td></tr>
</tbody></table>
```

* `property` format

```javascript
addTable(property_maps('nurswgvml007','jfs::', 'today'), 'property')
```

```ls
id=/=/dev=/mnt/u113452=/run=/var/lib/lxcfs
jfs_filespace_%used=12.8=0.0=34.9=7.5=0.0
```

## `addTable` for list

```csharp
addTable([[string]] strList, string format[, [string] header | bool addHeader]) string
```

Prints list of lists `strList` as a multi-column table in the specified `format`. Each nested list in the parent list `strList` is serialized into a separate row in the table.

The number of elements in each collection must be the same.

The default table header is `Value-1, ..., Value-N`.

Use header arguments to customize the header.

If the third argument is specified as a collection of strings, its elements replace the default header. The size of the header collection must be the same as the number of cells in each row.

If `addHeader` argument is specified as a boolean value `true`, the first row in the table is used as a header.

The function returns an empty string if `strList` is empty.

Examples:

```javascript
query = 'SELECT datetime, value FROM http.sessions WHERE datetime > current_hour LIMIT 2'
```

`executeSqlQuery(query)` returns a list consisting of the header row followed by data rows.

```ls
[[datetime, value], [2018-01-31T12:00:13.242Z, 37], [2018-01-31T12:00:28.253Z, 36]]
```

* `markdown` format

```javascript
addTable(executeSqlQuery(query), 'markdown', true)
```

```ls
| **datetime** | **value**  |
|:---|:--- |
| 2018-01-31T12:00:13.242Z | 37 |
| 2018-01-31T12:00:28.253Z | 36 |
```

* `csv` format

```javascript
addTable([['2018-01-31T12:00:13.242Z', '37'], ['2018-01-31T12:00:28.253Z', '36']], 'csv', ['date', 'count'])
```

```csv
date,count
2018-01-31T12:00:13.242Z,37
2018-01-31T12:00:28.253Z,36
```

* `ascii` format

```javascript
addTable(executeSqlQuery(query), 'ascii', true)
```

```ls
+--------------------------+-------+
| datetime                 | value |
+--------------------------+-------+
| 2018-01-31T12:00:13.242Z | 37    |
| 2018-01-31T12:00:28.253Z | 36    |
+--------------------------+-------+
```

* `html` format

```javascript
addTable(executeSqlQuery(query), 'html', true)
```

```html
<table style="font-family: monospace, consolas, sans-serif; border-collapse: collapse; font-size: 12px; margin-top: 5px"><tbody><tr><th bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">datetime</th><th align="left" style="border: 1px solid #d0d0d0;padding: 4px;">value</th></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">2018-01-31T12:00:13.242Z</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">37</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">2018-01-31T12:00:28.253Z</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">36</td></tr>
</tbody></table>
```

* `property` format

```javascript
addTable(executeSqlQuery(query), 'property')
```

```ls
datetime=value
2018-01-31T12:00:13.242Z=37
2018-01-31T12:00:28.253Z=36
```

```javascript
addTable(executeSqlQuery(query), 'property', true)
```

```ls
2018-01-31T12:00:13.242Z=37
2018-01-31T12:00:28.253Z=36
```

```javascript
addTable(executeSqlQuery(query), 'property', false)
```

```ls
datetime=value
2018-01-31T12:00:13.242Z=37
2018-01-31T12:00:28.253Z=36
```