# Scheduled File Upload to ATSD

## Before You Begin

1. Ensure that the `/opt/nmon/nmon` binary exists and is executable.
2. Launch the `nmon` console to ensure `nmon` executable can be started.

```sh
/opt/nmon/nmon
```

## Upload Files to ATSD by API with wget

Perform these steps to start uploading files to ATSD every hour with `wget`.

### Step 1

Create a file script `/opt/nmon/nmon_script.sh` and add the following row to the `cron` schedule:

```txt
0 * * * * /opt/nmon/nmon_script.sh
```

### Step 2

After that, add the following content to the file script `/opt/nmon/nmon_script.sh` replacing `username`, `password`, and `atsd_hostname` with actual credentials:

```bash
#!/bin/sh
fn="/nmon/nmon/`date +%y%m%d_%H%M`.nmon";pd="`/opt/nmon/nmon -F $fn -s 60 -c 60 -T -p`"; \
while kill -0 $pd; do sleep 15; done; \
wget -t 1 -T 10 --user=username --password=password --no-check-certificate -O - --post-file="$fn" \
--header="Content-type: text/csv" "https://atsd_hostname/api/v1/nmon?f=`basename $fn`"
```

## Upload Files to ATSD with Unix Socket

To start uploading files to ATSD every hour with Unix socket perform these steps (`bash` is required):

### Step 1

Create a file script `/opt/nmon/nmon_script.sh` and add the following row to the `cron` schedule:

```txt
0 * * * * /opt/nmon/nmon_script.sh
```

### Step 2

Add the following contents to script `/opt/nmon/nmon_script.sh` replacing `atsd_hostname` with the ATSD hostname or IP address:

```bash
#!/bin/bash
fn="/opt/nmon/`date +%y%m%d_%H%M`.nmon";pd="`/opt/nmon/nmon -F $fn -s 60 -c 60 -T -p`"; \
while kill -0 $pd; do sleep 15; done; \
{ echo "nmon p:default e:`hostname` f:`hostname`_file.nmon"; cat $fn; } > /dev/tcp/atsd_hostname/8081
```

## Upload Files into ATSD

To start uploading files to ATSD every hour with `netcat`, perform these steps:

### Step 1

Create a file script `/opt/nmon/nmon_script.sh` and add the following row to the `cron` schedule:

```txt
0 * * * * /opt/nmon/nmon_script.sh
```

### Step 2

Add the following contents to the `/opt/nmon/nmon_script.sh` file replacing `atsd_hostname` with the ATSD hostname or IP address:

```bash
#!/bin/sh
fn="/opt/nmon/`date +%y%m%d_%H%M`.nmon";pd="`/opt/nmon/nmon -F $fn -s 60 -c 60 -T -p`"; \
while kill -0 $pd; do sleep 15; done; \
{ echo "nmon p:default e:`hostname` f:`hostname`_file.nmon"; cat $fn; } | nc atsd_hostname 8081
```
