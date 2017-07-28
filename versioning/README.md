# Versioning

Versioning enables tracking of time-series value changes for the purpose of enabling an audit trail and traceable data reconciliation. Once enabled, ATSD tracks changes made to stored values with the following versioning fields:

| Field Name | Description | 
| --- | --- | 
|  Version Time  |  Timestamp when the insert command was received. Set automatically by the ATSD server with millisecond precision.  | 
|  Version Source  |  User-defined field to track sources (origins) of change events such as username, device id, or IP address.<br>Set to `user:{username}` by default for changes made through the ATSD web interface.  | 
|  Version Status  |  User-defined field to classify change events.<br>Set to `Invalid` code if an inserted value triggers an Invalid Value Action. Set to `SET_VERSION_STATUS` in metric editor.  | 


#### Enabling Versioning

Versioning is disabled by default. It can be enabled for particular metrics by selecting the Versioning checkbox on the Metric Editor page:

![](resources/metric-versioning.png)

In addition, the Invalid Value Action can be set to `SET_VERSION_STATUS` to initialize the Version Status field to an 'invalid' value if the inserted sample is outside of the specified minimum and maximum bounds.

#### Inserting Version Fields: Network Commands

To insert versioning fields, use the reserved series tags `version_source` and `version_status`. These tags will be removed by the server to populate corresponding versioning fields. If the sample value is outside of minimum and maximum bounds specified in the metric editor, `version_status` will be set to 'Invalid'.

Note that if metric is unversioned, the `version_source` and `version_status` tags will be processed as regular tags.

#### Inserting Versions with CSV Parser using Default Tags

If all records in a CSV file should have the same versioning fields, specify `version_source` and `version_status` in Default Tags.

![](resources/img_55cca7df4596f.png)

Note that the `version_source` and `version_status` tags will be applied only to metrics that are enabled for versioning. These reserved tags will be ignored for unversioned metrics.

#### Inserting Versions with CSV Parser using Renamed Columns

To extract versioning fields from CSV file columns, add the `version_source` and `version_status` to Tag Columns and specify mappings between the original column names and reserved tag names in the Renamed Columns field.

![](resources/img_55ccaafb69579.png)

Note that the `version_source` and `version_status` tags will be applied only to metrics that are enabled for versioning. These reserved tags will be ignored for unversioned metrics.

#### Viewing Versions

Version history can be retrieved on the Ad-hoc Export page or via a scheduled export job.

Click on the Versioning checkbox to view version history on the Ad-hoc Export page:

![](resources/img_55cc9fb5b3517.png)


- Records with version history are highlighted with blue and brown-colored borders.
- Blue border represents the latest value. Brown border represents a historical, overwritten value.
- NaN (Not a Number) represents deleted values. Deleted values are excluded from aggregation functions.
- For the purpose of API requests, aggregation functions, and other calculations, historical values and deleted values are ignored.


#### Viewing Versions with Filters


- Click on the 'Revisions Only' checkbox to display only values with version history. Values that haven’t been modified will be hidden.
- To display deleted values, enter `Double.isNaN(value)` into the Value Filter field.
- To filter version history, enter an expression into the Version Filter containing the `version_source`, `version_status`, and `version_time` fields. Note that the `version_time` field supports endtime syntax with the `date()`` function.
` version_source LIKE 'api*'`
` version_status = 'revised'`
` version_time > date('2015-08-13 00:00:00') AND version_time < date('previous_day')`


#### Updating Series Value

Create a report in HTML format on the Ad-hoc Export page with the Versioning mode enabled.

Click on Timestamp for the selected record to open the Data Entry page.

![](resources/img_55ccad5d81bc2.png)

Set version Status and Source, change the value, and click Update.

![](resources/img_55ccb9f02509b.png)

#### Deleting Series Value

Create a report in HTML format on Ad-hoc Export page, with Versioning mode enabled.

Click on Timestamp for the selected record, optionally modify Status and Source, and click the [Delete] button to delete the value.

![](resources/img_55ccad5d81bc2.png)

Note that the value will not be actually deleted. Rather, the current value for the selected timestamp will be replaced with a NaN (Not a Number) marker.

![](resources/img_55ccad87da9cf.png)

#### Deleting Multiple Series Values

To delete multiple values, select checkboxes for the selected rows or click the top checkbox to select all rows, and then click Delete.

![](resources/img_55ccae2dc3361.png)

#### Scheduled Version Reports

Open the Scheduled Export editor, click the Versioning checkbox, and optionally limit the report only to modified values by checking the 'Revision Only' field.

![](resources/img_55ccc02973864.png)
