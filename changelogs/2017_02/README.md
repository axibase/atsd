Weekly Change Log: January 09 - January 15, 2017
================================================

### ATSD

| Issue         | Category        | Tracker | Subject                                                                             |
|---------------|-----------------|---------|-------------------------------------------------------------------------------------|
| [3773](#issue-3773) | sql             | Bug     | Implemented rules for numeric precedence. If several metrics with different datatypes are queried, no data will be lost because of a lack of precision. |
| 3770 | api-rest        | Bug     | Removed exact match flags in series queries, which was resulting in empty result sets. |
| [3769](#issue-3769) | sql             | Bug     | Updated `LOOKUP` function to include support tags. |
| [3768](#issue-3768) | sql             | Feature | Revised the `CONCAT` function to accept numeric arguments. |
| [3767](#issue-3767) | sql             | Feature | Updated the `CAST` function to accept string arguments. |
| [3764](#issue-3764) | sql             | Bug     | For created metrics without any data, updated the query response from NPE to return an empty result set. |
| [3763](#issue-3763) | sql             | Bug     | Updated the `SELECT 1` query to return exactly one row containing columns included in the `SELECT` expression. |
| [3480](#issue-3480) | api-rest        | Feature | Added series data text and and automated testing for the `text` column. |
| 2814 | UI              | Bug     | Allowed for displaying the 'Name' field for unsaved item in the last breadcrumbs section. |

### Charts

| Issue         | Category        | Tracker | Subject                                                                             |
|---------------|-----------------|---------|-------------------------------------------------------------------------------------|
| [3481](#issue-3481) | widget-settings | Feature | Updated `getTags()` or `getSeries()` requests for metadata for metrics and entities. Now tags or series can be provided in JSON format. | 
| [3078](#issue-3078) | widget-settings | Feature | Add new series query settings `exact-match` and `interpolate-extend`. |
| [2928](#issue-2928) | widget-settings | Feature | Changed setting name from `interpolate` to `fill-value` to decrease overloading. |

### Collector

| Issue         | Category        | Tracker | Subject                                                                             |
|---------------|-----------------|---------|-------------------------------------------------------------------------------------|
| [3755](#issue-3755) | docker          | Feature | Added new condition to request container properties with or without specifying size metrics. | 
| 3752 | docker          | Bug     | Implemented the removal of old, stored properties (from a local database) for Docker entities when their properties are being requested. Added the initialization of entity tags (container, status) without Docker events. | 
| 3734 | docker          | Bug     | Fixed issue with stopped container status not being instantly updated. | 
| 3733 | docker          | Bug     | Eliminated Docker lock, which resulted in the collection all statistics being stopped. |


### Issue 3769
--------------

Fixed the `LOOKUP` function so that now it can accept series, metric, and entity tags. 

```sql
SELECT datetime, value, metric, metric.tags.digital_set 
  ,LOOKUP('BatchAct', value) AS VAL
  ,LOOKUP(metric.tags.digital_set, value) AS VALTAG
FROM 'ba:active.1' 
  LIMIT 10
```

```ls
| datetime                 | value  | metric      | metric.tags.digital_set | VAL      | VALTAG   | 
|--------------------------|--------|-------------|-------------------------|----------|----------| 
| 2016-11-02T18:00:06.000Z | -65536 | ba:active.1 | BatchAct                | Inactive | Inactive | 
| 2016-11-02T18:10:06.000Z | -65537 | ba:active.1 | BatchAct                | Active   | Active   | 
```

### Issue 3768
--------------

### Issue 3767
--------------

### Issue 3763
--------------

| 1 |
|---|

| 1 |
|---|
| 1 |


### Issue 3480
--------------

### Issue 3481
--------------

### Issue 3078
--------------

### Issue 2928
--------------

### Issue 3755
--------------

### Issue 3773
--------------

### Issue 3764
--------------
