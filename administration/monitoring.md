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
|api_command_malformed_per_second| Number of malformed (invalid) API commands discarded.|	
|cache.size| Number of records kept in cache. Cache size and usage are also displayed on **Admin>Cache Management** page.|	
|cache.used_percent| Cache used percentage. The cache size is displayed on **Admin>Cache Management** page.|
|disabled_entity_received_per_second|Number of series commands with disabled entity received.|	
|disabled_metric_received_per_second|Number of series commands with disabled metric received.|	
|disabled_properties_received_per_second|Number of property commands received by the database when `Property Enabled` was checked on Input Settings page.|	
|disk_totalspace|Total size of the file system where database is installed, in bytes.|	
|disk_unallocatedspace|Available space on the file system where database is installed, in bytes.|	
|disk_usablespace|Used space on the file system where database is installed, in bytes.|	
|email_notifications_per_minute |Number of email notifications sent by the rule engine. |	
|expired_metric_received_per_second |Number of series commands with timestamp earlier than specified by Time Filter in the rule engine. |	
|forward_metric_received_per_second |Number of series commands with timestamp greater than specified by Time Filter in the rule engine. |	
|filtered_metric_received_per_second|Number of metrics which have been discarded due to `Invalid Value Action`.|	
|gc_invocations_per_minute |Number of the Java garbage collection calls.|
|gc_time_percent |The percentage of cpu time used by the Java garbage collector.|	
|hbase.thread_pool_active|Number of active clients writing into HBase.|	
|hbase_scans_per_second |Number of HBase scans. |
|http.sessions|Number of http sessions.|	
|http.thread_pool_idle|Number of http server threads in waiting state. |	
|http.thread_pool_max|The maximum number of http server threads.|	
|http.thread_pool_used|Number of http server threads that are in use.|	
|http.thread_pool_used_percent|Percentage of used http server threads.|	
|invalid_message_received_per_second | Number of invalid message commands received. |
|invalid_property_received_per_second| Number of invalid property commands received.|	
|java_method_invoke_average | Number of times a Java method was invoked in a given period, in milliseconds. |
|java_method_invoke_count_per_second | Rate of Java method invokation in a given period. |
|java_method_invoke_last | Last execution time for the Java method in a given period, in milliseconds. |
|jvm_committed_virtual_memory_size|Committed JVM virtual memory, in bytes.|	
|jvm_free_physical_memory_size|Free physical memory on the machine, in bytes.|	
|jvm_free_swap_space_size| Free swap space on the machine, in bytes.|	
|jvm_max_file_descriptor_count|The maximum number of file descriptors.|	
|jvm_memory_free | Free memory available to the java virtual machine, in bytes. |	
|jvm_memory_max | Maximum memory available to the JVM, in bytes. |
|jvm_memory_used | Memory used by the JVM, in bytes. |	
|jvm_memory_used_percent | Percentage of memory by the JVM. |
|jvm_memorypool_used|JVM memory pool usage, in bytes.|
|jvm_open_file_descriptor_count|Number of open file descriptors.|	
|jvm_process_cpu_load|CPU used by the JVM process.|	
|jvm_system_cpu_load|CPU busy on the machine.|	
|jvm_system_load_average|System load average for the last minute on the machine. |	
|jvm_total_physical_memory_size|Total amount of physical memory on the machine, in bytes.|	
|jvm_total_swap_space_size| Total amount of swap spaceon the machine, in bytes.|	
|last.series.cache.count|Number of records in the 'last insert' cache.|	
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
