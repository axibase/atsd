# Value Aggregation

## Overview

Display the minimum exports each year.

## Data Source

* Table: `bi.ex_net1.m`

## Steps

* Drag-and-drop the table to Canvas area
* Click **Sheet 1**
* Click **OK** to acknowledge the warning about limitations
* Drag-and-drop `Value` to the Marks Card, right click > **Measure** > **Minimum**, replace _Detail_ with _Size_
* Drag-and-drop `Datetime` to the Marks Card, replace _Detail_ with `Color`
* Drag-and-drop `Datetime` to the Marks Card, right-click on the _QUARTER > YEAR_, replace _Detail_ with _Label_
* Change _Automatic_ to _Circle_ in the dropdown at Marks Card

## Results

![](../images/min_aggr.png)

We can see that in 1975, the value was equal to 109 and it is the absolute minimum among all measures in the `bi.ex_net1.m` metric:

![](../images/min_val.png)