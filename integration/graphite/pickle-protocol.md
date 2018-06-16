# Pickle Format

Pickle is a binary format for serializing and de-serializing Python objects.

Learn more about [Pickle format in Graphite](https://graphite.readthedocs.io/en/latest/feeding-carbon.html#the-pickle-protocol).

ATSD provides support for the Pickle format used by when Carbon daemons.

Pickle Format:

```ls
[(metric-1, (timestamp-1, value-1)), (metric-1, (timestamp-2, value-2)), ...]
```

The TCP port used by ATSD to receive data sent in Pickle protocol from carbon-relays is configured in  `server.properties` file. The default TCP port is 8084.

The maximum message length is 64 kilobytes.
