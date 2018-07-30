# Weekly Change Log: June 12, 2017 - June 18, 2017

## ATSD

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
| 4287 | UI | Bug | Enable syntax highlighting for extended SQL keywords. |
| 4282 | UI | Bug | Statistics page link does not generate a valid SQL query for metrics with tags. |
| 4275 | security | Bug | Enforce logout for the deleted user .|
| [4273](#issue-4273) | UI | Bug | User Interface **More** replaced with icons. |
| 4268 | core | Support | Java 8 startup validation added. |
| 4262 | UI | Bug | Support for [calendar](../../shared/calendar.md) expressions added to Rule Editor > Test tab. |
| 4260 | sql | Bug | Corrected [`ROUND`](../../sql/README.md#mathematical-functions) function error with [`NaN`](../../sql/README.md#not-a-number-nan) values.|
| 4258 | sql | Bug | Fixed an error that occurred when using non-overlapping interval conditions from different metrics. |
| [4247](#issue-4247) | sql | Feature | [`NaN`](../../sql/README.md#not-a-number-nan) comparison logic changed. `NaN` is compared similar to `NULL`. |
| 4231 | sql | Bug | Fixed an error that occurred when trying to compare [`date_format`](../../sql/README.md#date_format) with date string. |
| 4192 | client | Feature | Enable support for GZIP compression in [ATSD Java API](https://github.com/axibase/atsd-api-java) client. |
| [4187](#issue-4187) | UI | Feature | Add support for SQL syntax themes. |
| [4166](#issue-4166) | UI | Feature | Apply user-defined **Time Format** to [`date_format`](../../sql/README.md#date_format) function results in the [SQL Console](../../sql/sql-console.md). |
| 4129 | sql | Bug | Disallow non-positive period in [`PERIOD`](../../sql/README.md#period) and [`INTERPOLATE`](../../sql/README.md#interpolation). |
| 4121 | sql | Bug | [`ORDER BY`](../../sql/README.md#ordering) clause cannot reference non-grouped columns. |
| 3838 | sql | Feature | Add support for column aliases in [ORDER BY](../../sql/README.md#ordering) clause. |

### ATSD

#### Issue 4273

![4273](./Images/4273.png)

#### Issue 4247

Compare [`NaN`](../../sql/README.md#not-a-number-nan) values similar to [`NULL`](../../sql/README.md#null).

![4247](./Images/4247.png)

#### Issue 4187

![4187](./Images/4187.png)

#### Issue 4166

Apply user-applied date format on the [SQL Console](../../sql/sql-console.md).

![4166](./Images/4166.png)