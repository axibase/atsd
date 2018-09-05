# Monthly Change Log: November 2016

## ATSD

| **Issue**     | **Category**        | **Type**     | **Subject**                                                          |
|-----------|-----------------|----------|----------------------------------------------------------------------------|
| 3614      |   sql           | Feature  | Support for arithmetic expressions in the `COUNT` function. |
| 3612      |   test          | Support  | API tests for [property(path)](../../api/data/filter-entity.md#supported-functions) function. |
| 3609      |   sql           | Bug      | Server errors inconsistent when queries are executed via an [`/sql`](../../sql/api.md) endpoint. |
| 3606      |   api-rest      | Bug      | `entityExpression` not applied in [property query](../../api/data/properties/query.md) method. |
| 3605      |   UI            | Bug      | Removed header capitalization from the embedded property widget. |
| 3604      |   test          | Support  | API tests for the `entityExpression` field. |
| 3603      |   core          | Feature  | Replaced metric/entity/series/last-insert cache implementation to speed up write throughput. |
| 3602      |   core          | Feature  | Migrated to Spring 4. |
| 3584      |   security      | Feature  | Implemented encryption for the LDAP bind password stored in the database. |
| 3557      |   sql           | Bug      | Fixed incorrect empty string handling by the [`ISNULL`](../../sql/README.md#isnull) function. |
| 3502      |   sql           | Bug      | Replaced CSV generator to speed up response generation for SQL queries executed via an [`/api/sql`](../../sql/api.md) endpoint. |
|  3632     | sql             |  Feature | Added [`previous` mode interpolation](../../sql/examples/select-text-value.md#text-value-and-interpolation) for the `text` column, in compliance with the PI Server. |
|  3619     | UI              |  Bug     | Fixed **Set Persistence** button in the **Metric Editor**.  |
|  3616     | api-rest        |  Bug     | Corrected 500 error code returned for pre-flight cross-domain `OPTION` requests. |
|  3613     | portal          |  Bug     | Portal not assigned to entity group when imported from an XML file. |
|  3553     | rule engine     |  Feature | **Refactored Actions** tab in the Rule Editor to correctly handle non-printable characters in script arguments. |
|  3526     | core            |  Bug     | Addressed an issue with `Append` operations introduced with series counters. Removed the feature due to unstable HBase `Append` performance under heavy load. |
|  3319     | api-rest        |  Support | Added tests for [NodeJS API client](https://github.com/axibase/atsd-api-nodejs). |
|  2369     | portal          |  Support | Implemented Docker container portals: docker host overview, docker host counter breakdown, and docker container detail. |
|  1924     | forecast        |  Feature | Added new options for the `Period` setting in the Forecast Settings editor. |

---

## Charts

|**Issue**     | **Category**        | **Type**      | **Subject**                                                                    |
|----------|-----------------|---------- |----------------------------------------------------------------------------|
|  3443    | property        |   Bug     | Fixed an issue with time column formatting when time zone is set to UTC. |
|  2454    | property        |   Feature | Implemented `format-numbers` and `format-headers` settings.|
|  2335    | property        |   Bug     | Refactored `entity` setting to be specified in JSON and simplified no-JSON syntax. |

---

## Collector

| **Issue**     | **Category**        | **Type**     | **Subject**                                                                    |
|-----------|-----------------|----------|----------------------------------------------------------------------------|
|  3635     |tcp              |  Feature | Added support for default port, applied if list item does not have a port number. |
|  3633     |docker           |  Bug     | Removed the `collector-host` tag from `series`, `property`, and `message` commands. |
|  3629     |data-source      |  Feature | Added ATSD to the list of supported data sources. The implementation relies on the [ATSD JDBC driver](https://github.com/axibase/atsd-jdbc). |
|  3622     |tcp              |  Feature | Refactored the job configuration form: add metric prefix, use built-in metric names, and display test table with statuses. Added support for the `${ITEM}` placeholder similar to the FILE job. |
|  3620     |docker           |  Feature | Enabled collection of data for the Docker host using the fully qualified host name, passed with environment variable in the Docker container run command: "-e DOCKER_HOSTNAME=`hostname -f`". |
|  3611     |collection       |  Feature | Added support for ATSD Property API in Item Lists. |
|  3577     |jdbc             |  Bug     | Fixed issue with connection leakage when querying PI Server via JDBC. |
| 3589      | collectd        | Feature  | `Exec` plugin for [collectd](https://github.com/axibase/atsd-collectd-plugin) to capture `lvs` command output.|
| 3599      | docker          | Feature  | Store container `ENV` parameters into a dedicated property type. |
| 3597      | administrator           | Feature  | Added an Admin page to view and drop command `resender` cache. |
| 3595      | json            | Bug      | Added heuristics to handle Socrata dataset fields. |
| 3593      | json            | Feature  | Extend JSON to be able to parse the [BLS](https://www.bls.gov/developers/api_signature_v2.htm) JSON format. |
| 3569      | json            | Feature  | Fixed error when parsing dates in `Socrata` configurations. |
| 3568      | json            | Feature  | Partial loading of large datasets during `add` and `test` stages. |
| 3547      | docker          | Bug      | Fixed issue with high CPU usage generated by the Docker collector container. |