# Changing Ownership

This document describes changing ownership of all files that ATSD may use to `axibase` user, supposing ATSD was previously launched by `root` user.

## Stop ATSD

Stop all ATSD processes:

```bash
sudo /opt/atsd/bin/atsd-all.sh stop
```

## ATSD Directory Ownership

Change ownership of the executable files with following command:

```bash
sudo chown -R axibase:axibase /opt/atsd
```

## Data Directory Ownership

If ATSD data is stored under the [custom](changing-data-directory.md#changing-the-directory-where-data-is-stored) `/data` path use the following command:

```bash
sudo chown -R axibase:axibase /data
```

## Server Properties Ownership

The following settings contain paths to the directories used by ATSD:

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

### Example

```bash
search.index.path = /tmp/search/atsd
```

```bash
sudo chown -R axibase:axibase /tmp/search/atsd
```

## Configuration Files Ownership

By default, `logback.xml` [Configuration Files](editing-configuration-files.md#editing-configuration-files) contain the `<file>` and `<fileNamePattern>` settings for the following log types:

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

### Example

```xml
<!-- command.log -->
<file>/var/logs/atsd/command.log</file>
...
<fileNamePattern>/var/logs/atsd/compressed/command.%i.log.zip</fileNamePattern>
```

```bash
sudo chown -R axibase:axibase /var/logs/atsd
```

## Additional Directories Ownership

ATSD uses `/tmp` directory to store HDFS and HBase configuration files:

```bash
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
sudo chown -R axibase:axibase /tmp/hbase-axibase ... /tmp/Jetty_*_secondary____*
```

### Example

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

## Start ATSD

Start all ATSD processes as `axibase` user:

```bash
su axibase
/opt/atsd/bin/atsd-all.sh start
```
