# MIN and MAX by year for one metric

## Overview

Report comparing min and max exports per year.

## Data Source

* Table:`bi.ex_net1.m`

## Steps

- Drag-and-drop _Datetime_ onto the columns field
- Drag-and-drop _Value_ onto the rows field, change aggregation from **SUM** to **MIN**
- Drag-and-drop _Value_ onto the rows field, change aggregation from **SUM** to **MAX**
- Optionally add [drop lines](comparision_of_two_metrics_at_one_bar_graph.md#drop-lines)

## Results

![](../images/max_min.png)
