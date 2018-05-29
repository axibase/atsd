# StatsD

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
