# Weekly Change Log: November 21-27, 2016

## ATSD

| Issue     | Category        | Type     | Subject                                                                    |
|-----------|-----------------|----------|----------------------------------------------------------------------------|
|  3632     | sql             |  Feature | Added [`previous` mode interpolation](../../sql/examples/select-text-value.md#text-value-and-interpolation) for the `text` column, in compliance with the PI Server. |
|  3619     | UI              |  Bug     | Fixed 'Set Persistence' button on the Metrics list page.  |
|  3616     | api-rest        |  Bug     | Corrected 500 error code returned for pre-flight cross-domain `OPTION` requests. |
|  3613     | portal          |  Bug     | Portal not assigned to entity group when imported from an XML file. |
|  3553     | rule engine     |  Feature | Refactored Actions tab in the Rule Editor to correctly handle whitespace in script arguments. |
|  3526     | core            |  Bug     | Addressed an issue with `Append` operations introduced with series counters. Removed the feature due to unstable HBase `Append` performance under heavy load. |
|  3319     | api-rest        |  Support | Added tests for [NodeJS API client](https://github.com/axibase/atsd-api-nodejs). |
|  2369     | portal          |  Support | Implemented Docker container portals: docker host overview, docker host counter breakdown, and docker container detail. |
|  1924     | forecast        |  Feature | Added new options for the `Period` setting in the Forecast Settings editor. |

## Charts

|Issue     | Category        | Type      | Subject                                                                    |
|----------|-----------------|---------- |----------------------------------------------------------------------------|
|  3443    | property        |   Bug     | Fixed an issue with time column formatting when time zone is set to UTC. |
|  2454    | property        |   Feature | Implemented `format-numbers` and `format-headers` settings.|
|  2335    | property        |   Bug     | Refactored configuration so that the `entity` setting can be specified in json and simplified no-json syntax. |

## Collector

| Issue     | Category        | Type     | Subject                                                                    |
|-----------|-----------------|----------|----------------------------------------------------------------------------|
|  3635     |tcp              |  Feature | Added support for default port, applied if list item does not have a port number. |
|  3633     |docker           |  Bug     | Removed the `collector-host` tag from `series`, `property`, and `message` commands. |
|  3629     |data-source      |  Feature | Added ATSD to the list of supported data sources. The implementation relies on the [ATSD JDBC driver](https://github.com/axibase/atsd-jdbc). |
|  3622     |tcp              |  Feature | Refactored the job configuration form: add metric prefix, use built-in metric names, and display test table with statuses. Added support for the `${ITEM}` placeholder similar to the FILE job. |
|  3620     |docker           |  Feature | Enabled collection of data for the Docker host using the host's fully qualified name, passed with environment variable in the Docker container run command: "-e DOCKER_HOSTNAME=`hostname -f`". |
|  3611     |collection       |  Feature | Added support for ATSD Property API in Item Lists. |
|  3577     |jdbc             |  Bug     | Fixed issue with connection leakage when querying PI Server via JDBC. |
