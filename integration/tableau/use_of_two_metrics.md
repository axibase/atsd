# Use of two metrics

There is an explanation of how to visualize two metrics at one sheet.

We will need `bi.ex_net1.m` and `bi.im_net1.m` metrics:

- Drop each of them to Data Source Pane.
- Select _Inner Join_, specify _Time_ and _Entity_ as equal fields:

![](images/inner_Join.png)

> Note you should specify at least time/datetime and entity, otherwise ATSD will rise an error.

- Drag _Datetime_ to the columns field (you can use any of _Datetime_), change from YEAR aggregation to _Exact Date_ 
- Drag both _Value_ to the rows field, change from SUM aggregation to _Dimension_
- Specify color:_Marks_ - _Value_ (you can use any of _Value_) - _Color_
- Specify shape:_Marks_ - _Value_ (you can use any of _Value_) - _Shape_

It is possible to compare two metrics now:

![](images/two_metrcS.png)

Let's try to see the difference between the total values of each year for consider metrics:

- Clear columns and rows fields
- Drop _Datetime_ to the column field
- Drag both _Value_ to the rows field
- Drag _Measure Values_ to Filters Card 
- Drag _Measure Values_ to Marks Card, check only _Value_ boxes in appeared window, press **OK**
- Show Me Card -> _side-by-side bars_ 

![](images/Sheet.png)

It would be useful to add _Drop Lines_ and labels:

- Select some column
- _Right-Click -> Drop Lines -> Show Drop Lines_
- _Right-Click -> Drop Lines -> Edit Drop Lines -> Labels -> Automatic_

You can click Ctrl+W and swap columns and rows:

![](images/drop_lines_and_labels.png)