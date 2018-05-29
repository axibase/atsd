# Configuring the Data Source in IBM SPSS Statistics

* Open the attached scripts:

[`weight.sps`](resources/weight.sps)

![](./images/spss_1.png)

[`price.sps`](resources/price.sps)

![](./images/price.sps.png)

* Right click on the script window and select **Run All** to export the data into ATSD.

![](./images/run_all.png)

The scripts will connect to ATSD (`CONNECT='DSN=ATSD'`), execute the query specified in the `SQL` variable and display the dataset.

![](./images/script_results.png)