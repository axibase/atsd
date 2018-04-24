Weekly Change Log: January 23 - January 29, 2017
================================================

### ATSD

| Issue| Category    | Type    | Subject                                                                              |
|------|-------------|---------|--------------------------------------------------------------------------------------|
| 3831 | api-rest    | Bug     | Fixed metric [`series`](../../api/meta/entity/get.md#entity-get) request processing if series count exceeds 1000. Added a warning message to web UI when the threshold is reached. |
| 3825 | sql         | Bug     | Removed extra rows from the result set when the [`VALUE {n}`](../../sql/examples/interpolate-extend.md#interpolate-with-extend) interpolation function was specified in a `GROUP BY` period clause. |
| 3816 | UI          | Bug     | Fixed ordering of timestamps on the Interval tab on the Series Statistics page. Intervals smaller than the median minus standard deviation are now not displayed. |
| 3813 | UI          | Bug     | Fixed 'series not found' issue when displaying series with multiple tags on the Series Statistics page. |
| 3808 | metric      | Bug     | Corrected a defect where an incorrect `NaN` count was shown on the Series Statistics page. |
| [3742](#issue-3742) | UI          | Feature | Added a `Text Column` button to the UI Export form. |

### Collector

| Issue| Category    | Type    | Subject                                                                              |
|------|-------------|---------|--------------------------------------------------------------------------------------|
| 3823 | socrata     | Bug     | Added a record to the Statistics Detail page to display tasks with active downloads. |
| 3821 | socrata     | Bug     | Added 'Add Row Number' field to add an extra metric with the name `{prefix}row_number` added to series commands in case the data row doesn't contain any numeric columns. |
| 3820 | docker      | Bug     | Fixed missing 'path' entity tag for volumes. |
| 3819 | docker      | Feature     | Updated to construct volume label from the container label instead of the container name. |
| [3818](#issue-3818) | socrata     | Feature | In `Test` mode, added a table displaying columns from the metadata section. |
| 3812 | socrata     | Bug     | Removed `http` pool from the configuration tab. Now, only the dataset path will be displayed. |
| 3811 | socrata     | Bug     | Fixed auto-complete defect affecting configuration form fields. |
| 3810 | socrata     | Bug     | Updated settings so that if a field is specified in 'Custom Tags' and is not specified in 'Included Fields', it will not be sent as a metric.|
| 3804 | socrata     | Bug     | Excluded `null` values from custom tags or any other fields in commands for both JSON and Socrata jobs. |
| 3803 | socrata     | Bug     | Fixed issue where time fields were being stored as metrics. |
| 3802 | socrata     | Bug     | Corrected issues with statistics display showing inaccurate command counters. |
| 3801 | socrata     | Bug     | Handled an error caused by trailing slashes in the Path field. |
| 3799 | socrata     | Bug     | Removed form jitter. |
| 3798 | socrata     | Bug     | Updated time parser for JSON and Socrata jobs to accept the `yyyyw` time format. |
| 3793 | socrata     | Bug     | Added heuristics to the Socrata job. |
| [3772](#issue-3772) | Socrata     | Feature | Created new Socrata job to query [Socrata](https://socrata.com/) data. |

## ATSD

### Issue 3742
--------------

A `Text Column` button was added to the user interface export form. By enabling this button, a text column will be displayed for data exported in CSV and HTML formats.   

Now, a [text value](../../api/network/series.md#series-tags-text-value-messages) can be used to annotate a numeric observation without changing the series primary key. See
[Issue 3480](../../changelogs/2017_02#issue-3480) for more information.      

![Figure 1](Images/Figure1.png)

## Collector

### Issue 3818
--------------

The [Test] result now includes a list of columns from the underlying dataset and information on how they're mapped into command fields. The table contains column attributes as well as the following fields:

* Schema Type: classifies how the column is processed in ATSD commands, e.g. metric, series tag, time, property type, etc.
* Included: determines if the column is included in ATSD commands or is excluded (ignored).


```json
"columns" : [ {
    "id" : 266155015,
    "name" : "Proficient",
    "dataTypeName" : "number",
    "description" : "Number of students tested that were considered proficient - meeting standard score metric associated with the grade and content.  A null value identified by SCS (small cell size) indicates data was redacted to ensure privacy standards where met.",
    "fieldName" : "proficient_1",
    "position" : 7,
    "renderTypeName" : "number",
    "tableColumnId" : 23073592,
    "width" : 149,
    "cachedContents" : {
      "largest" : "1552",
      "non_null" : 57924,
      "average" : "74.43671017194945",
      "null" : 1666,
      "top" : [ {
        "item" : "0",
        "count" : 20
      }, {
        "item" : "18",
        "count" : 19
      }, {
        "item" : "54",
        "count" : 18
      }, {
        "item" : "44",
        "count" : 17
      }, {
        "item" : "12",
        "count" : 16
      }, {
        "item" : "37",
        "count" : 15
      }, {
        "item" : "39",
        "count" : 14
      }, {
        "item" : "27",
        "count" : 13
      }, {
        "item" : "32",
        "count" : 12
      }, {
        "item" : "17",
        "count" : 11
      }, {
        "item" : "9",
        "count" : 10
      }, {
        "item" : "43",
        "count" : 9
      }, {
        "item" : "47",
        "count" : 8
      }, {
        "item" : "25",
        "count" : 7
      }, {
        "item" : "24",
        "count" : 6
      }, {
        "item" : "21",
        "count" : 5
      }, {
        "item" : "15",
        "count" : 4
      }, {
        "item" : "13",
        "count" : 3
      }, {
        "item" : "90",
        "count" : 2
      }, {
        "item" : "113",
        "count" : 1
      } ],
      "smallest" : "0",
      "sum" : "4311672"
    },
    "format" : {
      "precisionStyle" : "standard",
      "noCommas" : "false",
      "align" : "right"
    }
  }
]
```

![Figure 3](Images/Figure3.png)

### Issue 3772
--------------

In order to simplify processing of JSON documents created with [Open Data](https://project-open-data.cio.gov/v1.1/schema/) schema, we implemented a new [Socrata](https://github.com/axibase/axibase-collector/blob/master/jobs/socrata.md) job. Support for Socrata format has been removed from the JSON job as a result.

The configuration options implemented in the Socrata job provide a way to convert the dataset into series, property, and message fields in ATSD.

![Figure 2](Images/Figure2.png)
