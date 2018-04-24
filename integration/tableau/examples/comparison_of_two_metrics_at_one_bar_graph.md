# Comparison of Two Metrics in One Bar Graph

## Overview

Build a report displaying monthly exports and imports.

## Data Source

- Tables: `bi.ex_net1.m` and `bi.im_net1.m`

## Steps

- Drag-and-drop both tables to Canvas area
- Select `Inner Join`, specify `Time` and `Entity` as equal fields:

![](../images/join_inner.png)

- Press **Sheet 1**
- Press **OK** to acknowledge the warning about limitations
- Drag-and-drop `Datetime` onto the column field
- Drag-and-drop both `Value` onto the rows field
- Optionally rename values: right click on `Value` and choose **Rename**
- Show Me Card > _side-by-side bars_ 

![](../images/bars.png)

Enter `Ctrl+W` and swap columns and rows.

## Drop Lines

Add **Drop Lines** and **Labels**:

- Select a column
- Right click and choose **Drop Lines** > **Show Drop Lines**
- Right click and choose **Drop Lines** > **Edit Drop Lines** > **Labels** > **Automatic**

## Results

![](../images/sswap.png)
