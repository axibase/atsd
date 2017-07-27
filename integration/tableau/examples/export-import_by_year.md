# Export - Import by Year

## Overview

Build a report illustrating the differences between exports and imports each year.

## Data Source

- Tables: `bi.ex_net1.m` and `bi.im_net1.m`

## Steps

- Drag-and-drop both tables to Canvas area
- Select _Inner Join_, specify _Time_ and _Entity_ as equal fields:

![](../images/join_inner.png)

- Press **Sheet 1**
- Press **OK** to acknowledge the warning about limitations
- Drag-and-drop _Datetime_ onto the column field
- Rename both _Value_ into 'Export Value' and 'Import Value'
- Copy: _[Export Value] - [Import Value]_ > double click on the rows field > paste > **Enter**
- Right click on calculation > **Dimension**
- Select _Line_ in the dropdown at Marks Card

## Results

![](../images/export_import.png)
