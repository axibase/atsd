# Pickle Protocol

Pickle is a binary protocol for serializing and de-serializing Python objects. > Pickling is the process where a Python object hierarchy is converted into a byte stream. > Unpickling is the process in reverse, where a byte stream is converted back into an object hierarchy.

[Learn more about Pickle protocol in Graphite.](https://graphite.readthedocs.io/en/latest/feeding-carbon.html#the-pickle-protocol)

Axibase Time Series Database supports Pickle protocol when ingesting messages produced by Carbon daemons.

Pickle Format:

```ls
[(metric-1, (timestamp-1, value-1)), (metric-1, (timestamp-2, value-2)), ...]
```

The TCP port used by ATSD to receive data sent in Pickle protocol from carbon-relays is configured in  `server.properties` file. The default TCP port is 8084.

The maximum message length is 64 kilobytes.
