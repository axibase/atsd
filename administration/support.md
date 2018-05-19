# Support

Provide the following artifacts as part of your support request related to a server-side issue.

## 1. ATSD Version Information

* A. **Settings > System Information** page: Select/copy rows to a text file.

* B. **Settings > Server Properties** page. Select/copy rows to a text file.

## 2. Operating System Information

* A. Output of system commands:

```sh
   cat /etc/*-release
   cat /proc/version
```

## 3. Log Files

* A. Archive (tar.gz) of `*.log` and `*.zip` files in the `/opt/atsd/atsd/logs` directory.

* B. Archive (tar.gz) of the local `/opt/atsd/hadoop/logs/` directory or from the HBase HRegionServers.

* C. Archive (tar.gz) of the local `/opt/atsd/hadoop/logs/` directory or from the HDFS DataNodes.

## 4. Heap Dump File

* A. Archive (tar.gz) of the most recent `java_pid*.hprof` file in the `/opt/atsd/atsd/logs` directory.

## 5. Monitoring Statistics

* A. Screenshot of the **Portals: ATSD** portal for the time period covering the issue.

* B. Screenshot of the **Portals: ATSD Log Viewer** portal for the time period covering the issue.

* C. Screenshots from the **Portals: ATSD Metric Viewer** portal for a subset of relevant metrics.

* D. CSV Export of the following query in the SQL console. Modify the `datetime` condition to match the hour when the issue occurred.

```sql
SELECT t1.datetime, t1.value AS api_cm, t2.value AS dis_mtr, t3.value AS exp_mtr, t4.value AS flt_mtr, t5.value AS fwd_mtr,
  t6.value AS hbs_scan, t7.value AS hsess, t8.value AS hpool, t9.value AS hpool_pct, t10.value AS jvm_com_vs,
  t11.value AS jvm_fr_pmem, t12.value AS jvm_fr_swap, t13.value AS max_file, t14.value AS mem_free, t15.value AS mem_max,
  t16.value AS mem_used, t17.value AS mem_used_pct, t18.value AS open_file, t19.value AS proc_load, t20.value AS sys_cpu_load,
  t21.value AS sys_loadavg, t22.value AS tot_phys_mem, t23.value AS tot_swap, t24.value AS mtr_gets, t25.value AS mtr_reads,
  t26.value AS mtr_recv, t27.value AS mtr_writes, t28.value AS net_cmd_ign, t29.value AS net_cmd_malf, t30.value AS non_pers,
  t31.value AS ser_pool_active, t32.value AS ser_queue, t33.value AS ser_rejc
  FROM api_command_malformed_per_second t1
  JOIN disabled_metric_received_per_second t2
  JOIN expired_metric_received_per_second t3
  JOIN filtered_metric_received_per_second t4
  JOIN forward_metric_received_per_second t5
  JOIN using entity hbase_scans_per_second t6
  JOIN http.sessions t7
  JOIN http.thread_pool_used t8
  JOIN http.thread_pool_used_percent t9
  JOIN jvm_committed_virtual_memory_size t10
  JOIN jvm_free_physical_memory_size t11
  JOIN jvm_free_swap_space_size t12
  JOIN jvm_max_file_descriptor_count t13
  JOIN jvm_memory_free t14
  JOIN jvm_memory_max t15
  JOIN jvm_memory_used t16
  JOIN jvm_memory_used_percent t17
  JOIN jvm_open_file_descriptor_count t18
  JOIN jvm_process_cpu_load t19
  JOIN jvm_system_cpu_load t20
  JOIN jvm_system_load_average t21
  JOIN jvm_total_physical_memory_size t22
  JOIN jvm_total_swap_space_size t23
  JOIN metric_gets_per_second t24
  JOIN metric_reads_per_second t25
  JOIN metric_received_per_second t26
  JOIN metric_writes_per_second t27
  JOIN network_command_ignored_per_second t28
  JOIN network_command_malformed_per_second t29
  JOIN non_persistent_metric_received_per_second t30
  JOIN series_pool_active_count t31
  JOIN series_queue_size t32
  JOIN series_rejected_count t33
WHERE t1.entity = 'atsd'
  AND t1.datetime BETWEEN '2016-10-16T08:00:00Z' AND '2016-10-16T09:00:00Z'
WITH INTERPOLATE(1 MINUTE)

```