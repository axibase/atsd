# Monitoring Metrics using Ingestion Statistics

Metric ingestion statistics are available on the **Settings > Receive Statistics** page.

The number of `top-N` rows displayed can be adjusted.

The statistics allows you to:

* View top-N metric and entities for up to the last 24
    hours ranked by the samples inserted into the database.
* Configure metric filters to discard particular entity/metric/tag
    combinations from being stored in the database.
* Modify metric retention intervals (default is unlimited retention) to
    reduce the amount of storage used.
* Qualify some metrics as non-persistent to use their data only in the
    rule engine without storing it on disk.

[Learn how to configure the metric persistence filter
here.](../metric-persistence-filter.md)

![](./images/ingestion_statistics_new.png "ingestion_statistics")
