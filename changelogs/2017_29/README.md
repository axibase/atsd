Weekly Change Log: July 17, 2017 - July 23, 2017
==================================================

### ATSD
| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------| 
| 4409 | export | Bug | Fixed an exporting error which did not include metric units |
| 4400 | sql | Bug | Fixed an issue which caused inconsistent handling of similar queries. |
| 4398 | UI | Feature | Review: new metric list page (not sure exactly what to screenshot here for the new feature, please advise) |
| 4394 | documentation | Bug | Undocumented fields for metrics |
| 4359 | forecast | Bug | Fixed a calculation error for [Forecasts](https://axibase.com/products/axibase-time-series-database/forecasts/) that contain an [endtime](https://axibase.com/products/axibase-time-series-database/visualization/end-time/) in the future.|
| [4286](#Issue-4286) | sql | Feature | Logic rule engine update to included three-valued logic (3VL) |

#### Issue 4286

Truth Tables for Logical Operators:

**Table 1.1**

| X | Not X |
|:---:|:-----:|
|`true`| `false` |
| `false` | `true` |
| `NULL` | `NULL` |

**Table 1.2**

| X | Y | X and Y | X or Y |
|:---:|:---:|:-------:|:------:|
| `true` | `true` | `true` | `true` |
| `true` | `false` | `false` | `true` |
| `false` | `false` | `false` | `false` |
| `true` | `NULL` | `NULL` | `true` |
| `false` | `NULL` | `false` | `NULL` |
| `NULL` | `NULL`| `NULL` | `NULL` |