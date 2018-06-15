# Change Owner

ATSD needs to execute under the `axibase` user, not as `root`, for proper functioning.

This document describes where to locate all directories used by the database and how to revert file ownership to `axibase` user.

Execute the below steps as `root` or a user with sudo privileges.

## Identify Custom Directories

Log in to ATSD and open the **Settings > Server Properties** page.

Review the following properties and identify files and directories located outside of the base directory `/opt/atsd`.

* `internal.metrics.dump.path`
* `jmx.access.file`
* `jmx.password.file`
* `webdriver.chromebrowser.path`
* `webdriver.chromedriver.path`
* `webdriver.phantomjs.path`
* `nmon.data.directory`
* `search.index.path`

Create a list consisting of files and directories located outside of the `/opt/atsd` directory.

Open the **Settings > Configuration Files** page.

Select the `logback.xml` file from the drop-down list.

Search for `<file>` and `<fileNamePattern>` tags and locate paths outside of the base directory.

Add the custom paths to the above list.

## Stop ATSD

Stop all ATSD processes.

```bash
sudo /opt/atsd/bin/atsd-all.sh stop
```

Verify that no [ATSD processes](restarting.md#processes) are present in `jps` output.

```bash
jps
```

The output must contain only the `jps` process itself.

```ls
8582 Jps
```

If other processes continue running, follow the [safe ATSD shutdown](restarting.md#stopping-services) procedure.

## Change Owner

### Base Directory

Change ownership of the base directory.

```bash
sudo chown -R axibase:axibase /opt/atsd
```

### Data Directory

If ATSD data is stored in a [custom](change-data-directory.md#changing-the-directory-where-data-is-stored) directory, execute the following command:

```bash
sudo chown -R axibase:axibase /path/to/data-directory
```

### Custom Directories

Change owner for each path in the custom directory list above.

```bash
sudo chown -R axibase:axibase /path/to/custom-directory
```

### Temporary Directories

List `/tmp` directory contents to locate subdirectories used by ATSD to store temporary files.

```sh
ls /tmp
```

```txt
drwxrwxrwt 13 root    root    2342912 Jun 15 19:55 .
drwxr-xr-x 24 root    root       4096 Apr 16 09:42 ..
drwxrwxr-x  3 axibase axibase    4096 May 29 10:05 atsd
drwxrwxr-x  3 axibase axibase    4096 May 29 09:59 hbase-axibase
drwxr-xr-x  2 axibase axibase    4096 Jun 15 15:55 hsperfdata_axibase
drwxrwxr-x  4 axibase axibase    4096 Jun 15 15:54 Jetty_0_0_0_0_16010_master____.6nvknp
drwxrwxr-x  4 axibase axibase    4096 Jun 15 15:54 Jetty_0_0_0_0_16030_regionserver____.45q9os
drwxrwxr-x  4 axibase axibase    4096 May 29 09:58 Jetty_0_0_0_0_50070_hdfs____w2cu08
drwxrwxr-x  4 axibase axibase    4096 May 29 09:58 Jetty_0_0_0_0_50075_datanode____hwtdwq
drwxrwxr-x  4 axibase axibase    4096 May 29 09:59 Jetty_0_0_0_0_50090_secondary____y6aanv
drwxrwxr-x  2 axibase axibase    4096 Jun 15 08:00 reports
```

Change ownership of `/tmp/atsd`, `/tmp/*axibase*`, `/tmp/Jetty*`, and other subdirectories used by ATSD.

```bash
sudo chown -R axibase:axibase /tmp/path-to-subdirectory
```

## Verify Ownership

For each directory type above verify that there are no files owned by the `root` user.

```bash
find /path/to/directory -depth -user root
```

Rerun the commands above of the output is not empty.

## Start ATSD

Switch to `axibase` user.

```bash
sudo su axibase
```

Start ATSD as `axibase` user.

```bash
/opt/atsd/bin/atsd-all.sh start
```