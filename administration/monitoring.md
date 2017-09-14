# Monitoring

ATSD performance metrics can be retrieved via JMX, file, or a http/JSON
request.

These metrics are updated every 15 seconds and can be used to monitor
the internal components of the Axibase Time Series Database, such as the
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

## Collected Metrics

Retrieve a full list of collected metrics in JSON:

```sh
 http://atsd_server:8088/jmx?query=com.axibase.tsd:name=metrics           
```

List of collected metrics:

| Metric | Description |
| --- | --- |
|api_command_malformed_per_second| Number of API commands were dropped because they were not valid.|	
|cache.size| Number of used memory bytes by the cache.|	
|cache.used_percent| Percentage of memory used by the cache.|	
|disabled_entity_received_per_second||	
|disabled_metric_received_per_second||	
|disabled_properties_received_per_second||	
|disk_totalspace|The size, in bytes, of the ATSD store.|	
|disk_unallocatedspace|Number of unallocated bytes in the ATSD store.|	
|disk_usablespace|Number of bytes available to this Java virtual machine on the ATSD store.|	
|email_notifications_per_minute |Number of email notifications sent by ATSD Rule Engine per minute. |	
|expired_metric_received_per_second |Number of metrics that satisfy the following rule: `now - timestamp > 1 hour` |	
|filtered_metric_received_per_second||	
|forward_metric_received_per_second | Number of metrics that satisfy the following rule: `timestamp - now > 1 hour` |	
|gc_invocations_per_minute_MarkSweepCompact | Number of MarkSweepCompact gc invocations per minute.|	
|gc_time_percent_MarkSweepCompact |The percentage of time spent by MarkSweepCompact|	
|hbase.thread_pool_active|The size (number of active clients) of the htable.executor.PoolSize.|	
|hbase_scans_per_second | Number of HBase searches per second. |
|http.sessions|Number of Jetty sessions.|	
|http.thread_pool_idle||	
|http.thread_pool_max||	
|http.thread_pool_used||	
|http.thread_pool_used_percent||	
|invalid_message_received_per_second | Number of invalid messages received per second. |
|invalid_property_received_per_second| Number of invalid properties received per second.|	
|java_method_invoke_average java_method_invoke_count_per_second java_method_invoke_last | Tracks storage performance methods. Three different aggregations, `average`, `count per second` and `last`, are collected for the following methods: `dao.MessageDaoImpl.putBatch` `dao.PropertyDaoImpl.search` `dao.TimeSeriesDaoImpl.putBatch` `service.TimeSeriesServiceImpl.putBatch` Last and Average are collected as time in ms. |	
|jvm_committed_virtual_memory_size|The amount of virtual memory that is guaranteed to be available to the running process in bytes.|	
|jvm_free_physical_memory_size|The amount of free physical memory in bytes.|	
|jvm_free_swap_space_size| The amount of free swap space in bytes.|	
|jvm_max_file_descriptor_count|The maximum number of file descriptors.|	
|jvm_memory_free | Number of free memory bytes available to the java virtual machine. |	
|jvm_memory_max | Maximum number of memory space available to the java virtual machine, in bytes. |
|jvm_memory_used | Number of used memory bytes by the java virtual machine. |	
|jvm_memory_used_percent | Percentage of memory used by the java virtual machine. |	
|jvm_memorypool_used|An estimate of the current usage of a memory pool.|	
|jvm_open_file_descriptor_count|The number of open file descriptors.|	
|jvm_process_cpu_load|The "recent cpu usage" for the Java Virtual Machine process.|	
|jvm_system_cpu_load|The "recent cpu usage" for the whole system.|	
|jvm_system_load_average|The system load average for the last minute. The system load average is the sum of the number of runnable entities queued to the available processors and the number of runnable entities running on the available processors averaged over a period of time. The way in which the load average is calculated is operating system specific but is typically a damped time-dependent average.|	
|jvm_total_physical_memory_size|The total amount of physical memory in bytes.|	
|jvm_total_swap_space_size| The total amount of swap space in bytes.|	
|last.series.cache.count||	
|last.series.cache.write-count||	
|last.series.cache.write-keys||	
|last.series.cache.write-new-keys||	
|last.series.cache.write-time||	
|message_reads_per_second|Number of messages read from disk per second.|	
|message_received_per_second | Number of messages received per second. |	
|message_writes_per_second | Number of messages stored on disk per second. |	
|metric_append_concat_per_second||	
|metric_append_per_second||	
|metric_reads_per_second | Number of metrics read from disk per second. |
|metric_received_per_second | Number of metrics received per second. |	
|metric_writes_per_second | Number of metrics stored on disk per second. |
|network_command_ignored_per_second|Number of TCP and UDP commands were skipped.|	
|network_command_malformed_per_second| Number of TCP and UDP commands were dropped because they were not valid.|	
|non_persistent_metric_received_per_second||	
|properties_pool_active_count||	
|properties_queue_size| Number of memory kilobytes in queue busy by property commands.|	
|properties_rejected_count|Number of discarded property commands.|	
|property_deleted_per_second||	
|property_reads_per_second | Number of properties read from disk per second. |
|property_received_per_second | Number of properties received per second. |	
|property_writes_per_second | Number of properties stored on disk per second. |	
|series_pool_active_count||	
|series_queue_size|Number of memory kilobytes in queue busy by series commands.|	
|series_rejected_count|Number of discarded series commands.|	
|table_region_count|Number of regions for each data table.|	
|table_region_server_count|Number of region servers for each data table.|	
|table_size|Summary size, in megabytes, for all regions and CFs in each data table: d, li, properties, message, tag, rule_alert.|	
|web_service_notifications_per_minute | Number of web service notifications sent by ATSD Rule Engine per minute.|