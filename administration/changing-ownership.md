# Changing Ownership

Document describes how to change ownership of all files that ATSD might be using to `axibase` user if ATSD was previously launched under `root`.

## Stop ATSD

Stop all ATSD processes.

```bash
sudo /opt/atsd/bin/atsd-all.sh stop
```

## ATSD Directory Ownership

To change ownership of the executable files use the following command:

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

## Configuration Files Ownership

By default `logback.xml` which placed at [Configuration Files](editing-configuration-files.md#editing-configuration-files) contains the `<file>` setting for the following log types:

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

## Start ATSD

Start all ATSD processes as `axibase` user.

```bash
su axibase
/opt/atsd/bin/atsd-all.sh start
```