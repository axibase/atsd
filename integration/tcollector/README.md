# tcollector

## Overview

[tcollector](https://github.com/OpenTSDB/tcollector) is a data collection agent for Linux. tcollector can be configured to send operating system and application metrics into Axibase Time Series Database for long-term retention and analytics.

## Installation

### Install Python

tcollector requires Python 2.5 and higher.

Install Python on Ubuntu 14.04.

```sh
sudo apt-get install python
```

Install Python on Ubuntu 16.04.

```sh
sudo apt install python
```

Install Python on CentOS 6.x/7.x and RHEL 6.x/7.x.

```sh
sudo yum install python
```

### Download tcollector

```sh
wget -O tcollector.tar.gz https://github.com/OpenTSDB/tcollector/archive/v1.3.2.tar.gz
mkdir tcollector
tar -xzf tcollector.tar.gz -C tcollector --strip-components=1
cd tcollector
```

## Start tcollector

### Manual Start

Start tcollector from the installation directory. Replace `atsd_hostname` with the ATSD hostname or IP address.

```sh
sudo ./tcollector start --host atsd_hostname --port 8081
```

### Auto-Start

Create `tcollector.conf` file in the tcollector home directory.

```sh
ATSD_HOST=atsd_hostname
ATSD_PORT=8081
```

Replace `atsd_hostname` with the ATSD hostname or IP address.

#### Ubuntu 14.04

Download [init script](resources/tcollector) and copy it into `/etc/init.d` directory.
Set `TCOLLECTOR_HOME` variable to tcollector home directory, for example

```sh
TCOLLECTOR_HOME=/home/axibase/tcollector
```

Make the script executable.

```sh
sudo chmod u+x /etc/init.d/tcollector
```

Enable auto-start for tcollector.

```sh
sudo update-rc.d tcollector defaults
```

Start tcollector.

```sh
sudo service tcollector start
```

#### CentOS 6.x and RHEL 6.x

Download [init script](resources/tcollector) and copy it into `/etc/init.d` directory.
Set `TCOLLECTOR_HOME` variable to tcollector home directory, for example

```sh
TCOLLECTOR_HOME=/home/axibase/tcollector
```

Make the script executable.

```sh
sudo chmod u+x /etc/init.d/tcollector
```

Enable auto-start for tcollector.

```sh
sudo chkconfig --add tcollector
```

Start tcollector.

```sh
sudo service tcollector start
```

#### Ubuntu 16.04, CentOS 7.x, RHEL 7.x

Download [init script](resources/tcollector) and place it into tcollector **home** directory, name it `tcollector-wrapper`.

Make the script executable.

```sh
chmod +x tcollector-wrapper
```

Download [service file](resources/tcollector.service) for tcollector and copy it into `/lib/systemd/system` directory.

Specify path to `tcollector-wrapper` script. Example

```ini
ExecStart=/home/axibase/tcollector/tcollector-wrapper start
ExecStop=/home/axibase/tcollector/tcollector-wrapper stop
ExecReload=/home/axibase/tcollector/tcollector-wrapper restart
```

Enable auto-start.

```sh
sudo systemctl enable tcollector
```

Start tcollector.

```sh
sudo systemctl start tcollector
```

### Auto-Start as a non-root user

Add `LOGFILE` and `PIDFILE` options to `tcollector.conf`.

```sh
LOGFILE=log_file_path
PIDFILE=pid_file_path
```

`log_file_path` and `pid_file_path` must be absolute paths to files in existing directory (or directories), where user has write access to.

#### Ubuntu 14.04, CentOS 6.x, RHEL 6.x

Add `RUN_AS_USER` option to tcollector config.

```sh
RUN_AS_USER=user_name
```

Replace `user_name` with user name.

#### Ubuntu 16.04, CentOS 7.x, RHEL 7.x

Add `User` option to `[Service]` section in `/lib/systemd/system/tcollector.service` file.

```ini
 [Service]
 User=user_name
 ...
```

Replace `user_name` with user name.

## Default Entity Group and Portal for tcollector in ATSD

Entities collecting tcollector data are automatically grouped into the `tcollector - linux` entity group.

Entity Group Expression:

```js
properties('tcollector').size() > 0
```

A default portal is assigned to the tcollector entity group called: `tcollector - Linux`.

Launch live tcollector portal in Axibase Chart Lab.

[Launch](https://apps.axibase.com/chartlab/bdad4416/3/)

![](./resources/tcollector-portal1.png)

## List of tcollector metrics

```txt
df.bytes.free
df.bytes.percentused
df.bytes.total
df.bytes.used
df.inodes.free
df.inodes.percentused
df.inodes.total
df.inodes.used
iostat.disk.await
iostat.disk.ios_in_progress
iostat.disk.msec_read
iostat.disk.msec_total
iostat.disk.msec_weighted_total
iostat.disk.msec_write
iostat.disk.r_await
iostat.disk.read_merged
iostat.disk.read_requests
iostat.disk.read_sectors
iostat.disk.svctm
iostat.disk.util
iostat.disk.w_await
iostat.disk.write_merged
iostat.disk.write_requests
iostat.disk.write_sectors
iostat.part.ios_in_progress
iostat.part.msec_read
iostat.part.msec_total
iostat.part.msec_weighted_total
iostat.part.msec_write
iostat.part.read_merged
iostat.part.read_requests
iostat.part.read_sectors
iostat.part.write_merged
iostat.part.write_requests
iostat.part.write_sectors
net.sockstat.ipfragqueues
net.sockstat.memory
net.sockstat.num_orphans
net.sockstat.num_sockets
net.sockstat.num_timewait
net.sockstat.sockets_inuse
net.stat.tcp.abort
net.stat.tcp.abort.failed
net.stat.tcp.congestion.recovery
net.stat.tcp.delayedack
net.stat.tcp.failed_accept
net.stat.tcp.invalid_sack
net.stat.tcp.memory.pressure
net.stat.tcp.memory.prune
net.stat.tcp.packetloss.recovery
net.stat.tcp.receive.queue.full
net.stat.tcp.reording
net.stat.tcp.retransmit
net.stat.tcp.syncookies
net.stat.udp.datagrams
net.stat.udp.errors
sys.numa.allocation
sys.numa.foreign_allocs
sys.numa.interleave
sys.numa.zoneallocs
tcollector.collector.lines_invalid
tcollector.collector.lines_received
tcollector.collector.lines_sent
tcollector.reader.lines_collected
tcollector.reader.lines_dropped
```

```txt
proc.interrupts
proc.kernel.entropy_avail
proc.loadavg.15min
proc.loadavg.1min
proc.loadavg.5min
proc.loadavg.runnable
proc.loadavg.total_threads
proc.meminfo.active
proc.meminfo.anonhugepages
proc.meminfo.anonpages
proc.meminfo.bounce
proc.meminfo.buffers
proc.meminfo.cached
proc.meminfo.commitlimit
proc.meminfo.committed_as
proc.meminfo.directmap2m
proc.meminfo.directmap4k
proc.meminfo.dirty
proc.meminfo.hardwarecorrupted
proc.meminfo.hugepagesize
proc.meminfo.inactive
proc.meminfo.kernelstack
proc.meminfo.mapped
proc.meminfo.memfree
proc.meminfo.memtotal
proc.meminfo.mlocked
proc.meminfo.nfs_unstable
proc.meminfo.pagetables
proc.meminfo.shmem
proc.meminfo.slab
proc.meminfo.sreclaimable
proc.meminfo.sunreclaim
proc.meminfo.swapcached
proc.meminfo.swapfree
proc.meminfo.swaptotal
proc.meminfo.unevictable
proc.meminfo.vmallocchunk
proc.meminfo.vmalloctotal
proc.meminfo.vmallocused
proc.meminfo.writeback
proc.meminfo.writebacktmp
proc.net.bytes
proc.net.carrier.errs
proc.net.collisions
proc.net.compressed
proc.net.dropped
proc.net.errs
proc.net.fifo.errs
proc.net.frame.errs
proc.net.multicast
proc.net.packets
proc.net.tcp
proc.stat.cpu
proc.stat.cpu.percpu
proc.stat.ctxt
proc.stat.intr
proc.stat.processes
proc.stat.procs_blocked
proc.uptime.now
proc.uptime.total
proc.vmstat.pgfault
proc.vmstat.pgmajfault
proc.vmstat.pgpgin
proc.vmstat.pgpgout
proc.vmstat.pswpin
proc.vmstat.pswpout
```
