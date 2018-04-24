# Extended Commands

ATSD supports the following third-party line protocols:

## tcollector

```css
put `<metric> <timestamp> <value> <tagk1=tagv1[ tagk2=tagv2 ...tagkN=tagvN]>`
```

```css
put sys.cpu.user 1356998400 42.5 host=webserver01 cpu=0
```

[tcollector integration](../../integration/tcollector/README.md)

ATSD uses the `host` tag as the entity. If the `host` tag is missing then entity will be `tcollector`.

## Graphite

```css
servers.nurswgvml007.cpu_busy 24.5 1232312313
```

[Graphite integration](../../integration/graphite/README.md)

## StatsD

```css
cpu.busy:20.5|c
```

```css
nurswfvml007/cpu.busy:20.5|c
```

```css
nurswgvml007.disk_used_percent:24.5|c|@0.5|#mount_point:/,disk_name:/sda
```

[StatsD integration](../../integration/statsd/README.md)

Forward slash is supported as a control character to extract the entity name. 

If no entity name is set, the default entity will be set as `statsd`.
