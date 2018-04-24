# Export - Import by Year

## Overview

Build a report illustrating the differences between exports and imports each year.

## Data Source

- Tables: `bi.ex_net1.m` and `bi.im_net1.m`

## Steps

- Drag-and-drop both tables to Canvas area
- Select `Inner Join`, specify `Time` and `Entity` as equal fields:

![](../images/join_inner.png)

- Press **Sheet 1**
- Press **OK** to acknowledge the warning about limitations
- Drag-and-drop `Datetime` onto the column field
- Rename both `Value` into 'Export Value' and 'Import Value': right click on `Value` and choose **Rename**
- Copy: `[Export Value]-[Import Value]` > double click on the rows field > paste > **Enter**
> In case of error remove ']' and select value from tooltip
- Right click on calculation > **Dimension**
- Select `Line` in the dropdown at Marks Card
- Optionally add [drop lines](comparison_of_two_metrics_at_one_bar_graph.md#drop-lines)

## Results

![](../images/export_import.png)
