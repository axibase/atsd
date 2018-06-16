# tcollector

```css
put `<metric> <timestamp> <value> <tagk1=tagv1[ tagk2=tagv2 ...tagkN=tagvN]>`
```

```css
put sys.cpu.user 1356998400 42.5 host=webserver01 cpu=0
```

[tcollector integration](../../integration/tcollector/README.md)

ATSD uses the `host` tag as the entity. If the `host` tag is missing then entity is set to `tcollector`.