# Downsampling

## Content

* [Overview](#overview)
* [Parameters](#parameters)
* [Gap Syntax](#gap)
* [Downsampling Algorithm](#downsampling-algorithm)
* [Examples](#downsampling-examples)

## Overview

The downsampling is a reduction of time series cardinality by filtering out some samples. If the [series query](./query.md) has the `downsample` field, then donsampling is performed in specified order among other series [transformations](./query.md#transformation-fields).

Example of the `downsample` setting.

```json
"donsample": {
    "gap": {"count": 1, "unit": "HOUR"},
    "difference": 10,
    "order": 2
}
```

The downsampling strategy is regulated by several parameters.

## Parameters

All parameters are optional. 

> Parameters `difference` and `factor` can not be set simultaneously.

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| `gap` | object | Time interval specified in terms of time unit and count. If this parameter is specified then the time gap between subsequent samples of resulting series is not much more than value of this parameter. For example, if `gap` is zero then no samples are filtered out, and resulting series is the same as initial series. <br>View the [algorithm](downsampling-algorithm) section for detailed description how this parameter works. <br> View the [gap](gap) section for description of the `gap` syntax. |
| `difference` | number | Not negative number, used as threshold for difference between values of two series samples. If the difference is not exceeds this threshold then one of samples could be filtered out. <br>Only one of the `difference` and the `factor` settings may be specified. |
| `factor` | number | Not negative number. If ratio of two series samples is less than `factor` then one of samples could be filtered out. <br> Could be used if the `difference` parameter is not set. |
| `order` | integer | This field determines the order of downsampling in the sequence of series [transformations](./query.md#transformation-fields). <br> Default value is 0.|

If no one of the `gap`, `diffrence`, and `factor` parameters is provided then the downsampling performs series deduplication, removing series sample if previous and next samples have the same value.

## Gap

Time interval specified in terms of time unit and count.

| **Name**  | **Type** | **Description** |
|:---|:---|:---|
| `count`  | number | Number of time units contained in the period. |
| `unit`  | string | Time unit. One of `MILLISECOND`, `SECOND`, `MINUTE`, `HOUR`. |

Example.

```json
"gap": {"count": 2, "unit": "MINUTE"}
```

## Downsampling Algorithm

The algorithm processes samples in increasing order of timestamps.
Each sample could be accepted or rejected by the algorithm.
Accepted samples constitute the resulting series.
To decide if a sample should be accepted or rejected the following conditions are checked sequentially.

**1.**
The following samples are accepted:

* The first series sample, and the last series sample.
* Annotated sample - the sample with not empty [text field](./query.md#value-object).
* Sample whose value is `NaN` (not a number).
* Sample whose previous or subsequent sample has the `NaN` value.

If the sample does not fall into one of these categories, go to the next step.

**2. If the `gap` parameter is specified.**
Calculate the difference between the sample timestamp and the timestamp of the latest accepted sample. If the difference exceeds the `gap` then accept the sample. Otherwise go to the next step.

**3. If the `difference` parameter is provided.**
Let `diff1` is difference between the sample value and the value of the latest accepted sample. Let `diff2` is difference between the sample value and the value of the nearest subsequent sample. If the absolute value of `diff1` or `diff2` exceeds the value of the `difference` parameter then accept the sample. Otherwise go to the next step.

**4. If the `factor` parameter is provided.**
Let `last_value` is the value of the last accepted sample, `value` is the value of the sample under consideration, and `next_value` is the value of the subsequent sample. If any of ratios `last_value/value`, `value/last_value`, `next_value/value`, and `value/next_value` exceeds the `factor` then accept the sample. Otherwise go to the next step.

**5. If no one of the `difference` and `factor` parameters is provided.**
If the sample value differs either from the value of the last accepted sample, or from the value of the next sample, then accept the sample. Otherwise go to the next step.

**6.** Reject the sample.

<!-- markdownlint-disable MD028 -->
> If series [versions](./versions.md) are queried, then algorithm is applied to the latest versions. If the latest version passes the downsampling filter then all versions with the same timestamp are included in resulting series.<br>

 > Sometimes samples are processed in decreasing order of the timestamps. That could happens if limited number of latest series samples is queried, so the [limit](./query.md#transformation-fields) is specified in the query.
<!-- markdownlint-enable MD028 -->

## Downsampling Examples

## Series Deduplication

To perform series deduplication use the `downsample` without parameters.

```json
"downsample": {}
```

The downsampling result:

```ls
|       | initial| downsampled |                              |
| time  | series |   series    |           comment            |
|-------|--------|-------------|------------------------------|
| 07:00 |   1    |      1      | first sample                 |
| 08:00 |   1    |      -      |                              |
| 09:00 |   1    |      -      |                              |
| 10:00 |   1    |      -      |                              |
| 11:00 |   1    |      -      |                              |
| 12:00 |   1    |      1      | differs from next sample     |
| 13:00 |   2    |      2      | differs from previous sample |
| 14:00 |   2    |      -      |                              |
| 15:00 |   2    |      2      | differs from next sample     |
| 16:00 |   3    |      3      | differs from previous sample |
| 17:00 |   3    |      -      |                              |
| 18:00 |   3    |      -      |                              |
| 19:00 |   3    |      -      |                              |
| 20:00 |   3    |      3      | last sample                  |
```

## Deduplication with `gap`

The `downsample` settings:

```json
"downsample": {"gap": {"count": 2, "unit": "HOUR"}}
```

The downsampling result:

```ls
|       | initial| downsampled |                                                  |
| time  | series |   series    |                     comment                      |
|-------|--------|-------------|--------------------------------------------------|
| 07:00 |   1    |      1      | first sample                                     |
| 08:00 |   1    |      -      |                                                  |
| 09:00 |   1    |      -      |                                                  |
| 10:00 |   1    |      1      | time gap with previous accepted sample > 2 hours |
| 11:00 |   1    |      -      |                                                  |
| 12:00 |   1    |      1      | differs from next sample                         |
| 13:00 |   2    |      2      | differs from previous sample                     |
| 14:00 |   2    |      -      |                                                  |
| 15:00 |   2    |      2      | differs from next sample                         |
| 16:00 |   3    |      3      | differs from previous sample                     |
| 17:00 |   3    |      -      |                                                  |
| 18:00 |   3    |      -      |                                                  |
| 19:00 |   3    |      3      | time gap with previous accepted sample > 2 hours |
| 20:00 |   3    |      3      | last sample                                      |
```

## Downsampling with `difference` and `gap`

The `downsample` settings:

```json
"downsample": {
    "difference": 2,
    "gap": {"count": 4, "unit": "HOUR"}
}
```

The downsampling result:

```ls
|       | initial| downsampled |                                                  |
| time  | series |   series    |                     comment                      |
|-------|--------|-------------|--------------------------------------------------|
| 07:00 |   1    |      1      | first sample                                     |
| 08:00 |   1    |      -      |                                                  |
| 09:00 |   1    |      -      |                                                  |
| 10:00 |   1    |      -      |                                                  |
| 11:00 |   1    |      -      |                                                  |
| 12:00 |   1    |      1      | time gap with previous accepted sample > 4 hours |
| 13:00 |   2    |      -      |                                                  |
| 14:00 |   2    |      -      |                                                  |
| 15:00 |   2    |      -      |                                                  |
| 16:00 |   3    |      3      | difference with previous accepted sample > 2     |
| 17:00 |   3    |      -      |                                                  |
| 18:00 |   3    |      -      |                                                  |
| 19:00 |   3    |      -      |                                                  |
| 20:00 |   3    |      3      | last sample                                      |
```
