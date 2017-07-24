# Detailed values by date (no aggregation) for two metric

## Overview
There is an explanation of how to visualize two metrics at one sheet.

## Data Source

- Tables: `bi.ex_net1.m` and `bi.im_net1.m`

## Steps

- Drag-and-drop each of them to the Data Source Pane.
- Select _Inner Join_, specify _Time_ and _Entity_ as equal fields:

![](../images/join_inner.png)

> Note you should specify at least time/datetime and entity, otherwise ATSD will rise an error.
> You shouldn't combine INNER and FULL OUTER joins due to Tableau sends invalid queries into ATSD.
> There is only the equals (=) comparison operator can used in  joins.
> LEFT/RIGHT joins are not supported.

- Drag-and-drop _Datetime_ onto the columns field (you can use any of _Datetime_), change from **YEAR** aggregation to _Exact Date_ 
- Drag-and-drop both _Value_ onto the rows field, change from **SUM** aggregation to _Dimension_
- Specify color: _Marks_ > _Value_ (you can use any of _Value_) > _Color_
- Specify shape: _Marks_ > _Value_ (you can use any of _Value_) > _Shape_

## Results

It is possible to compare two metrics now:

![](../images/two_metrcS.png)

