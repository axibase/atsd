# Export - Import by year

## Overview

By analogy with [Max-Min by year for one metric](max-min_by_year_for_one_metric.md) let's build a report illustrating the difference between the export and import each year.

## Data Source

- Tables: `bi.ex_net1.m` and `bi.im_net1.m`

## Steps

> Don't forget to specify at least time/datetime and entity in INNER/FULL OUTER join
 
- Drag-and-drop _Datetime_ onto the column field
- Rename both _Value_ onto 'Export Value' and 'Import Value'
- Copy: _[Export Value] - [Import Value]_ > double click on the rows field > paste > **Enter**
- Right click on calculation > **Dimension**
- Select _Line_ in drop-down at Marks Card

## Results
![](../images/export_import.png)