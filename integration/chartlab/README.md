# ChartLab

## Overview

ChartLab is a publicly hosted Node application that makes it easy to build charts using the visualization library implemented in Axibase Time Series Database.

The public ChartLab is hosted at the following URL: `https://apps.axibase.com/chartlab`.

ChartLab's primary role is to provide a simple user interface to view and save portal and widget examples. Each example consists of one or multiple widgets built with the ATSD charts library. The widgets act as API clients and load series, properties and messages from ATSD Data API endpoints.

## Authentication and Authorization

ChartLab is optimized for convenience. The service does not require visitors to create an account to view or save configurations.

## Data Sources

The widgets can be configured to load data from the following sources:

* Random data source
* ATSD instance, operated by Axibase
* Custom ATSD instance

## Connecting ChartLab to Custom ATSD

> Note: The custom ATSD instance should be publicly accessible on a DNS/IP address.

* Login into Axibase Time Series Database server via SSH.

* Open the `/opt/atsd/atsd/conf/server.properties` file.

  Add the following setting:

```elm
  api.guest.access.enabled = true
```

  Save the file.

* Restart the Database

```sh
  /opt/atsd/bin/atsd-tsd.sh stop
```

```sh
  /opt/atsd/bin/atsd-tsd.sh start
```

* Open [ChartLab](https://apps.axibase.com/chartlab/) on the plain text protocol to avoid security errors.

  > The error is raised in the browser if the custom ATSD instance is using a self-signed or an untrusted SSL certificate.

* Change `Source` to ATSD in the ChartLab top menu.

* Add `url` property to the `[configuration]` section.

  Specify DNS name or IP address of the target ATSD instance.

```elm
  url = https://144.132.12.4:8443/
```

  User credentials are not required since ATSD is now configured for anonymous read-only access via Data and Meta API methods.

* Verify that the data is displayed for the following example for a built-in entity/metric:

```ls
  [configuration]
    offset-right = 50
    height-units = 2
    width-units = 1
    url = https://144.132.12.4:8443/

  [group]

  [widget]
    type = chart
    timespan = 15 minute
    format = bytes

    [series]
      entity = atsd
      metric = jvm_memory_used
```
