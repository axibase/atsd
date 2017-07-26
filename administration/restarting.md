# Restarting

ATSD provides scripts to control the database and its components.

Use these scripts to gracefully restart ATSD and to resolve startup issues.

## Permissions

If logged in as root or another user, change user to 'axibase' to ensure that no files are locked.

```sh
su axibase
```

## Script Directory

The scripts are located in the `/opt/atsd/bin` directory.

## Scripts

| **Name** | **Description** | **Arguments** | **Example** |
|---|:---|---|---|
| `atsd-all.sh` | Start, stop, and get status of all components. | start, stop, status | `/opt/atsd/bin/atsd-all.sh status` |
| `atsd-tsd.sh` | Start, stop, and get status of ATSD. | start, stop, status | `/opt/atsd/bin/atsd-tsd.sh stop` |
| `atsd-hbase.sh` | Start, stop, and get status of HBase. | start, stop, status | `/opt/atsd/bin/atsd-hbase.sh status` |
| `atsd-dfs.sh` | Start, stop, and get status of HDFS. | start, stop, status | `/opt/atsd/bin/atsd-dfs.sh start` |
| `update.sh` | [Update ATSD](update.md) in interactive mode.<br>`-t` - Upgrade and restart ATSD silently. No HBase and HDFS restart.<br>`-a` - Upgrade and restart ATSD, HBase, and HDFS silently.| -a, -t | `/opt/atsd/bin/update.sh` |

## Examples

```sh
/opt/atsd/bin/atsd-tsd.sh status
```

```sh
/opt/atsd/bin/update.sh
```

## Docker Container

To restart and update an ATSD instance running inside a Docker container, open a `/bin/bash` session with `docker exec -it` and execute commands as usual:

```sh
docker exec -it atsd /bin/bash
```

```sh
/opt/atsd/bin/update.sh
```

```sh
docker exec -it atsd tail -f /opt/atsd/atsd/logs/atsd.log
```

## Processes

Switch to the`axibase` user and run the `jps` utility to display Java processes running under the current user.

```java
27392 Jps
22110 Server
18494 HMaster
18387 HQuorumPeer
18673 HRegionServer
25587 NameNode
25961 SecondaryNameNode
25790 DataNode
```

## Process Types

| **Type** | **Process Name** |
|---|---|
| HDFS | DataNode |
| HDFS | SecondaryNameNode |
| HDFS | NameNode |
| HBase | HRegionServer |
| HBase | HQuorumPeer |
| HBase | HMaster |
| ATSD | Server |

## Safe Restart

### Stop Services

#### Stop ATSD

Stop ATSD and wait for the script to exit:

```
/opt/atsd/bin/atsd-tsd.sh stop
```

Verify that the `Server` process is **not** present in `jps` output:

```sh
jps
```

If the `Server` process is still running, kill it forcefully with `kill -9 {Server-pid}`:

### Stop HBase

Execute the following script and wait for the script to exit:

```sh
/opt/atsd/bin/atsd-hbase.sh stop
```

Verify that the `HMaster`, `HRegionServer`, `HQuorumPeer` processes are **not** present in the `jps` output:

```sh
jps
```

The `jps` output should display only HDFS processes at this time:

```
27392 Jps
25961 SecondaryNameNode
25790 DataNode
25587 NameNode
```

If any HBase processes are still running, retry `/opt/atsd/bin/atsd-hbase.sh stop`.

If the repeat attempt fails to stop HBase processes, execute the following commands:

```sh
/opt/atsd/hbase/bin/hbase-daemon.sh stop regionserver
/opt/atsd/hbase/bin/hbase-daemon.sh stop master
/opt/atsd/hbase/bin/hbase-daemons.sh stop zookeeper
```

If subsequent  `./atsd-hbase.sh stop` executions fail to stop HBase processes, kill HBase processes by PID with SIGTERM (no flags).

Make sure you **don't** kill HDFS processes NameNode, DataNode, SecondaryNameNode.

```sh
kill 18494
```

If any HBase process fails to stop after that and is still visible in `jps`, contact Axibase support for further instructions to prevent data loss.

#### Stop HDFS

```sh
/opt/atsd/bin/atsd-dfs.sh stop
```

### Start Services

Start HDFS, HBase, and ATSD in that order, opposite to the order they were shut down.

#### Start HDFS

Start HDFS, if `jps` shows that no HDFS processes are running:

```sh
/opt/atsd/bin/atsd-dfs.sh start
```

#### Start HBase

Start HBase, if `jps` shows that no HBase processes are running:

```sh
/opt/atsd/bin/atsd-hbase.sh start
```

#### Start ATSD

Start ATSD, if `jps` shows that no ATSD processes are running:

```sh
/opt/atsd/bin/atsd-tsd.sh start
```

## Zookeeper Cache

If ATSD fails to start and the `atsd.log` contains the `TableExistsException` error for any table, clean the Zookeeper cache.

```ls
Caused by:
  org.apache.hadoop.ipc.RemoteException:
  org.apache.hadoop.hbase.TableExistsException: atsd_message
```

Open Zookeper shell:

```sh
/opt/atsd/hbase/bin/hbase zkcli
```

Execute the command to remove the ephemeral `/hbase` directory from Zookeeper cache:

```sh
rmr /hbase
```

## File Permissions

### JPS

The `/opt/atsd/bin/atsd-all.sh` script relies on the **[jps](http://docs.oracle.com/javase/7/docs/technotes/tools/share/jps.html)** utility to determine that Java processes are started in the correct order.

The `jps` utility requires write permissions to the `/tmp/hsperfdata_axibase` directory in order to store temporary files. If permissions to this directory are missing when it is owned by root, `jps` returns an incomplete process list, even if processes are running and can be listed with `ps aux | grep java`.

If `jps` output is incomplete, the `atsd-all.sh` script aborts the startup procedure with the following message:

```
nurswgvml007 atsdService: * [ATSD] DataNode is not running.
```

* Solution: Stop all ATSD services. Remove the `/tmp/hsperfdata_axibase` directory.

### Temporary Files

ATSD uses `/tmp/atsd` directory to store temporary files. If this directory is owned by root, ATSD cannot function properly.

* Solution: Stop all ATSD services. Grant ownership to `/tmp/atsd` directory to the 'axibase' user.

```sh
chown -R axibase:axibase /tmp/atsd
```

### `/opt/atsd` directory

ATSD uses the `/opt/atsd` directory to store log files, backup files, and other files. If this directory is owned by root, ATSD cannot function properly.

* Solution: Stop all ATSD services. Grant ownership to `/opt/atsd` directory to the 'axibase' user.

```sh
chown -R axibase:axibase /opt/atsd
```
