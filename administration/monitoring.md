# Monitoring

ATSD performance metrics can be retrieved via JMX, file, or a http/JSON
request.

These metrics are updated every 15 to 60 seconds and can be used to monitor
the database state and the status of its individual components, such as the
amount of data received, memory usage, and read/write activity.

You can retrieve, test, or view the metrics using the following methods:

-   [JMX in JSON format](monitoring-metrics/json.md)
-   [JMX](monitoring-metrics/jmx.md)
-   [File](monitoring-metrics/file.md)
-   [Rule Engine](monitoring-metrics/rule-engine.md)
-   [Ingestion Statistics](monitoring-metrics/ingestion-statistics.md)
-   [Database Tables](monitoring-metrics/database-tables.md)
-   [I/O Tests](monitoring-metrics/io-tests.md)
-   [HBase Write Test](monitoring-metrics/hbase-write-test.md)
-   [Portals](monitoring-metrics/portals.md)

## Example

Retrieving a full list of collected metrics in JSON:

```sh
 http://atsd_server:8088/jmx?query=com.axibase.tsd:name=metrics           
```

## Collected metrics

| **Metric** | **Description** |
| --- | --- |
|api_command_malformed_per_second| Number of malformed (invalid) API commands discarded, per second.|	
|cache.size| Number of records kept in cache. Cache size and usage are also displayed on **Admin>Cache Management** page.|	
|cache.used_percent| Cache used percentage. The cache size is displayed on **Admin>Cache Management** page.|
|disabled_entity_received_per_second|Number of series commands with disabled entity received, per second.|	
|disabled_metric_received_per_second|Number of series commands with disabled metric received, per second.|	
|disabled_properties_received_per_second|Number of properties commands received by ATSD with skipped `Property Enabled` input setting, per second.|	
|disk_totalspace|Size of the ATSD store, in bytes.|	
|disk_unallocatedspace|Number of unallocated bytes in the ATSD store.|	
|disk_usablespace|Number of bytes available to this Java virtual machine on the ATSD store.|	
|email_notifications_per_minute |Number of email notifications sent by ATSD Rule Engine per minute. |	
|expired_metric_received_per_second |Number of metrics that satisfy the following rule: `now - timestamp > 1 hour`. |	
|filtered_metric_received_per_second|Number of metrics which have been filtered due to triggering of `Invalid Value Action`.|	
|forward_metric_received_per_second |Number of metrics that satisfy the following rule: `timestamp - now > 1 hour`. |	
|gc_invocations_per_minute_MarkSweepCompact |Number of garbage collection calls per minute.|
|gc_time_percent_MarkSweepCompact |The percentage of time in between calls that garbage collection took.|	
|hbase.thread_pool_active|Size (number of active clients) of the `htable.executor.PoolSize`.|	
|hbase_scans_per_second |Number of HBase searches, per second. |
|http.sessions|Number of Jetty sessions.|	
|http.thread_pool_idle|Number of Jetty threads in waiting state. |	
|http.thread_pool_max|The maximum number of Jetty threads that can be in the pool.|	
|http.thread_pool_used|Number of Jetty threads that are in use.|	
|http.thread_pool_used_percent|Percentage of active threads of the maximum number of threads in the pool.|	
|invalid_message_received_per_second | Number of invalid message commands received, per second. |
|invalid_property_received_per_second| Number of invalid property commands received, per second.|	
|java_method_invoke_average java_method_invoke_count_per_second java_method_invoke_last | Tracks storage performance methods. Three different aggregations, `average`, `count per second` and `last`, are collected for the following methods: `dao.MessageDaoImpl.putBatch` `dao.PropertyDaoImpl.search` `dao.TimeSeriesDaoImpl.putBatch` `service.TimeSeriesServiceImpl.putBatch` Last and Average are collected as time in ms. |	
|jvm_committed_virtual_memory_size|Amount of virtual memory that is guaranteed to be available to the running process, in bytes.|	
|jvm_free_physical_memory_size|Amount of free physical memory, in bytes.|	
|jvm_free_swap_space_size| Amount of free swap space, in bytes.|	
|jvm_max_file_descriptor_count|The maximum number of file descriptors.|	
|jvm_memory_free | Number of free memory bytes available to the java virtual machine. |	
|jvm_memory_max | Maximum number of memory space available to the java virtual machine, in bytes. |
|jvm_memory_used | Number of used memory bytes by the java virtual machine. |	
|jvm_memory_used_percent | Percentage of memory used by the java virtual machine. |
|jvm_memorypool_used|An estimate of the current usage of a memory pool.|
|jvm_open_file_descriptor_count|Number of open file descriptors.|	
|jvm_process_cpu_load|The "recent cpu usage" for the Java Virtual Machine process.|	
|jvm_system_cpu_load|The "recent cpu usage" for the whole system.|	
|jvm_system_load_average|System load average for the last minute. The system load average is the sum of the number of runnable entities queued to the available processors and the number of runnable entities running on the available processors averaged over a period of time. The way in which the load average is calculated is operating system specific but is typically a damped time-dependent average.|	
|jvm_total_physical_memory_size|Total amount of physical memory, in bytes.|	
|jvm_total_swap_space_size| Total amount of swap space, in bytes.|	
|last.series.cache.count|Current size of the cache of table li.|	
|last.series.cache.write-count|How many times during the period was made the record to the table li.|	
|last.series.cache.write-keys|Number of keys recorded in li.|	
|last.series.cache.write-new-keys|Number of the recorded keys that are not in the cache.|	
|last.series.cache.write-time|Number of milliseconds spent on a record of batch.|	
|message_reads_per_second|Number of messages read from disk, per second.|	
|message_received_per_second | Number of messages received per second. |	
|message_writes_per_second | Number of messages stored on disk, per second. |	
|metric_append_concat_per_second|Number of series commands with flag `append = true` collected immediately before data record to HBase.|	
|metric_append_per_second|Number of series commands with flag `append = true`.|	
|metric_reads_per_second |Number of metrics read from disk, per second. |
|metric_received_per_second |Number of metrics received per second. |	
|metric_writes_per_second |Number of metrics stored on disk, per second. |
|network_command_ignored_per_second|Number of TCP and UDP commands were skipped.|	
|network_command_malformed_per_second| Number of malformed (invalid) TCP and UDP commands were dropped.|	
|non_persistent_metric_received_per_second|Number of series commands with non-persistent metric received, per second.|	
|properties_pool_active_count|Number of active threads which are adding properties to ATSD.|	
|properties_queue_size| Number of property commands in the queue.|
|properties_rejected_count|Number of property commands discarded due to absence of free space in the queue provided that properties.queue.rejection.policy=DISCARD.|	
|property_deleted_per_second|Number of properties deleted from disk, per second.|	
|property_reads_per_second |Number of properties read from disk, per second. |
|property_received_per_second |Number of properties received, per second.|
|property_writes_per_second |Number of properties stored on disk, per second. |	
|series_pool_active_count|Number of active threads which are adding series to ATSD.|	
|series_queue_size|Number of series commands in the queue.|
|series_rejected_count|Number of series commands discarded due to absence of free space in the queue provided that series.queue.rejection.policy=DISCARD.|	
|table_region_count|Number of regions for each data table: d, li, properties, message, tag, rule_alert.|	
|table_region_server_count|Number of region servers for each data table: d, li, properties, message, tag, rule_alert.|	
|table_size|Summary size for all regions and CFs in each data table: d, li, properties, message, tag, rule_alert, in megabytes.|	
|web_service_notifications_per_minute | Number of web service notifications sent by ATSD Rule Engine per minute.|
