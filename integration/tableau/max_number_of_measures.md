# Max number of measures

Let's try to understand which day contains max number of measures.
 
 
We will need `bi.ex_net1.m` metric:

 - Drop _Datetime_ to the Marks Card, **Right-click** on the _Year -> Day_, replace _Detail_ with _Color_
 - Drag _Value_ to the Marks Card, change aggregation from SUM to COUNT, replace _Detail_ with _Angle_
 - Drop _Datetime_ to the Marks Card, **Right-click** on the _Year -> Day_, replace _Detail_ with _Label_
 
 The greatest number of records were made the 31st:
 
 ![](images/pie.png)