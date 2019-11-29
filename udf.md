# Query API: MVEL преобразования рядов

Возможность выполнить одно MVEL выражение для запрошенных рядов.

Одну коллекцию можно, при желании, задать на верхнем уровне, остальные коллекции задаются в массиве
объектов series:

```json
  // first collection
  "name": "A",      // collection name
  "metric": "...",  // series key selectors
  "metrics": [...]  // one collection per metric will be created
  "entity": "...",
  "series": [
    {
      // second collection
      "name": "B",      // collection name
      "metric": "...",  // series key selectors
      "entity": "..."
    },
    {
      // third collection
    }
  ],
  "evaluate": {
    "mode": "NON-STRICT",
    "libs": ["my-lib.mvel", "helpers.mvel"],
    "expression": " A.calculateSomthing()",
    // "script": "script-file.mvel",
    "order": 2
  }
```

## Как обращаться к рядам в MVEL выражении

Основные объекты: `SeriesKey`, `Series`, `SeriesCollection`, `GroupedCollection` и `MultiSeriesCollection`.

Объект `SeriesCollection` доступен по имени указанному в поле `name` запроса. К коллекциям заданным полем `metrics` можно обращаться по имени метрики. Кроме того коллекции естественным :) образом упорядочены и доступны по именам `A`, `B`, ... .
Из коллекции можно достать содержащиеся в ней ряды - объекты `Series`, сгруппировать ряды и получить объект `GroupedCollection`, либо сопоставить ряды из одной коллекции с рядами из другой коллекции и получить объект `MultiSeriesCollection`.
У каждого объекта есть методы преобразовывающие ряды этого объекта.
У объектов `Series`, `SeriesCollection` и `MultiSeriesCollection` есть специальные методы `calculate` позволяющие оценить переданное MVEL выражение в подходящем контексте.

## Тестовые данные по загрузке авиарейсов

Метрики `flight.capacity` и `flight.load_pct` содержат
данные по загрузке авиарейсов - для каждого рейса известна вместимость самолета и доля занятых кресел (даты - в UTC).

| date                | airplane   | capacity | load_pct | passengers |
|---------------------|------------|----------|----------|------------|
| 2019-06-14 14:00:00 | airplane-1 |      100 |      0.6 |         60 |
| 2019-06-14 14:05:00 | airplane-2 |      300 |      0.8 |        240 |
| 2019-06-14 14:10:00 | airplane-1 |      100 |      0.7 |         70 |
| 2019-06-14 14:15:00 | airplane-3 |      100 |      0.7 |         70 |
| 2019-06-14 14:20:00 | airplane-1 |      100 |      0.9 |         90 |
| 2019-06-14 14:25:00 | airplane-4 |      500 |      0.5 |        250 |
| 2019-06-14 14:25:00 | airplane-2 |      300 |      0.6 |        180 |

<details><summary>Series-команды для закладки данных</summary>

```text
series d:2019-06-14T14:00:00Z e:airplane-1 m:flight.capacity=100
series d:2019-06-14T14:05:00Z e:airplane-2 m:flight.capacity=300
series d:2019-06-14T14:10:00Z e:airplane-1 m:flight.capacity=100
series d:2019-06-14T14:15:00Z e:airplane-3 m:flight.capacity=100
series d:2019-06-14T14:20:00Z e:airplane-1 m:flight.capacity=100
series d:2019-06-14T14:25:00Z e:airplane-4 m:flight.capacity=500
series d:2019-06-14T14:25:00Z e:airplane-2 m:flight.capacity=300

series d:2019-06-14T14:00:00Z e:airplane-1 m:flight.load_pct=0.6
series d:2019-06-14T14:05:00Z e:airplane-2 m:flight.load_pct=0.8
series d:2019-06-14T14:10:00Z e:airplane-1 m:flight.load_pct=0.7
series d:2019-06-14T14:15:00Z e:airplane-3 m:flight.load_pct=0.7
series d:2019-06-14T14:20:00Z e:airplane-1 m:flight.load_pct=0.9
series d:2019-06-14T14:25:00Z e:airplane-4 m:flight.load_pct=0.5
series d:2019-06-14T14:25:00Z e:airplane-2 m:flight.load_pct=0.6
```

</details>

## Пример - объединение коллекций и рядов

MVEL выражение `[x, y]` создает список из `x` и `y`, а выражение `{x, y}` создает массив.
Любое из этих выражений можно использовать, чтобы объединить коллекции или ряды между собой.

API запрос - массив коллекций

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "metrics": ["flight.capacity", "flight.load_pct"],
  "entity": "*",
  "evaluate": {
    "expression": "{flight.capacity, flight.load_pct}"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "flight.capacity",
    "entity": "airplane-1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 100
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 100
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 100
      }
    ]
  },
  {
    "metric": "flight.capacity",
    "entity": "airplane-2",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:05:00.000Z",
        "v": 300
      },
      {
        "d": "2019-06-14T14:25:00.000Z",
        "v": 300
      }
    ]
  },
  {
    "metric": "flight.capacity",
    "entity": "airplane-3",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:15:00.000Z",
        "v": 100
      }
    ]
  },
  {
    "metric": "flight.capacity",
    "entity": "airplane-4",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:25:00.000Z",
        "v": 500
      }
    ]
  },
  {
    "metric": "flight.load_pct",
    "entity": "airplane-1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 0.6
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 0.7
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 0.9
      }
    ]
  },
  {
    "metric": "flight.load_pct",
    "entity": "airplane-2",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:05:00.000Z",
        "v": 0.8
      },
      {
        "d": "2019-06-14T14:25:00.000Z",
        "v": 0.6
      }
    ]
  },
  {
    "metric": "flight.load_pct",
    "entity": "airplane-3",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:15:00.000Z",
        "v": 0.7
      }
    ]
  },
  {
    "metric": "flight.load_pct",
    "entity": "airplane-4",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:25:00.000Z",
        "v": 0.5
      }
    ]
  }
]
```

</details>

API запрос - список рядов

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "metrics": ["flight.capacity", "flight.load_pct"],
  "entity": "*",
  "evaluate": {
    "expression": "[flight.capacity.seriesList(), flight.load_pct.seriesList()]"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "flight.capacity",
    "entity": "airplane-1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 100
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 100
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 100
      }
    ]
  },
  {
    "metric": "flight.capacity",
    "entity": "airplane-2",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:05:00.000Z",
        "v": 300
      },
      {
        "d": "2019-06-14T14:25:00.000Z",
        "v": 300
      }
    ]
  },
  {
    "metric": "flight.capacity",
    "entity": "airplane-3",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:15:00.000Z",
        "v": 100
      }
    ]
  },
  {
    "metric": "flight.capacity",
    "entity": "airplane-4",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:25:00.000Z",
        "v": 500
      }
    ]
  },
  {
    "metric": "flight.load_pct",
    "entity": "airplane-1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 0.6
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 0.7
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 0.9
      }
    ]
  },
  {
    "metric": "flight.load_pct",
    "entity": "airplane-2",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:05:00.000Z",
        "v": 0.8
      },
      {
        "d": "2019-06-14T14:25:00.000Z",
        "v": 0.6
      }
    ]
  },
  {
    "metric": "flight.load_pct",
    "entity": "airplane-3",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:15:00.000Z",
        "v": 0.7
      }
    ]
  },
  {
    "metric": "flight.load_pct",
    "entity": "airplane-4",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:25:00.000Z",
        "v": 0.5
      }
    ]
  }
]
```

</details>

## Пример - фильтрация коллекции по сущности

Коллекцию можно отфильтровать по ключам рядов.
В выражении передаваемом методу `filter()` имя сущности хранится в переменной `entity`,
имя метрики - в переменной `metric`,
а тэги в переменной `tags`.
Например отфильтруем ряды по сущности.
Пример фильтрации по тэгам приведен для других данных (с тэгами).

API запрос - фильтрация по сущности

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "metric": "flight.load_pct",
  "entity": "*",
  "evaluate": {
    "expression": "flight.load_pct.filter('entity == \"airplane-1\" || entity == \"airplane-3\"')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "flight.load_pct",
    "entity": "airplane-1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 0.6
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 0.7
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 0.9
      }
    ]
  },
  {
    "metric": "flight.load_pct",
    "entity": "airplane-3",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:15:00.000Z",
        "v": 0.7
      }
    ]
  }
]
```

</details>

Выражение передаваемое в метод `filter(expression)` можно присвоить переменной
или определить как функцию:

API запрос - фильтрация с использованием функции

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "metric": "flight.load_pct",
  "entity": "*",
  "evaluate": {
    "expression": "def match(){entity == 'airplane-1' || entity == 'airplane-3'} flight.load_pct.filter('match()')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "flight.load_pct",
    "entity": "airplane-1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 0.6
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 0.7
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 0.9
      }
    ]
  },
  {
    "metric": "flight.load_pct",
    "entity": "airplane-3",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:15:00.000Z",
        "v": 0.7
      }
    ]
  }
]
```

</details>

## Пример - сопоставление рядов, арифметические операции

Посчитаем долю занятых кресел по всем рейсам,
то есть отношение суммы всех занятых кресел (по всем рейсам) к сумме всех посадочных мест (по всем рейсам).

API запрос

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "series": [
    {
      "name": "capacity",
      "metric": "flight.capacity",
      "entity": "*"
    },
    {
      "name": "load",
      "metric": "flight.load_pct",
      "entity": "*"
    }
  ],
  "evaluate": {
    "expression": "capacity.pair(load, 'entity').prod().totalSum() / capacity.totalSum()"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": null,
    "entity": "",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "1970-01-01T00:00:00.000Z",
        "v": 0.64
      }
    ]
  }
]
```

</details>

## Пример - другое задания коллекций

Посчитаем долю занятых кресел для каждой сущности (самолета) в отдельности.

API запрос

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "metrics": ["flight.capacity", "flight.load_pct"],
  "entity": "*",
  "evaluate": {
    "expression": "flight.capacity.pair(flight.load_pct, 'entity').dotProd().divide(flight.capacity.seriesSum(), 'entity')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": null,
    "entity": "airplane-1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "1970-01-01T00:00:00.000Z",
        "v": 0.7333333333333333
      }
    ]
  },
  {
    "metric": null,
    "entity": "airplane-2",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "1970-01-01T00:00:00.000Z",
        "v": 0.7
      }
    ]
  },
  {
    "metric": null,
    "entity": "airplane-3",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "1970-01-01T00:00:00.000Z",
        "v": 0.7
      }
    ]
  },
  {
    "metric": null,
    "entity": "airplane-4",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "1970-01-01T00:00:00.000Z",
        "v": 0.5
      }
    ]
  }
]
```

</details>

## Пример - обращение к коллекциям через `A`, `B`, ... . Аггрегирующие функции с периодом

Посчитаем долю занятых кресел для 10 минутных интервалов.

API запрос

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "metrics": ["flight.capacity", "flight.load_pct"],
  "entity": "*",
  "evaluate": {
    "expression": "A.pair(B, 'entity').prod().totalSum('10 minute').divide(A.totalSum('10 minute'))"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": null,
    "entity": "",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 0.75
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 0.7
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 0.5777777777777777
      }
    ]
  }
]
```

</details>

## Пример - все вместе

Посчитаем долю занятых кресел и для каждого самолета в отдельности и для 10 минутных интервалов.

API запрос

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "series": [
    {
      "name": "capacity",
      "metric": "flight.capacity",
      "entity": "*"
    },
    {
      "name": "load",
      "metric": "flight.load_pct",
      "entity": "*"
    }
  ],
  "evaluate": {
    "expression": "capacity.multiply(load, 'entity').seriesSum('10 minute').divide(capacity.seriesSum('10 minute'), 'entity')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": null,
    "entity": "airplane-1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 0.6
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 0.7
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 0.9
      }
    ]
  },
  {
    "metric": null,
    "entity": "airplane-2",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 0.8
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": null
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 0.6
      }
    ]
  },
  {
    "metric": null,
    "entity": "airplane-3",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": null
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 0.7
      }
    ]
  },
  {
    "metric": null,
    "entity": "airplane-4",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": null
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": null
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 0.5
      }
    ]
  }
]
```

</details>

## Пример - фунция `wavg`

На этот раз посчитаем долю занятых кресел и для каждого самолета в отдельности и для 10 минутных интервалов с помощью функции `wavg`.

API запрос

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "metrics": ["flight.load_pct", "flight.capacity"],
  "entity": "*",
  "evaluate": {
    "expression": "wavg(A, B, '10 minute')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "udf",
    "entity": "airplane-1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 0.6
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 0.7
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 0.9
      }
    ]
  },
  {
    "metric": "udf",
    "entity": "airplane-2",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 0.8
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": null
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 0.6
      }
    ]
  },
  {
    "metric": "udf",
    "entity": "airplane-3",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 0.7
      }
    ]
  },
  {
    "metric": "udf",
    "entity": "airplane-4",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 0.5
      }
    ]
  }
]
```

</details>

## Пример - применение математической функции к каждому элементу ряда

Возьмем один из рядов с метрикой `flight.capacity` и вычислим квадратный корень для каждого значения в этом ряду.

API запрос

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "metric": "flight.capacity",
  "entity": "airplane-1",
  "evaluate": {
    "expression": "A.firstSeries().forEach('Math.sqrt(v)')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "flight.capacity",
    "entity": "airplane-1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 10
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 10
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 10
      }
    ]
  }
]
```

</details>

## Пример - значение ряда по дате

Найдем значение метрики `flight.capacity` во время `2019-06-14 14:15:00` по `UTC`,
или `2019-06-14 17:15:00` по `MSK` для каждого самолета.

API запрос

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "metric": "flight.capacity",
  "entity": "*",
  "evaluate": {
    "expression": "A.value('2019-06-14 17:15:00')",
    "timezone": "Europe/Moscow"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "flight.capacity",
    "entity": "airplane-1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T00:00:00.000Z",
        "v": null
      }
    ]
  },
  {
    "metric": "flight.capacity",
    "entity": "airplane-2",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T00:00:00.000Z",
        "v": null
      }
    ]
  },
  {
    "metric": "flight.capacity",
    "entity": "airplane-3",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T00:00:00.000Z",
        "v": 100
      }
    ]
  },
  {
    "metric": "flight.capacity",
    "entity": "airplane-4",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T00:00:00.000Z",
        "v": null
      }
    ]
  }
]
```

</details>

## Пример - интерполированное значение ряда

Найдем интерполированное значение метрики `flight.load_percent` в
`2019-06-14 17:15:00` по `MSK` для каждого самолета.

API запрос

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "metric": "flight.load_pct",
  "entity": "*",
  "evaluate": {
    "expression": "flight.load_pct.value('2019-06-14 17:15:00', 'linear')",
    "timezone": "Europe/Moscow"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "flight.load_pct",
    "entity": "airplane-1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:15:00.000Z",
        "v": 0.8
      }
    ]
  },
  {
    "metric": "flight.load_pct",
    "entity": "airplane-2",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:15:00.000Z",
        "v": 0.7
      }
    ]
  },
  {
    "metric": "flight.load_pct",
    "entity": "airplane-3",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:15:00.000Z",
        "v": 0.7
      }
    ]
  },
  {
    "metric": "flight.load_pct",
    "entity": "airplane-4",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:15:00.000Z",
        "v": null
      }
    ]
  }
]
```
</details>

</details>

## Пример - использование add_time

Выведем значение метрики `flight.load_percent` с 10 минутной задержкой.

API запрос

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "metric": "flight.load_pct",
  "entity": "airplane-1",
  "evaluate": {
    "expression": "flight.load_pct.forEach('value(time_add(\"-10 minute\"))')",
    "timezone": "UTC"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "flight.load_pct",
    "entity": "airplane-1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": null
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 0.6
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 0.7
      }
    ]
  }
]
```

</details>

## Пример - использование переменной и функции определенных в главном контексте в выражении переданном в метод `forEach()`

В основном выражении можно определять переменные и функции,
которые доступны в выражениях передаваемых в методы `calculate()` и `forEach()`.

В этом примере определяется переменная `period` и функция `transform()`,
которые затем используются в выражении передаваемом методу `forEach()`.

API запрос

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "metric": "flight.load_pct",
  "entity": "*",
  "evaluate": {
    "expression": "delta = '10 minute'; def transform(period) {v + value(time_add(period))} A.firstSeries().forEach('transform(delta)')"
  }
}]
```

Так же можно передавать MVEL функцию и ее аргументы не как строку, которая оценивается методами `calculate()` и `forEach()`, а как апгументы этих методов.
В данном случае вместо `forEach('transform(delta)')` можно вызвать метод `forEach` так: `forEach(transform, delta)`.

API запрос

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "metric": "flight.load_pct",
  "entity": "*",
  "evaluate": {
    "expression": "delta = '10 minute'; def transform(period) {v + value(time_add(period))} A.firstSeries().forEach(transform, delta)"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "flight.load_pct",
    "entity": "airplane-1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 1.2999999999999998
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 1.6
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": null
      }
    ]
  }
]
```

</details>

## Еще тестовые данные

Все данные для 2019-06-14 в 14 часов по UTC. В таблице указаны минуты.

| метр:сущн:тэги | 00 | 04 | 06 | 07 | 09 | 10 | 11 | 14 | 19 | 20 | 21 | 23 |
|----------------|----|----|----|----|----|----|----|----|----|----|----|----|
| m1:e1          |  1 |  1 |  7 |  3 |  4 |  2 |  1 |  8 |  0 |  2 |  7 |  5 |
| m1:e1:tn=tv1   |  3 |  1 |  2 |  4 |  7 |  9 |  1 |  0 |  5 |  4 |  3 |  8 |

<details><summary>Series-команды для закладки данных</summary>

```text
series d:2019-06-14T14:00:00Z e:e1 m:m1=1
series d:2019-06-14T14:04:00Z e:e1 m:m1=1
series d:2019-06-14T14:06:00Z e:e1 m:m1=7
series d:2019-06-14T14:07:00Z e:e1 m:m1=3
series d:2019-06-14T14:09:00Z e:e1 m:m1=4
series d:2019-06-14T14:10:00Z e:e1 m:m1=2
series d:2019-06-14T14:11:00Z e:e1 m:m1=1
series d:2019-06-14T14:14:00Z e:e1 m:m1=8
series d:2019-06-14T14:19:00Z e:e1 m:m1=0
series d:2019-06-14T14:20:00Z e:e1 m:m1=2
series d:2019-06-14T14:21:00Z e:e1 m:m1=7
series d:2019-06-14T14:23:00Z e:e1 m:m1=5

series d:2019-06-14T14:00:00Z e:e1 m:m1=3 t:tn=tv1
series d:2019-06-14T14:04:00Z e:e1 m:m1=1 t:tn=tv1
series d:2019-06-14T14:06:00Z e:e1 m:m1=2 t:tn=tv1
series d:2019-06-14T14:07:00Z e:e1 m:m1=4 t:tn=tv1
series d:2019-06-14T14:09:00Z e:e1 m:m1=7 t:tn=tv1
series d:2019-06-14T14:10:00Z e:e1 m:m1=9 t:tn=tv1
series d:2019-06-14T14:11:00Z e:e1 m:m1=1 t:tn=tv1
series d:2019-06-14T14:14:00Z e:e1 m:m1=0 t:tn=tv1
series d:2019-06-14T14:19:00Z e:e1 m:m1=5 t:tn=tv1
series d:2019-06-14T14:20:00Z e:e1 m:m1=4 t:tn=tv1
series d:2019-06-14T14:21:00Z e:e1 m:m1=3 t:tn=tv1
series d:2019-06-14T14:23:00Z e:e1 m:m1=8 t:tn=tv1
```

</details>

## Пример - `calculate(expr)` - `expr` оценивается один раз

Найдем сколько четных чисел в каждом ряду.

API запрос

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "metric": "m1",
  "entity": "e1",
  "evaluate": {
    "expression": "m1.calculate('result = 0; foreach(value : series.values()) {if ((int) value % 2 == 0) {result++;}} return result;')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "m1",
    "entity": "e1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "1970-01-01T00:00:00.000Z",
        "v": 5
      }
    ]
  },
  {
    "metric": "m1",
    "entity": "e1",
    "tags": {
      "tn": "tv1"
    },
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "1970-01-01T00:00:00.000Z",
        "v": 5
      }
    ]
  }
]
```

</details>

## Пример - `forEach(expr)` - `expr` оценивается для каждого элемента ряда

Найдем сколько раз значение первого ряда было больше значения второго ряда.

API запрос

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "name": "A",
  "metric": "m1",
  "entity": "e1",
  "evaluate": {
    "expression": "A.toMultiCollection().forEach('A > B ? 1 : 0').seriesSum()"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "m1",
    "entity": "",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "1970-01-01T00:00:00.000Z",
        "v": 3
      }
    ]
  }
]
```

</details>

## Пример  - `calculate(expr, perid)` - `expr` оценивается по разу для каждого интервала

Для каждого ряда разобьем время на 10 минутные интервалы и найдем последнee значение ряда на интервале.

API запрос

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "name": "A",
  "metric": "m1",
  "entity": "e1",
  "evaluate": {
    "expression": "A.calculate('intervalSamples.lastEntry().getValue()', '10 minute')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "m1",
    "entity": "e1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 4
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 0
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 5
      }
    ]
  },
  {
    "metric": "m1",
    "entity": "e1",
    "tags": {
      "tn": "tv1"
    },
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 7
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 5
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 8
      }
    ]
  }
]
```

</details>

## Пример - использование переменных из контекста при вычислениях на интервале

Для каждого ряда разобьем время на 5 минутные интервалы.
Для четных интервалов вернем 111, для нечетных найдем разницу между временем первого значения на интервале и началом интервала.

API запрос

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "name": "A",
  "metric": "m1",
  "entity": "e1",
  "evaluate": {
    "expression": "A.firstSeries().calculate('iIndex % 2 == 0 ? 111 : (intervalSamples.firstEntry().getKey() - intervalStart) / 60000', '5 minute')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "m1",
    "entity": "e1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 111
      },
      {
        "d": "2019-06-14T14:05:00.000Z",
        "v": 1
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 111
      },
      {
        "d": "2019-06-14T14:15:00.000Z",
        "v": 4
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 111
      }
    ]
  }
]
```

</details>

## Пример - использование `memory` для хранения значений при многократном оценивании выражения

Для каждого значения ряда посчитаем его разность с наибольшим из предшествующих значений.

API запрос

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "name": "A",
  "metric": "m1",
  "entity": "e1",
  "evaluate": {
    "expression": "A.forEach('if (memory.isEmpty()) {memory.put(\"max\", v); return Double.NaN;} max = memory.get(\"max\"); if (v > max) {memory.put(\"max\", v);} return v - max;')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "m1",
    "entity": "e1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": null
      },
      {
        "d": "2019-06-14T14:04:00.000Z",
        "v": 0
      },
      {
        "d": "2019-06-14T14:06:00.000Z",
        "v": 6
      },
      {
        "d": "2019-06-14T14:07:00.000Z",
        "v": -4
      },
      {
        "d": "2019-06-14T14:09:00.000Z",
        "v": -3
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": -5
      },
      {
        "d": "2019-06-14T14:11:00.000Z",
        "v": -6
      },
      {
        "d": "2019-06-14T14:14:00.000Z",
        "v": 1
      },
      {
        "d": "2019-06-14T14:19:00.000Z",
        "v": -8
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": -6
      },
      {
        "d": "2019-06-14T14:21:00.000Z",
        "v": -1
      },
      {
        "d": "2019-06-14T14:23:00.000Z",
        "v": -3
      }
    ]
  },
  {
    "metric": "m1",
    "entity": "e1",
    "tags": {
      "tn": "tv1"
    },
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": null
      },
      {
        "d": "2019-06-14T14:04:00.000Z",
        "v": -2
      },
      {
        "d": "2019-06-14T14:06:00.000Z",
        "v": -1
      },
      {
        "d": "2019-06-14T14:07:00.000Z",
        "v": 1
      },
      {
        "d": "2019-06-14T14:09:00.000Z",
        "v": 3
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 2
      },
      {
        "d": "2019-06-14T14:11:00.000Z",
        "v": -8
      },
      {
        "d": "2019-06-14T14:14:00.000Z",
        "v": -9
      },
      {
        "d": "2019-06-14T14:19:00.000Z",
        "v": -4
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": -5
      },
      {
        "d": "2019-06-14T14:21:00.000Z",
        "v": -6
      },
      {
        "d": "2019-06-14T14:23:00.000Z",
        "v": -1
      }
    ]
  }
]
```

</details>

## Пример - `forEach(expr, period)` - `expr` оценивается для каждого элемента ряда в контексте текущего интервала

То же самое, что в предыдущем примере, но только для второго ряда и для 10 минутных интервалов. То есть для каждого значения ряда посчитаем его разность с наибольшим из предшествующих значений на том же интервале.

API запрос

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "name": "A",
  "metric": "m1",
  "entity": "e1",
  "evaluate": {
    "expression": "A.seriesList().get(1).forEach('if (sIndex == 0) {memory.put(\"max\", v); return Double.NaN;} max = memory.get(\"max\"); if (v > max) {memory.put(\"max\", v);} return v - max;', '10 minute')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "m1",
    "entity": "e1",
    "tags": {
      "tn": "tv1"
    },
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": null
      },
      {
        "d": "2019-06-14T14:04:00.000Z",
        "v": -2
      },
      {
        "d": "2019-06-14T14:06:00.000Z",
        "v": -1
      },
      {
        "d": "2019-06-14T14:07:00.000Z",
        "v": 1
      },
      {
        "d": "2019-06-14T14:09:00.000Z",
        "v": 3
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": null
      },
      {
        "d": "2019-06-14T14:11:00.000Z",
        "v": -8
      },
      {
        "d": "2019-06-14T14:14:00.000Z",
        "v": -9
      },
      {
        "d": "2019-06-14T14:19:00.000Z",
        "v": -4
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": null
      },
      {
        "d": "2019-06-14T14:21:00.000Z",
        "v": -1
      },
      {
        "d": "2019-06-14T14:23:00.000Z",
        "v": 4
      }
    ]
  }
]
```

</details>

## Еще тестовые метрики

Все данные для 2019-06-14 в 14 часов по UTC. В таблице указаны минуты.

| метр:сущн:тэги | 00 | 04 | 06 | 07 | 09 | 10 | 11 | 14 | 19 | 20 | 21 | 23 |
|----------------|----|----|----|----|----|----|----|----|----|----|----|----|
| m1:e1          |  1 |  1 |  7 |  3 |  4 |  2 |  1 |  8 |  0 |  2 |  7 |  5 |
| m1:e1:tn=tv1   |  3 |  1 |  2 |  4 |  7 |  9 |  1 |  0 |  5 |  4 |  3 |  8 |
| m1:e2          |  7 |  1 |  5 |  4 |  8 |  3 |  7 |  2 |  4 |  9 |  4 |  7 |
| m1:e2:tn=tv1   |  3 |  4 |  2 |  6 |  9 |  1 |  4 |  7 |  7 |  5 |  7 |  3 |
| m2:e1          |  8 |  6 |  7 |  8 |  0 |  9 |  9 |  1 |  4 |  1 |  5 |  8 |
| m2:e1:tn=tv1   |  4 |  1 |  8 |  2 |  5 |  5 |  6 |  0 |  2 |  8 |  3 |  9 |

<details><summary>Series-команды для закладки данных</summary>

```text
series d:2019-06-14T14:00:00Z e:e1 m:m1=1
series d:2019-06-14T14:04:00Z e:e1 m:m1=1
series d:2019-06-14T14:06:00Z e:e1 m:m1=7
series d:2019-06-14T14:07:00Z e:e1 m:m1=3
series d:2019-06-14T14:09:00Z e:e1 m:m1=4
series d:2019-06-14T14:10:00Z e:e1 m:m1=2
series d:2019-06-14T14:11:00Z e:e1 m:m1=1
series d:2019-06-14T14:14:00Z e:e1 m:m1=8
series d:2019-06-14T14:19:00Z e:e1 m:m1=0
series d:2019-06-14T14:20:00Z e:e1 m:m1=2
series d:2019-06-14T14:21:00Z e:e1 m:m1=7
series d:2019-06-14T14:23:00Z e:e1 m:m1=5

series d:2019-06-14T14:00:00Z e:e1 m:m1=3 t:tn=tv1
series d:2019-06-14T14:04:00Z e:e1 m:m1=1 t:tn=tv1
series d:2019-06-14T14:06:00Z e:e1 m:m1=2 t:tn=tv1
series d:2019-06-14T14:07:00Z e:e1 m:m1=4 t:tn=tv1
series d:2019-06-14T14:09:00Z e:e1 m:m1=7 t:tn=tv1
series d:2019-06-14T14:10:00Z e:e1 m:m1=9 t:tn=tv1
series d:2019-06-14T14:11:00Z e:e1 m:m1=1 t:tn=tv1
series d:2019-06-14T14:14:00Z e:e1 m:m1=0 t:tn=tv1
series d:2019-06-14T14:19:00Z e:e1 m:m1=5 t:tn=tv1
series d:2019-06-14T14:20:00Z e:e1 m:m1=4 t:tn=tv1
series d:2019-06-14T14:21:00Z e:e1 m:m1=3 t:tn=tv1
series d:2019-06-14T14:23:00Z e:e1 m:m1=8 t:tn=tv1

series d:2019-06-14T14:00:00Z e:e2 m:m1=7
series d:2019-06-14T14:04:00Z e:e2 m:m1=1
series d:2019-06-14T14:06:00Z e:e2 m:m1=5
series d:2019-06-14T14:07:00Z e:e2 m:m1=4
series d:2019-06-14T14:09:00Z e:e2 m:m1=8
series d:2019-06-14T14:10:00Z e:e2 m:m1=3
series d:2019-06-14T14:11:00Z e:e2 m:m1=7
series d:2019-06-14T14:14:00Z e:e2 m:m1=2
series d:2019-06-14T14:19:00Z e:e2 m:m1=4
series d:2019-06-14T14:20:00Z e:e2 m:m1=9
series d:2019-06-14T14:21:00Z e:e2 m:m1=4
series d:2019-06-14T14:23:00Z e:e2 m:m1=7

series d:2019-06-14T14:00:00Z e:e2 m:m1=3 t:tn=tv1
series d:2019-06-14T14:04:00Z e:e2 m:m1=4 t:tn=tv1
series d:2019-06-14T14:06:00Z e:e2 m:m1=2 t:tn=tv1
series d:2019-06-14T14:07:00Z e:e2 m:m1=6 t:tn=tv1
series d:2019-06-14T14:09:00Z e:e2 m:m1=9 t:tn=tv1
series d:2019-06-14T14:10:00Z e:e2 m:m1=1 t:tn=tv1
series d:2019-06-14T14:11:00Z e:e2 m:m1=4 t:tn=tv1
series d:2019-06-14T14:14:00Z e:e2 m:m1=7 t:tn=tv1
series d:2019-06-14T14:19:00Z e:e2 m:m1=7 t:tn=tv1
series d:2019-06-14T14:20:00Z e:e2 m:m1=5 t:tn=tv1
series d:2019-06-14T14:21:00Z e:e2 m:m1=7 t:tn=tv1
series d:2019-06-14T14:23:00Z e:e2 m:m1=3 t:tn=tv1

series d:2019-06-14T14:00:00Z e:e1 m:m2=8
series d:2019-06-14T14:04:00Z e:e1 m:m2=6
series d:2019-06-14T14:06:00Z e:e1 m:m2=7
series d:2019-06-14T14:07:00Z e:e1 m:m2=8
series d:2019-06-14T14:09:00Z e:e1 m:m2=0
series d:2019-06-14T14:10:00Z e:e1 m:m2=9
series d:2019-06-14T14:11:00Z e:e1 m:m2=9
series d:2019-06-14T14:14:00Z e:e1 m:m2=1
series d:2019-06-14T14:19:00Z e:e1 m:m2=4
series d:2019-06-14T14:20:00Z e:e1 m:m2=1
series d:2019-06-14T14:21:00Z e:e1 m:m2=5
series d:2019-06-14T14:23:00Z e:e1 m:m2=8

series d:2019-06-14T14:00:00Z e:e1 m:m2=4 t:tn=tv1
series d:2019-06-14T14:04:00Z e:e1 m:m2=1 t:tn=tv1
series d:2019-06-14T14:06:00Z e:e1 m:m2=8 t:tn=tv1
series d:2019-06-14T14:07:00Z e:e1 m:m2=2 t:tn=tv1
series d:2019-06-14T14:09:00Z e:e1 m:m2=5 t:tn=tv1
series d:2019-06-14T14:10:00Z e:e1 m:m2=5 t:tn=tv1
series d:2019-06-14T14:11:00Z e:e1 m:m2=6 t:tn=tv1
series d:2019-06-14T14:14:00Z e:e1 m:m2=0 t:tn=tv1
series d:2019-06-14T14:19:00Z e:e1 m:m2=2 t:tn=tv1
series d:2019-06-14T14:20:00Z e:e1 m:m2=8 t:tn=tv1
series d:2019-06-14T14:21:00Z e:e1 m:m2=3 t:tn=tv1
series d:2019-06-14T14:23:00Z e:e1 m:m2=9 t:tn=tv1
```

</details>

## Пример - сопоставление рядов из 3 коллекций по тэгам

Разобьем ряды по тэгам, так что получится 2 группы по 3 ряда в каждой, и вычтем ряд с метрикой m2 из суммы рядов с метрикой m1.

API запрос

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "name": "A",
  "metric": "m1",
  "entity": "e1",
    "series": [
    {
      "name": "B",
      "metric": "m1",
      "entity": "e2"
    },
    {
      "name": "C",
      "metric": "m2",
      "entity": "e1"
    }
  ],
  "evaluate": {
    "expression": "join('tags', A, B, C).forEach('A + B - C')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "m1",
    "entity": "",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 0
      },
      {
        "d": "2019-06-14T14:04:00.000Z",
        "v": -4
      },
      {
        "d": "2019-06-14T14:06:00.000Z",
        "v": 5
      },
      {
        "d": "2019-06-14T14:07:00.000Z",
        "v": -1
      },
      {
        "d": "2019-06-14T14:09:00.000Z",
        "v": 12
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": -4
      },
      {
        "d": "2019-06-14T14:11:00.000Z",
        "v": -1
      },
      {
        "d": "2019-06-14T14:14:00.000Z",
        "v": 9
      },
      {
        "d": "2019-06-14T14:19:00.000Z",
        "v": 0
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 10
      },
      {
        "d": "2019-06-14T14:21:00.000Z",
        "v": 6
      },
      {
        "d": "2019-06-14T14:23:00.000Z",
        "v": 4
      }
    ]
  },
  {
    "metric": "m1",
    "entity": "",
    "tags": {
      "tn": "tv1"
    },
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 2
      },
      {
        "d": "2019-06-14T14:04:00.000Z",
        "v": 4
      },
      {
        "d": "2019-06-14T14:06:00.000Z",
        "v": -4
      },
      {
        "d": "2019-06-14T14:07:00.000Z",
        "v": 8
      },
      {
        "d": "2019-06-14T14:09:00.000Z",
        "v": 11
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 5
      },
      {
        "d": "2019-06-14T14:11:00.000Z",
        "v": -1
      },
      {
        "d": "2019-06-14T14:14:00.000Z",
        "v": 7
      },
      {
        "d": "2019-06-14T14:19:00.000Z",
        "v": 10
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 1
      },
      {
        "d": "2019-06-14T14:21:00.000Z",
        "v": 7
      },
      {
        "d": "2019-06-14T14:23:00.000Z",
        "v": 2
      }
    ]
  }
]
```

</details>

## Пример - фильтрация коллекции по тэгам

Отфильтруем результат предыдущего примера, оставив только ряды у которых значение тэга `tn` равно `tv1`.
При оценивании выражения переданного в функцию `filter` тэги доступны как значение переменной `tags`.

API запрос - фильтрация по тэгу

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "name": "A",
  "metric": "m1",
  "entity": "e1",
    "series": [
    {
      "name": "B",
      "metric": "m1",
      "entity": "e2"
    },
    {
      "name": "C",
      "metric": "m2",
      "entity": "e1"
    }
  ],
  "evaluate": {
    "expression": "def match(){tags['tn'] == 'tv1'} join('tags', A, B, C).forEach('A + B - C').filter('match()')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "udf",
    "entity": "udf-0",
    "tags": {
      "tn": "tv1"
    },
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-06-14T14:00:00.000Z",
        "v": 2
      },
      {
        "d": "2019-06-14T14:04:00.000Z",
        "v": 4
      },
      {
        "d": "2019-06-14T14:06:00.000Z",
        "v": -4
      },
      {
        "d": "2019-06-14T14:07:00.000Z",
        "v": 8
      },
      {
        "d": "2019-06-14T14:09:00.000Z",
        "v": 11
      },
      {
        "d": "2019-06-14T14:10:00.000Z",
        "v": 5
      },
      {
        "d": "2019-06-14T14:11:00.000Z",
        "v": -1
      },
      {
        "d": "2019-06-14T14:14:00.000Z",
        "v": 7
      },
      {
        "d": "2019-06-14T14:19:00.000Z",
        "v": 10
      },
      {
        "d": "2019-06-14T14:20:00.000Z",
        "v": 1
      },
      {
        "d": "2019-06-14T14:21:00.000Z",
        "v": 7
      },
      {
        "d": "2019-06-14T14:23:00.000Z",
        "v": 2
      }
    ]
  }
]
```

</details>

## Доступ к объекту DateTime

При оценивании MVEL выражения в методах `calculate(...)`, `forEach(...)` объектов `Series`, `SeriesColletion`, `MultiCollection`
можно получить объект `DateTime`, следующими методами:

```java
/**
 * Return {@link DateTime} implementation for current timestamp {@link #t},
 * calendar specified in the {@code default.holiday.calendar} server property,
 * and timezone specified in the query (server timezone by default).
 */
 d
```

```java
/**
 * Return {@link DateTime} implementation for current timestamp {@link #t},
 * specified holiday calendar,
 * and timezone specified in the query (server timezone by default).
 */
 d(String calendar)
```

```java
    /**
     * Return {@link DateTime} implementation for specified timestamp,
     * calendar specified in the {@code default.holiday.calendar} server property,
     * and timezone specified in the query (server timezone by default).
     */
 d(long timestamp)
```

```java
/**
 * Return {@link DateTime} implementation for specified timestamp,
 * specified holiday calendar,
 * and timezone specified in the query (server timezone by default).
 */

  public DateTime d(long timestamp, String calendar)
```

```java
/** Return DateTime object for specified parameters. */
d(long timestamp, String calendar, TimeZone timezone) {
```

## Метрики для демонстрации использование DateTime

дни в мае 2019 года, в 14:00 дня по UTC.

|метр:сущн|8 Wed|9 Thu<br>VictoryDay|10 Fri<br> additional holiday|11 Sat|27 Mon<br>USA Memorial Day|
|---------|-----|-------------------|-----------------------------|------|--------------------------|
|m:e1     |   1 |                 2 |                           3 |    4 |                        5 |
|m:e2     |  11 |                22 |                          33 |   44 |                       55 |

<details><summary>Series-команды для закладки данных</summary>

```text
series d:2019-05-08T14:00:00Z e:e1 m:m=1
series d:2019-05-09T14:00:00Z e:e1 m:m=2
series d:2019-05-10T14:00:00Z e:e1 m:m=3
series d:2019-05-11T14:00:00Z e:e1 m:m=4
series d:2019-05-27T14:00:00Z e:e1 m:m=5
series d:2019-05-08T14:00:00Z e:e2 m:m=11
series d:2019-05-09T14:00:00Z e:e2 m:m=22
series d:2019-05-10T14:00:00Z e:e2 m:m=33
series d:2019-05-11T14:00:00Z e:e2 m:m=44
series d:2019-05-27T14:00:00Z e:e2 m:m=55
```

</details>

## Пример - использование `DateTime` для текущего времени и календаря по умолчанию

Заменить значение метрики в нерабочий день на 0, используя календарь `default.holiday.calendar`.

API запрос

```json
[{
  "startDate": "2019-05-08T00:00:00Z",
  "endDate":   "2019-05-27T23:00:00Z",
  "entity": "e1",
  "metric": "m",
  "evaluate": {
    "expression": "m.forEach('if (d.is_workday()) return v; return 0;')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "m",
    "entity": "e1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-05-08T14:00:00.000Z",
        "v": 1
      },
      {
        "d": "2019-05-09T14:00:00.000Z",
        "v": 0
      },
      {
        "d": "2019-05-10T14:00:00.000Z",
        "v": 0
      },
      {
        "d": "2019-05-11T14:00:00.000Z",
        "v": 0
      },
      {
        "d": "2019-05-27T14:00:00.000Z",
        "v": 5
      }
    ]
  }
]
```

</details>

## Пример - использование `DateTime` для текущего времени и указанного календаря

То же самое, что в предыдущем примере, но с использованием календаря указанного в запросе.

API запрос

```json
[{
  "startDate": "2019-05-08T00:00:00Z",
  "endDate":   "2019-05-27T23:00:00Z",
  "entity": "e1",
  "metric": "m",
  "evaluate": {
    "expression": "m.forEach('if (d(\"usa\").is_workday()) return v; return 0;')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "m",
    "entity": "e1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-05-08T14:00:00.000Z",
        "v": 1
      },
      {
        "d": "2019-05-09T14:00:00.000Z",
        "v": 2
      },
      {
        "d": "2019-05-10T14:00:00.000Z",
        "v": 3
      },
      {
        "d": "2019-05-11T14:00:00.000Z",
        "v": 0
      },
      {
        "d": "2019-05-27T14:00:00.000Z",
        "v": 0
      }
    ]
  }
]
```

</details>

## Пример - использование `DateTime` для указанного времени и календаря по умолчанию

Найти число рабочих дней, используя календарь по умолчанию.

API запрос

```json
[{
  "startDate": "2019-05-08T00:00:00Z",
  "endDate":   "2019-05-27T23:00:00Z",
  "entity": "e1",
  "metric": "m",
  "name": "test",
  "evaluate": {
    "expression": "test.calculate('int workdays = 0; foreach(time : series.timestamps()) {if (d(time).is_workday()) {workdays++;}}; return workdays;')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "m",
    "entity": "e1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-05-08T00:00:00.000Z",
        "v": 2
      }
    ]
  }
]
```

</details>

## Пример - использование `DateTime` для указанного времени и календаря

То же самое, что в предыдущем примере, но с использованием указанного календаря.

API запрос

```json
[{
  "startDate": "2019-05-08T00:00:00Z",
  "endDate":   "2019-05-27T23:00:00Z",
  "entity": "e1",
  "metric": "m",
  "evaluate": {
    "expression": "m.calculate('int workdays = 0; foreach(t : series.timestamps()) {if (d(t, \"usa\").is_workday()) {workdays++;}}; return workdays;')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "m",
    "entity": "e1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-05-08T00:00:00.000Z",
        "v": 3
      }
    ]
  }
]
```

</details>

## Пример - интерполяция

Методы

```java
interpolate(String period, String type)
interpolate(String period, String type, String alignment)
```

объектов `Series` и `SeriesCollection` выполняют интерполяцию ряда (каждого ряда в коллекции).
В результате получаются регулярные ряды с указанным периодом.
Доступные типы интерполяции - `"previous"`, `"next"`, `"nearest"`, `"linear"`.
Параметр `alignment` определяет каким образом будет выровнена временная сетка:
`"first"` - первая точка сетки совпадает со временем первого элемента ряда, `"last"` - последняя точка сетки совпадает со временем последнего элемента ряда, `"calendar"`- календарное выравнивание описанное в документации по ATSD.

API запрос

```json
[{
  "startDate": "2019-05-08T00:00:00Z",
  "endDate":   "2019-05-27T23:00:00Z",
  "entity": "e1",
  "metric": "m",
  "evaluate": {
    "timezone": "UTC",
    "expression": "m.interpolate('2 day', 'linear', 'calendar')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "m",
    "entity": "e1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-05-09T00:00:00.000Z",
        "v": 1.4166666666666667
      },
      {
        "d": "2019-05-11T00:00:00.000Z",
        "v": 3.4166666666666665
      },
      {
        "d": "2019-05-13T00:00:00.000Z",
        "v": 4.088541666666667
      },
      {
        "d": "2019-05-15T00:00:00.000Z",
        "v": 4.213541666666667
      },
      {
        "d": "2019-05-17T00:00:00.000Z",
        "v": 4.338541666666667
      },
      {
        "d": "2019-05-19T00:00:00.000Z",
        "v": 4.463541666666667
      },
      {
        "d": "2019-05-21T00:00:00.000Z",
        "v": 4.588541666666667
      },
      {
        "d": "2019-05-23T00:00:00.000Z",
        "v": 4.713541666666667
      },
      {
        "d": "2019-05-25T00:00:00.000Z",
        "v": 4.838541666666667
      },
      {
        "d": "2019-05-27T00:00:00.000Z",
        "v": 4.963541666666667
      }
    ]
  }
]
```

</details>

## Метрика для демонстрации использования временной зоны

Даты приведены в UTC, метрика `m`, сущность `e`.

|             время    | значение |
|----------------------|----------|
| 2019-07-24T00:00:00Z |        1 |
| 2019-07-24T00:03:00Z |        1 |
| 2019-07-24T00:06:00Z |        1 |
| 2019-07-24T00:09:00Z |        1 |
| 2019-07-24T00:12:00Z |        1 |
| 2019-07-24T00:15:00Z |        1 |
| 2019-07-24T00:18:00Z |        1 |
| 2019-07-24T00:21:00Z |        1 |
| 2019-07-25T00:00:00Z |        1 |
| 2019-07-25T00:03:00Z |        1 |
| 2019-07-25T00:06:00Z |        1 |
| 2019-07-25T00:09:00Z |        1 |
| 2019-07-25T00:12:00Z |        1 |
| 2019-07-25T00:15:00Z |        1 |
| 2019-07-25T00:18:00Z |        1 |
| 2019-07-25T00:21:00Z |        1 |

<details><summary>Series-команды для закладки данных</summary>

```text
series d:2019-07-24T00:00:00Z e:e m:m=1
series d:2019-07-24T03:00:00Z e:e m:m=1
series d:2019-07-24T06:00:00Z e:e m:m=1
series d:2019-07-24T09:00:00Z e:e m:m=1
series d:2019-07-24T12:00:00Z e:e m:m=1
series d:2019-07-24T15:00:00Z e:e m:m=1
series d:2019-07-24T18:00:00Z e:e m:m=1
series d:2019-07-24T21:00:00Z e:e m:m=1

series d:2019-07-25T00:00:00Z e:e m:m=1
series d:2019-07-25T03:00:00Z e:e m:m=1
series d:2019-07-25T06:00:00Z e:e m:m=1
series d:2019-07-25T09:00:00Z e:e m:m=1
series d:2019-07-25T12:00:00Z e:e m:m=1
series d:2019-07-25T15:00:00Z e:e m:m=1
series d:2019-07-25T18:00:00Z e:e m:m=1
series d:2019-07-25T21:00:00Z e:e m:m=1
```

</details>

## Пример - разбиения ряда на интервалы в указанной временной зоне

Посчитаем количество значений ряда за день в указанной временной зоне.

API запрос

```json
[{
  "startDate": "2019-07-24T00:00:00Z",
  "endDate":   "2019-07-26T00:00:00Z",
  "metric": "m",
  "entity": "e",
  "evaluate": {
    "timezone": "Europe/Moscow",
    "expression": "A.seriesCount('1 day')"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "m",
    "entity": "e",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-07-23T21:00:00.000Z",
        "v": 7
      },
      {
        "d": "2019-07-24T21:00:00.000Z",
        "v": 8
      },
      {
        "d": "2019-07-25T21:00:00.000Z",
        "v": 1
      }
    ]
  }
]
```

</details>

## Использование пользовательских MVEL библиотек

Можно определить собственные библиотеки MVEL функций и сохранить их для последующего использования.
Для этого предназначен редактор MVEL скриптов доступный по пути `/mvel-scripts`.

Тестовые данные приведены для 2019-07-01 в 14 часов по UTC. В таблице указаны минуты.

| метр:сущн:тэги | 00 | 01 | 02 | 03 | 04 | 05 |
|----------------|----|----|----|----|----|----|
| m1:e1          |  1 |  1 |  7 |  3 |  4 |  2 |
| m1:e1:tn=tv1   |  3 |  1 |  2 |  4 |  7 |  9 |

<details><summary>Series-команды для закладки данных</summary>

```text
series d:2019-07-01T14:00:00Z e:e1 m:m1=1
series d:2019-07-01T14:01:00Z e:e1 m:m1=1
series d:2019-07-01T14:02:00Z e:e1 m:m1=7
series d:2019-07-01T14:03:00Z e:e1 m:m1=3
series d:2019-07-01T14:04:00Z e:e1 m:m1=4
series d:2019-07-01T14:05:00Z e:e1 m:m1=2
series d:2019-07-01T14:00:00Z e:e1 m:m1=3 t:tn=tv1
series d:2019-07-01T14:01:00Z e:e1 m:m1=1 t:tn=tv1
series d:2019-07-01T14:02:00Z e:e1 m:m1=2 t:tn=tv1
series d:2019-07-01T14:03:00Z e:e1 m:m1=4 t:tn=tv1
series d:2019-07-01T14:04:00Z e:e1 m:m1=7 t:tn=tv1
series d:2019-07-01T14:05:00Z e:e1 m:m1=9 t:tn=tv1
```

</details>

## Пример - использование пользовательской функции в основном контексте

Пользуясь редактором MVEL скриптов, создадим и сохраним два файла.

В файле `test-lib-1.mvel` - определим функцию, возвращающую первый ряд из переданной коллекции.

```text
def getFirstSeriesOfCollection(collection) {
  return collection.firstSeries();
}
```

В файле `test-lib-2.mvel` - определим функцию, вызывающую функцию  определенную в предыдущей библиотеке.

```text
def generateSeries(collection) {
  return getFirstSeriesOfCollection(collection);
}
```

Теперь в запросе можно подключить эти библиотеки и использовать определенные там функции.

API запрос

```json
[{
  "startDate": "2019-07-01T14:00:00Z",
  "endDate":   "2019-07-01T15:00:00Z",
  "metric": "m1",
  "entity": "e1",
  "evaluate": {
    "libs": ["test-lib-1.mvel", "test-lib-2.mvel"],
    "expression": "generateSeries(m1);"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "m1",
    "entity": "e1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-07-01T14:00:00.000Z",
        "v": 1
      },
      {
        "d": "2019-07-01T14:01:00.000Z",
        "v": 1
      },
      {
        "d": "2019-07-01T14:02:00.000Z",
        "v": 7
      },
      {
        "d": "2019-07-01T14:03:00.000Z",
        "v": 3
      },
      {
        "d": "2019-07-01T14:04:00.000Z",
        "v": 4
      },
      {
        "d": "2019-07-01T14:05:00.000Z",
        "v": 2
      }
    ]
  }
]
```

</details>

## Пример - использование пользовательской функции в контексте ряда при вызове метода `forEach()`

Пользовательские MVEL функции также доступны в контексте ряда,
при оценивании выражения переданного в методы `calculate()`, `forEach()`.
Для примера создадим и сохраним в файле `test-series-context-lib-1.mvel` функцию, складывающую текущее значение ряда со значением ряда через 1 минуту. Обратите внимание, что в теле этой функции используются переменные и методы доступные в контексте ряда:

```text
def transform() {
  return v + value(time_add("1 minute"));
}
```

Используем эту функцию для преобразования каждого ряда в коллекции.

API запрос

```json
[{
  "startDate": "2019-07-01T14:00:00Z",
  "endDate":   "2019-07-01T15:00:00Z",
  "metric": "m1",
  "entity": "e1",
  "evaluate": {
    "libs": ["test-series-context-lib-1.mvel"],
    "expression": "A.forEach('transform()');"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "m1",
    "entity": "e1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-07-01T14:00:00.000Z",
        "v": 2
      },
      {
        "d": "2019-07-01T14:01:00.000Z",
        "v": 8
      },
      {
        "d": "2019-07-01T14:02:00.000Z",
        "v": 10
      },
      {
        "d": "2019-07-01T14:03:00.000Z",
        "v": 7
      },
      {
        "d": "2019-07-01T14:04:00.000Z",
        "v": 6
      },
      {
        "d": "2019-07-01T14:05:00.000Z",
        "v": null
      }
    ]
  },
  {
    "metric": "m1",
    "entity": "e1",
    "tags": {
      "tn": "tv1"
    },
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-07-01T14:00:00.000Z",
        "v": 4
      },
      {
        "d": "2019-07-01T14:01:00.000Z",
        "v": 3
      },
      {
        "d": "2019-07-01T14:02:00.000Z",
        "v": 6
      },
      {
        "d": "2019-07-01T14:03:00.000Z",
        "v": 11
      },
      {
        "d": "2019-07-01T14:04:00.000Z",
        "v": 16
      },
      {
        "d": "2019-07-01T14:05:00.000Z",
        "v": null
      }
    ]
  }
]
```

</details>

## Пример - использование пользовательской функции в контексте ряда при вызове метода `calculate()`

Сохраним в файле `test-series-context-lib-2.mvel` функцию, переворачивающую ряд задом наперед:

```text
def revert() {
  Iterator timeIt = series.timestamps().iterator();
  Iterator valueIt = series.samples().descendingMap().values().iterator();
  Map result = new TreeMap();
  while (timeIt.hasNext() && valueIt.hasNext()) {
    result.put(timeIt.next(), valueIt.next());
  }
  return result;
}
```

Перевернем первый ряд в коллекции.

API запрос

```json
[{
  "startDate": "2019-07-01T14:00:00Z",
  "endDate":   "2019-07-01T15:00:00Z",
  "metric": "m1",
  "entity": "e1",
  "evaluate": {
    "libs": ["test-series-context-lib-2.mvel"],
    "expression": "A.firstSeries().calculate('revert()');"
  }
}]
```

Так же вместо строки, которая будет оценена методом `calculate` можно перередать объект - саму MVEL функцию, которая будет выполнена. Т.е. вместо `calculate('revert()')` можно вызвать `calculate(revert)`:

```json
[{
  "startDate": "2019-07-01T14:00:00Z",
  "endDate":   "2019-07-01T15:00:00Z",
  "metric": "m1",
  "entity": "e1",
  "evaluate": {
    "libs": ["test-series-context-lib-2.mvel"],
    "expression": "A.firstSeries().calculate(revert);"
  }
}]
```

 Если бы у функции `revert` были аргументы, то их можно было бы передать, как аргументы функции `calculate` следующие за `revert`.  

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "m1",
    "entity": "e1",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-07-01T14:00:00.000Z",
        "v": 2
      },
      {
        "d": "2019-07-01T14:01:00.000Z",
        "v": 4
      },
      {
        "d": "2019-07-01T14:02:00.000Z",
        "v": 3
      },
      {
        "d": "2019-07-01T14:03:00.000Z",
        "v": 7
      },
      {
        "d": "2019-07-01T14:04:00.000Z",
        "v": 1
      },
      {
        "d": "2019-07-01T14:05:00.000Z",
        "v": 1
      }
    ]
  }
]
```

</details>

## Пример - использование пользовательской функции в контексте `MultiCollection` при вызове метода `forEach()`

Cохраним в файле `test-multi-series-context-lib-1.mvel` функцию, которая по очереди возвращает значения первого и второго рядов данной `MultiCollection`.

```text
def alternate() {
  return tIndex % 2 == 0 ? A : B;
}
```

Используем эту функцию чтобы чередовать значения первого и второго тестовых рядов.

API запрос

```json
[{
  "startDate": "2019-07-01T14:00:00Z",
  "endDate":   "2019-07-01T15:00:00Z",
  "metric": "m1",
  "entity": "e1",
  "evaluate": {
    "libs": ["test-multi-series-context-lib-1.mvel"],
    "expression": "A.toMultiCollection().forEach('alternate()');"
  }
}]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "udf",
    "entity": "udf-0",
    "tags": {},
    "type": "HISTORY",
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-07-01T14:00:00.000Z",
        "v": 1
      },
      {
        "d": "2019-07-01T14:01:00.000Z",
        "v": 1
      },
      {
        "d": "2019-07-01T14:02:00.000Z",
        "v": 7
      },
      {
        "d": "2019-07-01T14:03:00.000Z",
        "v": 4
      },
      {
        "d": "2019-07-01T14:04:00.000Z",
        "v": 4
      },
      {
        "d": "2019-07-01T14:05:00.000Z",
        "v": 9
      }
    ]
  }
]
```

</details>

## Пример - просмотр объектов - метод `log()`

С помощью функции

```java
log(Object obj, String... objName)
```

можно посмотреть объекты создаваемые в процессе оценивания MVEL-выражения.
Все описания объектов находятся в поле `mvel` ответа.
Необязательный параметр `objName` задает имя поля в котором будет храниться описание
объекта `obj`.
По умолчанию генерируется имя `object-n`.

Для удобства просмотра сохраним MVEL-выражение в файле `log-demo.mvel`:

```groovy
def demo() {
  log('Test log()', 'string');
  log(42, 'number');
  log(A, 'series collection');
  mc = A.toMultiCollection();
  log(mc, 'multi-collection');
  mc.calculate("
    log(A, 'series');
    log(A.samples(), 'map');
    log(A.values(), 'double collection');
    log(A.valuesArray(), 'double array');
    log(A.timestamps(), 'navigable set');
    log(true, 'boolean');
    return A.forEach('
       log(t);
       return v;
    ');
  ");
}
```

API запрос

```json
[
  {
    "startDate": "2019-07-01T14:00:00Z",
    "endDate": "2019-07-01T15:00:00Z",
    "metric": "m1",
    "entity": "e1",
    "evaluate": {
      "libs": ["log-demo.mvel"],
      "expression": "demo()"
    }
  }
]
```

<details><summary>Ответ сервера</summary>

```json
[
  {
    "metric": "m1",
    "entity": "e1",
    "tags": {},
    "type": "HISTORY",
    "mvel": {
      "string": "Test log()",
      "number": "42",
      "series collection": "SeriesCollection{
  Series{key=SeriesKey{metric=m1, entity=e1, tags={}, aggregation=DETAIL, groupAggregation=DETAIL, type=HISTORY, forecast=null}, samples={1561989600000=1.0, 1561989660000=1.0, 1561989720000=7.0, 1561989780000=3.0, 1561989840000=4.0, 1561989900000=2.0}, isScalar=false},
  Series{key=SeriesKey{metric=m1, entity=e1, tags={tn=tv1}, aggregation=DETAIL, groupAggregation=DETAIL, type=HISTORY, forecast=null}, samples={1561989600000=3.0, 1561989660000=1.0, 1561989720000=2.0, 1561989780000=4.0, 1561989840000=7.0, 1561989900000=9.0}, isScalar=false},
}
",
      "multi-collection": "MultiCollection{
    groups = {
        SeriesKey{metric=, entity=, tags={}, aggregation=DETAIL, groupAggregation=DETAIL, type=HISTORY, forecast=null} = {
            A = Series{key=SeriesKey{metric=m1, entity=e1, tags={}, aggregation=DETAIL, groupAggregation=DETAIL, type=HISTORY, forecast=null}, samples={1561989600000=1.0, 1561989660000=1.0, 1561989720000=7.0, 1561989780000=3.0, 1561989840000=4.0, 1561989900000=2.0}, isScalar=false},
            B = Series{key=SeriesKey{metric=m1, entity=e1, tags={tn=tv1}, aggregation=DETAIL, groupAggregation=DETAIL, type=HISTORY, forecast=null}, samples={1561989600000=3.0, 1561989660000=1.0, 1561989720000=2.0, 1561989780000=4.0, 1561989840000=7.0, 1561989900000=9.0}, isScalar=false},
        },
    }
}
",
      "series": "Series{key=SeriesKey{metric=m1, entity=e1, tags={}, aggregation=DETAIL, groupAggregation=DETAIL, type=HISTORY, forecast=null}, samples={1561989600000=1.0, 1561989660000=1.0, 1561989720000=7.0, 1561989780000=3.0, 1561989840000=4.0, 1561989900000=2.0}, isScalar=false}",
      "map": "{1561989600000=1.0, 1561989660000=1.0, 1561989720000=7.0, 1561989780000=3.0, 1561989840000=4.0, 1561989900000=2.0}",
      "double collection": "[1.0, 1.0, 7.0, 3.0, 4.0, 2.0]",
      "double array": "[1.0, 1.0, 7.0, 3.0, 4.0, 2.0]",
      "navigable set": "[1561989600000, 1561989660000, 1561989720000, 1561989780000, 1561989840000, 1561989900000]",
      "boolean": "true",
      "object-10": "1561989600000",
      "object-11": "1561989660000",
      "object-12": "1561989720000",
      "object-13": "1561989780000",
      "object-14": "1561989840000",
      "object-15": "1561989900000"
    },
    "transformationOrder": [
      "EVALUATE"
    ],
    "data": [
      {
        "d": "2019-07-01T14:00:00.000Z",
        "v": 1
      },
      {
        "d": "2019-07-01T14:01:00.000Z",
        "v": 1
      },
      {
        "d": "2019-07-01T14:02:00.000Z",
        "v": 7
      },
      {
        "d": "2019-07-01T14:03:00.000Z",
        "v": 3
      },
      {
        "d": "2019-07-01T14:04:00.000Z",
        "v": 4
      },
      {
        "d": "2019-07-01T14:05:00.000Z",
        "v": 2
      }
    ]
  }
]
```

</details>
