# collectd

collectd is a system statistics daemon that collects operating system performance metrics.

collectd can be configured to stream data into the Axibase Time Series Database via TCP or UDP protocol using the `write_atsd` plugin.

See the [collectd plugin installation](https://github.com/axibase/atsd-collectd-plugin/blob/master/docs/README.write_atsd.md) instructions for technical details.

##### collectd Portal

##### Launch live collectd Portal in Axibase Chart Lab.




[Launch](https://axibase.com/chartlab/ff756c10)

![](resources/collectd_portal.png)

##### Collected Metrics

```css
contextswitch.contextswitch
cpu.aggregation.busy.average
cpu.aggregation.idle.average
cpu.aggregation.interrupt.average
cpu.aggregation.nice.average
cpu.aggregation.softirq.average
cpu.aggregation.steal.average
cpu.aggregation.system.average
cpu.aggregation.user.average
cpu.aggregation.wait.average
cpu.busy
cpu.idle
cpu.interrupt
cpu.nice
cpu.softirq
cpu.steal
cpu.system
cpu.user
cpu.wait
df.inodes.free
df.inodes.free.percent
df.inodes.reserved
df.inodes.reserved.percent
df.inodes.used
df.inodes.used.percent
df.space.free
df.space.free.percent
df.space.reserved
df.space.reserved.percent
df.space.used
df.space.used-reserved.percent
df.space.used.percent
disk.disk_io_time.io_time
disk.disk_io_time.weighted_io_time
disk.disk_merged.read
disk.disk_merged.write
disk.disk_octets.read
disk.disk_octets.write
disk.disk_ops.read
disk.disk_ops.write
disk.disk_time.read
disk.disk_time.write
disk.pending_operations
entropy.available
interface.if_errors.received
interface.if_errors.sent
interface.if_octets.received
interface.if_octets.sent
interface.if_packets.received
interface.if_packets.sent
io.swap_in
io.swap_out
load.loadavg.15m
load.loadavg.1m
load.loadavg.5m
memory.buffered
memory.cached
memory.free
memory.slab_recl
memory.slab_unrecl
memory.swap_cached
memory.swap_free
memory.swap_used
memory.used
processes.blocked
processes.fork_rate
processes.paging
processes.running
processes.sleeping
processes.stopped
processes.zombies
uptime.uptime
users.logged_in
```
