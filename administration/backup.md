# Backup and Restore ATSD Data

This article describes how to backup ATSD data, and use the backup to restore ATSD.

## Create Backup Files

Open the **Settings** menu, expand the **Diagnostics** section and select **Backup Files**.

![](./images/backup-files.png)

Create a new backup by clicking **Backup**. Backed up files will appear in the **Backup Files** table.

![](./images/backed-up-files.png)

Download individual backup files in gzipped XML format by clicking the link in the **Name** column or access the `backup` folder at `/opt/atsd/atsd/backup`.

## Import Backup Files

Open the **Settings** menu, expand the **Diagnostics** section and select **Backup Import**.

![](./images/backup-import.png)

Add the desired files by clicking **Choose Files**. If needed, select multiple files. Click **Import** to add the selected files to ATSD.

![](./images/import-backup.png)

## Replication

To replicate an ATSD master node instance to an slave node, follow the instructions in [Replication](./replication.md).

## Manual Copy

To manually copy ATSD files, follow these steps.

1. Stop ATSD.

```sh
/opt/atsd/bin/atsd-all.sh stop
```

2. Copy the `/opt/atsd` directory to the desired location.

```sh