# Monitoring Metrics using the HBase Write Test

The HBase Write Test can be launched on the **Settings > Diagnostics > I/O Tests** page.

HBase Write Test allows you to:

* Analyze the data being loaded, for example the number of unique
    metric/entity/tag combinations, and run a write throughput test.
* Launch an Auto Test to view a matrix of throughput statistics for
    different batch sizes and thread count combinations.
* Apply test results to modify the default configuration parameters in
    the ATSD `server.properties` file:

```elm
series.batch.size = 1024
series.queue.pool.size = 4
```

Auto Test Example Results:

![](./images/auto-test-1.png "auto-test-1")

| Field | Description |
| --- | --- |
| Entity prefix | Entity name prefix. |
| Metric prefix | Metric name prefix. |
| Entities count | Number of unique entities to store. |
| Metrics count | Number of unique metrics to store. |
| Series count | Total number of series to store. |
| Tags count | Number of tags in each series. Set it to an estimated number of tags that are normally present in the series. |
| Batch size | Size of each test batch. |
| Thread count | Number of threads used for each test. |
| Start time | Start timestamp for the generated series. |
| Period, minutes | Period added to the Start Time timestamp with each iteration. |
| Log interval, seconds | Interval between log outputs. |
| Auto test delay, seconds | Delay between finishing one test and starting the next test in Auto Test mode. |

![](./images/hbase_test_atsd.png "hbase_test_atsd")
