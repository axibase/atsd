# SUM by year for two metrics

## Overview

We already know how to see [difference between two metrics at one bar graph](comparision_of_two_metrics_at_one_bar_graph.md), let's find out how to do it at separate graphs.

## Data Source

* Tables: `bi.im_net1.m` and `bi.ex_net1.m`

## Steps

> Don't forget to specify at least time/datetime and entity in INNER/FULL OUTER join

- Drag-and-drop _Datetime_ onto the column field
- Drag-and-drop both _Value_ onto the rows field
- Change _Automatic_ to _Bar_ in drop-down at _All_ section at Marks Card

## Results

![](../images/sum_by_year_for_rwo_metrics.png)