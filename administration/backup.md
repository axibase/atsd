# Backup and Restore ATSD

This article describes creating a backup of [configuration records](#configuration-records) and [data](#data) in ATSD.

## Configuration Records

The database performs a backup for the following configuration types:

* [CSV Parsers](../parsers/csv/README.md)
* [Entities](../README.md#glossary)
* [Entity Groups](../configuration/entity_groups.md)
* [Entity Views](../configuration/entity_views.md)
* [Export Jobs](../reporting/scheduled-exporting.md#export-job-logging)
* [Export Queries](../sql/scheduled-sql.md)
* [Forecast Settings](../forecasting/README.md)
* [Metrics](../README.md#glossary)
* [Named Collections](../rule-engine/functions-random.md#named-collection)
* [Portals](../portals/README.md)
* [Replacement Tables](../sql/examples/lookup.md#replacement-tables)
* [Rules](../rule-engine/README.md#developing-rules)
* [Tag Templates](../configuration/tag-templates.md)
* [Users](./collector-account.md#create-user)
* [User Groups](./collector-account.md#create-user-group)
* [Web Configurations](../rule-engine/notifications/webhook.md)

A backup does not include [data tables](./data_retention.md#data-tables) containing series, properties, or metadata messages. See [Data](#data) for instructions on creating data backup.

ATSD performs an [automatic backup](#configure-automatic-backup-schedule) each day at a specified time.

Whether performed manually or automatically, `metric` and `entity` backups only contain non-default settings such as custom tags, labels, or field values.

### Manual Backup

Open the **Settings** menu, expand the **Diagnostics** section and select **Backup Files**.

![](./images/backup-files.png)

Manually create a new backup by clicking **Backup**. New backup files appear in the **Backup Files** table alongside **Last Modified** and **Size, KB** information.

![](./images/backed-up-files.png)

Download individual backup files in gzipped XML format by clicking the link in the **Name** column or access the complete `backup` folder at `/opt/atsd/atsd/backup`.

Import backup XML files to any ATSD instance whose records you plan to restore. Use backup files to revert ATSD records to an earlier date if a record is deleted erroneously or contains recent errors for example. Alternatively, import records to another ATSD instance to replicate a configuration.

### Manual Restore

Open the **Settings** menu, expand the **Diagnostics** section and select **Backup Import**.

![](./images/backup-import.png)

Add the desired backup files by clicking **Choose Files**. If needed, select multiple files. Click **Import** to add the selected backup files to ATSD.

![](./images/import-backup.png)

**Backup Import** has two optional settings:

* **Replace Existing** setting toggles whether or not ATSD deletes existing records which match those incoming. If disabled, and matching records exist in the database, ATSD does not import matching incoming records.
* **Auto Enable** setting toggles whether or not uploaded records are [enabled](./data_retention.md#disable-metric) by default.

### Configure Backup Schedule

The [**Server Properties**](./server-properties.md) page contains the `internal.backup.schedule` property. By default, ATSD creates a backup at `/opt/atsd/atsd/backup` every day at 23:30 [server local time](./timezone.md). Configure the [`cron`](https://axibase.com/docs/axibase-collector/scheduling.html#cron-expressions) expression as needed to modify this schedule.

New backup files do not replace existing backup files. Each backup is timestamped with the date and time of creation. Configure an external `cron` job to prune old backup files.

## Data

### Replication

To replicate an ATSD master node to an ATSD slave node, follow the instructions in [Replication](./replication.md).

### Base Directory Copy

This method only applies to [standalone](../installation/README.md#packages) ATSD instances.

Stop ATSD.

```sh
/opt/atsd/bin/atsd-all.sh stop
```

Copy the `/opt/atsd` directory to the desired location.

```sh
cp -a /opt/atsd/  /path/to/opt/atsd/
```

Start ATSD.

```sh
/opt/atsd/bin/atsd-all.sh start
```

### HBase Backup

Perform a backup to another HDFS cluster using the underlying HBase [Backup and Restore](https://hbase.apache.org/book.html#backuprestore) functionality.