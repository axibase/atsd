# Forecasting

## Overview

Forecasting is a transformation that predicts future values by extracting trends and recurring patterns from historical data.

Supported forecasting algorithms:

* `Holt-Winters`
* `ARIMA` (Auto-Regressive Integrated Moving Average).
* `SSA` (Singular Spectrum Analysis).
* `baseline`

Unlike other transformations, the **forecast** returns samples ahead of the selection interval.

The example below produces a forecast for the next day using the Holt-Winters algorithm with auto-detected parameters.

```json
"forecast": {
  "horizon": {
    "interval": {"count": 1, "unit": "DAY"}
  },
  "hw": {
    "auto": true
  }
}
```

For graphical examples, refer to [Forecasting](https://axibase.com/docs/charts/widgets/shared/#forecasting) settings in Axibase Charts.

## Regularization

The forecast algorithms need the input series to be regularized which requires a preceding [`aggregation`](aggregate.md), [`interpolation`](interpolate.md), or a [`group`](group.md) transformation as in the example below.

```json
[{
  "startDate": "2019-04-01T00:00:00Z",
  "endDate": "2019-04-12T00:00:00Z",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "aggregate": {
    "type": "AVG",
    "period": { "count": 1, "unit": "HOUR" }
  },
  "forecast": {
    "horizon": {
      "interval": { "count": 1, "unit": "DAY" }
    },
    "hw": { "auto": true },
    "range": {"min": 0, "max": 100}
  }
}]
```

* Aggregation

```json
"aggregate": {
  "type": "AVG",
  "period": { "count": 1, "unit": "HOUR" },
  "interpolate" : { "type": "LINEAR" }  
}
```

* Interpolation

```json
"interpolate" : {
  "function": "LINEAR",
  "period": { "count": 1, "unit": "HOUR" }
}
```

* Grouping

```json
"group": {
  "type": "SUM",
  "period": { "count": 1, "unit": "HOUR"},
  "interpolate": { "type": "PREVIOUS" }
}
```

* Auto-aggregation

As an alternative to manually specified period, the forecast can be generated in auto-aggregation mode in which case the period is determined automatically based on the mean sampling period.

```json
"forecast": {
  "autoAggregate": true,
  "aggregationFunction": "AVG",
  "horizon": {
    "interval": { "count": 1, "unit": "DAY" }
  },
  "ssa": {}
}
```

## Request Fields

The request fields described below must be included inside the `forecast` object.

### Horizon Fields

The horizon fields specify the length of the forecasting interval. One of the duration fields (`interval`, `length`, `endDate`) is **required**.

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| `interval` | object | Forecast length specified with `count` and time [`unit`](time-unit.md).<br>For example: `{"count": 3, "unit": "DAY"}`. |
| `length` | number | Forecast length specified as the number of samples. The frequency of the forecast samples is the same as the frequency of the input samples. |
| `endDate` | string | End date until the forecast must be extrapolated. Must be greater then the end date of the selection interval.<br>[ISO format](../../../shared/date-format.md) date or [calendar](../../../shared/calendar.md) keyword. |
| `startDate` | string | Start date for the forecast interval. If not set, the forecast starts after the last sample in the input series.<br>[ISO format](../../../shared/date-format.md) date or [calendar](../../../shared/calendar.md) keyword. |

The forecast samples are generated starting with the timestamp following the [last sample](https://apps.axibase.com/chartlab/d33a9bc4) in the input series and not the end of the selection interval itself.

The start date of the forecast interval can be customized with [`startDate`](https://apps.axibase.com/chartlab/d33a9bc4/2/) setting to compare estimated and actual values.

Examples:

```json
"forecast": {
  "horizon": {
    "interval": {"count": 1, "unit": "DAY"}
  }
}
```

```json
"forecast": {
  "horizon": {
    "length": 10
  }
}
```

```json
"forecast": {
  "horizon": {
    "endDate": "2018-12-15T16:00:00Z"
  }
}
```

### Regularization Fields

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| `autoAggregate` | boolean | Set to `true` to perform auto-aggregation.<br>For Holt-Winters and ARIMA the period is determined based on lowest standard deviation. For SSA, the period is based on mean sampling interval.<br>Default value: `false`. |
| `aggregationFunction` | string | [Aggregation function](../aggregation.md) applied if auto-aggregation is enabled.<br>Default value: `AVG`. |

### Control Fields

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| `include` | array | Include input series, forecast, and reconstructed series into response.<br>Allowed values: `FORECAST`, `HISTORY`, `RECONSTRUCTED`.<br>Default value: `FORECAST`.|
| `scoreInterval` | object | Interval for scoring the produced forecasts in auto-parameter mode. Specified with `count` and time [`unit`](time-unit.md).<br>For example: `{"count": 1, "unit": "DAY"}`.<br>For SSA, the default value is the minimum of the horizon interval and `1/3` of the input series duration.<br>For ARIMA and Holt-Winters the default value is `1/4` of the input series duration.|
| `range` | object | Minimum and maximum value range.<br>If forecast value exceeds `max`, such value is replaced with `max`. If forecast value is below `min`, such value is replaced with `min`. |

Examples:

```json
"forecast": {
  "include": ["HISTORY", "FORECAST"]
}
```

```json
"forecast": {
  "scoreInterval": {"count": 1, "unit": "DAY"}
}
```

```json
"forecast": {
  "range": {"min": 0, "max": 100}
}
```

### Holt-Winters Fields

The fields described below must be included in the `forecast.hw` object.

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| `auto` | boolean | Generate a forecast using most optimal settings.<br>If set to `true`, parameters `alpha`, `beta`, `gamma` are detected automatically based on the lowest standard deviation within the score interval.<br>If set to `false`, parameters `alpha`, `beta`, `gamma` are required. |
| `period` | object | Periodicity parameter specified with `count` and time [`unit`](time-unit.md).<br>For example: `{"count": 1, "unit": "DAY"}`.|
| `alpha` | number | Alpha (data) parameter.<br>Possible values: `[0, 1]`. |
| `beta` | number | Beta (trend) parameter.<br>Possible values: `[0, 1]`. |
| `gamma` | number | Gamma (seasonality) parameter.<br>Possible values: `[0, 1]`. |

Examples:

```json
"forecast": {
  "hw": {
    "auto": true
  }
}
```

```json
"forecast": {
  "hw": {
    "alpha": 0.5,
    "beta": 0.3,
    "gamma": 0.5
  }
}
```

### ARIMA Fields

The fields described below must be included in the `forecast.arima` object.

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| `auto` | boolean | Generate a forecast using most optimal settings.<br>If set to `true`, parameters `p` and `d` are detected automatically based on the lowest standard deviation within the score interval.<br>If set to `false`, parameters `p` and `d` are required. |
| `autoRegressionInterval` | object | Alternative parameter for `p` where `p` is calculated as `auto-regression-interval / interval`.<br>Specified with `count` and time [`unit`](time-unit.md).<br>For example: `{"count": 1, "unit": "DAY"}`.|
| `p` | number | Auto-regression parameter. |
| `d` | number | Integration parameter.<br>Possible values: `0` or `1`. |

Examples:

```json
"forecast": {
  "arima": {
    "auto": true
  }
}
```

```json
"forecast": {
  "arima": {
    "p": 2,
    "d": 0
  }
}
```

### Baseline Fields

One of fields `period` or `count` must be proided to determine which samples of input series are used to calculate baseline value for given timestamp.

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| `period` | object | Baseline value for time `t` is an averaged value of input series for times `t - period`, `t - 2 * period`, `t - 3 * period`, ... It is expected that input series is regular and its inter-sample time interval divides the `period`. Specified with `count` and time [`unit`](time-unit.md). |
| `count` | number | Another way to specify the `period`: `period = count * spacing`, where `spacing` is inter-sample time interval of input series.|
| `function` | String | [Aggregation function](./../aggregation.md) used to average values of input series. |

Examples:

```json
"forecast": {
  "baseline": {
    "period": {"count": 1, "unit": "DAY"},
    "function": "AVG"
  }
}
```

### SSA Fields

The fields described below must be included in the `forecast.ssa` object.

If the `forecast.ssa` object is empty but has no fields, the forecast is generated using most optimal settings based on the lowest standard deviation within the score interval.

#### Decomposition Parameters

The fields described below must be included in the `forecast.ssa.decompose` object.

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| `eigentripleLimit` | number | Maximum number of eigenvectors extracted from the trajectory matrix during the singular value decomposition (SVD).<br>Possible values: between `0` and `500`.<br>If set to `0`, the count is determined automatically. |
| `method` | string | The algorithm applied in singular value decomposition (SVD) of the trajectory matrix to extract eigenvectors.<br>Possible values: `FULL`, `TRUNCATED`, `AUTO`. |
| `windowLength` | number | Height (row count) of the trajectory matrix, specified as the % of the sample count in the input series.<br>Possible values: `(0, 50]`.<br>Default value: `50`. |
| `singularValueThreshold` | number | Threshold, specified in percent, to discard small eigenvectors. Eigenvector with eigenvalue λ is discarded if √λ is less than the specified % of √ sum of all eigenvalues.<br>Discard if `√λ ÷ √ (∑ λi) < threshold ÷ 100`<br>If threshold is `0`, no vectors are discarded.<br>Possible values: `[0, 100)`. |

Example:

```json
"forecast": {
  "ssa": {
    "decompose": {
      "singularValueThreshold": 0.5,
      "windowLength": 50
    }
  }
}
```

#### Auto Grouping Parameters

The fields described below must be included in the `forecast.ssa.group.auto` object.

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| `count` | number | Maximum number of eigenvector groups. The eigenvectors are placed into groups by the clustering method in Auto mode, or using by enumerating eigenvector indexes in Manual mode. The groups are sorted by maximum eigenvalue in descending order and are named with letters `A`, `B`, `C` etc.<br>If set to `0`, only one group is returned. |
| `stack` | boolean | Build groups recursively, starting with the group `A` with maximum eigenvalue, to view the cumulative effect of added eigenvectors. In enabled, group `A` contains its own eigenvectors. Group `B` contains its own eigenvectors as well as eigenvectors from group `A`. Group `C` includes its own eigenvectors as well as eigenvectors from group `A` and `B`, etc. |
| `union` | array | Join eigenvectors from automatically created groups into custom groups. Multiple custom groups are separated using comma. Groups within the custom group are enumerated using semi-colon as a separator or hyphen for range. For example, custom group `A;B;D` contains eigenvectors from automatic groups `A`, `B` and `D`. Custom group `A;C-E` contains eigenvectors from automatic groups `A`,`C`,`D`,`E`. |

Example:

```json
"forecast": {
  "ssa": {
    "group": {
      "auto": {
        "count": 3,
        "stack": true,
        "union": ["A;C-E", "B"]
      }
    }
  }
}
```

#### Auto Grouping Clustering Parameters

The fields described below must be included in the `forecast.ssa.group.auto.clustering` object.

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| `method` | string | Algorithm used to place eigenvectors into groups.<br>Possible values: `HIERARCHICAL`, `XMEANS`, `NOVOSIBIRSK`.<br>Default value: `HIERARCHICAL`. |
| `params` | object | Dictionary (map) of parameters required by the given clustering method. |

Example:

```json
"forecast": {
  "ssa": {
    "group": {
      "auto": {
        "count": 3,
        "clustering": {
          "method": "XMEANS"
        }
      }
    }
  }
}
```

#### Manual Grouping Parameters

The fields described below must be included in the `forecast.ssa.group.manual` object.

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| `groups` | array | Join eigenvectors using their index into custom groups. Multiple custom groups are separated using comma. Eigenvectors within the same group are enumerated using semi-colon as a separator or hyphen for range. For example, custom group `1;3-6` contains eigenvectors with indexes `1`, `3`, `4`, `5` and `6`. |

Example:

```json
"forecast": {
  "ssa": {
    "group": {
      "manual": {
        "groups": ["1-10;12", "11;13-"]
      }
    }
  }
}
```

#### Reconstruction Parameters

The fields described below must be included in the `forecast.ssa.reconstruct` object.

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| `averagingFunction` | string | Averaging function to calculate anti-diagonal elements of the reconstructed matrix.<br>Possible values: `AVG`, `MEDIAN`.<br>Default value: `AVG`. |
| `fourier` | boolean | Apply Fourier transform.<br>Default value: `true`. |

Example:

```json
"forecast": {
  "ssa": {
    "reconstruct": {
      "averagingFunction": "AVG"
    }
  }
}
```

#### Forecast Parameters

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| `method` | string | Forecast calculation method.<br>Possible values: `RECURRENT`, `VECTOR`.<br>Default value: `RECURRENT`. |
| `base` | boolean | Input series to which the recurrent formula is applied when calculating the forecast.<br>Possible values: `RECONSTRUCTED`, `ORIGINAL`. |

Example:

```json
"forecast": {
  "ssa": {
    "forecast": {
      "method": "RECURRENT"
    }
  }
}
```

## Examples

Generate SSA forecast for 1 day using the default parameters.

```json
[{
  "metric":"cpu_busy",
  "entity":"nurswgvml007",
  "aggregate":{"type":"AVG","period":{"count":1,"unit":"HOUR"}},
  "startDate": "2018-12-01T00:00:00Z",
  "endDate":   "2018-12-08T00:00:00Z",
  "forecast": {
    "horizon": {
      "interval": {"count": 1, "unit": "DAY"}
    },
    "include": ["HISTORY", "FORECAST"],
    "ssa": {}
  }
}]
```

Generate SSA forecast for 1 day and return 3 component groups.

```json
[{
  "metric":"cpu_busy",
  "entity":"nurswgvml007",
  "aggregate":{"type":"AVG","period":{"count":1,"unit":"HOUR"}},
  "startDate": "2018-12-01T00:00:00Z",
  "endDate":   "2018-12-08T00:00:00Z",
  "forecast": {
    "horizon": {
      "interval": {"count": 1, "unit": "DAY"}
    },
    "include": ["HISTORY", "FORECAST"],
    "ssa": {
      "group": {
        "auto": { "count": 3 }
      }
    }
  }
}]
```

```json
[
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "FORECAST",
    "transformationOrder": [
      "AGGREGATE",
      "FORECAST"
    ],
    "aggregate": {
      "type": "AVG",
      "period": {
        "count": 1,
        "unit": "HOUR",
        "align": "CALENDAR"
      },
      "interpolate": {
        "type": "LINEAR",
        "extend": false,
        "windowLength": 0
      }
    },
    "forecast": {
      "ssa": {
        "implementation": "JAVA",
        "averagingFunction": "AVG",
        "fourier": true,
        "svd": "FULL",
        "clustering": {
          "method": "HIERARCHICAL"
        },
        "groupCount": 3,
        "windowLength": 84,
        "singularValuesThreshold": -1,
        "matrixNorm": 1366.6989400912828,
        "totalEigentripleCount": 84,
        "usedEigentripleCount": 30,
        "discardedEigentripleCount": 54,
        "groupedEigentripleCount": 30,
        "maxSingularValue": 1248.3197826979504,
        "discardedSingularValue": 22.215178225695876,
        "minRetainedSingularValue": 1248.3197826979504,
        "scoreStDev": 6,
        "groupingType": "AUTO_AND_STACK",
        "groupOrder": 1,
        "stack": true,
        "joinedGroups": [
          "A"
        ],
        "eigentripleIndexes": [
          1
        ],
        "singularValues": [
          1248.3197826979504
        ]
      }
    },
    "data": [
      {
        "d": "2018-12-08T00:00:00.000Z",
        "v": 16.323130767882148
      },
      {
        "d": "2018-12-08T01:00:00.000Z",
        "v": 16.342557100645664
      },
      {
        "d": "2018-12-08T02:00:00.000Z",
        "v": 16.361999901649803
      },
      {
        "d": "2018-12-08T03:00:00.000Z",
        "v": 16.38146827162976
      },
      {
        "d": "2018-12-08T04:00:00.000Z",
        "v": 16.400950500421814
      },
      {
        "d": "2018-12-08T05:00:00.000Z",
        "v": 16.420467555096234
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "FORECAST",
    "transformationOrder": [
      "AGGREGATE",
      "FORECAST"
    ],
    "aggregate": {
      "type": "AVG",
      "period": {
        "count": 1,
        "unit": "HOUR",
        "align": "CALENDAR"
      },
      "interpolate": {
        "type": "LINEAR",
        "extend": false,
        "windowLength": 0
      }
    },
    "forecast": {
      "ssa": {
        "implementation": "JAVA",
        "averagingFunction": "AVG",
        "fourier": true,
        "svd": "FULL",
        "clustering": {
          "method": "HIERARCHICAL"
        },
        "groupCount": 3,
        "windowLength": 84,
        "singularValuesThreshold": -1,
        "matrixNorm": 1366.6989400912828,
        "totalEigentripleCount": 84,
        "usedEigentripleCount": 30,
        "discardedEigentripleCount": 54,
        "groupedEigentripleCount": 30,
        "maxSingularValue": 1248.3197826979504,
        "discardedSingularValue": 22.215178225695876,
        "minRetainedSingularValue": 77.62121560723442,
        "scoreStDev": 6,
        "groupingType": "AUTO_AND_STACK",
        "groupOrder": 2,
        "stack": true,
        "joinedGroups": [
          "A",
          "B"
        ],
        "eigentripleIndexes": [
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          24
        ],
        "singularValues": [
          1248.3197826979504,
          146.94530499128334,
          143.92794141473993,
          134.99099344398564,
          133.7233440792101,
          131.9598700252816,
          131.15575519259218,
          124.69099819793217,
          120.63396980913338,
          117.99711659180291,
          117.3125200770626,
          116.82382176224395,
          112.31205236484509,
          110.74873548967649,
          109.1089829354941,
          107.200678759671,
          99.56623413354185,
          97.73271184511265,
          96.49813770348236,
          92.718762965264,
          89.95945733645226,
          88.04449833394744,
          78.5215925412881,
          77.62121560723442
        ]
      }
    },
    "data": [
      {
        "d": "2018-12-08T00:00:00.000Z",
        "v": 16.941437368091886
      },
      {
        "d": "2018-12-08T01:00:00.000Z",
        "v": 12.939489053146213
      },
      {
        "d": "2018-12-08T02:00:00.000Z",
        "v": 11.16216931816397
      },
      {
        "d": "2018-12-08T03:00:00.000Z",
        "v": 18.375039896564356
      },
      {
        "d": "2018-12-08T04:00:00.000Z",
        "v": 13.609606683445598
      },
      {
        "d": "2018-12-08T05:00:00.000Z",
        "v": 13.272122376879008
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "FORECAST",
    "transformationOrder": [
      "AGGREGATE",
      "FORECAST"
    ],
    "aggregate": {
      "type": "AVG",
      "period": {
        "count": 1,
        "unit": "HOUR",
        "align": "CALENDAR"
      },
      "interpolate": {
        "type": "LINEAR",
        "extend": false,
        "windowLength": 0
      }
    },
    "forecast": {
      "ssa": {
        "implementation": "JAVA",
        "averagingFunction": "AVG",
        "fourier": true,
        "svd": "FULL",
        "clustering": {
          "method": "HIERARCHICAL"
        },
        "groupCount": 3,
        "windowLength": 84,
        "singularValuesThreshold": -1,
        "matrixNorm": 1366.6989400912828,
        "totalEigentripleCount": 84,
        "usedEigentripleCount": 30,
        "discardedEigentripleCount": 54,
        "groupedEigentripleCount": 30,
        "maxSingularValue": 1248.3197826979504,
        "discardedSingularValue": 22.215178225695876,
        "minRetainedSingularValue": 23.91003219261129,
        "scoreStDev": 6,
        "groupingType": "AUTO_AND_STACK",
        "groupOrder": 3,
        "stack": true,
        "joinedGroups": [
          "A",
          "B",
          "C"
        ],
        "eigentripleIndexes": [
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          24,
          25,
          26,
          27,
          28,
          29,
          30
        ],
        "singularValues": [
          1248.3197826979504,
          146.94530499128334,
          143.92794141473993,
          134.99099344398564,
          133.7233440792101,
          131.9598700252816,
          131.15575519259218,
          124.69099819793217,
          120.63396980913338,
          117.99711659180291,
          117.3125200770626,
          116.82382176224395,
          112.31205236484509,
          110.74873548967649,
          109.1089829354941,
          107.200678759671,
          99.56623413354185,
          97.73271184511265,
          96.49813770348236,
          92.718762965264,
          89.95945733645226,
          88.04449833394744,
          78.5215925412881,
          77.62121560723442,
          26.21438894527334,
          26.08667243107496,
          25.381606345570727,
          25.1518659560464,
          24.97900929304035,
          23.91003219261129
        ]
      }
    },
    "data": [
      {
        "d": "2018-12-08T00:00:00.000Z",
        "v": 16.0076042167122
      },
      {
        "d": "2018-12-08T01:00:00.000Z",
        "v": 14.01962309351334
      },
      {
        "d": "2018-12-08T02:00:00.000Z",
        "v": 11.958413336437872
      },
      {
        "d": "2018-12-08T03:00:00.000Z",
        "v": 17.71256946367641
      },
      {
        "d": "2018-12-08T04:00:00.000Z",
        "v": 13.062727400642963
      },
      {
        "d": "2018-12-08T05:00:00.000Z",
        "v": 14.110200706263136
      }
    ]
  }
]
```