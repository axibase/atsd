# Aggregation

## Statistical Functions

| Name | Description |
|:---|---|
| [`MIN`](../../rule-engine/functions-statistical.md#min) | Minimum value of selected samples.
| [`MAX`](../../rule-engine/functions-statistical.md#max) | Maximum value of selected samples.
| [`AVG`](../../rule-engine/functions-statistical.md#avg) | Average value of selected samples.
| [`SUM`](../../rule-engine/functions-statistical.md#sum) | Sum of selected samples.
| [`COUNT`](../../rule-engine/functions-statistical.md#count) | Number of selected samples.
| [`FIRST`](../../rule-engine/functions-statistical.md#first) | First value of selected samples.
| [`LAST`](../../rule-engine/functions-statistical.md#last) | Final value of selected samples.
| [`DELTA`](../../rule-engine/functions-statistical.md#delta) | Difference between consecutive values of selected samples.
| [`COUNTER`](../../sql/examples/aggregate-counter.md#counter-function) | Difference between consecutive values of selected samples.<br>Negative values
| `PERCENTILE_999` | 99.9% Percentile
| `PERCENTILE_995` | 99.5% Percentile
| `PERCENTILE_99` | 99% Percentile
| `PERCENTILE_95` | 95% Percentile
| `PERCENTILE_90` | 90% Percentile
| `PERCENTILE_75` | 75% Percentile
| `PERCENTILE_50` | 50% Percentile
| `PERCENTILE_25` | 25% Percentile
| `PERCENTILE_10` | 10% Percentile
| `PERCENTILE_5` | 5% Percentile
| `PERCENTILE_1` | 1% Percentile
| `PERCENTILE_05` | 0.5% Percentile
| `PERCENTILE_01` | 0.1% Percentile
| [`MEDIAN`](../../rule-engine/functions-statistical.md#median) | Median value of selected samples.<br>Same as `PERCENTILE_50`  
| `STANDARD_DEVIATION` | Standard deviation of selected samples.
| [`SLOPE`](../../rule-engine/functions-statistical.md#slope) | Linear regression slope of selected samples.
| [`INTERCEPT`](../../rule-engine/functions-statistical.md#slope) | Linear regression intercept of selected samples.
| [`WAVG`](../../rule-engine/functions-statistical.md#wavg) | Weighted average of selected samples.
| [`WTAVG`](../../rule-engine/functions-statistical.md#wtavg) | Weighted time average of selected samples.
| [`THRESHOLD_COUNT`](../../api/data/series/examples/query-aggr-threshold.md#description) | Number threshold violations by selected samples.
| [`THRESHOLD_DURATION`](../../api/data/series/examples/query-aggr-threshold.md#description) | Time of threshold violations by selected samples.
| [`THRESHOLD_PERCENT`](../../api/data/series/examples/query-aggr-threshold.md#description) | Percentage of samples which violate threshold from selected samples.
| [`MIN_VALUE_TIME`](../../sql/README.md#min_value_time) | Unix time with millisecond granularity for maximum value of selected samples.
| [`MAX_VALUE_TIME`](../../sql/README.md#max_value_time) | Unix time with millisecond granularity for minimum value of selected samples.
| [`DETAIL`](../../api/data/series/downsample.md#algorithm) | Downsampling algorithm which filters duplicate samples from selected samples.
