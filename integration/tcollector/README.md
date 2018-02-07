# tcollector

## Overview

[tcollector](https://github.com/OpenTSDB/tcollector) is a data collection framework for Linux operating system. tcollector can be configured to stream data into the Axibase Time Series Database for storage, analysis, forecasting, and visualization. Documentation can be found here: http://opentsdb.net/docs/build/html/user_guide/utilities/tcollector.html

## Installation

### Requirements

tcollector depends on Python 2 (2.5 or higher)

Install Python on Ubuntu 14.04:

```sh
sudo apt-get install python
```

Install Python on Ubuntu 16.04:

```sh
sudo apt install python
```

Install Python on Centos 6.x/7.x and RHEL 6.x/7.x

```sh
sudo yum install python
```

### Getting the source code

The source code can be obtained by cloning the project repository or by downloading source code archive

#### Cloning repostory

To clone repository you need git to be installed.

Install git on Ubuntu 14.04

```
sudo apt-get install git
```

Install git on Ubuntu 16.04

```
sudo apt install git
```

Install git on Centos 6.x/7.x and RHEL 6.x/7.x

```
sudo yum install git
```

Next, clone the repository

```sh
git clone https://github.com/OpenTSDB/tcollector.git
cd tcollector
```

#### Downloading the source code archive

As the second option, the lateset source code can be downloaded from the [latest release](https://github.com/OpenTSDB/tcollector/releases/latest) page of the project. Download it using wget or curl and copy to the target machine, if necessary.

```
wget -O tcollector.tar.gz https://github.com/OpenTSDB/tcollector/archive/v1.3.2.tar.gz
mkdir tcollector
tar -xzf tcollector.tar.gz -C tcollector --strip-components=1
cd tcollector
```

## Starting tcollector

### Manual start

Start tcollector from source code directory with command

```sh
sudo ./tcollector start --host [atsd_host] --port 8081
```

where `[atsd_host]` must be replaced with ATSD host name.

### Autostart

#### Create config

In tcollector root directory create `tcollector.conf` file

```sh
cat <<EOF > tcollector.conf
ATSD_HOST=[atsd_host]
ATSD_PORT=8081
EOF
```

where `[atsd_host]` must be replaced with ATSD host name.

#### Ubuntu 14.04

Download [init script](resources/tcollector) and place it into `/etc/init.d` directory.
From root directory of tcollector installation run the following command

```sh
sudo sed -i "/^TCOLLECTOR_HOME=/{s|=.*|=\"$(pwd)\"|}" /etc/init.d/tcollector
```

Make the script executable

```
sudo chmod u+x /etc/init.d/tcollector
```

Add tcollector to autostart

```sh
sudo update-rc.d tcollector defaults
```

To start tcollector immidiately run

```sh
sudo service tcollector start
```

#### Centos 6.x and RHEL 6.x

Download [init script](resources/tcollector) and place it into `/etc/init.d` directory.
From root directory of tcollector installation run the following command

```sh
sudo sed -i "/^TCOLLECTOR_HOME=/{s|=.*|=\"$(pwd)\"|}" /etc/init.d/tcollector
```

Make the script executable

```
sudo chmod u+x /etc/init.d/tcollector
```

Add tcollector to autostart

```sh
sudo chkconfig --add tcollector
```

To start tcollector immidiately run

```sh
sudo service tcollector start
```

#### Ubuntu 16.04, Centos 7.x, RHEL 7.x

Download [init script](resources/tcollector) and place it into tcollector root directory directory, name it `tcollector-wrapper`.
From root directory of tcollector installation run the following command

```sh
sed -i "/^TCOLLECTOR_HOME=/{s|=.*|=\"$(pwd)\"|}" tcollector-wrapper
```

Make the script executable

```
chmod +x tcollector-wrapper
```

Download [service file](resources/tcollector.service) for tcollector and place it into `/lib/systemd/system` directory.

From tcollector root direcotry run this command to edit service file

```
sudo sed "/\(start\|stop\|restart\)/s|=|=$(pwd)/tcollector-wrapper|" /lib/systemd/system/tcollector.service
```

Enable autostart

```sh
sudo systemctl enable tcollector
```

To start tcollector immidiately run

```sh
sudo systemctl start tcollector
```

### Autostart as a non-root user

Add `LOGFILE` and `PIDFILE` options to tcollector config

```
echo "LOGFILE=[log_file_path]" >> tcollector.conf
echo "PIDFILE=[pid_file_path]" >> tcollector.conf
```

`[log_file_path]` and `[pid_file_path]` must be absolute paths to files in existing directory (or directories), where user has write access to.

#### Ubuntu 14.04, Centos 6.x, RHEL 6.x

Add `RUN_AS_USER` option to tcollector config

```
echo "RUN_AS_USER=[user_name]" >> tcollector.conf
```

where `[user_name]` must be replaced with user name.

#### Ubuntu 16.04, Centos 7.x, RHEL 7.x

Add `User` option to `[Service]` section of the service file

```
 sudo sed -i '/\[Service\]/a User=[user_name]' /lib/systemd/system/tcollector.service
 sudo systemctl daemon-reload
```

where `[user_name]` must be replaced with user name.

## Default Entity Group and Portal for tcollector in ATSD

Entities collecting tcollector data are automatically grouped into the `tcollector - linux` entity group.

Entity Group Expression:

```
properties('tcollector').size() > 0
```

A default portal is assigned to the tcollector entity group called: `tcollector - Linux`.


Launch live tcollector portal in Axibase Chart Lab.

[Launch](https://apps.axibase.com/chartlab/bdad4416/3/)

![](resources/tcollector-portal1.png)

## List of tcollector metrics

```css
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

```
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
