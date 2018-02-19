# collectd

collectd is a system statistics daemon that collects operating system performance metrics.
collectd can be configured to stream data into the Axibase Time Series Database via TCP or UDP protocol using the `write_atsd` plugin.

See the `write_atsd` plugin [documentation](https://github.com/axibase/atsd-collectd-plugin/blob/master/docs/README.write_atsd.md) for details.

## Installation

### Ubuntu 14.04

Download package
```sh
wget https://github.com/axibase/atsd-collectd-plugin/releases/download/5.7.2-7-atsd-binary/collectd_ubuntu_14.04_amd64.deb
```
Install package
```sh
sudo dpkg -i collectd_ubuntu_14.04_amd64.deb
```

### Ubuntu 16.04

Download package
```sh
wget https://github.com/axibase/atsd-collectd-plugin/releases/download/5.7.2-7-atsd-binary/collectd_ubuntu_16.04_amd64.deb
```
Install package
```sh
sudo dpkg -i collectd_ubuntu_16.04_amd64.deb
```

### Centos 6.x and RHEL 6.x

Download package
```sh
curl -L --output collectd.rpm \
    https://github.com/axibase/atsd-collectd-plugin/releases/download/5.7.2-7-atsd-binary/collectd_rhel_6_amd64.rpm
```
Install package
```sh
sudo yum install collectd.rpm
```

### Centos 7.x and RHEL 7.x

Download package
```sh
curl -L --output collectd.rpm \
    https://github.com/axibase/atsd-collectd-plugin/releases/download/5.7.2-7-atsd-binary/collectd_rhel_7_amd64.rpm
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

## Autostart

Add collectd to autostart.

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

[Launch](https://axibase.com/chartlab/ff756c10)

![](resources/collectd_portal.png)

## Collected Metrics

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
