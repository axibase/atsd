# Configuring the Data Source in IBM SPSS Statistics

* Open the attached scripts:

[`weight.sps`](./resources/weight.sps)

![](./images/spss_1.png)

[`price.sps`](./resources/price.sps)

![](./images/price.sps.png)

* Right-click the script window and select **Run All** to export the data into ATSD.

![](./images/run_all.png)

The script connects to ATSD (`CONNECT='DSN=ATSD'`), executes the query specified in the `SQL` variable and displays the dataset.

![](./images/script_results.png)