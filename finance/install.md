# Installation

## Requirements

### Operating System

* Ubuntu `16.04`, `18.04`
* RedHat Enterprise Linux `7.x`
* CentOS `7.x`
* Debian `8.x`, `9.x`

### Processor Architecture

* `x86_64` / `64`-bit

### CPU and Memory

| Ресурс | Количество
| --- | :--- |
| RAM | `16+` GB |
| CPU | `10+` GHz |
| Disk Type | SSD |

:::tip Note
To calculate the available CPU capacity, multiply the number of cores by CPU clock speed, for example `4` x `2.5` GHz = `10` GHz.
:::

### Disks

* Application files: `2` GB.
* Daily log files: `20` GB.
* Market data: `200` GB.

### File System

The standalone version is supported on local ext4 file system.

In scale-out mode ATSD is deployed on [Apache HBase](https://hbase.apache.org/) on file systems such as [Hadoop](../installation/cloudera.md) (HDFS), [Amazon EMRFS](../installation/aws-emr-s3.md), and [Azure Storage](../installation/azure-hdinsight.md).

## Install Java

Install [Java 8](../administration/migration/install-java-8.md).

Add the `JAVA_HOME` path to the user environment in `.bashrc`.

```sh
jp=`dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"`; \
  sed -i "s,^export JAVA_HOME=.*,export JAVA_HOME=$jp,g" ~/.bashrc ; \
  echo $jp
```

## Install ATSD

Download and unpack installation files.

```bash
curl -O https://axibase.com/public/atsd.fin.latest.tar.gz
tar -xzf atsd.fin.latest.tar.gz
```

Start the database.

```bash
./atsd/bin/atsd-tsd.sh start
```

## Network Settings

Increase network buffers and disable Reverse Path Filtering.

```bash
sudo vim /etc/sysctl.conf
```

```text
# Increase the maximum total buffer-space allocatable
net.ipv4.udp_mem = 65536 131072 262144

# Default Socket Receive Buffer
net.core.rmem_default = 25165824

# Maximum Socket Receive Buffer
net.core.rmem_max = 134217728

# Increase the read-buffer space allocatable (minimum size,
# initial size, and maximum size in bytes)
net.ipv4.tcp_rmem = 20480 12582912 25165824
net.ipv4.udp_rmem_min = 16384

# Default Socket Send Buffer
net.core.wmem_default = 25165824

# Maximum Socket Send Buffer
net.core.wmem_max = 25165824

# Increase the write-buffer-space allocatable
net.ipv4.tcp_wmem = 20480 12582912 25165824
net.ipv4.udp_wmem_min = 16384

# Maximum number of packets in waiting queue
net.core.netdev_max_backlog=50000

# Disable Reverse Path Filtering
net.ipv4.conf.all.rp_filter = 0
```

Apply changes.

```bash
sudo sysctl -p
```