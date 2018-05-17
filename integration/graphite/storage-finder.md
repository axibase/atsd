# Storage Finder

ATSD Storage Finder is an alternative to the default Graphite storage finder.

[More information about Graphite storage finders can be found here.](https://graphite.readthedocs.org/en/latest/storage-backends.html)

[Graphite and ATSD Storage Finder installation instructions can be found here.](installation.md)

ATSD Storage Finder configuration parameters are set in the `local_settings.py` file.

The configurations are set under `ATSD_CONF`.

There are two versions of the ATSD Storage Finder:

* ATSD Storage Finder Default – allows you to view metrics as they are stored in ATSD.
* ATSD Storage Finder Virtual – allows you to create custom paths to entities, metrics, and tags.

ATSD Storage Finder settings in `local_settings.py`:

```python
STORAGE_FINDERS = (
    'atsd_finder.AtsdFinder',
    'atsd_finder.AtsdFinderV',
    'graphite.finders.standard.StandardFinder',
)
```

ATSD Storage Finder and ATSD Storage Finder Virtual can be used together (their settings can be combined in `ATSD_CONF`).

## ATSD Storage Finder Default

```python
STORAGE_FINDERS = (
    'atsd_finder.AtsdFinder',
)
```

`local_settings.py` settings:

| Setting | Description | Default Value |
| --- | --- | --- |
|  url  |  ATSD hostname or IP  |  localhost:8088  |
|  username  |  ATSD user username  |  –  |
|  password  |  ATSD user password  |  –  |
|  entity_folders  |  List of folders for grouping entities by name.<br>Grouping is done according to the beginning of each entity name.<br>If it is matched to a folder name, then it will be visible in that folder.<br>For example if an entity name begins with<br>`com` (like `com_axibase`)<br>then it will be placed into the folder called `'com'`.<br>If the entity name does not satisfy any of the listed folder names, then it will be placed into the `"_"` folder by default.  |  `'entity_folders' : 'abcdefghijklmnopqrstuvwxyz_'`<br>Will result in folders from a to z (iterates through the string).  |
|  metric_folders  |  List of folders for grouping metrics by name.<br>Grouping is done according to the beginning of each metric name.<br>If it is matched to a folder name, then it will be visible in that folder.<br>For example if a metric name begins with<br>`statsd` (`statsd_cpuload_avg5`)<br>then it will be placed into the folder called `'statsd'`.<br>If metric name does not satisfy any of the listed folder names, then it will be placed into the `"_"` folder by default.  |  `'metric_folders' : 'abcdefghijklmnopqrstuvwxyz_'`<br>Will result in folders from a to z, iterates through the string.  |
|  aggregators  |  List of aggregators.  |  `'aggregators' : {<br>                'avg'               : 'Average',<br>                'min'               : 'Minimum',<br>                'max'               : 'Maximum',<br>                'sum'               : 'Sum',<br>                'count'             : 'Count',<br>                'first'             : 'First value',<br>                'last'              : 'Last value',<br>                'percentile_999'    : 'Percentile 99.9%',<br>                'percentile_99'     : 'Percentile 99%',<br>                'percentile_995'    : 'Percentile 99.5%',<br>                'percentile_95'     : 'Percentile 95%',<br>                'percentile_90'     : 'Percentile 90%',<br>                'percentile_75'     : 'Percentile 75%',<br>                'median'            : 'Median',<br>                'standard_deviation': 'Standard deviation',<br>                'delta'             : 'Delta',<br>                'wavg'              : 'Weighted average',<br>                'wtavg'             : 'Weighted time average'<br>}`  |

If you use an underscore at the beginning of a setting value (`entity_folders` or `metric_folders`), then all folders that do not satisfy any other setting will be placed there.

For example:

`'_other'`

## ATSD Storage Finder `local_settings.py` example

```python
ATSD_CONF = {
    'url': 'http://atsd_hostname:8088',
    'username': 'atsd_user',
    'password': 'secrect_pwd',
    'entity_folders': ['_other',
                       'com_',
                       'nur',
                       'dkr',
                       'us',
                       'emea-1',
                       'emea-2'],
    'metric_folders': ['_other',
                       'nmon',
                       'collectd',
                       'statsd',
                       'vmware',
                       'wordpress'],
    'aggregators':    {'avg' : 'Average',
                       'min' : 'Minimum',
                       'max' : 'Maximum',
                       'median' : 'Median',
                       'delta' : 'Delta'}
}
```

## ATSD Storage Finder Virtual

```python
STORAGE_FINDERS = (
    'atsd_finder.AtsdFinderV',
)
```

ATSD Storage Finder Virtual only has one extra setting: `views`.

Under `views`, use `type` to control which folders and the order you would like for them to appear in the graphite-web interface.

| Type | Description |
| --- | --- |
|  `'type': 'entity folder'`  |  Node representing entity filters.  |
|  `'type': 'entity'`  |  Node representing entities.  |
|  `'type': 'tag'`  |  Node representing tag values.  |
|  `'type': 'metric folder'`  |  Node representing metric filters.  |
|  `'type': 'metric'`  |  Node representing metrics.  |
|  `'type': 'interval'`  |  Node representing selection intervals.  |
|  `'type': 'collection'`  |  Node representing different types of nodes.  |
|  `'type': 'aggregator'`  |  Node representing statistics.  |
|  `'type': 'period'`  |  Node representing statistics periods.  |

## `local_settings.py` example with "views"

```python
ATSD_CONF = {

    'views': {'DistributedGeoMon': [{'type': 'entity folder',
                                     'value': [{'com.axibase'  : 'com.axibase'},
                                               {'com.axibase.*': 'com.axibase.*'}]},
                                    {'type': 'entity',
                                     'value': ['*']},
                                    {'type': 'tag',
                                     'value': ['path'],
                                     'global': [{'type': 'metric',
                                                 'value': ['distgeomon.connect-dns']}]},
                                    {'type': 'tag',
                                     'value': ['geo-target', 'geo-source']},
                                    {'type': 'metric folder',
                                     'value': [{'distgeomon.response*': 'response'},
                                               {'distgeomon.connect*' : 'connect'}]},
                                    {'type': 'metric',
                                     'value': ['*']},
                                    {'type': 'interval',
                                     'value': [{'count': '30',
                                                'unit': 'minute',
                                                'label': '30 minutes'},
                                               {'count': '2',
                                                'unit': 'hour',
                                                'label': '2 hours'},
                                               {'count': '1',
                                                'unit': 'day',
                                                'label': '1 day'}]},
                                    {'type': 'collection',
                                     'value': [{'type': 'aggregator',
                                                'value': [{'detail': 'Detail'}],
                                                'is leaf': True},
                                               {'type': 'const',
                                                'value': ['Aggregate']}]},
                                    {'type': 'aggregator',
                                     'value': [{'count'        : 'Count'},
                                               {'min'          : 'Minimum'},
                                               {'max'          : 'Maximum'},
                                               {'avg'          : 'Average'},
                                               {'median'       : 'Median'},
                                               {'sum'          : 'Sum'},
                                               {'percentile_75': 'Percentile 75%'},
                                               {'delta'        : 'Delta'}]},
                                    {'type': 'period',
                                     'value': [{'count': '30',
                                                'unit': 'second',
                                                'label': '30 seconds'},
                                               {'count': '10',
                                                'unit': 'minute',
                                                'label': '10 minutes'},
                                               {'count': '1',
                                                'unit': 'hour',
                                                'label': '1 hour'}],
                                     'is leaf': True}]}
```

![](./resources/00.png)

## "views" example breakdown

![](./resources/01.png)

```python
{'type': 'entity folder',
 'value': [{'com.axibase'  : 'com.axibase'},
           {'com.axibase.*': 'com.axibase.*'}]}
```

Below two entity folders are shown. One filters out only the entity `com.axibase`. The other one filters out entities that start with `com.axibase`.

![](./resources/02.png)

```python
{'type': 'entity',
 'value': ['*']}
```

List of entities filtered by the folder they’re in.

![](./resources/03.png)

```python
{'type': 'tag',
 'value': ['path'],
 'global': [{'type': 'metric',
             'value': ['distgeomon.connect-dns']}]}
```

Values of the tag path. To retrieve tags we need a metric; however, it hasn’t been established yet. We can make a global token inside this one to make the metric become `distgeomon.connect-dns` until stated otherwise.

![](./resources/04.png)

```python
{'type': 'tag',
 'value': ['geo-target', 'geo-source']}
```

Values of tags `geo-target` and `geo-source` separated by a comma.

![](./resources/05.png)

```python
{'type': 'metric folder',
 'value': [{'distgeomon.response*': 'response'},
           {'distgeomon.connect*' : 'connect'}]}
```

Two metric folders.

![](./resources/06.png)

```python
{'type': 'metric',
 'value': ['*']}
```

List of metrics.

![](./resources/07.png)

```python
{'type': 'interval',
 'value': [{'count': 30,
            'unit': 'minute',
            'label': '30 minutes'},
           {'count': 2,
            'unit': 'hour',
            'label': '2 hours'},
           {'count': 1,
            'unit': 'day',
            'label': '1 day'}]}
```

List of aggregation intervals.

![](./resources/08.png)

```python
{'type': 'collection',
 'value': [{'type': 'aggregator',
            'value': [{'detail': 'Detail'}],
            'is leaf': True},
           {'type': 'const',
            'value': ['Aggregate']}]}
```

If we want to make two different types of tokens at the same level, i.e. a leaf and a branch (as shown below), we can make a collection. In this collection, there is a detail aggregator, which is a leaf. We can click on it and see the plot and a constant folder Aggregate, which will lead us further into the tree.

![](./resources/09.png)

```python
{'type': 'aggregator',
 'value': [{'count'        : 'Count'},
           {'min'          : 'Minimum'},
           {'max'          : 'Maximum'},
           {'avg'          : 'Average'},
           {'median'       : 'Median'},
           {'sum'          : 'Sum'},
           {'percentile_75': 'Percentile 75%'},
           {'delta'        : 'Delta'}]}
```

Here is a list of aggregators. First we define an ATSD aggregator we want to use, and then can assign any name we would like to it.

![](./resources/10.png)

```python
{'type': 'period',
 'value': [{'count': 30,
            'unit': 'second',
            'label': '30 seconds'},
           {'count': 10,
            'unit': 'minute',
            'label': '10 minutes'},
           {'count': 1,
            'unit': 'hour',
            'label': '1 hour'}],
 'is leaf': True}
```

Final leaf representing possible aggregation periods.

When the storage finder is enabled, metrics from ATSD become available for visualization in the Graphite-web application.

ATSD metrics visualization in Graphite-web application:

![](./resources/graphite.png)
