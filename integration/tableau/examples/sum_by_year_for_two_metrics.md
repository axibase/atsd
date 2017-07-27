# SUM by Year for Two Metrics

## Overview

Report showing the differences between two metrics on separate graphs.

## Data Source

* Tables: `bi.im_net1.m` and `bi.ex_net1.m`

## Steps

- Drag-and-drop both tables to Canvas area
- Select _Inner Join_, specify _Time_ and _Entity_ as equal fields:

![](../images/join_inner.png)

- Press **Sheet 1**
- Press **OK** to acknowledge the warning about limitations
- Drag-and-drop _Datetime_ onto the column field
- Drag-and-drop both _Value_ onto the rows field
- Select _Bar_ in the dropdown at the _All_ section on Marks Card
- Optionally add [drop lines](comparision_of_two_metrics_at_one_bar_graph.md#drop-lines)

## Results

![](../images/sum_by_year_for_rwo_metrics.png)
