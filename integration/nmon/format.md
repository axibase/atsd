# Format

* [Snapshot Example](#snapshot-example)

* [Collected Metrics](#complete-list-of-collected-metrics)

* [Derived Metrics](#derived-metrics)

## Snapshot Example

Below is a snapshot extract from an nmon file displaying its format and how it records the collected data:

```elm
ZZZZ,T0009,23:02:43,14-OCT-2014
CPU01,T0009,58.9,27.9,6.6,6.6
CPU02,T0009,0.4,0.6,0.0,99.0
CPU03,T0009,0.1,0.3,0.0,99.6
CPU04,T0009,0.0,0.3,0.0,99.7
....
SCPU255,T0009,0.00,0.00,0.00,0.01
SCPU256,T0009,0.00,0.00,0.00,0.01
CPU_ALL,T0009,16.0,1.7,0.7,81.6,,256
PCPU_ALL,T0009,10.22,1.12,0.1,6.42,64.00
SCPU_ALL,T0009,10.22,1.12,0.1,6.42
LPAR,T0009,17.817,64,256,124,64.00,128,0.00,13.92,14.37,1,0,15.98,1.75,0.09,10.03,15.98,1.75,0.09,10.03,0,0
POOLS,T0009,124,124.00,124.00,0.00,0.00,0.00,0.00,0,64.00
MEM,T0009,43.1,98.5,451646.0,129618.0,1048576.0,131584.0
MEMNEW,T0009,40.4,4.3,12.1,43.1,15.0,41.6
MEMUSE,T0009,4.3,3.0,40.0,960,1088,4.3,40.0, 259828592.0
PAGE,T0009,19186.2,17033.4,673.6,0.0,0.0,0.0,0.0,0.0
MEMPAGES4KB,T0009,229089856,106620616,11661852,0,11661852,110641309,960,1088,0,0,110641309
MEMPAGES64KB,T0009,2459100,562547,0,0,0,1896553,60,68,0,0,1896553,0,0,1843706
LARGEPAGE,T0009,0,0,0,0,16.0
PROC,T0009,20.79,0.52,24224,113015,9105,6041,5,6,41235,0,0,0,10
FILE,T0009,0,486,0,89481716,29209504,0,0,0
NET,T0009,0.0,1569.1,4748.1,0.0,21043.1,4752.3
NETPACKET,T0009,0.6,10604.5,4517.1,0.6,10604.5,4517.1
NETSIZE,T0009,56.8,151.5,1076.4,60.0,2921.5,1076.5
NETERROR,T0009,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0
IOADAPT,T0009,20985.2,834.6,797.9,21476.7,882.3,814.1,21053.4,861.9,807.3,21326.5,911.4,812.4,744.0,138.7,36.1,0.1,138.7,33.0
JFSFILE,T0009,88.2,9.5,59.9,44.7,1.3,0.3,15.6,0.3,36.4,73.7,68.1,89.5,59.0,88.9,88.9,88.9,88.9,0.7,46.8,88.6,93.1,93.0,93.5,93.8
JFSINODE,T0009,13.8,0.0,12.4,4.4,0.1,0.0,0.8,0.0,11.1,0.3,18.0,3.2,2.9,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0
DISKBUSY,T0009,5.1,6.4,3.9,4.2,4.9,4.4,4.1,4.1,4.6,3.1,3.9,3.6,2.8,2.2,14.0,22.6,8.5,0.0,5.5,5.6,6.7,10.5,0.5,11.1,0.0,24.9,7.8,5.0
DISKREAD,T0009,1136.4,447.6,382.6,305.1,322.3,352.8,321.1,326.3,355.4,97.8,95.5,87.6,152.3,92.2,979.4,2052.8,10432.8,0.0,438.8,559.2,4
DISKWRITE,T0009,2701.0,6.9,14.3,2.8,10.6,3.0,3.8,3.0,34.0,0.4,0.2,0.6,23.2,278.8,5.2,4.8,0.4,0.0,20.5,38.4,0.8,138.7,0.0,138.7,0.0
DISKXFER,T0009,124.5,56.8,44.8,38.5,40.8,44.2,40.4,41.2,45.6,12.4,12.1,11.3,24.5,15.0,122.6,185.4,166.0,0.0,55.2,70.9,56.7,33.2,3.0,33
DISKRXFER,T0009,74.8,56.0,43.7,38.3,40.4,44.1,40.2,40.9,43.4,12.4,12.1,11.2,19.1,11.0,122.3,185.0,166.0,0.0,53.3,68.5,56.6,0.2,3.0,0.0
DISKBSIZE,T0009,30.8,8.0,8.9,8.0,8.2,8.0,8.0,8.0,8.5,7.9,7.9,7.8,7.2,24.8,8.0,11.1,62.9,0.0,8.3,8.4,8.0,4.8,244.9,4.2,0.5,60.2,8.0,8
```

## Complete List of Collected Metrics

### CPU and Memory Metrics

```txt
asynchronous_i/o.aiocpu
asynchronous_i/o.aioprocs
asynchronous_i/o.aiorunning
cpu.idle%
cpu.sys%
cpu.user%
cpu.wait%
cpu_total.busy
cpu_total.idle%
cpu_total.sys%
cpu_total.user%
cpu_total.wait%
logical_partition.capped
logical_partition.ec_idle%
logical_partition.ec_sys%
logical_partition.ec_user%
logical_partition.ec_wait%
logical_partition.entitled
logical_partition.folded
logical_partition.logicalcpus
logical_partition.physicalcpu
logical_partition.pool_id
logical_partition.poolcpus
logical_partition.poolidle
logical_partition.sharedcpu
logical_partition.usedallcpu%
logical_partition.usedpoolcpu%
logical_partition.virtualcpus
logical_partition.vp_idle%
logical_partition.vp_sys%
logical_partition.vp_user%
logical_partition.vp_wait%
logical_partition.weight
pcpu.idle
pcpu.sys
pcpu.user
pcpu.wait
pcpu_total.entitled_capacity
pcpu_total.idle
pcpu_total.sys
pcpu_total.user
pcpu_total.wait
processes.asleep_bufio
processes.asleep_diocio
processes.asleep_rawio
processes.blocked
processes.exec
processes.fork
processes.msg
processes.pswitch
processes.read
processes.runnable
processes.sem
processes.swap-in
processes.syscall
processes.write
scpu.idle
scpu.sys
scpu.user
scpu.wait
scpu_total.idle
scpu_total.sys
scpu_total.user
scpu_total.wait
multiple_cpu_pools.entitled
multiple_cpu_pools.entitled_pool_capacity
multiple_cpu_pools.max_pool_capacity
multiple_cpu_pools.pool_busy_time
multiple_cpu_pools.pool_id
multiple_cpu_pools.pool_max_time
multiple_cpu_pools.shcpu_busy_time
multiple_cpu_pools.shcpu_tot_time
multiple_cpu_pools.shcpus_in_sys  |  memory.real_free(mb)
memory.real_free_%
memory.real_total(mb)
memory.virtual_free(mb)
memory.virtual_free_%
memory.virtual_total(mb)
memory_mb.active
memory_mb.bigfree
memory_mb.buffers
memory_mb.cached
memory_mb.highfree
memory_mb.hightotal
memory_mb.inactive
memory_mb.lowfree
memory_mb.lowtotal
memory_mb.memfree
memory_mb.memshared
memory_mb.memtotal
memory_mb.swapcached
memory_mb.swapfree
memory_mb.swaptotal
memory_new.free%
memory_new.fscache%
memory_new.pinned%
memory_new.process%
memory_new.system%
memory_new.user%
memory_use.%maxclient
memory_use.%maxperm
memory_use.%minperm
memory_use.%numclient
memory_use.%numperm
memory_use.lruable_pages
memory_use.maxfree
memory_use.minfree
memorypages.cycles
memorypages.exfills
memorypages.maxfree
memorypages.minfree
memorypages.nonsys_pgs
memorypages.numclient
memorypages.numclsegpin
memorypages.numclseguse
memorypages.numcompress
memorypages.numframes
memorypages.numfrb
memorypages.numiodone
memorypages.numperm
memorypages.numpermio
memorypages.numpgsp_pgs
memorypages.numpout
memorypages.numpsegpin
memorypages.numpseguse
memorypages.numralloc
memorypages.numremote
memorypages.numsios
memorypages.numvpages
memorypages.numwsegpin
memorypages.numwseguse
memorypages.pageins
memorypages.pageouts
memorypages.pfavail
memorypages.pfpinavail
memorypages.pfrsvdblks
memorypages.pgexct
memorypages.pgrclm
memorypages.pgspgins
memorypages.pgspgouts
memorypages.pgsteals
memorypages.scans
memorypages.system_pgs
memorypages.zerofills
paging_and_virtual.allocstall
paging_and_virtual.kswapd_inodesteal
paging_and_virtual.kswapd_steal
paging_and_virtual.nr_dirty
paging_and_virtual.nr_mapped
paging_and_virtual.nr_page_table_pages
paging_and_virtual.nr_slab
paging_and_virtual.nr_unstable
paging_and_virtual.nr_writeback
paging_and_virtual.pageoutrun
paging_and_virtual.pgactivate
paging_and_virtual.pgalloc_dma
paging_and_virtual.pgalloc_high
paging_and_virtual.pgalloc_normal
paging_and_virtual.pgdeactivate
paging_and_virtual.pgfault
paging_and_virtual.pgfree
paging_and_virtual.pginodesteal
paging_and_virtual.pgmajfault
paging_and_virtual.pgpgin
paging_and_virtual.pgpgout
paging_and_virtual.pgrefill_dma
paging_and_virtual.pgrefill_high
paging_and_virtual.pgrefill_normal
paging_and_virtual.pgrotated
paging_and_virtual.pgscan_direct_dma
paging_and_virtual.pgscan_direct_high
paging_and_virtual.pgscan_direct_normal
paging_and_virtual.pgscan_kswapd_dma
paging_and_virtual.pgscan_kswapd_high
paging_and_virtual.pgscan_kswapd_normal
paging_and_virtual.pgsteal_dma
paging_and_virtual.pgsteal_high
paging_and_virtual.pgsteal_normal
paging_and_virtual.pswpin
paging_and_virtual.pswpout
paging_and_virtual.slabs_scanned
paging.cycles
paging.faults
paging.pgin
paging.pgout
paging.pgsin
paging.pgsout
paging.reclaims
paging.scans
```

### Disk, I/O and Network Metrics

```txt
disk_%busy
disk_adapter.kb/s
disk_adapter.tps
disk_block_size
disk_io_average_reads_per_second
disk_io_average_writes_per_second
disk_io_reads_per_second
disk_io_writes_per_second
disk_read_kb/s
disk_read_service_time_msec/xfer
disk_service_time_msec/xfer
disk_transfers_per_second
disk_wait_queue_time_msec/xfer
disk_write_kb/s
disk_write_service_time_msec/xfer
file_i/o.dirblk
file_i/o.iget
file_i/o.namei
file_i/o.readch
file_i/o.ttycanch
file_i/o.ttyoutch
file_i/o.ttyrawch
file_i/o.writech
jfs_filespace_%used
jfs_inode_%used
large_page_use.freepages
large_page_use.highwater
large_page_use.pages
large_page_use.sizemb
large_page_use.usedpages
transfers_from_disk_(reads)_per_second  |  network_errors.collisions
network_errors.ierrs
network_errors.oerrs
network_i/o.read-kb/s
network_i/o.write-kb/s
network_packets.read/s
network_packets.reads/s
network_packets.write/s
network_packets.writes/s
network_size.readsize
network_size.writesize
```

#### Derived Metrics

* Derived metrics are calculated to simplify rule development and visualization tasks.
* The derived metrics are stored similar to original metrics and are available in rule expressions, forecasts, and widgets.

| Derived Metric | Original Metrics |
| --- | --- |
|  `pcpu_total.busy`  |  `pcpu_total.sys` + `pcpu_total.user` + `pcpu_total.wait`  |
|  `scpu_total.busy`  |  `scpu_total.sys` + `scpu_total.user` + `scpu_total.wait`  |
|  `pcpu_total.entitled_capacity_used%`  |  `pcpu_total.busy` / `pcpu_total.entitled_capacity` * 100  |
|  `pcpu.total`  |  `pcpu.sys` + `pcpu.user` + `pcpu.wait` — computed by tag (by processor id)   |
|  `scpu.total`  |  `scpu.sys` + `scpu.user` + `scpu.wait` — computed by tag (by processor id)  |
|  `memory_mb.memused%`  |  (1 – `memory_mb.memfree`/`memory_mb.memtotal`) * 100  |
|  `memory_mb.memused`  |  `memory_mb.memtotal` – `memory_mb.memfree`  |
|  `memory_mb.swapused%`  |  (1 – `memory_mb.swapfree`/`memory_mb.swaptotal`) * 100  |
|  `memory_mb.swapused`  |  `memory_mb.swaptotal` – `memory_mb.swapfree`  |
|  `cpu_total.busy%`  |  100 – `cpu_total.idle%`  |
|  `logical_partition.entitled_used%`  |  `logical_partition.physicalcpu` / `logical_partition.entitled` * 100   |
|  `logical_partition.physicalcpu_used%`  |  `logical_partition.physicalcpu` / `logical_partition.virtualcpus` * 100  |
|  `memory.real_used_%`  |  100 – `memory.real_free_%`  |
|  `memory.virtual_used_%`  |  100 – `memory.virtual_free_%`  |
|  `memory.real_used(mb)`  | `memory.real_total(mb)` – `memory.real_free(mb)`  |
|  `memory.virtual_used(mb)`  |  `memory.virtual_total(mb)` – `memory.virtual_free(mb)`  |
|  `memory_new.used%`  |  100 – `memory_new.free%`  |
|  `disk_read_kb/s`<br>`nmon.disk_write_kb/s`<br>`nmon.disk_%busy`<br>`nmon.disk_transfers_per_second`  |  Sum of values for all disks for each snapshot.  |
|  `nmon.network_packets.write/s`<br>`nmon.network_packets.read/s`  |  Sum of values for all interfaces for each snapshot except local.  |
