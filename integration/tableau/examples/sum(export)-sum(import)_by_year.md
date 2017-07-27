#  SUM(Export)-SUM(Import) by Year

## Data Source

* Tables: `bi.im_net1.m` and `bi.ex_net1.m`

## Steps

- Drag-and-drop both tables to Canvas area
- Select _Inner Join_, specify _Time_ and _Entity_ as equal fields:

![](../images/join_inner.png)

- Press **Sheet 1**
- Press **OK** to acknowledge the warning about limitations
- Drag-and-drop _Datetime_ onto the column field
- Rename both _Value_ to 'Export Value' and 'Import Value'
- Copy: `SUM([Export Value]) - SUM([Import Value])` > double click on the rows field > paste > **Enter**

## Results

![](../images/sum.png)
