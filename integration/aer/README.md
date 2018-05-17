# ATSD Adapter

## Overview

ATSD adapter in Axibase Enterprise Reporter and Axibase Fabrica creates a hierarchical representation of metrics
collected in ATSD and makes them available for querying in reports.

In order for the Axibase Server to group ATSD metrics into virtual tables, metrics need to be tagged with the `table` tag.

## Enable the `table` Tag in the Metrics List

* Login into ATSD.
* Open the **Settings > Server Properties** page.
* Add the `table` tag to the `metric.display.tags` property.

![Server Properties](./metric-table-tags.png)

* Click Apply Changes and open the Metrics tab to verify that the `table` tag is visible in the Metrics list.

![Metrics List: table tag](./metrics-table-tag.png)

## Apply the `table` Tag to Metrics

* Enter partial metric name in the Name Mask to filter Metric list by name. `*` and `?` wildcards are supported.
* Set Page Size (Display on Page) to 1000.

![Metric List: filter](./metric-list-filter.png)

* Click checkbox to select filtered metrics.
* Make sure that grouped metrics have the same tags. For example, group `df.disk_used`, `df.disk_used_percent`, and other `df.*` metrics into one table since their shared tags are `file_system` and `mount_point`.
* Enter a name that describes this group of selected metrics and click [Apply].

![Metric List: apply tag](./metric-table-tag-apply.png)

* Verify that selected metrics have the `table` tag set.

![Metric List: applied tag](./metric-table-tag-applied.png)

* Repeat the process to group metrics into tables.

![Metric List: tag all](./metric-table-tag-all.png)

## Discover Metric Tables in the Axibase Server

* Login into the Axibase Server.
* Open the Admin:Warehouse Tools page.
* Select the `Reload Schema Cache` action.
* Select `View Schema Cache` to ensure that new metric groups are present as tables in the reloaded schema.

## Configure ATSD Proxy

Configure the Axibase Server to serve as an ATSD proxy so that widgets stored in the Axibase Server can optionally query data in ATSD transparently. In this configuration, the Axibase Server redirects an API request received from the client, and executes the request.

* Open the **Admin:Settings:** page in the Axibase Server and expand the `SERVER` section.
* Enter a full URL to ATSD into the `REDIRECT URL` field, including username and password as follows: `schema://atsd_user:atsd_user_password@atsd_hostname:atsd_port`

Example:

`http://reader:my_password@10.102.0.6:8088`

![](./redirect_settings.png)

* Save these Settings.
* Add the `url = /proxy` setting in widget configuration files that need to query ATSD directly:

```ls
[configuration]
  title = Performance/Daily
  width-units = 4
  height-units = 3
  url = /proxy

  [group]
  [widget]
    type = chart
    /*
        Query entities and metrics defined in ATSD, even if not exposed in Axibase Server
    */
    metric = mpstat.cpu_busy
    entity = nurswghbs001
```
