# Viewing Metrics on the Local File System

To view ATSD metrics on the local file system, you can open the `metrics.txt` file which is updated continuously. This file
can be downloaded from the Server Logs page located under the **Settings** tab on the main menu of ATSD.

![atsd metrics file](./images/server_logs_metrics.png "server_logs_metrics")

Example `metrics.txt` file:

```elm
 api_command_malformed_per_second=0.0
 com.axibase.tsd.hbase.dao.EntityDaoImpl.processEntities:java_method_invoke_average=20.0
 com.axibase.tsd.hbase.dao.EntityDaoImpl.processEntities:java_method_invoke_count_per_second=0.016661390559656108
 com.axibase.tsd.hbase.dao.EntityDaoImpl.processEntities:java_method_invoke_last=20.0
 com.axibase.tsd.hbase.dao.LastSeriesDaoImpl.findEntitiesForMetric:java_method_invoke_average=0.0
 com.axibase.tsd.hbase.dao.LastSeriesDaoImpl.findEntitiesForMetric:java_method_invoke_count_per_second=0.016661390559656108
 com.axibase.tsd.hbase.dao.LastSeriesDaoImpl.findEntitiesForMetric:java_method_invoke_last=0.0
 com.axibase.tsd.hbase.dao.LastSeriesDaoImpl.putBatch:java_method_invoke_average=2.0
 com.axibase.tsd.hbase.dao.LastSeriesDaoImpl.putBatch:java_method_invoke_count_per_second=0.06658676255160474
 com.axibase.tsd.hbase.dao.LastSeriesDaoImpl.putBatch:java_method_invoke_last=2.0
 com.axibase.tsd.hbase.dao.MessageDaoImpl.putBatch:java_method_invoke_average=0.0
 com.axibase.tsd.hbase.dao.MessageDaoImpl.putBatch:java_method_invoke_count_per_second=0.3995205753096284
 com.axibase.tsd.hbase.dao.MessageDaoImpl.putBatch:java_method_invoke_last=0.0
 com.axibase.tsd.hbase.dao.MetricDaoImpl.getMetricByName:java_method_invoke_average=0.25
 com.axibase.tsd.hbase.dao.MetricDaoImpl.getMetricByName:java_method_invoke_count_per_second=0.06664556223862443
 com.axibase.tsd.hbase.dao.MetricDaoImpl.getMetricByName:java_method_invoke_last=0.0
 com.axibase.tsd.hbase.dao.PropertyDaoImpl.save:java_method_invoke_average=4.0
 com.axibase.tsd.hbase.dao.PropertyDaoImpl.save:java_method_invoke_count_per_second=0.06658676255160474
 com.axibase.tsd.hbase.dao.PropertyDaoImpl.save:java_method_invoke_last=4.0
 com.axibase.tsd.hbase.dao.PropertyDaoImpl.search:java_method_invoke_average=0.5833333333333334
 com.axibase.tsd.hbase.dao.PropertyDaoImpl.search:java_method_invoke_count_per_second=0.3998733734317466
 com.axibase.tsd.hbase.dao.PropertyDaoImpl.search:java_method_invoke_last=0.0
 com.axibase.tsd.hbase.dao.TimeSeriesDaoImpl.putBatch:java_method_invoke_average=12.25
 com.axibase.tsd.hbase.dao.TimeSeriesDaoImpl.putBatch:java_method_invoke_count_per_second=0.5333688912594173
 com.axibase.tsd.hbase.dao.TimeSeriesDaoImpl.putBatch:java_method_invoke_last=1.0
 com.axibase.tsd.service.TimeSeriesServiceImpl.putBatch:java_method_invoke_average=12.375
 com.axibase.tsd.service.TimeSeriesServiceImpl.putBatch:java_method_invoke_count_per_second=0.5326941004128379
 com.axibase.tsd.service.TimeSeriesServiceImpl.putBatch:java_method_invoke_last=1.0
 com.axibase.tsd.service.message.MessageServiceImpl.putBatch:java_method_invoke_average=0.0
 com.axibase.tsd.service.message.MessageServiceImpl.putBatch:java_method_invoke_count_per_second=0.3995205753096284
 com.axibase.tsd.service.message.MessageServiceImpl.putBatch:java_method_invoke_last=0.0
 com.axibase.tsd.web.:java_method_invoke_average=568.0
 com.axibase.tsd.web.:java_method_invoke_count_per_second=0.06666666666666667
 com.axibase.tsd.web.:java_method_invoke_last=568.0
 disabled_entity_received_per_second=0.0
 disabled_metric_received_per_second=0.0
 disabled_properties_received_per_second=0.0
 email_notifications_per_minute=0.0
 expired_metric_received_per_second=0.0
 filtered_metric_received_per_second=0.0
 forward_metric_received_per_second=0.0
 gc_invocations_per_minute_PS_MarkSweep=0.0
 gc_invocations_per_minute_PS_Scavenge=1.0
 gc_time_percent_PS_MarkSweep=0.0
 gc_time_percent_PS_Scavenge=0.07666666666666666
 hbase_scans_per_second=0.0
 http.sessions=1
 http.thread_pool_idle=34
 http.thread_pool_max=250
 http.thread_pool_used=16
 http.thread_pool_used_percent=6.4
 invalid_message_received_per_second=0.0
 invalid_property_received_per_second=0.0
 jvm_memory_free=395131712
 jvm_memory_max=477102080
 jvm_memory_used=81970368
 jvm_memory_used_percent=17.180886740212912
 last.series.cache.count=516
 last.series.cache.write-count=1
 last.series.cache.write-keys=10.446470157695122
 last.series.cache.write-new-keys=3
 last.series.cache.write-time=3
 message_reads_per_second=0.0
 message_received_per_second=0.0
 message_writes_per_second=0.0
 metric_reads_per_second=0.0
 metric_received_per_second=10.779160290105796
 metric_writes_per_second=15.969126355712289
 network_command_ignored_per_second=0.0
 network_command_malformed_per_second=0.0
 non_persistent_metric_received_per_second=0.0
 properties_pool_active_count=0
 properties_queue_size=0
 properties_rejected_count=0
 property_deleted_per_second=0.0
 property_reads_per_second=0.0
 property_received_per_second=0.73191829130348
 property_writes_per_second=0.73191829130348
 series_pool_active_count=0
 series_queue_size=0
 series_rejected_count=0
 web_service_notifications_per_minute=0.0
```
