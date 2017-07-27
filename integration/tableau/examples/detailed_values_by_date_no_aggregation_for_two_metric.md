# Detailed Values by Date (No Aggregation) for Two Metrics

## Overview

Build a report displaying two metrics in one workspace.

## Data Source

- Tables: `bi.ex_net1.m` and `bi.im_net1.m`

## Steps

- Drag-and-drop both tables to Canvas area
- Select _Inner Join_, specify _Time_ and _Entity_ as equal fields:

![](../images/join_inner.png)

- Press **Sheet 1**
- Press **OK** to acknowledge the warning about limitations
- Drag-and-drop _Datetime_ onto the columns field (you can use any of _Datetime_), change from **YEAR** aggregation to _Exact Date_ 
- Drag-and-drop both _Value_ onto the rows field, change from **SUM** aggregation to _Dimension_
- Specify color: _Marks_ > _Value_ (you can use any of _Value_) > _Color_
- Specify shape: _Marks_ > _Value_ (you can use any of _Value_) > drop-down > _Shape_

## Results

Compare the two metrics:

![](../images/two_metrcS.png)

