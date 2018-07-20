# Downsampling

## Content

* [Overview](#overview)
* [Parameters](#parameters)
* [Gap](#gap)
* [Downsampling Algorithm](#downsampling-algorithm)
* [Examples](#downsampling-examples)

## Overview

Downsampling is a reduction of time series cardinality achieved by filtering out certain samples. Downsampling is performed in a specified order among other required series [transformations](./query.md#transformation-fields).

### Syntax Example

```json
"downsample": {
    "gap": {"count": 1, "unit": "HOUR"},
    "algorithm": "INTERPOLATE",
    "difference": 10,
    "order": 2
}
```

## Parameters

Downsampling is regulated by following **optional** parameters.

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| [gap](#gap) | object | Time interval specified in terms of time unit and count. This parameter sets desired maximal gap between subsequent samples of the resulting series. For example, if `gap` is `0` then resulting series is the same as initial series. <br>View the [algorithm](#downsampling-algorithm) section for detailed description how this parameter works. |
| `algorithm` | string | Downsampling algorithm. Possible Values: `DETAIL` or `INTERPOLATE`. <br>Default value is `DETAIL`. |
| `difference` | number | Non-negative number used as threshold. If difference between sample value and value produced by downsampling algorithm exceeds threshold, sample is included in resulting series. |
| `ratio` | number | Threshold &ge; `1`. Downsampling algorithm generates numeric value for each series sample. If the ratio of sample value to generated value exceeds the `ratio` threshold then  sample is included in resulting series. |
| `order` | integer | Determines the order of downsampling in the sequence of series [transformations](./query.md#transformation-fields). <br> Default value is `0`.|

> `difference` and `factor` parameters cannot be used simultaneously.

If neither parameter is provided, downsampling performs series deduplication, removing series samples when `previous` and `next` samples contain the same value.

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

`DETAIL` and `INTERPOLATE` algorithms differ only by criteria used to filter series sample.
Each algorithm processes samples in timestamp increasing order.
Each sample is accepted or rejected by the algorithm.
Accepted samples constitute the resulting series.
To accept or reject a sample the following conditions are checked sequentially.

**1.** The following samples are accepted:

* The first series sample, and the last series sample.
* Annotated sample: Sample with a non-empty [text field](./query.md#value-object).
* Samples with `NaN` value.
* Samples whose previous or subsequent sample value is `NaN`.

If the sample does not fall into one of these categories, the algorithm proceeds to the next step.

**2.** If the `gap` parameter is specified. Calculate the difference between the sample timestamp and the timestamp of the latest accepted sample. If the difference exceeds the `gap` then the sample is accepted. Otherwise the algorithm proceeds to the next step.

**3.** Introduce the following notation:

* `last_sample`: The last accepted series sample.
* `sample`: Sample under consideration.
* `next_sample`: The sample immediately following the `sample`.

The timestamps of these samples are `last_time`, `time`, `next_time`, and their values are `last_value`, `value`, `next_value`.

The `INTERPOLATE` algorithm performs linear interpolation between the `last_sample` and the `next_sample` then calculates interpolated value `interpolated_value` with a timestamp equal to `time`.

**4.** If the `difference` parameter is provided. The algorithm accepts the sample if an expression evaluates to `true`.

* The `DETAIL` algorithm evaluates

```java
|value - last_value| > difference || |next_value - value| > difference
```

* The `INTERPOLATE` algorithm evaluates `|value - interpolated_value| > difference`.

If the sample is not accepted the algorithm proceeds to the next step.

**5.** If the `ratio` parameter is provided. The algorithm calculates several ratios, and accepts the sample, if any of them exceed the `ratio`.

* The `DETAIL` algorithm calculates `value/last_value`, `last_value/value`, `value/next_value`, and`next_value/value`.

* The `INTERPOLATE` algorithm calculates `value/interpolated_value`, and `interpolated_value/value`.

If sample is not accepted the algorithm proceeds to the next step.

**6.** If neither the `difference` nor `ratio` parameter is provided.

* The `DETAIL` algorithm accepts the sample if the `value` differs either from the `last_value`, or from the `next_value`.

* The `INTERPOLATE` algorithm accepts the sample if the `value` differs from the `interpolated_value`.

If sample is not accepted, then the algorithm rejects the it.

### Remarks

<!-- markdownlint-disable MD028 -->

* To prevent division by zero issue, algorithm checks inequality `x/ratio > y` instead of `x/y > ratio` in step five.
* If series [versions](./versions.md) are queried, then algorithm is applied to the latest versions. If the latest version passes the downsampling filter then all versions with the same timestamp are included in resulting series.<br>
* If limited number of latest series samples is queried, then samples are processed in decreasing order of the timestamps. Downsampling result depends on the samples ordering.

<!-- markdownlint-enable MD028 -->

## Downsampling Examples

## Series Deduplication

Perform series deduplication use `downsample` without additional parameters.

```json
"downsample": {}
```

**Result**:

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

```json
"downsample": {"gap": {"count": 2, "unit": "HOUR"}}
```

**Result**:

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

## `DETAIL` downsampling with `difference` and `gap`

```json
"downsample": {
    "difference": 2,
    "gap": {"count": 4, "unit": "HOUR"}
}
```

**Result**:

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

## `INTERPOLATE` downsampling

```json
"downsample": {
    "algorithm": "INTERPOLATE"
}
```

**Result**:

```ls
|       | initial| downsampled |                                                  |
| time  | series |   series    |                     comment                      |
|-------|--------|-------------|--------------------------------------------------|
| 07:00 |   1    |      1      | first sample                                     |
| 08:00 |   3    |      -      |                                                  |
| 09:00 |   5    |      -      |                                                  |
| 10:00 |   7    |      -      |                                                  |
| 11:00 |   9    |      9      | last sample                                                 |
```
