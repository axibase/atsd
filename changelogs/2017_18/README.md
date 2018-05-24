# Weekly Change Log: May 01, 2017 - May 07, 2017

## ATSD

| Issue| Category    | Type    | Subject                                                             |
|------|-------------|---------|----------------------
| 4149 | sql | Bug | Fixed a self-join exception that occurred when using the [`metrics()`](../../sql#metrics) function |
| 4131 | Test | Bug | Fixed an error caused by ignoring Daylight Savings Time when using a [`GROUP BY PERIOD`](../../sql#calendar-alignment) clause with a user-defined time zone.|
| 4130 | sql | Bug | Fixed an error causing the display of duplicate rows when aggregation was performed without grouping.|
| 4112 | sql | Bug | Fixed [`ISNULL`](../../sql#isnull) function evaluation that ignored the first condition unless another condition was presented in the `WHERE` clause.|
| 4105 | sql | Bug | Fixed an error causing missing rows in [sub-queries](../../sql/examples/filter-by-date.md#query-using-between-subquery) containing the `WHERE` condition.|
| 4097 | UI | Bug | Fixed a concurrency problem causing multiple queries to be terminated with a single cancel request. |

## Collector

| Issue| Category    | Type    | Subject                                                             |
|------|-------------|---------|----------------------
| 4154 | docker | Bug | Fixed an `async` exception that listens for Docker events. |
| 4151 | docker | Bug | Fixed data gap when ATSD is temporarily down. |

### Charts

| Issue| Category    | Type    | Subject                                                             |
|------|-------------|---------|----------------------
| [4153](#Issue-4153) | box | Bug | Fixed an auto-scaling error for aggregated series in the [Box Widget](https://axibase.com/products/axibase-time-series-database/visualization/widgets/box-chart-widget/#tab-id-1). |
| 4124 | refactoring | Bug | Optimize series-label rendering. |

### Issue 4153

![](./Images/ChangeLogDemo4.png)

[![](./Images/button.png)](https://apps.axibase.com/chartlab/27dc8b67)

Application of the `statistic` command yielded incorrect displays for the `entity = *` fields
under particular `[series]` clusters which can be viewed in ChartLab.