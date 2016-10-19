# Scheduled Exporting

Scheduled exporting enables exporting of historical data and forecasts to the local file system in CSV or Excel formats, as well as delivery of produced reports to email subscribers.

#### Scheduled Exporting Settings

##### Schedule

| Field | Description | 
| --- | --- | 
|  <p>Enabled</p>  |  <p>Enable the current scheduled export job.</p>  | 
|  <p>Schedule</p>  |  <p>Cron expression specifying when the export job will be executed.</p>  <p>Field order: `seconds minutes hours day-of-month month day-of-week year`.</p>  <p>By default all export jobs are executed daily at 02:00 AM local server time: `0 0 2 * * *`.</p>  | 


##### Schedule Syntax Examples:

| Schedule | Expression | 
| --- | --- | 
|  <p>Every 15 minutes</p>  |  <p>`0 0/15 * * * *`</p>  | 
|  <p>Every hour</p>  |  <p>`0 0 * * * *`</p>  | 
|  <p>Every 4 hours</p>  |  <p>`0 0 0/4 * * *`</p>  | 
|  <p>Once per day at 02:00 server time</p>  |  <p>`0 0 2 * * *`</p>  | 
|  <p>Every Monday at 02:00 server time</p>  |  <p>`0 0 2 * * MON`</p>  | 
|  <p>First day of each month at 02:00 server time</p>  |  <p>`0 0 2 1 * *`</p>  | 


Concurrent execution for the same job is not allowed.

Export job settings in the server.properties file:


- `export.worker.count (default = 8)` – number of export jobs that can be executed at the same time
- `export.worker.queue (default = 8)` – number of export jobs that can be queued for execution


If new jobs are added for executing when the queue is full, such jobs will be rejected.

##### Export Job Logging:

Each export job execution is logged in ATSD. Messages are saved to track the status. Below are their parameters.

The administrator can create rules to be informed if jobs are not executed according to schedule.

`entity= atsd`
common tags: `type=application`, `source=atsd_export`, `hostname={HOST}`

|  | Status | Severity | Name | Message | Start Time | End Time | 
| --- | --- | --- | --- | --- | --- | --- | 
|  <p>on job start</p>  |  <p>`status=started`</p>  |  <p>`severity=INFO`</p>  |  <p>`name={job_name}`</p>  |  <p>`message=Job started`</p>  |  <p>`start_time={start_time_iso}`</p>  |  | 
|  <p>on job complete</p>  |  <p>`status=complete`</p>  |  <p>`severity=INFO`</p>  |  <p>`name={job_name}`</p>  |  <p>`message=Job completed`</p>  |  <p>`start_time={start_time_iso}`</p>  |  <p>`end_time={start_time_iso}`</p>  | 
|  <p>on job queued</p>  |  <p>`status=queued`</p>  |  <p>`severity=WARN`</p>  |  <p>`name={job_name}`</p>  |  <p>`message=Job queued`</p>  |  <p>`start_time={start_time_iso}`</p>  |  | 
|  <p>on job blocked *</p>  |  <p>`status=blocked`</p>  |  <p>`severity=ERROR`</p>  |  <p>`name={job_name}`</p>  |  <p>`message=Job blocked`</p>  |  <p>`start_time={start_time_iso}`</p>  |  | 
|  <p>on job rejected</p>  |  <p>`status=rejected`</p>  |  <p>`severity=ERROR`</p>  |  <p>`name={job_name}`</p>  |  <p>`message=Job rejected`</p>  |  <p>`start_time={start_time_iso}`</p>  |  | 
|  <p>on job failed</p>  |  <p>`status=failed`</p>  |  <p>`severity=ERROR`</p>  |  <p>`name={job_name}`</p>  |  <p>`message=Job failed`</p>  |  <p>`start_time={start_time_iso}`</p>  |  <p>`end_time={start_time_iso}`</p>  | 


> * Raised when the job starts while the previous instance of the same job is still running.

##### Dataset

| Field | Description | 
| --- | --- | 
|  <p>Name</p>  |  <p>Export job name.</p>  | 
|  <p>Data Type</p>  |  <p>Type of data that will be exported.</p>  <p>Possible values: history, forecast.</p>  | 
|  <p>Metric</p>  |  <p>Metric name for which data will be exported. Data can be exported for one metric at a time.</p>  | 
|  <p>Entity</p>  |  <p>If selected, exported data will be limited to the specified entity. Supersedes the Entity Group selector.</p>  | 
|  <p>Entity Group</p>  |  <p>If selected, exported data will be limited to entities contained in the specified entity group. Supersedes Entity Expression field.</p>  | 
|  <p>Entity Expression</p>  |  <p>An expression to filter selected data by entity name and entity tags. For example: `name like 'nur*' AND tags.environment = 'prod'`</p>  | 
|  <p>Value Filter</p>  |  <p>Expression to fetch only detailed samples that satisfy a condition. For example, `value != 0`. Value Filter is applied before aggregation and therefore impacts aggregated statistics values. To filter deleted values, use the Double.isNaN(value) syntax.</p>  | 
|  <p>Selection Interval</p>  |  <p>Time frame of exported data. End of the Selection Interval can be optionally specified in End Time field, otherwise it is set to current time. Selection Interval setting is ignored if both Start Time and End Time fields are set.</p>  | 
|  <p>Start Time</p>  |  <p>Start time of the selection interval. This field supports [End Time](../end-time-syntax.md) syntax, for example ‘previous_day’. If Start Time is not defined, it is set to End Time minus Selection Interval.</p>  | 
|  <p>End Time</p>  |  <p>End time of the selection interval. This field supports [End Time](../end-time-syntax.md) syntax, for example ‘next_day’. If End Time is not defined, it is set to Start Time plus Selection Interval. If Start Time is not defined, End Time is set to current time.</p>  | 
|  <p>Versioning</p>  |  <p>Display value history for metric that is enabled for Versioning. Versioning is displayed only for detailed, non-aggregated, samples.</p>  | 
|  <p>Revisions Only</p>  |  <p>Filters displayed versions only for samples with values changes. Excludes samples without versions.</p>  | 
|  <p>Version Filter</p>  |  <p>Expression to filter value history (versions) by version status, source, or time. For example: `version_status = 'Deleted' or version_source LIKE '*user*'`. To filter by version time, use the `date()` function. For example, `version_time > date('2015-08-11T16:00:00Z') or version_time > date('current_day')`. The `date()` function accepts [End Time](../end-time-syntax.md) syntax.</p>  | 
|  <p>Aggregate</p>  |  <p>Enable period aggregations based on selected detailed samples, after the optional Value Filter is applied.</p>  | 
|  <p>Aggregation Period</p>  |  <p>Period of time over which detailed samples are aggregated.</p>  | 
|  <p>Interpolation</p>  |  <p>Insert missing periods in aggregated results. The period is considered missing if it contains no detailed samples. Supported options: `STEP` – value of missing period equals value of the previous period; `LINEAR` – value is linearly interpolated between previous and next available value; `NONE` – missing periods are not inserted.</p>  | 
|  <p>Aggregate Statistics</p>  |  <p>One or multiple aggregation functions: average, minimum, maximum, sum, count, standard deviation, weighted average, weighted time average, median (percentile 50), first, last, percentile 50/75/90/95/99/99.5/99.9, MinValueTime, MaxValueTime.</p>  | 


##### Output

| Field | Description |
| --- | --- | 
|  <p>Format</p>  |  <p>Export file format.</p>  <p>Possible values: CSV, XLSX.</p>  | 
|  <p>Compression</p>  |  <p>Compression of exported files.</p>  <p>Possible values: none, gzip, zip.</p>  | 
|  <p>Output Path</p>  |  <p>Absolute path for exported files.</p>  <p>Expressions can be used to create timestamped files.</p>  <p>For example: `/tmp/daily/${yyyy-MM-dd}.csv`.</p>  <p>An expression like `/tmp/daily/${yyyy/MM/dd}.csv` creates the following directory `/tmp/daily/2015/08/02.csv`.</p>  <p>This means that exported files will be grouped by month and year, each in their relevant directory.</p>  <p>Supported placeholders: ` ${ENTITY}, ${ENTITY.tagName}, ${METRIC}, ${METRIC.tagName}, ${yyyy-MM-dd}, ${yyyy/MM/dd}`.</p>  | 
|  <p>Split by Entity</p>  |  <p>Will create a new file for each exported entity, which is useful when exporting data for multiple entities.</p>  <p>If Output Path contains `${ENTITY}`, then for each entity the name will be substituted.</p>  <p>If Output Path does not contain `${ENTITY}`, then the entity name will be added to the end of the file name.</p>  <p>For example: `daily2015-07-31-nurswgsvl007.csv`.</p>  | 
|  <p>Annotation</p>  |  <p>Custom annotation that will be added above the exported time series.</p>  <p>Can include any text, characters, and numbers.</p>  <p>If the field is left empty, no custom annotation will be added.</p>  <p>To include entity name, entity tags, metric names, or metric tags use the following placeholders as part of the annotation text:</p>  <p>`${ENTITY}`</p>  <p>`${ENTITY.tag1}`</p>  <p>`${METRIC}`</p>  <p>`${METRIC.tag2}`</p>  | 
|  <p>Entity Tags</p>  |  <p>List of entity tags that will be included as columns in the exported file.</p>  | 
|  <p>Metric Tags</p>  |  <p>List of metric tags that will be included as columns in the exported file.</p>  | 
|  <p>Decimal Precision</p>  |  <p>Number of fractional digits displayed. If a negative value such as -1 is specified, stored numbers are displayed ‘as is’ without any formatting.</p>  | 
|  <p>Time Format</p>  |  <p>Format for displaying series sample timestamps: Local Time (server timezone) or ISO (UTC time).</p>  <p>Local = `yyyy-MM-dd HH:mm:ss`</p>  <p>ISO = `yyyy-MM-dd'T'HH:mm:ss'Z'`</p>  | 


##### Distribution

| Field | Description | 
| --- | --- | 
|  <p>Email Subscribers</p>  |  <p>List of email addresses separated by commas, white spaces, or semicolons, to which the exported files will be sent as attachments.</p>  | 
|  <p>Email Subject</p>  |  <p>Subject of email.</p>  <p>Supports placeholders: `${ENTITY}, ${ENTITY.tagName}, ${METRIC}, ${METRIC.tagName}, ${yyyy-MM-dd}`.</p>  | 


Clicking on the TEST button will export the first file, display the file name, and provide a link to download the file.

![](images/export_job_test_button.png)
