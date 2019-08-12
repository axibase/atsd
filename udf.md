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

## Пример - объединение коллекций и рядов

MVEL выражение `[x, y]` создает список из `x` и `y`, а выражение `{x, y}` создает массив.
Любое из этих выражений можно использовать, чтобы объединить коллекции или ряды между собой.

<details><summary>API запрос - массив коллекций</summary>

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

</details>

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

<details><summary>API запрос - список рядов</summary>

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

</details>

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
Например отфильтруем ряды по сущности.

<details><summary>API запрос - фильтрация по сущности</summary>

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

</details>

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

<details><summary>API запрос - фильтрация с использованием функции</summary>

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

</details>

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

<details><summary>API запрос</summary>

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

</details>

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

<details><summary>API запрос</summary>

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

</details>

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

<details><summary>API запрос</summary>

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

</details>

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

<details><summary>API запрос</summary>

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

</details>

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

<details><summary>API запрос</summary>

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

</details>

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

<details><summary>API запрос</summary>

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "metric": "flight.capacity",
  "entity": "airplane-1",
  "evaluate": {
    "expression": "A.firstSeries().calculateForEach('Math.sqrt(v)')"
  }
}]
```

</details>

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

<details><summary>API запрос</summary>

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

</details>

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

<details><summary>API запрос</summary>

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

</details>

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
        "d": "2019-06-14T00:00:00.000Z",
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
        "d": "2019-06-14T00:00:00.000Z",
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
        "d": "2019-06-14T00:00:00.000Z",
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
        "d": "2019-06-14T00:00:00.000Z",
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

<details><summary>API запрос</summary>

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "metric": "flight.load_pct",
  "entity": "airplane-1",
  "evaluate": {
    "expression": "flight.load_pct.calculateForEach('value(time_add(\"-10 minute\"))')",
    "timezone": "UTC"
  }
}]
```

</details>

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

## Пример - использование переменной и функции определенных в главном контексте в выражении переданном в метод `calculateForEach()`

В основном выражении можно определять переменные и функции,
которые доступны в выражениях передаваемых в методы `calculate()` и `calculateForEach()`.

В этом примере определяется переменная `period` и функция `transform()`,
которые затем используются в выражении передаваемом методу `calculateForEach()`.

<details><summary>API запрос</summary>

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "metric": "flight.load_pct",
  "entity": "*",
  "evaluate": {
    "expression": "delta = '10 minute'; def transform(period) {v + value(time_add(period))} A.firstSeries().calculateForEach('transform(delta)')"
  }
}]
```

</details>

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

## Пример - `calculate(expr)` - `expr` оценивается один раз

Найдем сколько четных чисел в каждом ряду.

<details><summary>API запрос</summary>

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

</details>

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

## Пример - `calculateForEach(expr)` - `expr` оценивается для каждого элемента ряда

Найдем сколько раз значение первого ряда было больше значения второго ряда.

<details><summary>API запрос</summary>

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "name": "A",
  "metric": "m1",
  "entity": "e1",
  "evaluate": {
    "expression": "A.toMultiCollection().calculateForEach('A > B ? 1 : 0').seriesSum()"
  }
}]
```

</details>

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

<details><summary>API запрос</summary>

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

</details>

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

<details><summary>API запрос</summary>

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

</details>

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

<details><summary>API запрос</summary>

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "name": "A",
  "metric": "m1",
  "entity": "e1",
  "evaluate": {
    "expression": "A.calculateForEach('if (memory.isEmpty()) {memory.put(\"max\", v); return Double.NaN;} max = memory.get(\"max\"); if (v > max) {memory.put(\"max\", v);} return v - max;')"
  }
}]
```

</details>

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

## Пример - `calculateForEach(expr, period)` - `expr` оценивается для каждого элемента ряда в контексте текущего интервала

То же самое, что в предыдущем примере, но только для второго ряда и для 10 минутных интервалов. То есть для каждого значения ряда посчитаем его разность с наибольшим из предшествующих значений на том же интервале.

<details><summary>API запрос</summary>

```json
[{
  "startDate": "2019-06-14T00:00:00Z",
  "endDate":   "2019-06-15T00:00:00Z",
  "name": "A",
  "metric": "m1",
  "entity": "e1",
  "evaluate": {
    "expression": "A.seriesList().get(1).calculateForEach('if (sIndex == 0) {memory.put(\"max\", v); return Double.NaN;} max = memory.get(\"max\"); if (v > max) {memory.put(\"max\", v);} return v - max;', '10 minute')"
  }
}]
```

</details>

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

## Пример - сопоставление рядов из 3 коллекций по тэгам

Разобьем ряды по тэгам, так что получится 2 группы по 3 ряда в каждой, и вычтем ряд с метрикой m2 из суммы рядов с метрикой m1.

<details><summary>API запрос</summary>

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
    "expression": "join('tags', A, B, C).calculateForEach('A + B - C')"
  }
}]
```

</details>

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

<details><summary>API запрос - фильтрация по тэгу</summary>

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
    "expression": "def match(){tags['tn'] == 'tv1'} join('tags', A, B, C).calculateForEach('A + B - C').filter('match()')"
  }
}]
```

</details>

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

При оценивании MVEL выражения в методах `calculate(...)` объектов `Series`, `SeriesColletion`, `MultiCollection`
можно получить объект `DateTime`, следующими методами:

```java
 /**
  * If expression is evaluated for each timestamp.
  * Return {@link DateTime} implementation for current timestamp {@link #t},
  * country specified in the {@code default.holiday.calendar} server property,
  * and server timezone.
 */
 d
```

```java
 /**
  * If expression is evaluated for each timestamp.
  * Return {@link DateTime} implementation for current timestamp {@link #t},
  * specified country's holiday calendar,
  * and server timezone.
 */
 d(String country)
```

```java
 /**
  * Return {@link DateTime} implementation for specified timestamp,
  * country specified in the {@code default.holiday.calendar} server property,
  * and server timezone.
 */
 d(long timestamp)
```

```java
  /**
   * Return {@link DateTime} implementation for specified timestamp,
   * specified country's holiday calendar,
   * and server timezone.
   */
  public DateTime d(long timestamp, String country)
```

## Метрики для демонстрации использование DateTime

все даты приведены в UTC, в 14:00 дня.

| метр:сущн | Wed<br>2019-05-08 | Thu - VictoryDay<br>2019-05-09 | Fri - additional holiday<br>2019-05-10 | Sat<br>2019-05-11 | Mon USA Memorial Day<br>2019-05-27 |
|-----------|-------------------|--------------------------------|----------------------------------------|-------------------|------------------------------------|
| m:e1      |                 1 |                              2 |                                      3 |                 4 |                                  5 |
| m:e2      |                11 |                             22 |                                     33 |                44 |                                 55 |

## Пример - использование `DateTime` для текущего времени и календаря по умолчанию

Заменить значение метрики в нерабочий день на 0, используя календарь `default.holiday.calendar`.

<details><summary>API запрос</summary>

```json
[{
  "startDate": "2019-05-08T00:00:00Z",
  "endDate":   "2019-05-27T23:00:00Z",
  "entity": "e1",
  "metric": "m",
  "evaluate": {
    "expression": "m.calculateForEach('if (d.is_workday()) return v; return 0;')"
  }
}]
```

</details>

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

<details><summary>API запрос</summary>

```json
[{
  "startDate": "2019-05-08T00:00:00Z",
  "endDate":   "2019-05-27T23:00:00Z",
  "entity": "e1",
  "metric": "m",
  "evaluate": {
    "expression": "m.calculateForEach('if (d(\"usa\").is_workday()) return v; return 0;')"
  }
}]
```

</details>

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

<details><summary>API запрос</summary>

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

</details>

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

<details><summary>API запрос</summary>

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

</details>

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

## Пример - разбиения ряда на интервалы в указанной временной зоне

Посчитаем количество значений ряда за день в указанной временной зоне.

<details><summary>API запрос</summary>

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

</details>

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

<details><summary>API запрос</summary>

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

</details>

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

## Пример - использование пользовательской функции в контексте ряда при вызове метода `calculateForEach()`

Пользовательские MVEL функции также доступны в контексте ряда,
при оценивании выражения переданного в методы `calculate()`, `calculateForEach()`.
Для примера создадим и сохраним в файле `test-series-context-lib-1.mvel` функцию, складывающую текущее значение ряда со значением ряда через 1 минуту. Обратите внимание, что в теле этой функции используются переменные и методы доступные в контексте ряда:

```text
def transform() {
  return v + value(time_add("1 minute"));
}
```

Используем эту функцию для преобразования каждого ряда в коллекции.

<details><summary>API запрос</summary>

```json
[{
  "startDate": "2019-07-01T14:00:00Z",
  "endDate":   "2019-07-01T15:00:00Z",
  "metric": "m1",
  "entity": "e1",
  "evaluate": {
    "libs": ["test-series-context-lib-1.mvel"],
    "expression": "A.calculateForEach('transform()');"
  }
}]
```

</details>

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

<details><summary>API запрос</summary>

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

</details>

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

## Пример - использование пользовательской функции в контексте `MultiCollection` при вызове метода `calculateForEach()`

Cохраним в файле `test-multi-series-context-lib-1.mvel` функцию, которая по очереди возвращает значения первого и второго рядов данной `MultiCollection`.

```text
def alternate() {
  return tIndex % 2 == 0 ? A : B;
}
```

Используем эту функцию чтобы чередовать значения первого и второго тестовых рядов.

<details><summary>API запрос</summary>

```json
[{
  "startDate": "2019-07-01T14:00:00Z",
  "endDate":   "2019-07-01T15:00:00Z",
  "metric": "m1",
  "entity": "e1",
  "evaluate": {
    "libs": ["test-multi-series-context-lib-1.mvel"],
    "expression": "A.toMultiCollection().calculateForEach('alternate()');"
  }
}]
```

</details>

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
