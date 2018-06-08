# `csv` Command

## Description

Inserts plain text data in CSV/TSV format into the database.

Lines are parsed and converted into commands as they're received, without buffering.

The client may keep a persistent connection. To prevent the server from timing out an idle connection, set read timeout to a desired threshold with the `o` field.

## Syntax

```bash
csv p:${parser} e:${entity} r:${metric_prefix} z:${timezone} t:${timeout}
... Header Row ...
... Data Rows  ...
```

### Fields

| **Name** | **Type** | **Description** |
|:---|:---|:---|
| `p`         | yes          | **[Required]** Parser name from `Data > CSV Parsers` page. |
| `e`         | string       | Default entity name. |
| `ep`        | string       | Entity prefix applied to all entity names in the file. |
| `et`        | string       | Entity tags.<br>Comma separated list of entity tags added as series, message, or property tags to parsed commands. |
| `m`         | string       | Default metric name. |
| `mp`        | string       | Metric prefix applied to all metric names in the file. |
| `mt`        | string       | Metric tags.<br>Comma separated list of metric tags added as series, message, or property tags to parsed commands. |
| `z`         | string       | Time zone applied when parsing dates specified in local time, for example GMT.<br>[Time Zone ID](../../shared/timezone-abnf.md)  |
| `o`         | integer      | Server read timeout in seconds, for example `o:60` |
| `t`         | string       | One or multiple series tag key=value pairs, for example: `t:location=SVL` |

> Tags specified in `t:` fields override `Default Tags` with the same name specified in the CSV parser configuration.

### ABNF Syntax

Rules inherited from [Base ABNF](base-abnf.md).

```elm
command = "csv" MSP parser [MSP entity] [MSP entity-prefix] [MSP entity-tags]
                           [MSP metric] [MSP metric-prefix] [MSP metric-tags]
                           [MSP timezone] [MSP timeout] *(MSP tag)
parser = "p:" NAME
entity = "e:" NAME
entity-prefix = "ep:" NAME
entity-tags = "et:" NAME *("," NAME)
metric = "m:" NAME
metric-prefix = "mp:" NAME
metric-tags = "mt:" NAME *("," NAME)
timezone = "z:" TIMEZONE
timeout = "o:" POSITIVE_INTEGER
tag = "t:" NAME "=" VALUE
```

## Examples

```ls
csv p:was-csv-parser e:nurswgvml007 t:environment=prod
date,jvm.memory_used_pct,jvm.system_load
2016-05-22T00:00:00Z,46.6,1.2
2016-05-22T00:00:30Z,46.4,0.8
```
