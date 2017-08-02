# Installing on MapR


Download the MapR M3 distribution and follow the installation
instructions from the MapR M3 website
[https://www.mapr.com/products/hadoop-download](https://www.mapr.com/products/hadoop-download)
to install MapR Community Edition.

Recommendations for installing MapR M3:

-   When MapR installer asks "Is this cluster going to run Apache
    HBase", be sure to answer "y"
-   Be sure to allocate at least the minimum recommended RAM amount and
    Hard Drive space for MapR
-   We recommend installing MapR on a separate Hard Drive in order to
    avoid issues down the line

## ATSD Installation

Copy ATSD distribution archive to the target machine:

```sh
 /opt/atsd.tar.gz
```

Unpack the package:

```sh
 cd /opt
 tar -xzvf atsd.tar.gz
```

Stop the HBase process:

```sh
 sudo service mapr-warden stop
```

Copy the `atsd.jar` file containing coprocessors to the `hbase/lib` directory:

```sh
 cp /opt/atsd/hbase/lib/atsd.jar /opt/mapr/hbase/hbase-0.94.24/lib/
```

Start HBase. Make sure that all services are started. This may take a few
minutes:

```sh
 sudo service mapr-warden start
```

Start HBase master and regionserver services:

```sh
 /opt/mapr/hbase/hbase-0.94.24/bin/hbase-daemons.sh --config /opt/mapr/hbase/hbase-0.94.24/conf start master
 /opt/mapr/hbase/hbase-0.94.24/bin/hbase-daemons.sh --config /opt/mapr/hbase/hbase-0.94.24/conf start regionserver
```

Modify ATSD configuration files to avoid port conflict with MapR
services:

```sh
 echo "hbase.zookeeper.property.clientPort = 5181" >> /opt/atsd/atsd/conf/hadoop.properties
 sed -i "s/http.port = 8088/http.port = 8099/g" /opt/atsd/atsd/conf/server.properties
```

Start ATSD:

```sh
 /opt/atsd/atsd/bin/start-atsd.sh
```

Verify that the ATSD web interface is available at http://atsd_hostname:8099

## Optional Steps
- [Veryfing installation](veryfing-installation.md)
- [Post-installation](post-installation.md)
