# Change ATSD Base Directory

By default ATSD is installed in the `/opt/atsd` directory.

Execute these steps to move ATSD to a different file system.

Stop ATSD services.

```sh
/opt/atsd/bin/atsd-all.sh stop
```

Verify that no ATSD services are running.

```sh
jps
```

`jps` output must contain only the `jps` process itself.

```ls
12150 Jps
```

If other processes continue running, follow the [safe ATSD shutdown](restarting.md#stopping-services) procedure.

Move ATSD to another directory, such as `/path/to/new-base-dir`.

```sh
sudo mv /opt/atsd /path/to/new-base-dir
```

Create a symbolic link to the new ATSD directory.

```sh
ln -s path/to/new-base-dir /opt/atsd
```

Start ATSD services.

```sh
/opt/atsd/bin/atsd-all.sh start
```

Open the **Settings > System Information** page and verify that the new base directory has been applied.