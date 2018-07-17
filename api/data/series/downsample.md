# Downsampling

## Content

* [Overview](#overview)
* [Parameters](#parameters)
* [Gap Syntax](#gap)
* [Downsampling Algorithm](#downsampling-algorithm)
* [Examples](#downsampling-examples)

## Overview

Downsampling is a reduction of time series cardinality achieved by filtering out certain samples. If a [series query](./query.md) contains the `downsample` field, downsampling is performed in a specified order among other series [transformations](./query.md#transformation-fields).

### Syntax Example

```json
"downsample": {
    "gap": {"count": 1, "unit": "HOUR"},
    "difference": 10,
    "order": 2
}
```

## Parameters

Downsampling is regulated by following optional parameters.

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| `gap` | object | Time interval specified in terms of time unit and count. If this parameter is specified the time gap between subsequent samples of the resulting series is close to equivalent to the value of this parameter. For example, if `gap` is `0` then no samples are filtered and resulting series is the same as initial series. <br>View the [algorithm](#downsampling-algorithm) section for detailed description how this parameter works. <br> View the [gap](#gap) section for description of the `gap` syntax. |
| `difference` | number | Non-negative number, used as threshold for difference between values of two series samples. If the difference exceeds this threshold then samples are included in resulting series. |
| `factor` | number | Non-negative number. If the ratio of two series samples exceeds `factor` then samples are included in resulting series. |
| `order` | integer | This field determines the order of downsampling in the sequence of series [transformations](./query.md#transformation-fields). <br> Default value is `0`.|

> `difference` and `factor` parameters cannot be used simultaneously.

If neither `gap`, `difference`, nor `factor` parameter is provided, downsampling performs series de-duplication, removing a series sample if `previous` and `next` samples contain the same value.

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

The algorithm processes samples in timestamp increasing order.
Each sample is accepted or rejected by the algorithm.
Accepted samples constitute the resulting series.
To accept or reject a sample the following conditions are checked sequentially.

**1.** The following samples are accepted:

* The first series sample, and the last series sample.
* Annotated sample: Sample with a non-empty [text field](./query.md#value-object).
* Sample with `NaN` value.
* Sample whose previous or subsequent sample value is `NaN`.

If the sample does not fall into one of these categories, the algorithm proceeds to the next step.

**2.** If the `gap` parameter is specified.

Calculate the difference between the sample timestamp and the timestamp of the latest accepted sample. If the difference exceeds the `gap` then the sample is accepted. Otherwise the algorithm proceeds to the next step.

**3.** If the `difference` parameter is provided.

Introduce the following notation:

* `last_value`: Value of the last accepted sample.
* `value`: Value of the sample under consideration.
* `next_value`: Value of the nearest subsequent sample.

The algorithm calculates:

```java
|value - last_value| > difference || |next_value - value| > difference
```

If the statement is `true`, the algorithm accepts the sample. Otherwise the algorithm proceeds to the next step.

**4.** If the `factor` parameter is provided.

If any of ratios `last_value/value`, `value/last_value`, `next_value/value`, and `value/next_value` exceed the `factor` the algorithm accepts the sample. Otherwise the algorithm proceeds to the next step.

**5.** If neither the `difference` nor `factor` parameter is provided.

If the `value` differs either from the `last_value`, or from the `next_value`, the algorithm accepts the sample. Otherwise the algorithm proceeds to the next step.

**6.** Reject the sample.

<!-- markdownlint-disable MD028 -->
> If series [versions](./versions.md) are queried, then algorithm is applied to the latest versions. If the latest version passes the downsampling filter then all versions with the same timestamp are included in resulting series.<br>

 > Sometimes samples are processed in decreasing order of the timestamps. That happens if limited number of latest series samples is queried.
<!-- markdownlint-enable MD028 -->

## Downsampling Examples

## Series De-duplication

Perform series de-duplication use `downsample` without additional parameters.

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

## De-duplication with `gap`

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

## Downsampling with `difference` and `gap`

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