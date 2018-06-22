# Max Records by Day of Month

## Overview

Build a report showing the number of filings per day of month.

## Data Source

* Table: `bi.ex_net1.m`

## Steps

* Drag-and-drop the table to Canvas area
* Click **Sheet 1**
* Click **OK** to acknowledge the warning about limitations
* Drag-and-drop `Datetime` to the Marks Card, right-click **Year > Day**, replace `Detail` with `Color`
* Drag-and-drop `Datetime` to the Marks Card, right-click **Year > Day**, replace `Detail` with `Label`
* Change `Automatic` to `Pie` in drop-down on the Marks Card
* Drag-and-drop `Value` to the Marks Card, change aggregation from **SUM** to **COUNT**, replace `Detail` with `Angle`

## Results

Most records were reported on the 31st day of month:

![](../images/pie.png)
