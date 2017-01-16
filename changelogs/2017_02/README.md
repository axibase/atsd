Weekly Change Log: January 09 - January 15, 2017
================================================

### ATSD

| Issue         | Category        | Tracker | Subject                                                                             |
|---------------|-----------------|---------|-------------------------------------------------------------------------------------|
| 3773 | sql             | Bug     | SQL: wrong type inference in query to atsd_series with multiple metrics with different types | 
| 3770 | api-rest        | Bug     | Api Series Query - Exact match remove version series from response                           | 
| 3769 | sql             | Bug     | SQL: LOOKUP function doesn't support tags, entity.tags, metric.tags fields                   | 
| 3768 | sql             | Feature | SQL: CONCAT for numbers                                                                      | 
| 3767 | sql             | Feature | SQL: CAST to string                                                                          | 
| 3764 | sql             | Bug     | SQL: Empty result set should be returned if metric exists but no data is put                 | 
| 3763 | sql             | Bug     | SELECT 1 should return row of data                                                           | 
| 3757 | sql             | Feature | External sorting algorithm investigation                                                     | 
| 3751 | api-rest        | Bug     | API: isEmpty() function parsing error                                                        | 
| 3740 | api-rest        | Bug     | Data API: series query for versioned metric doesn't provide a history of text value          | 
| 3480 | api-rest        | Feature | Data API: series insert/query - add support for 'text' column                                | 
| 2870 | api-rest        | Bug     | REST API - authentication errors - check 403 status and json format in responses             | 
| 2814 | UI              | Bug     | breadcrumbs: do not show unsaved item                                                        | 
| 2546 | applications    | Bug     | Cross-filter config update crash                                                             |

### Charts

| Issue         | Category        | Tracker | Subject                                                                             |
|---------------|-----------------|---------|-------------------------------------------------------------------------------------|
| 3481 | widget-settings | Feature | Widgets: js method to load a list of values into a list                                      | 
| 3078 | widget-settings | Feature | Widgets: add new series query settings                                                       | 
| 2928 | widget-settings | Feature | fill-value setting instead of interpolate                                                    |

### Collector

| Issue         | Category        | Tracker | Subject                                                                             |
|---------------|-----------------|---------|-------------------------------------------------------------------------------------|
| 3755 | docker          | Feature | Docker: container size                                                                       | 
| 3752 | docker          | Bug     | Docker: volume labels are different                                                          | 
| 3736 | docker          | Bug     | Docker: statistics stopped coming in                                                         | 
| 3734 | docker          | Bug     | Docker: stopped container status not instantly updated                                       | 
| 3733 | docker          | Bug     | Docker: derby locks                                                                          |
