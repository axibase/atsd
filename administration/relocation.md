# Relocating ATSD Directory

By default, ATSD is installed in the directory `/opt/atsd`.

Execute these steps to move ATSD to a different file system.

Stop ATSD services:

```sh
/opt/atsd/bin/atsd-all.sh stop
```

Verify that no ATSD services are running:

```sh
jps
```

Output should show only the `jps` process:

```txt
12150 Jps
```

Move ATSD to another directory, such as `/opt/data/`:

```sh
sudo mv /opt/atsd /opt/data/
```

Create a symbolic link to the new ATSD directory:

```sh
ln -s /opt/data/atsd /opt/atsd
```

Restart ATSD services:

```sh
/opt/atsd/bin/atsd-all.sh start
```
