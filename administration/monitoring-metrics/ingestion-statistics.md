# Monitoring Metrics using Ingestion Statistics


ATSD ingestion statistics can be viewed directly from the ATSD user interface under
Admin -\> Receive Statistics.

Direct url: `atsd_hostname:8088/admin/receive-statistics?n=20`

The number of top-N rows displayed can be adjusted by changing the `n`
parameter in the request URL.

Receiving ingestion statistics allows you to:

-   View top-N metric and entities for up to the last 24
    hours ranked by the number of series samples inserted into ATSD.
-   Configure metric filters to discard particular entity/metric/tag
    combinations from being stored in the database.
-   Modify metric retention intervals (default is unlimited retention) to
    reduce the amount of storage used.
-   Qualify some metrics as non-persistent to use their data only in the
    rule engine without storing it on disk.

[Learn how to configure the metric persistence filter
here.](../metric-persistence-filter.md)

![](images/ingestion_statistics_new.png "ingestion_statistics")
