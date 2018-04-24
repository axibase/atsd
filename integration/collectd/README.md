# collectd

collectd is a system statistics daemon that collects operating system performance metrics.
collectd can be configured to stream data into the Axibase Time Series Database via TCP or UDP protocol using the `write_atsd` plugin.

See the `write_atsd` plugin [documentation](https://github.com/axibase/atsd-collectd-plugin/blob/master/docs/README.write_atsd.md) for details.

## Installation

### Ubuntu 14.04

Download package
```sh
wget https://github.com/axibase/atsd-collectd-plugin/releases/download/5.7.2-7/collectd_ubuntu_14.04_amd64.deb
```
Install package
```sh
sudo dpkg -i collectd_ubuntu_14.04_amd64.deb
```

### Ubuntu 16.04

Download package
```sh
wget https://github.com/axibase/atsd-collectd-plugin/releases/download/5.7.2-7/collectd_ubuntu_16.04_amd64.deb
```
Install package
```sh
sudo dpkg -i collectd_ubuntu_16.04_amd64.deb
```

### Centos 6.x and RHEL 6.x

Download package
```sh
curl -L --output collectd.rpm \
    https://github.com/axibase/atsd-collectd-plugin/releases/download/5.7.2-7/collectd_rhel_6_amd64.rpm
```
Install package
```sh
sudo yum install collectd.rpm
```

### Centos 7.x and RHEL 7.x

Download package
```sh
curl -L --output collectd.rpm \
    https://github.com/axibase/atsd-collectd-plugin/releases/download/5.7.2-7/collectd_rhel_7_amd64.rpm
```

Install collectd with utility for managing SELinux policies
```sh
sudo yum install collectd.rpm policycoreutils-python
```

Persist updated SELinux policy to allow TCP connections for collectd
```sh
setsebool -P collectd_tcp_network_connect on
```

## Configuration

Edit `/ect/collect.conf` by replacing atsd_host with ATSD IP address or host name, specify protocol and port. Example

```
...
<Plugin write_atsd>
     <Node "atsd">
         AtsdUrl "tcp://10.10.20.1:8081"
...
     </Node>
</Plugin>
...
```

Description of `write_atsd` plugin options below


 **Setting**      | **Required** | **Description**                                                                                                                                        | **Default Value**
------------------|:-------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------|:----------------------
 `AtsdUrl`        | no           | Protocol to transfer data: `tcp` or `udp`, hostname and port of target ATSD server                                                                     | `tcp://localhost:8081`
 `Entity`         | no           | Default entity under which all metrics will be stored. By default (if setting is left commented out), entity will be set to the machine hostname.      | `hostname`
  `ShortHostname` | no           | Convert entity from fully qualified domain name to short name                                                                                          | `false`
 `Prefix`         | no           | Metric prefix to group `collectd` metrics                                                                                                              | `collectd`
 `Cache`          | no           | Name of read plugins whose metrics will be cached. Cache feature is used to save disk space in the database by not resending the same values.          | `-`
 `Interval`       | no           | Time in seconds during which values within the threshold are not sent.                                                                                 | `-`
 `Threshold`      | no           | Deviation threshold, in %, from the previously sent value. If threshold is exceeded, then the value is sent regardless of the cache interval.          | `-`
 `StoreRates`     | no           | If set to true, convert counter values to rates. If set to false counter values are stored as is, i. e. as an increasing integer number.               | true

More information about collectd configuration in [collectd.conf.5](https://collectd.org/documentation/manpages/collectd.conf.5.shtml) manual page.

## Auto-Start

Enable auto-start for collectd.

On Ubuntu 14.04

```sh
sudo update-rc.d collectd-axibase defaults 90 10
```

On Centos 6.x and RHEL 6.x

```sh
sudo chkconfig --add collectd-axibase
```

On Ubuntu 16.04, Centos 7.x and RHEL 7.x

```sh
sudo systemctl enable collectd-axibase
```

## collectd Portal

Launch live collectd Portal in Axibase Chart Lab.

[Launch](https://apps.axibase.com/chartlab/ff756c10)

![](resources/collectd_portal.png)

## Collected Metrics

```elm
collectd.aggregation.cpu.idle
collectd.aggregation.cpu.interrupt
collectd.aggregation.cpu.nice
collectd.aggregation.cpu.softirq
collectd.aggregation.cpu.steal
collectd.aggregation.cpu.system
collectd.aggregation.cpu.user
collectd.aggregation.cpu.wait
collectd.contextswitch.contextswitch
collectd.cpu.cpu.busy
collectd.cpu.cpu.idle
collectd.cpu.cpu.interrupt
collectd.cpu.cpu.nice
collectd.cpu.cpu.softirq
collectd.cpu.cpu.steal
collectd.cpu.cpu.system
collectd.cpu.cpu.user
collectd.cpu.cpu.wait
collectd.df.df_complex.free
collectd.df.df_complex.reserved
collectd.df.df_complex.used
collectd.df.df_inodes.free
collectd.df.df_inodes.reserved
collectd.df.df_inodes.used
collectd.df.percent_bytes.free
collectd.df.percent_bytes.reserved
collectd.df.percent_bytes.used
collectd.df.percent_bytes.used_reserved
collectd.df.percent_inodes.free
collectd.df.percent_inodes.reserved
collectd.df.percent_inodes.used
collectd.disk.disk_io_time.io_time
collectd.disk.disk_io_time.weighted_io_time
collectd.disk.disk_merged.read
collectd.disk.disk_merged.write
collectd.disk.disk_octets.read
collectd.disk.disk_octets.write
collectd.disk.disk_ops.read
collectd.disk.disk_ops.write
collectd.disk.disk_time.read
collectd.disk.disk_time.write
collectd.disk.pending_operations
collectd.entropy.entropy
collectd.interface.if_dropped.rx
collectd.interface.if_dropped.tx
collectd.interface.if_errors.rx
collectd.interface.if_errors.tx
collectd.interface.if_octets.rx
collectd.interface.if_octets.tx
collectd.interface.if_packets.rx
collectd.interface.if_packets.tx
collectd.load.load.longterm
collectd.load.load.midterm
collectd.load.load.shortterm
collectd.memory.memory.buffered
collectd.memory.memory.cached
collectd.memory.memory.free
collectd.memory.memory.slab_recl
collectd.memory.memory.slab_unrecl
collectd.memory.memory.used
collectd.processes.fork_rate
collectd.processes.ps_state.blocked
collectd.processes.ps_state.paging
collectd.processes.ps_state.running
collectd.processes.ps_state.sleeping
collectd.processes.ps_state.stopped
collectd.processes.ps_state.zombies
collectd.swap.swap.cached
collectd.swap.swap.free
collectd.swap.swap.used
collectd.swap.swap_io.in
collectd.swap.swap_io.out
collectd.uptime.uptime
collectd.users.users
collectd.vmem.vmpage_action.dirtied
collectd.vmem.vmpage_action.written
collectd.vmem.vmpage_faults.majflt
collectd.vmem.vmpage_faults.minflt
collectd.vmem.vmpage_io.memory.in
collectd.vmem.vmpage_io.memory.out
collectd.vmem.vmpage_io.swap.in
collectd.vmem.vmpage_io.swap.out
collectd.vmem.vmpage_number.active_anon
collectd.vmem.vmpage_number.active_file
collectd.vmem.vmpage_number.anon_pages
collectd.vmem.vmpage_number.anon_transparent_hugepages
collectd.vmem.vmpage_number.bounce
collectd.vmem.vmpage_number.dirty
collectd.vmem.vmpage_number.dirty_background_threshold
collectd.vmem.vmpage_number.dirty_threshold
collectd.vmem.vmpage_number.file_pages
collectd.vmem.vmpage_number.free_cma
collectd.vmem.vmpage_number.free_pages
collectd.vmem.vmpage_number.inactive_anon
collectd.vmem.vmpage_number.inactive_file
collectd.vmem.vmpage_number.isolated_anon
collectd.vmem.vmpage_number.isolated_file
collectd.vmem.vmpage_number.kernel_stack
collectd.vmem.vmpage_number.mapped
collectd.vmem.vmpage_number.mlock
collectd.vmem.vmpage_number.page_table_pages
collectd.vmem.vmpage_number.shmem
collectd.vmem.vmpage_number.shmem_hugepages
collectd.vmem.vmpage_number.shmem_pmdmapped
collectd.vmem.vmpage_number.slab_reclaimable
collectd.vmem.vmpage_number.slab_unreclaimable
collectd.vmem.vmpage_number.unevictable
collectd.vmem.vmpage_number.unstable
collectd.vmem.vmpage_number.vmscan_immediate_reclaim
collectd.vmem.vmpage_number.vmscan_write
collectd.vmem.vmpage_number.writeback
collectd.vmem.vmpage_number.writeback_temp
collectd.vmem.vmpage_number.zone_active_anon
collectd.vmem.vmpage_number.zone_active_file
collectd.vmem.vmpage_number.zone_inactive_anon
collectd.vmem.vmpage_number.zone_inactive_file
collectd.vmem.vmpage_number.zone_unevictable
collectd.vmem.vmpage_number.zone_write_pending
collectd.vmem.vmpage_number.zspages
```
