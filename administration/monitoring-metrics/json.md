# Monitoring Metrics using JSON

Retrieve ATSD and HBase JMX metrics and outputs in JSON:

| Method Name | URL | Response |
| --- | --- | --- |
| ATSD | `https://atsd_hostname:8443/jmx` | [atsd.json](sources/atsd.json) |
| HBase Region Server | `http://atsd_hostname:60030/jmx` | [`hbase-region-server.json`](sources/hbase-region-server.json) |
| HBase Master | `http://atsd_hostname:60010/jmx` | [`hbase-master.json`](sources/hbase-master.json) |
