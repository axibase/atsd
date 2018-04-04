# Graphite Format

#### Patterns and `graphite.conf`

The `graphite.conf` file in the `/opt/atsd/atsd/conf/graphite.conf` directory controls how graphite commands are mapped into ATSD commands.

`graphite.conf` contains patterns used to parse incoming metrics:

`pattern =` is used to match incoming metrics.

`atsd-pattern =` is used to convert a graphite metric name into an ATSD metric name, entity, and tags.

If a metric name matches the regex `pattern`, it will be parsed according to `atsd-pattern`.

> NOTE: every `\` in `pattern` must be duplicated.

`graphite.conf` is parsed from top to bottom, meaning that metric names are matched to patterns in the same order they are placed in the file. Matching stops as soon as a `pattern` in satisfied. It is worth noting that if a `pattern` is added at the bottom of the file, but the target metric name is matched to a different `pattern` contained higher up in the file, then it will not be used.

If a metric name has more tokens than `atsd-pattern`, extra tokens are cropped.

If a metric name has less tokens than `atsd-pattern`, but still satisfies `pattern`, then the metric will not be parsed.

If there is no `atsd-pattern` for an incoming metric name, then everything before the first period is recorded as the entity and the rest is recorded as the metric. If there are no periods in the metric name, then the default entity will be `graphite`, and the metric name will be recorded as the metric.

`metric` – metric token; multiple occurrences are combined.

`entity` – entity token to replace the default entity (`graphite`); multiple occurrences are combined.

`tag:tag_name` – token for the tag named `tag_name`.

`metrics` – any number of metric tokens; can be used once per pattern.

String constants:

String constants in brackets(tokens) will be replaced.

String constants without brackets(tokens) will be added.

> NOTE: Empty tokens will be omitted.

> NOTE: Empty `atsd-pattern` will drop all incoming metrics that satisfy `pattern`.

##### Examples:

```
INPUT: awgswgvml001.counters.axibase_com.wordpress.http.counts.api_bruteprotect_com.count
```

<script src="http://gist.github.com/6f6ac04677b8db5bae20.js"></script><noscript>View the code on <a href="https://gist.github.com/6f6ac04677b8db5bae20">Gist</a>:</noscript>

```
OUTPUT: e:awgswgvml001 m:wordpress.http.counts.count t:site=axibase_com t:url=api_bruteprotect_com
```

```
INPUT: servers.www-1.workers.busyWorkers
```

<script src="http://gist.github.com/aeb33620c669eb864a75.js"></script><noscript>View the code on <a href="https://gist.github.com/aeb33620c669eb864a75">Gist</a>:</noscript>

```
OUTPUT: e:www-1 m:workers.busyWorkers t:type=servers
```

```
INPUT: com.acmeCorp.instance01.jvm.memory.garbageCollections
```

<script src="http://gist.github.com/78311b1f8a6455671000.js"></script><noscript>View the code on <a href="https://gist.github.com/78311b1f8a6455671000">Gist</a>:</noscript>

```
OUTPUT: e:instance01 m:jvm.memory.garbageCollections t:type=com t:dep=acmeCorp
```

```
INPUT: collectd.nurdkr002.disk-sda1.disk_time.write
```

<script src="http://gist.github.com/eb86b2f33827a530bbb4.js"></script><noscript>View the code on <a href="https://gist.github.com/eb86b2f33827a530bbb4">Gist</a>:</noscript>

```
OUTPUT: e:nurdkr002 m:collectd.disk_time.write t:id=disk-sda1
```

```
INPUT: collectd.nurdkr002.interface-vethe538ad3.if_errors.tx
```

<script src="http://gist.github.com/0da1dfb35e35ae3918a8.js"></script><noscript>View the code on <a href="https://gist.github.com/0da1dfb35e35ae3918a8">Gist</a>:</noscript>

```
OUTPUT: e:nurdkr002 m:collectd.if_errors.tx t:id=interface-vethe538ad3
```

```
INPUT: collectd.nurdkr002.df-run-shm.percent_bytes-used
```

<script src="http://gist.github.com/96bfa6f9dee001e66ee1.js"></script><noscript>View the code on <a href="https://gist.github.com/96bfa6f9dee001e66ee1">Gist</a>:</noscript>

```
OUTPUT: e:nurdkr002 m:collectd.percent_bytes-used t:id=df-run-shm
```

```
INPUT: collectd.nurswgdkr002.df-run-shm.percent_bytes-used
```

<script src="http://gist.github.com/7b4c7e76aa80580446e8.js"></script><noscript>View the code on <a href="https://gist.github.com/7b4c7e76aa80580446e8">Gist</a>:</noscript>

```
OUTPUT: e:nurdkr002 m:collectd.percent_bytes-used t:id=run-shm
```

> Note how the token containing `df-` is used to omit that precise part the of the input.

```
INPUT: collectd.nurswgdkr002.df-run-shm.percent_bytes-used
```

<script src="http://gist.github.com/1c4e2b650df1e75e49a6.js"></script><noscript>View the code on <a href="https://gist.github.com/1c4e2b650df1e75e49a6">Gist</a>:</noscript>

```
OUTPUT: e:nurdkr002 m:collectd.df.percent_bytes-used t:id=run-shm
```

> Note how `df` is used to add it as a part of metric.

#### Collectl Example

[Collectl](http://collectl.sourceforge.net/index.html) is a universal system performance monitoring tool for Linux systems. Collectl can monitor a broad set of subsystems, which currently include buddyinfo, cpu, disk, inodes, infiniband, lustre, memory, network, nfs, processes, quadrics, slabs, sockets, and tcp.

You can instrument Collectl to send data to ATSD using the Graphite format.

Review the complete Collectl documentation [here](http://collectl.sourceforge.net/Documentation.html).

Review the complete list of collected metrics [here](http://collectl.sourceforge.net/Data.html).

Download Collectl:

[http://sourceforge.net/projects/collectl/files/](http://sourceforge.net/projects/collectl/files/)

Unpack Collectl:

```
tar xzf collectl-4.0.2.src.tar.gz
```

Install Collectl:

```
cd collectl-4.0.2
```

```
sudo ./INSTALL
```

Run Collectl:

```
collectl --export graphite,atsdserver:8081
```

Verify that Collectl is running correctly:

```
sudo collectl --export graphite,atsdserver:8081,d=1,s=dn --rawtoo -f /var/log/collectl
```

The output will contain a log of data streamed to ATSD:

```
nurswgvml031.disktotals.reads 0 1434010410
nurswgvml031.disktotals.readkbs 0 1434010410
nurswgvml031.disktotals.writes 40 1434010410
nurswgvml031.disktotals.writekbs 228 1434010410
nurswgvml031.nettotals.kbin 0 1434010410
nurswgvml031.nettotals.pktin 8 1434010410
nurswgvml031.nettotals.kbout 1 1434010410
nurswgvml031.nettotals.pktout 9 1434010410
nurswgvml031.disktotals.reads 0 1434010411
nurswgvml031.disktotals.readkbs 0 1434010411
nurswgvml031.disktotals.writes 8 1434010411
nurswgvml031.disktotals.writekbs 36 1434010411
```

The entity and metrics collected by Collectl will be visible under the Entity and Metrics tabs in ATSD.

#### Sensu Example

[Sensu](https://sensuapp.org/) is a monitoring tool written in Ruby that uses RabbitMQ as a message broker and Redis for storing data. It is well-suited for monitoring cloud environments.

You can instrument Sensu to send data to ATSD using the Graphite format.

Review the complete Sensu documentation [here](https://sensuapp.org/docs/latest/overview).

Official guide covering Sensu installation and configuration:

[https://sensuapp.org/docs/latest/installation-overview](https://sensuapp.org/docs/latest/installation-overview)

To set up the server and client on separate machines please refer to the following guide:

[https://www.digitalocean.com/community/tutorials/how-to-configure-sensu-monitoring-rabbitmq-and-redis-on-ubuntu-14-04](https://www.digitalocean.com/community/tutorials/how-to-configure-sensu-monitoring-rabbitmq-and-redis-on-ubuntu-14-04)

##### Configure Sensu to send data to ATSD:

To send data into ATSD, you need a TCP handler, for example:

[Official Sensu Handler guide.](https://sensuapp.org/docs/latest/getting-started-with-handlers)

```
{
  "handlers": {
    "tcp_socket": {
      "type": "tcp",
      "socket": {
        "host": "atsdserver",
        "port": 8081
      },
      "mutator": "only_check_output"
    }
  }
}
```

Including the `"only_check_output"` mutator is crucial. Without it the Sensu server is going to send the entire JSON output doc into ATSD, with all the metadata and not just the necessary Graphite output.

You have to find and download a check plugin (or write one yourself).
A large variety of Sensu community plugins, mainly written in Ruby, is available here: [https://github.com/sensu-plugins](https://github.com/sensu-plugins)

Next you have to create a check, for example:

[Official Sensu Checks Guide.](https://sensuapp.org/docs/latest/getting-started-with-checks)

```
{
  "checks": {
    "cpu_metrics": {
      "type": "metric",
      "handlers": [
        "debug",
        "tcp_socket"  
      ],
      "command": "/etc/sensu/plugins/cpu-metrics.rb --scheme stats.:::name:::.cpu",
      "subscribers": ["webservers"],
      "interval": 10
    }
  }
}
```

The `debug` handler is included for logging purposes and may be omitted.

At least one element of `subscribers` has to match an element of the `subscriptions` in your client configuration file.

`command` is basically the address of the plugin you want to execute with the option `--scheme` enabled. It allows you to preface the metric name in the plugins output. Since ATSD accepts `{prefix}.{hostname}.{check/task-name}.<...>`, you can choose `--scheme` value accordingly. If you want your Sensu client name to be included in its place, you can also insert `:::name:::` into the prefix.
