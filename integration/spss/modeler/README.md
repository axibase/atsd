# IBM SPSS Modeler


## Overview

The IBM SPSS Modeler provides a set of tools to build data transformations and analysis models for users without programming experience. The following guide includes examples of loading time series data from the Axibase Time Series Database (ATSD),
calculating derived time series in the IBM SPSS Modeler interface and storing the results back in ATSD.

## Sample Dataset

For the purpose of instruction, we will use the following [sample series commands](resources/commands.txt).
The series contain the Consumer Price Index (CPI) for each category
of items in a consumer's basket as well as a weight for each category in the CPI
basket. The weights are stored as fractions of 1000. The CPI is tracked from 2013 to
2017 and uses Year 2016 values as the baseline. Weight values are available only for
year 2017.

To load the data into ATSD, log in to the database web interface and submit
these commands on the **Metrics > Data Entry** page.

![](images/metrics_entry.png)

## Prerequisites

- Install IBM SPSS Modeler, version 18
- Install [ODBC-JDBC bridge](../../odbc/README.md).

## Create Data Source

- Create a new stream. A stream is a configuration that includes all the steps to load and analyze the data in the SPSS Modeler. 

- Select the **Sources** tab from the bottom panel and choose **Database** 

  ![](images/modeler_1.png)

- Add the **Database** source to the stream by dragging-and-dropping it into the stream workspace.

  ![](images/modeler_2.png)

- Right click on the source and click **Edit...**

  ![](images/modeler_3.png)

- Expand the **Data source** menu and choose **Add new database connection**

  ![](images/modeler_4.png)
  
- Choose ATSD ODBC as the data source. If there are no data sources visible - create an ODBC-bridged connection to ATSD as described [here](../../odbc/README.md#configure-odbc-data-source) and click **Refresh**

  ![](images/modeler_5.png)
  
- Enter your username and password and click **Connect**

  ![](images/modeler_6.png)
  
- The connection should be visible in the **Connections** table

  ![](images/modeler_7.png)
  
- Click **OK**. Select the newly created ATSD data source.

  ![](images/modeler_8.png)
  
- Click **Select...** to view the list of available ATSD tables. The list of tables is based on the `tables=` property specified in the JDBC URL. If you don't see the desired table in the list, update ODBC data source as described [here](../../odbc/table-config.md), delete your connection in SPSS Modeler and create it again. Specify `tables=%` to view all tables in ATSD.

  ![](images/modeler_9.png)
  
- Uncheck the **Show table owner** box shown below, select `inflation.cpi.categories.price` table and click **OK**

  ![](images/modeler_10.png)
  
- Check **Never** in **Quote table and column names** 

  ![](images/modeler_11.png)
  
- Go to **Filter** tab and click on the respective arrows in the Filter column to disable the `time`, `text` and `metric` columns.

  ![](images/modeler_12.png)
  
- Database source setup is finished. Click **Preview** to verify the results by reviewing the first 10 rows in the table.

  ![](images/modeler_13.png)

  ![](images/modeler_14.png)
  
- Close the preview table and click **OK** in database source settings window to save changes.

- Repeat these steps to create another data source for table `inflation.cpi.categories.weight`
  
  ![](images/modeler_15.png)
  
## Join Tables

- Select the **Record Ops** tab in the bottom panel, choose the **Merge** node and add it to the stream

  ![](images/modeler_16.png)
  
- Right click on one of the database source shapes and select **Connect...**

  ![](images/modeler_17.png)

- Select **Merge** shape. A link should appear between the source and the **Merge** shapes.

  ![](images/modeler_18.png)
  
- Connect the other source with the **Merge** shape using the same technique.

  ![](images/modeler_19.png)
  
- Right click on the **Merge** shape and select **Edit...**. Set **Merge method** to **Keys**
and add the `tags` field to **Keys for merge** field

  ![](images/modeler_20.png)
  
- Open the **Filter** tab and disable `entity` and `datetime` fields for the `inflation.cpi.categories.weight` table.

  ![](images/modeler_21.png)
  
- Rename the `value` field in the `inflation.cpi.categories.price` table to `price` and the `value` field
in `inflation.cpi.categories.weight` to `weight`

  ![](images/modeler_22.png)
  
- Click **Preview** button to check the results

  ![](images/modeler_23.png)
  
- Close the **Preview** window and click **Ok** to save changes.

## Calculate Weighted Price

- Select the **Field Ops** tab in the bottom panel, choose the **Derive** shape and
add it to the stream.

  ![](images/modeler_24.png)
  
- Connect the **Merge** and **Derive** shapes

  ![](images/modeler_25.png)
  
- Right click on the **Derive** shape and select **Edit...**
  - Set **Derive field** to **weighted_price**
  - Set field type to **Continuous**
  - Add the formula **price * weight / 1000**
  
  ![](images/modeler_26.png)
  
- Click **Preview** button to check results. You should see the **weighted_price** column.

  ![](images/modeler_27.png)
  
- Close the **Preview** window and click **Ok** to save changes.

## Calculate Weighted Inflation per Year

- Select the **Record Ops** tab, choose the **Aggregate** shape and add it to the stream.

  ![](images/modeler_28.png)
  
- Connect the **Derive** (weighted_price) and **Aggregate** shapes

  ![](images/modeler_29.png)
  
- Right click on the **Aggregate** shape and select **Edit...**
  - Add `datetime` in **Key fields**
  - Uncheck the **Include record count in field** box. 

  ![](images/modeler_30.png)
  
- In the **Aggregate expressions** table, enter the field name `value` and click **Launch expression builder**

  ![](images/modeler_31.png)
  
- In the Expression Builder window, enter the formula `SUM('weighted_price')` and click **OK**

  ![](images/modeler_32.png)
  
- Click the **Preview** button to check the results

  ![](images/modeler_33.png)

- Close the preview table and click **OK** to save the changes.

## Add Entity Field

- Select the **Field Ops** tab, choose the **Derive** shape and
add it to the stream

  ![](images/modeler_34.png)
  
- Connect the **Aggregate** and **Derive** shapes

  ![](images/modeler_35.png)
  
- Right click on the **Derive** shape and select **Edit...**
  - Set the **Derive field** to **entity**
  - Set field type to **Categorical**
  - Add formula **"bls.gov"**

  ![](images/modeler_36.png)
  
- Click the **Preview** button to check the results. The**entity** column should have been added.

  ![](images/modeler_37.png)
  
- Close the preview table and click **OK** to save changes.

## Export Results

- Select the **Export** tab, choose the **Database** shape and
add it to the stream

  ![](images/modeler_38.png)
  
- Connect the **Derive** (entity) and **Database** shapes

  ![](images/modeler_39.png)
  
- Right click on the **Database** shape and select **Edit...**
  - Choose **Data source**
  - Type `inflation.cpi.composite.price` in **Table name**. This will be the name of the new metric inserted into ATSD.
  - Select the **Insert into table** option
  - Set **Quote table and column names** to **Never**

  ![](images/modeler_40.png)
  
- Click the **Advanced...** button

  ![](images/modeler_41.png)
  
- In the Advanced Options window
  - Check **Use batch commit**
  - Set batch size large enough to load all your export data in a single batch
  - Set **Use bulk loading** to **Via ODBC**
  - Click **OK** to save and exit.

  ![](images/modeler_42.png)
  
- Click **Run** to export data into ATSD

  ![](images/modeler_43.png)

## Verify Insertion

To check that data is successfully exported to ATSD go to the ATSD web interface, click **SQL** and execute the
following query

```sql
SELECT entity, datetime, value 
  FROM inflation.cpi.composite.price
```

  ![](images/query_result.png)
  
## Stream File

Download the [stream file](resources/Stream.str) used for this guide for review in your own IBM SPSS Modeler installation.
