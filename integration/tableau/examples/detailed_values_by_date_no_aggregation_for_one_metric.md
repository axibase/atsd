# Monthly Exports

## Overview

Display a history of export volume over a period of time.
 
## Data Source

* Table: `bi.ex_net1.m`

## Steps

- Drag-and-drop the table to Canvas area
- Press **Sheet 1**
- Press **OK** to acknowledge the warning about limitations
- Drag-and-drop `Datetime` onto the columns field, change from **YEAR** aggregation to `Exact Date`
- Drag-and-drop `Value` onto the rows field, change from **SUM** aggregation to `Dimension`
- Select `Line` in the dropdown at Marks Card
- Optionally add [drop lines](comparison_of_two_metrics_at_one_bar_graph.md#drop-lines)

## Results

![](../images/detailed_values.png)
