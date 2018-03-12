# Details Table

## Overview

The `detailsTable` function assembles a table consisting of window and command fields printed in the specified format.

Decimal numbers presented in the table are rounded to 5 significant digits, except on the **Logging** and **Derived Commands** tabs.

## Syntax

```java
detailsTable(string format)
```

## Contents

* entity name
* entity label
* entity tags
* window placeholders
* command tags
* values
* statistical functions
* variables

## Formats

* markdown
* ascii
* html
* property
* csv

## Examples

The examples below were written to a log file via the **Logging** tab and maintain the original numeric precision.

### ascii

```java
detailsTable('ascii')
```

```
+-------------------+------------------------------+
| Name              | Value                        |
+-------------------+------------------------------+
| name              | atsd                         |
| label             | Axibase Time Series Database |
| app               | ATSD                         |
| host              | NURSWGVML007                 |
| metric            | jvm_memory_used_percent      |
| metric_label      | JVM Memory Used, %           |
| expression        | avg() > 0                    |
| window            | time(1 minute)               |
| severity          | warning                      |
| alert_type        | OPEN                         |
| timezone          | GMT (+00:00)                 |
| window_first_time | 2017-12-17 11:04:07          |
| event_time        | 2017-12-17 11:04:37          |
| received_time     | 2017-12-17 11:04:37          |
| alert_open_time   | 2017-12-17 11:04:37          |
| value             | 22.72808635185156            |
| status            | OPEN                         |
| tags.host         | NURSWGVML007                 |
| count             | 3                            |
| sum               | 62.80243733055981            |
| avg               | 20.93414577685327            |
| first             | 18.97742859958052            |
| last              | 22.72808635185156            |
| diff              | 3.7506577522710387           |
| max               | 22.72808635185156            |
| min               | 18.97742859958052            |
| variance          | 3.5367305603537185           |
| stddev            | 1.8806197277370347           |
| wavg              | 21.559255402231774           |
| wtavg             | 22.10622632443797            |
| percentile_50     | 21.09692237912773            |
| percentile_75     | 22.72808635185156            |
| percentile_90     | 22.72808635185156            |
| percentile_95     | 22.72808635185156            |
| percentile_99     | 22.72808635185156            |
| slope             | 1.2502e-4                    |
| intercept         | -1.8922e8                    |
+-------------------+------------------------------+
```

### markdown

```java
detailsTable('markdown')
```

```
| **Name** | **Value** |
|:---|:---|
| name | atsd |
| label | Axibase Time Series Database |
| app | ATSD |
| host | NURSWGVML007 |
| metric | jvm_memory_used_percent |
| metric_label | JVM Memory Used, % |
| expression | avg() > 0 |
| window | time(1 minute) |
| severity | warning |
| alert_type | OPEN |
| timezone | GMT (+00:00) |
| window_first_time | 2017-12-17 11:04:07 |
| event_time | 2017-12-17 11:04:37 |
| received_time | 2017-12-17 11:04:37 |
| alert_open_time | 2017-12-17 11:04:37 |
| value | 22.72808635185156 |
| status | OPEN |
| tags.host | NURSWGVML007 |
| count | 3 |
| sum | 62.80243733055981 |
| avg | 20.93414577685327 |
| first | 18.97742859958052 |
| last | 22.72808635185156 |
| diff | 3.7506577522710387 |
| max | 22.72808635185156 |
| min | 18.97742859958052 |
| variance | 3.5367305603537185 |
| stddev | 1.8806197277370347 |
| wavg | 21.559255402231774 |
| wtavg | 22.10622632443797 |
| percentile_50 | 21.09692237912773 |
| percentile_75 | 22.72808635185156 |
| percentile_90 | 22.72808635185156 |
| percentile_95 | 22.72808635185156 |
| percentile_99 | 22.72808635185156 |
| slope | 1.2502e-4 |
| intercept | -1.8922e8 |
```

### csv

```java
detailsTable('csv')
```

```
Name,Value
name,atsd
label,Axibase Time Series Database
app,ATSD
host,NURSWGVML007
metric,jvm_memory_used_percent
metric_label,"JVM Memory Used, %"
expression,avg() > 0
window,time(1 minute)
severity,warning
alert_type,OPEN
timezone,GMT (+00:00)
window_first_time,2017-12-17 11:04:07
event_time,2017-12-17 11:04:37
received_time,2017-12-17 11:04:37
alert_open_time,2017-12-17 11:04:37
value,22.72808635185156
status,OPEN
tags.host,NURSWGVML007
count,3
sum,62.80243733055981
avg,20.93414577685327
first,18.97742859958052
last,22.72808635185156
diff,3.7506577522710387
max,22.72808635185156
min,18.97742859958052
variance,3.5367305603537185
stddev,1.8806197277370347
wavg,21.559255402231774
wtavg,22.10622632443797
percentile_50,21.09692237912773
percentile_75,22.72808635185156
percentile_90,22.72808635185156
percentile_95,22.72808635185156
percentile_99,22.72808635185156
slope,1.2502e-4
intercept,-1.8922e8
```

### html

```java
detailsTable('html')
```

```
<table style="font-family: monospace, consolas, sans-serif; border-collapse: collapse;"><tbody><tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">name</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;"><a href="https://atsd_host/entities/atsd">atsd</a></td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">label</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">Axibase Time Series Database</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">app</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">ATSD</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">url</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">https://atsd_host</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">host</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">NURSWGVML007</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">metric</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;"><a href="https://atsd_host/metrics/metric.xhtml?metricName=jvm_memory_used_percent">jvm_memory_used_percent</a></td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">metric_label</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">JVM Memory Used, %</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">expression</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">avg() > 0</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">window</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">time(1 minute)</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">severity</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">warning</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">alert_type</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">OPEN</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">timezone</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">GMT (+00:00)</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">window_first_time</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">2017-12-17 11:04:07</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">event_time</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">2017-12-17 11:04:37</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">received_time</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">2017-12-17 11:04:37</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">alert_open_time</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">2017-12-17 11:04:37</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">value</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">22.72808635185156</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">status</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">OPEN</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">tags.host</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">NURSWGVML007</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">count</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">3</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">sum</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">62.80243733055981</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">avg</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">20.93414577685327</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">first</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">18.97742859958052</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">last</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">22.72808635185156</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">diff</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">3.7506577522710387</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">max</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">22.72808635185156</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">min</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">18.97742859958052</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">variance</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">3.5367305603537185</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">stddev</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">1.8806197277370347</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">wavg</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">21.559255402231774</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">wtavg</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">22.10622632443797</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">percentile_50</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">21.09692237912773</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">percentile_75</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">22.72808635185156</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">percentile_90</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">22.72808635185156</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">percentile_95</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">22.72808635185156</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">percentile_99</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">22.72808635185156</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">slope</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">1.2502e-4</td></tr>
<tr><td bgcolor="#f0f0f0" align="right" style="font-weight: bold;border: 1px solid #d0d0d0;padding: 4px;">intercept</td><td align="left" style="border: 1px solid #d0d0d0;padding: 4px;">-1.8922e8</td></tr>
</tbody></table>
```

### property

```java
detailsTable('property')
```

```
name=atsd
label=Axibase Time Series Database
app=ATSD
url=https://atsd_host
host=NURSWGVML007
metric=jvm_memory_used_percent
metric_label=JVM Memory Used, %
expression=avg() > 0
window=time(1 minute)
severity=warning
alert_type=OPEN
timezone=GMT (+00:00)
window_first_time=2017-12-17 11:04:07
event_time=2017-12-17 11:04:37
received_time=2017-12-17 11:04:37
alert_open_time=2017-12-17 11:04:37
value=22.72808635185156
status=OPEN
tags.host=NURSWGVML007
count=3
sum=62.80243733055981
avg=20.93414577685327
first=18.97742859958052
last=22.72808635185156
diff=3.7506577522710387
max=22.72808635185156
min=18.97742859958052
variance=3.5367305603537185
stddev=1.8806197277370347
wavg=21.559255402231774
wtavg=22.10622632443797
percentile_50=21.09692237912773
percentile_75=22.72808635185156
percentile_90=22.72808635185156
percentile_95=22.72808635185156
percentile_99=22.72808635185156
slope=1.2502e-4
intercept=-1.8922e8
```
