#  SUM(export)-SUM(import) by year

## Data Source

* Tables: `bi.im_net1.m` and `bi.ex_net1.m`

## Steps

> Don't forget to specify at least time/datetime and entity in INNER/FULL OUTER join

- Drag-and-drop _Datetime_ onto the column field
- Rename both _Value_ to 'Export Value' and 'Import Value'
- Copy: `SUM([Export Value]) - SUM([Import Value])` > double click on the rows field > paste > **Enter**

## Results

![](../images/sum.png)