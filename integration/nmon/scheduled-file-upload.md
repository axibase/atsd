# Scheduled File Upload to ATSD

## Before You Begin

1. Make sure that the `/opt/nmon/nmon` binary exists and is executable.
2. Launch the nmon console to make sure nmon works correctly:

```sh
/opt/nmon/nmon
```

## Upload Files to ATSD by API with `wget`

Perform the following steps to start uploading files to ATSD every hour with `wget`

### Step 1

Create a file script `/opt/nmon/nmon_script.sh` and add the following row to the cron schedule:

```txt
0 * * * * /opt/nmon/nmon_script.sh
```

### Step 2

After that, add the following content to the file script `/opt/nmon/nmon_script.sh` replacing `atsd_user`, `atsd_password`, and `atsd_hostname` with actual credentials.

## Upload Files to ATSD with Unix Socket

To start uploading files to ATSD every hour with Unix socket perform the following steps (bash is required):

### Step 1

Create a file script `/opt/nmon/nmon_script.sh` and add the following row to the cron schedule:

```txt
0 * * * * /opt/nmon/nmon_script.sh
```

### Step 2

Add the following contents to script `/opt/nmon/nmon_script.sh` replacing `atsd_hostname` with the ATSD hostname or IP address.

## Upload Files to ATSD with Netcat

To start uploading files to ATSD every hour with Netcat, perform the following steps:

### Step 1

Create a file script `/opt/nmon/nmon_script.sh` and add the following row to the cron schedule:

```txt
0 * * * * /opt/nmon/nmon_script.sh
```

### Step 2

Add the following contents to the `/opt/nmon/nmon_script.sh` file replacing `atsd_hostname` with the ATSD hostname or IP address.
