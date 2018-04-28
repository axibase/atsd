# StatsD Backend

ATSD back-end for StatsD enables you to forward metrics collected by StatsD daemon into the Axibase Time Series Database for retention, analytics, visualization, and alerting.

[Learn more about StatsD.](README.md)

[Download the ATSD StatsD back-end.](https://github.com/axibase/atsd-statsd-backend)

#### Configuration

Configuration file example:

```json
{
    atsd : {
        host: "atsd_hostname",
        port: 8081,
        protocol: "tcp",
        patterns: [
            {
                pattern: /^([^.]+\.){2}com\..+/,
                atsd_pattern: "<entity>.<>.<>.<metrics>"
            },
            {
                pattern: /.*/,
                atsd_pattern: "<entity>.<metrics>"
            }
        ]
    },
    port: 8125,
    backends: [ "./node_modules/atsd-statsd-backend/lib/atsd" ],
    debug: true
}
```

Possible variables:

| Variable | Description | Default Value |
| --- | --- | --- |
|  `debug`  |  Enable debug logging : `true` or `false`  |  `false`  |
|  `keyNameSanitize`  |  Sanitizing metric names (removing forbidden characters): `true` or `false`  |  `true`  |
|  `flush_counts`  |  Processing flush counts: `true` or `false`  |  true  |
|  `atsd`  |  Container for options specific to ATSD back-end  |  –  |
|  `atsd.host`  |  ATSD hostname  |  –  |
|  `atsd.port`  |  ATSD port  |  8081  |
|  `atsd.user`  |  Username  |    |
|  `atsd.password`  |  Password to log into ATSD  |    |
|  `atsd.protocol`  |  Protocol: `tcp` or `udp`  |  `tcp`  |
|  `atsd.entity`  |  Default entity  |  local hostname  |
|  `atsd.prefix`  |  Global prefix for each metric  |    | 
|  `atsd.prefixCounter`  |  Prefix for counter metrics  |  `counters`  |
|  `atsd.prefixTimer`  |  Prefix for timer metrics  |  `timers`  |
|  `atsd.prefixGauge`  |  Prefix for gauge metrics  |  `gauges`  |
|  `atsd.prefixSet`  |  Prefix for set metrics  |  `sets`  |
|  `atsd.patterns`  |  Patterns to parse statsd metric names  |  –  |

[Other variables used by StatsD can be specified.](https://github.com/etsy/statsd/blob/master/exampleConfig.js)

StatsD has an [open bug](https://github.com/etsy/statsd/issues/462) regarding the inability of the configuration to sometimes reload during operation. Changing the configuration file while StatsD is running may result in StatsD crashing. Until the bug is fixed, add `automaticConfigReload: false` to your configuration and restart StatsD for the changed configuration to take effect.

#### Patterns

Patterns enable the conversion of native StatsD metric names into ATSD entity/metric/tags.

If a metric name matches a regexp `pattern`, it will be parsed according to `atsd_pattern`.

> NOTE: every `\` in `pattern` must be duplicated.

If a metric name has more tokens than `atsd_pattern`, extra tokens are cropped.

`alfa.bravo.charlie.delta` is used as an example metric and the default example entity is `zulu`.

`metric` – metric token; multiple occurrences are combined.


`entity` – entity token to replace the default entity; multiple occurrences are combined.

```sh
[garbageCollections]
pattern = garbageCollections$
atsd-pattern = <tag:type>.<tag:dep>.<entity>.<metric>.<metric>.<metric>

# atsd-pattern = <tag:type>.<tag:dep>.<entity>.<metrics>     -Alternative Syntax
```

`tag:tag_name` – token for the tag named `tag_name`.

```ls
atsd-pattern = <entity>.<tag:test>.<metric>.<metric>
result = series e:alfa m:charlie.delta t:test=bravo ...
```

`metrics` – any number of metric tokens; can be used once per pattern; can also be omitted.

```ls
atsd-pattern = <entity>.<tag:test>.<metrics>
result = series e:alfa m:charlie.delta t:test=bravo ...
```

```ls
<> - token to be excluded
atsd-pattern = <entity>.<tag:test>.<>.<metric>
result = series e:alfa m:delta t:test=bravo ...
```
