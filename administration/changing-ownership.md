# Changing Ownership

This document describes changing ownership of all files that ATSD may use to `axibase` user, supposing ATSD was previously launched by `root` user.

## Stop ATSD

Switch to `axibase` user:

```bash
su axibase
```

Stop all ATSD processes:

```bash
sudo /opt/atsd/bin/atsd-all.sh stop
```

Verify that no [ATSD services](restarting.md#processes) are present in `jps` output:

```bash
jps
```

Output should show only the `jps` process:

```ls
8582 Jps
```

> If some processes continue running, follow the [safe ATSD shutdown](restarting.md#stopping-services) procedure.

## Set Directory Owner

### Base Directory

Change ownership of the executable files with following command:

```bash
sudo chown -R axibase:axibase /opt/atsd
```

### Data Directory

If ATSD data is stored under the [custom](changing-data-directory.md#changing-the-directory-where-data-is-stored) `/data` path use the following command:

```bash
sudo chown -R axibase:axibase /data
```

### Server Properties Directories

There are several path settings at the **Settings > Server Properties** page:

* `internal.metrics.dump.path` = `path1`
* `jmx.access.file` = `path2`
* `jmx.password.file` = `path3`
* `webdriver.chromebrowser.path` = `path4`
* `webdriver.chromedriver.path` = `path5`
* `webdriver.phantomjs.path` = `path6`
* `nmon.data.directory` = `path7`
* `search.index.path` = `path8`

Change ownership for each directory:

```bash
sudo chown -R axibase:axibase path1 path2 ... path8
```

#### Example

```bash
search.index.path = /tmp/search/atsd
```

```bash
sudo chown -R axibase:axibase /tmp/search/atsd
```

### Logging Directories

This step is necessary if any log files are stored outside of the `/tmp/atsd` and base directory `/opt/atsd`.

Logging directories are listed at **Settings > Configuration Files** page, in the `logback.xml` file. The built-in log types containing the `<file>` and `<fileNamePattern>` settings are listed below:

<table>
  <thead>
    <tr>
      <th>Log type</th>
      <th>Appender name</th>
      <th>Path example</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>command.log</code></td>
      <td><code>commandsLogRoller</code></td>
      <td align="center"><code>path1</code></td>
    </tr>
    <tr>
      <td rowspan=3><code>discard.log</code></td>
      <td><code>malformedLogRoller</code></td>
      <td align="center"><code>path2</code></td>
    </tr>
    <tr>
      <td><code>ignoredLogRoller</code></td>
      <td align="center"><code>path3</code></td>
    </tr>
    <tr>
      <td><code>discardedLogRoller</code></td>
      <td align="center"><code>path4</code></td>
    </tr>
    <tr>
      <td rowspan=2><code>main</code></td>
      <td><code>logRoller</code></td>
      <td align="center"><code>path5</code></td>
    </tr>
    <tr>
      <td><code>alertLogRoller</code></td>
      <td align="center"><code>path6</code></td>
    </tr>
  </tbody>
</table>

Change ownership for each directory:

```bash
sudo chown -R axibase:axibase path1 path2 ... path6
```

#### Example

```xml
<!-- command.log -->
<file>/var/logs/atsd/command.log</file>
...
<fileNamePattern>/var/logs/atsd/compressed/command.%i.log.zip</fileNamePattern>
```

```bash
sudo chown -R axibase:axibase /var/logs/atsd
```

### Temporary Directories

ATSD uses `/tmp` directory to store HDFS and HBase configuration files:

```bash
atsd
hbase-axibase
hsperfdata_axibase
Jetty_*_master____*
Jetty_*_regionserver____*
Jetty_*_hdfs____*
Jetty_*_datanode____*
Jetty_*_secondary____*
```

Change ownership for each directory:

```bash
sudo chown -R axibase:axibase /tmp/atsd ... /tmp/Jetty_*_secondary____*
```

#### Example

```bash
hbase-axibase
hsperfdata_axibase
Jetty_0_0_0_0_50070_hdfs____w2cu08
Jetty_0_0_0_0_50075_datanode____hwtdwq
Jetty_0_0_0_0_50090_secondary____y6aanv
```

```bash
sudo chown -R axibase:axibase /tmp/*axibase /tmp/Jetty*
```

## Check Ownership

For each directory type above check there is no ATSD files under `root`:

```bash
find <directory> -depth -user root
```

Repeat the procedure of granting ownership if output contains any ATSD files.

Examples:

```bash
find /opt/atsd -depth -user root
```

```bash
find /tmp -depth -user root
```

## Start ATSD

Start all ATSD processes as `axibase` user:

```bash
/opt/atsd/bin/atsd-all.sh start
```