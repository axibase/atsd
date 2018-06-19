# Backup and Restore ATSD

This article describes creating backup [records](#backup-records) and [data](#backup-data) in ATSD.

## Backup Records

An individual backup includes the following:

* [Entity Groups](../configuration/entity_groups.md)
* [Entity Views](../configuration/entity_views.md)
* [Metrics](../README.md#glossary)
* Tag Templates
* [User Groups](./collector-account.md#create-user-group)
* [CSV Parsers](../parsers/csv/README.md)
* [Entities](../README.md#glossary)
* [Named Collections](../rule-engine/functions-random.md#named-collection)
* [Portals](../portals/README.md)
* [Web Configurations](../rule-engine/notifications/webhook.md)
* [Export Jobs](../reporting/scheduled-exporting.md#export-job-logging)
* Export Queries
* [Forecast Settings](../forecasting/README.md)
* [Replacement Tables](../sql/examples/lookup.md#replacement-tables)
* [Rules](../rule-engine/README.md#developing-rules)
* [Users](./collector-account.md#create-user)

A backup does not include [data tables](./data_retention.md#data-tables) containing series, properties, or metadata messages. See [Backup Data](#backup-data) for instructions on creating data backup.

ATSD performs an [automatic backup](#configure-automatic-backup-schedule) each day at a specified time.

Whether performed manually or automatically, backups only contain non-default records.

### Create Backup in Web Interface

Open the **Settings** menu, expand the **Diagnostics** section and select **Backup Files**.

![](./images/backup-files.png)

Manually create a new backup by clicking **Backup**. New backup files appear in the **Backup Files** table alongside **Last Modified** and **Size, KB** information.

![](./images/backed-up-files.png)

Download individual backup files in gzipped XML format by clicking the link in the **Name** column or access the complete `backup` folder at `/opt/atsd/atsd/backup`.

Import backup XML files to any ATSD instance whose records you plan to restore. Use backup files to revert ATSD records to an earlier date, if a record is deleted erroneously or contains recent errors for example. Alternatively, import records to another ATSD instance to replicate a configuration.

### Import Backup Files in Web Interface

Open the **Settings** menu, expand the **Diagnostics** section and select **Backup Import**.

![](./images/backup-import.png)

Add the desired backup files by clicking **Choose Files**. If needed, select multiple files. Click **Import** to add the selected backup files to ATSD.

![](./images/import-backup.png)

**Backup Import** has two optional settings:

* **Replace Existing** setting toggles whether or not ATSD deletes existing records which match those incoming. If disabled, and matching records exist in the database, ATSD does not import matching incoming records.
* **Auto Enable** setting toggles whether or not uploaded records are [enabled](./data_retention.md#disable-metric) by default.

### Configure Automatic Backup Schedule

The [**Server Properties**](./server-properties.md) page contains the `internal.backup.schedule` property. By default, ATSD creates a backup at `/opt/atsd/atsd/backup` every day at 23:30 [server local time](./timezone.md). Configure the [`cron`](https://axibase.com/docs/axibase-collector/scheduling.html#cron-expressions) expression as needed to modify this schedule.

New backup files do not replace existing backup files. Each backup is timestamped with the date and time of creation. Configure an external `cron` job to prune old backup files.

## Backup Data

### Node Replication

To replicate an ATSD master node to an ATSD slave node, follow the instructions in [Replication](./replication.md).

### Manual Copy

Manual copy method only applies to [standalone](../installation/README.md#packages) ATSD instances.

Stop ATSD.

```sh
/opt/atsd/bin/atsd-all.sh stop
```

Copy the `/opt/atsd` directory to the desired location.

```sh
cp -a /opt/atsd/  /path/to/opt/atsd/
```

Start ATSD from the new directory.

```sh
/path/to/opt/atsd/bin/atsd-all.sh start
```

### HBase Backup

Axibase is built on [Apache HBase](../README.md#technology-stack), which supports separate [Backup and Restore](https://hbase.apache.org/book.html#backuprestore) functionality.

Follow the procedure shown below:

1. Choose backup location: within a cluster, using a dedicated cluster, to the cloud, or a storage vendor appliance.
1. Allow the `hbase` system user in [YARN](https://hbase.apache.org/book.html#br.initial.setup).
1. Modify the `hbase-site.xml` file to support backup by adding the following properties and restart HBase.

    ```xml
    <property>
      <name>hbase.backup.enable</name>
      <value>true</value>
    </property>
    <property>
      <name>hbase.master.logcleaner.plugins</name>
      <value>org.apache.hadoop.hbase.backup.master.BackupLogCleaner,...</value>
    </property>
    <property>
      <name>hbase.procedure.master.classes</name>
      <value>org.apache.hadoop.hbase.backup.master.LogRollMasterProcedureManager,...</value>
    </property>
    <property>
      <name>hbase.procedure.regionserver.classes</name>
      <value>org.apache.hadoop.hbase.backup.regionserver.LogRollRegionServerProcedureManager,...</value>
    </property>
    <property>
      <name>hbase.coprocessor.region.classes</name>
      <value>org.apache.hadoop.hbase.backup.BackupObserver,...</value>
    </property>
    <property>
      <name>hbase.master.hfilecleaner.plugins</name>
      <value>org.apache.hadoop.hbase.backup.BackupHFileCleaner,...</value>
    </property>
    ```

1. Create an HBase backup image.

    ```sh
    hbase backup create <type> <backup_path>
    ```
1. Restore HBase from backup image.

    ```sh
    hbase restore <backup_path> <backup_id>
    ```