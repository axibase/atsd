# Graphite

- [Graphite Format](../../integration/graphite/graphite-format.md)
- [Storage Finder](../../integration/graphite/storage-finder.md)
- [Pickle Protocol](../../integration/graphite/pickle-protocol.md)
- [Data Migration from Graphite to ATSD](../../integration/graphite/data-migration.md)
- [Installing Graphite-Web with ATSD Storage Finder](../../integration/graphite/installation.md)

## Overview

[Graphite](https://graphite.readthedocs.org/en/latest/) is a monitoring tool that stores numeric time-series data and renders graphs of this data on demand.

The Axibase Time Series Database supports the Graphite format and Pickle protocol, so tools that send data to Graphite can also send data to ATSD.

ATSD has a Storage Finder for Graphite-Web, which means that you can use ATSD as the back-end for Graphite replacing or augmenting the default Whisper database.

[Learn more about ATSD Storage Finder here.](storage-finder.md)

![](resources/atsd_protocols_finders3.png)

##### List of key tools that support Graphite Format

- [collectd](http://collectd.org/) – a daemon which collects system performance statistics periodically.
- [collectl](http://collectl.sourceforge.net/) – a collection tool for system metrics that can be run both interactively and as a daemon, and has support for collecting from a broad set of subsystems.
- [Ganglia](http://ganglia.info/) – a scalable distributed monitoring system for high-performance computing systems such as clusters and Grids.
- [Sensu](https://sensuapp.org/) – a monitoring framework that can route metrics to Graphite.
- [StatsD](../statsd) – a simple daemon for easy stats aggregation.
- [Grafana](http://grafana.org/) – a general purpose graphite dashboard replacement with features such as rich graph editing and dashboard creation interface.

You can review the complete list of supported tools [here](http://graphite.readthedocs.org/en/latest/tools.html).
