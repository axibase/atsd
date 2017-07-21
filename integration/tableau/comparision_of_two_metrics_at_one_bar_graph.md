# Comparision of two metrics at one bar graph

Let's try to see the difference between the total values of each year for export and import metrics.

We will need `bi.ex_net1.m` and `bi.im_net1.m` tables:

> Don't forget to specify at least time/datetime and entity in INNER/FULL OUTER join

- Drop _Datetime_ to the column field
- Drop both _Value_ to the rows field

> You can rename values:
> - _Right-click -> Rename_

- Show Me Card -> _side-by-side bars_ 

![](images/bars.png)

You can click Ctrl+W and swap columns and rows.

## Drop Lines
It would be useful to add _Drop Lines_ and labels:

- Select some column
- _Right-Click -> Drop Lines -> Show Drop Lines_
- _Right-Click -> Drop Lines -> Edit Drop Lines -> Labels -> Automatic_


![](images/sswap.png)