# Portal Settings

## Reference

* [Layout](#layout)
* [[configuration] Section](#configuration-section)
  * [General Settings](#general-settings)
  * [Interval Settings](#interval-settings)
  * [Layout Settings](#layout-settings)
  * [Connection Settings](#connection-settings)
* [Comments](#comments)
* [Freemarker Expressions](#freemarker-expressions)

## Layout

Widget are positioned on the portal page using a **grid** layout. The dimensions of the grid are specified under the `[configuration]` tag.

```ls
[configuration]
  width-units = 3
  height-units = 2
```

In this example, the page is split into 3 columns and 2 rows.

The default portal grid dimensions are 6×4.

The default widget size is 1×1 which can be adjusted with the `width-units` and `height-units` settings in the `[widget]` section to stretch the widget into multiple columns or rows.

To display multiple widgets on one row, group them using the `[group]` tag.

```ls
[configuration]
  width-units = 3
  height-units = 2

# 1st widget row
[group]
  [widget]
  [widget]
  [widget]

# 2nd widget row
[group]
  [widget]
  [widget]
  [widget]
```

As an alternative to creating groups for each row, add the `widgets-per-row` setting under the `[group]` tag.

```ls
[configuration]
  width-units = 3
  height-units = 2

[group]
  widgets-per-row = 3

  [widget]
  [widget]
  [widget]
  [widget]
  [widget]
  [widget]
```

[2x3 Group Layout (per row grouping)](https://apps.axibase.com/chartlab/adfe0fe2)
![](./resources/6_widget_portal.png)

[3x2 Grid Layout (manual grouping)](https://apps.axibase.com/chartlab/adfe0fe2/18/)
![](./resources/portal-per-row.png)

## [configuration] Section

### General Settings

| **Name** | **Example** | **Description** | **ChartLab** |
| --- | --- | --- | --- |
|  `title`  |  `title = CPU Busy Portal`  |  Portal name.  |  |
|  `dialog-maximize`  |  `dialog-maximize = true`  |  If enabled, the dialog window will occupy the entire portal page.<br>Dialog window can be opened by clicking on the widget header.<br>Default value: true.  |  [View](https://apps.axibase.com/chartlab/808e5846/14/)  |
|  `display-panels`  |  `display-panels = true`  |  Display widget controls.<br>Possible values: true, false, hover.  |  [View](https://apps.axibase.com/chartlab/808e5846/16/)  |
|  `expand-panels`  |  `expand-panels = compact`  |  Expand widget controls.<br>Possible values: all, compact, none.  |  [View](https://apps.axibase.com/chartlab/808e5846/18/)  |
|  `periods`  |  `periods = 20 minute, 4 hour`  |  Add custom period(s) to aggregation controls in the top-right corner of the widget.  |  [View](https://apps.axibase.com/chartlab/fedaa42e/45/)  |
|  `buttons`  |  `buttons = update`  |  Add buttons to the widget header. The buttons are visible on mouse-over.<br>Possible values: update, reset.<br>`update` stops/resumes the loading of new data into the widget.<br>Reset is available only for the table widget. It resets column sorting to the initial order.  |  [View](https://apps.axibase.com/chartlab/808e5846/12/)  |

### Interval Settings

| **Name** | **Example** | **Description** | **ChartLab** |
| --- | --- | --- | --- |
|  `timespan`  |  `timespan = 2 hour`  |  Specifies the timespan for which the data should be loaded for all widgets by default.<br>The setting can be overridden by each widget separately.  |  [View](https://apps.axibase.com/chartlab/808e5846/6/)  |
|  `start-time`  |  `start-time = 2017-04-01T10:15:00Z`  |  Specifies the date and time in local or ISO-8601 format from which the values for the series are loaded.<br>The setting can be overridden by each widget separately.<br>Note that `start-time` is **inclusive** and `end-time` is **exclusive**.<br>This means that `start-time = 2017-09-14 10:00:00` will include data points that occurred exactly at `10:00:00` and later whereas `end-time = 2017-09-14 11:00:00` will include data points that occurred up to `10:59:59`, excluding points that occurred at `11:00:00`.<br>The setting supports [calendar](../shared/calendar.md) keywords.  |  [View](https://apps.axibase.com/chartlab/ca5669c8)  |
|  `end-time`  |  `end-time = previous_working_day`  |  Specifies the date and time in local or ISO-8601 format until which the values for the series are loaded.<br>The setting can be overridden by each widget separately..<br>Note that `start-time` is **inclusive** and `end-time` is **exclusive**.<br>This means that `start-time = 2017-09-14 10:00:00` will include data points that occurred exactly at `10:00:00` and later whereas `end-time = 2017-09-14 11:00:00` will include data points that occurred up to `10:59:59`, excluding points that occurred at `11:00:00`.<br>The setting supports [calendar](../shared/calendar.md) keywords.  |  [View](https://apps.axibase.com/chartlab/808e5846/7/)  |
|  `timezone`  |  `timezone = UTC`  |  Set the time zone for the data being loaded into the portal. Only the 'UTC' option is supported. <br>If 'UTC' is not set, the portal displays dates in the local time zone. <br>If 'UTC' is set, `start-time` and `end-time` settings specified in local format are evaluated based on the UTC time zone. |  [View](https://apps.axibase.com/chartlab/808e5846/8/)  |

* Supported `datetime` formats:
  * ISO 8601: `yyyy-MM-ddTHH:mm:ss[.NNN]Z`, for example: `2017-07-01T00:00:00Z`
  * Local: `yyyy-MM-dd[ HH:mm:ss[.NNN]]`, for example: `2017-07-01 00:00:00.015` or `2017-07-01`

### Layout Settings

| **Name** | **Example** | **Description** | **ChartLab** |
| --- | --- | --- | --- |
|  `width-units`   |  `width-units = 2`  |  Number of columns in the portal. Default: 6. |  [View](https://apps.axibase.com/chartlab/808e5846)  |
|  `height-units`  |  `height-units = 2`  |      Number of rows in the portal. Default: 4.  |  [View](https://apps.axibase.com/chartlab/808e5846/2/)  |
|  `offset-right`  |  `offset-right = 50`  |  Offset from the right border, in pixels.<br>`offset-` can be used with: top, right, bottom, left.  |  [View](https://apps.axibase.com/chartlab/808e5846/10/)  |
| `widgets-per-row`  |  `widgets-per-row = 3`  | Maximum number of widgets in the [group] section. If the value is exceeded, extra widgets are automatically placed into a new row.  |  [View](https://apps.axibase.com/chartlab/a4b4182b) |

### Connection Settings

| **Name** | **Example** | **Description** | **ChartLab** |
| --- | --- | --- | --- |
|  `url`  |  `url = http://atsd_hostname:port`  |  URL of the ATSD server. The setting is necessary if the data is loaded from an ATSD server running on a different host.  |  |
|  `context-path`  |  `context-path = api/v2`  |  Context path. Default value is `api/v1`.  |  |
| `method-path` | `method-path = /series/query` | Data API method path. Default value is specific for each data type: `/series/query`, `/properties/query`, `/messages/query`, `/alerts/query`. | |
| `url-parameters`  |  `url-parameters = db=12&adapter=7`  |  Optional request parameters included in data API requests.<br>Parameter names and values must be URL-encoded if necessary and separated by ampersand. `?` at the start of the query string is optional. |  |
|  `update-interval`  |  `update-interval = 5 minute`  |  Polling interval at which new incremental data is requested from the server by widgets on the portal.<br>For example `update-interval = 5 minute`.<br>The default value is 1 minute.<br>The setting can be overridden by each widget separately.<br>Chart updates are disabled if the `endtime` parameter for the portal or the widget is set to a fixed date, for example: `endtime = 2016-06-27T00:00:00Z`.  |  [View](https://apps.axibase.com/chartlab/808e5846/3/)  |
|  `batch-update`  |  `batch-update = true`  |  Sending data queries to the server in batches with size specified in `batch-size` setting. Default: false.<br>If enabled, series for which the request has failed will be requested separately from successfully updated series.  |  [View](https://apps.axibase.com/chartlab/808e5846/4/)  |
|  `batch-size`  |  `batch-size = 1`  |  Maximum number of series in one batch request to the server. Default: 8.<br>If 0 is specified, the limit is not set.<br>Applies when `batch-update = true`.  |  [View](https://apps.axibase.com/chartlab/808e5846/5/)  |

> The actual URL for data requests is assembled from `{url}{context-path}{method-path}{url-parameters}`. For example, the default URL for loading series data is `https://atsd_hostname:8443/api/v1/series/query`.

## Comments

Comments provide a way to annotate and describe the settings. Comment text is ignored when the configuration is parsed and evaluated.

### Single-line Comments

A single line comment starts with `#`. Text after the `#` is ignored.

```ls
[widget]
  type = chart
  # Metric field will be inherited by all series in the widget
  metric = nmon.cpu_total.busy%
```

A hash symbol in the middle of a line (preceded by any character other than tab or whitespace) is escaped and treated as regular text.

```ls
[widget]
  type = chart
  # Next line does not contain any comments because hash is preceded by characters other than tab or whitespace.
  title = Hello # World
```

### Multi-line Comments

Multi-line comments start with /* and end with */.

Any text between /* and */ will be ignored.

```ls
[widget]
  type = chart
  /*
     This widget provides information on CPU
     utilization measured in percent of available capacity.
  */
  metric = nmon.cpu_total.busy%
```

#### Placeholders

You can insert placeholders into the configuration text to populate it with values of the request parameters. Placeholders have the `{placeholderName}` format. The value of the placeholder is parsed from the query string from any parameter starting with `p_`, i.e. `p_placeholderName`.

```ls
[series]
  entity = {id}
  metric = cpu_busy
```

Invoked with `?p_id=nurswgvml002`, the above configuration is converted into the following text:

```ls
[series]
  entity = nurswgvml002
  metric = cpu_busy
```

## Freemarker Expressions

Refer to [Freemarker expressions in ATSD portals](freemarker.md).
