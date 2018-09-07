# Versioning

Versioning tracks time series value changes for the purpose of audit trail and data reconciliation.

The capability is required for vertical applications such as Energy Data Management.

## Versioning Fields

Once enabled, the database tracks changes made to stored values with the following versioning fields:

| Field Name | Description |
| --- | --- |
|  Version Time  |  Timestamp when insert command is received. Set automatically by ATSD server with millisecond precision.  |
|  Version Source  |  User-defined field to track the source of change events such as username, device id, or IP address. <br>Set to `user:{username}` by default for changes made through the [web interface](#modifying-values).|
|  Version Status  |  User-defined field to classify change events. <br> Set to `invalid` for `NaN` and out of range values by default if **Invalid Value Action = `SET_VERSION_STATUS`** |

## Enabling Versioning

Versioning is **disabled** by default.

Enable versioning for specific metrics via [Meta API](../api/meta/metric/update.md), by setting the **Versioning** drop-down to **Yes** in the multi-record editor or enabling **Versioning** in the **Metric Editor**.

![](./resources/1.png)

Additionally, set **Invalid Value Action** to `SET_VERSION_STATUS` to initialize **Version Status** as `invalid` if the inserted sample is not a valid number or is outside of the specified minimum and maximum bounds.

## Inserting Version Fields

To insert versioning fields along with the modified value, use the reserved tags:

* `$version_source`
* `$version_status`

These tags are converted to the corresponding [versioning fields](#versioning-fields). Note that `$version_status` tag overrides `invalid` value set by `SET_VERSION_STATUS` trigger.

Options to insert versioned series:

* [Network Commands](#network-commands)
* [Data Entry Series form](#data-entry-form)
* [CSV Parser using Default Tags](#csv-parser-using-default-tags)
* [CSV Parser using Renamed Columns](#csv-parser-using-renamed-columns)

### Network Commands

To insert versioned samples, use a [series](../api/network/series.md) command with the version tags:

```ls
series e:{entity} m:{metric}={number} t:$version_status={status} t:$version_source={source} d:{iso-date}
```

<!-- markdownlint-enable MD032 -->
:::warning Note
Request to insert versioned value for a **non-versioned** metric causes a validation error.
:::
:::tip Note
If the command refers to a new metric, the metric is created automatically with **Versioning** set to **Yes**.
:::
<!-- markdownlint-disable MD032 -->

Example:

```ls
series e:e-vers m:m-vers=13 t:$version_status=OK t:$version_source=collector-1 d:2018-03-20T15:25:40Z
```

### Data Entry Form

Add versioned samples by opening the form at **Data > Data Entry > Series** and specifying versioning tags:

![](./resources/8.png)

<!-- markdownlint-enable MD032 -->
:::tip Note
**Metric** field must reference an existing metric with **Versioning** set to **Yes**.
:::
<!-- markdownlint-disable MD032 -->

### CSV Parser using Default Tags

To apply the same versioning fields to all records in a CSV file, specify them in the **Default Tags** field in the CSV parser or on the [CSV File Upload](../parsers/csv/README.md#uploading-csv-files) page.

```ls
$version_status={status}
$version_source={source}
```

![](./resources/2.png)

<!-- markdownlint-enable MD032 -->
:::warning Note
Request to insert versioned value for a **non-versioned** metric causes a validation error.
:::
:::tip Note
If the command refers to a new metric, the metric is created automatically with **Versioning** set to **Yes**.
:::
<!-- markdownlint-disable MD032 -->

### CSV Parser using Renamed Columns

To extract versioning fields from CSV content, add the version tags to the **Tag Columns** field and specify mappings between the original column names and version tag names in the **Renamed Columns** field.

![](./resources/3.png)

<!-- markdownlint-enable MD032 -->
:::warning Note
Request to insert versioned value for a **non-versioned** metric causes a validation error.
:::
:::tip Note
If the command refers to a new metric, the metric is created automatically with **Versioning** set to **Yes**.
:::
<!-- markdownlint-disable MD032 -->

## View Versions

Retrieve version history on the [Ad-hoc Export](../reporting/ad-hoc-exporting.md) page or via scheduled [Export Job](../reporting/scheduled-exporting.md).

### Ad-hoc Export page

Open the **Filters** section and enable **Display Versions** on the **Data > Export** page.

![](./resources/4.png)

* Records with version history are highlighted with **blue** borders. **Blue** border represents the latest value, transparent border represents a historical, overwritten value.
* `NaN` represents deleted values.
* Aggregation functions and other calculations ignore historical and deleted values.

#### Version Filters

|**Name**|**Description**|
|---|---|
|**Revisions Only** |Displays only modified values.|
|**Version Filter**| An expression to filter version history.<br>The expression can contain the `version_source`, `version_status` and `version_time` fields.<br>The `version_time` field supports [calendar](../shared/calendar.md) syntax using the `date()` function.<br> The `version_source` and `version_status` fields support wildcards.<br> To view the deleted values use `Double.isNaN(value)` method in the [Value Filter](../reporting/ad-hoc-exporting.md#ad-hoc-export-settings) field.|

**Examples**:

* Match using wildcards.

```ls
version_source LIKE 'col*'
```

   ![](./resources/5.png)

* Match using date function.

```ls
version_time > date('2018-03-21 10:41:00') AND version_time < date('now')
```

   ![](./resources/6.png)

* Match using exact value.

```ls
version_status = 'OK'
```

   ![](./resources/7.png)

* Display only modified values.

    ![](./resources/17.png)

## Modifying Values

Create a report in HTML format on the [Ad-hoc Export](../reporting/ad-hoc-exporting.md) page with versioning mode enabled.

Click timestamp for the selected record to open the **Data Entry** page.

![](./resources/9.png)

Change version **Status**, **Source**, and **Value** fields and click **Update**.

![](./resources/10.png)

![](./resources/11.png)

## Deleting Values

Create a report in HTML format on the [Ad-hoc Export](../reporting/ad-hoc-exporting.md) page with versioning mode enabled.

Click the timestamp for the selected record to open the **Data Entry** page.

![](./resources/9.png)

Change version `Status` and `Source`, change the `Value` and click **Delete**.

![](./resources/12.png)

Note that the current value for the selected timestamp is not deleted. Instead, it is replaced with a `NaN` marker.

![](./resources/13.png)

A value can also be deleted by selecting the value checkbox clicking **Delete** on the **Data > Export** page.

![](./resources/14.png)

### Deleting Multiple Series Values

To delete multiple values, select specific rows using checkboxes or select all rows using the header checkbox. Click **Delete**.

![](./resources/15.png)
