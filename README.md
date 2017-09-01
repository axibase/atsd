# Axibase Time Series Database Documentation

## [API](api)

  * [Network](api/network#network-api)
    * [series](api/network/series.md)
    * [property](api/network/property.md)
    * [message](api/network/message.md)
    * [csv](api/network/csv.md)
    * [nmon](api/network/nmon.md)
    * [entity](api/network/entity.md)  
    * [metric](api/network/metric.md)
    * [extended](api/network/extended-commands.md)
  * [Data](api/data#overview)
    * [Series](api/data/series/README.md): [query](api/data/series/query.md), [insert](api/data/series/insert.md), [csv insert](api/data/series/csv-insert.md), [url query](api/data/series/url-query.md)
    * [Properties](api/data/properties/README.md): [query](api/data/properties/query.md), [insert](api/data/properties/insert.md), [url query](api/data/properties/url-query.md), [type query](api/data/properties/type-query.md), [delete](api/data/properties/delete.md)
    * [Messages](api/data/messages/README.md): [query](api/data/messages/query.md), [insert](api/data/messages/insert.md), [statistics](api/data/messages/stats-query.md)
    * [Alerts](api/data/alerts/README.md): [query](api/data/alerts/query.md), [update](api/data/alerts/update.md), [delete](api/data/alerts/delete.md), [history query](api/data/alerts/history-query.md)
    * [Extended](api/data/ext/README.md): [csv-upload](api/data/ext/csv-upload.md), [nmon-upload](api/data/ext/nmon-upload.md), [command](api/data/ext/command.md)
  * [Meta](api/meta#overview)
    * [Metrics](api/meta/metric/README.md): [list](api/meta/metric/list.md), [get](api/meta/metric/get.md), [update](api/meta/metric/update.md), [delete](api/meta/metric/delete.md), [create/replace](api/meta/metric/create-or-replace.md), [series](api/meta/metric/series.md)
    * [Entities](api/meta/entity/README.md): [list](api/meta/entity/list.md), [get](api/meta/entity/get.md), [update](api/meta/entity/update.md), [delete](api/meta/entity/delete.md), [create/replace](api/meta/entity/create-or-replace.md), [metrics](api/meta/entity/metrics.md), [entity-groups](api/meta/entity/entity-groups.md), [property-types](api/meta/entity/property-types.md)
    * [Entity Groups](api/meta/entity-group/README.md): [list](api/meta/entity-group/list.md), [get](api/meta/entity-group/get.md), [update](api/meta/entity-group/update.md), [delete](api/meta/entity-group/delete.md), [create/replace](api/meta/entity-group/create-or-replace.md), [get-entities](api/meta/entity-group/get-entities.md), [add-entities](api/meta/entity-group/add-entities.md), [set-entities](api/meta/entity-group/set-entities.md), [delete-entities](api/meta/entity-group/delete-entities.md)
    * [Miscellaneous](api/meta/misc/README.md): [search](api/meta/misc/search.md), [ping](api/meta/misc/ping.md), [version](api/meta/misc/version.md)

## [API Clients](api#api-clients)

  * [R](https://github.com/axibase/atsd-api-r)
  * [PHP](https://github.com/axibase/atsd-api-php)
  * [Java](https://github.com/axibase/atsd-api-java)
  * [Python](https://github.com/axibase/atsd-api-python)
  * [Ruby](https://github.com/axibase/atsd-api-ruby)
  * [NodeJS](https://github.com/axibase/atsd-api-nodejs)

## [SQL](api/sql#overview)

  * [Syntax](api/sql#syntax)
  * [Grouping](api/sql#grouping)
  * [Partitioning](api/sql#partitioning)
  * [Ordering](api/sql#ordering)
  * [Limiting](api/sql#limiting)
  * [Interpolation](api/sql#interpolation)
  * [Joins](api/sql#joins)
  * [API Endpoint](api/sql/api.md#sql-query-api-endpoint)
  * [Examples](api/sql#examples)

## Drivers

  * [JDBC](https://github.com/axibase/atsd-jdbc)
  * [ODBC](integration/odbc/README.md)
  
## Integrations

  * [Alteryx Designer](integration/alteryx/README.md)
  * [IBM SPSS Modeler](integration/spss/modeler/README.md)
  * [IBM SPSS Statistics](integration/spss/statistics/README.md)
  * [MatLab](integration/matlab/README.md)
  * [Pentaho Data Integration](integration/pentaho/data-integration/README.md)
  * [Pentaho Report Designer](integration/pentaho/report-designer/README.md)  
  * [Stata](integration/stata/README.md)
  * [Tableau](integration/tableau/README.md)
  * [ODBC](integration/odbc/README.md)
  * [Grafana](https://github.com/axibase/grafana-data-source)
  * [Graphite](https://github.com/axibase/atsd/tree/master/integration/graphite)

## Rule Engine

  * [Overview](rule-engine/README.md)
  * [Expression](rule-engine/expression.md)
  * [Filters](rule-engine/filters.md)
  * [Functions](rule-engine/functions.md)
  * [Placeholders](rule-engine/placeholders.md)
  * [Editor](rule-engine/editor.md)
  * [Email Action](rule-engine/email-action.md)

## Installation

  * [Requirements](administration/requirements.md)
  * [Distributions](installation/#installation-guides)
    * [Ubuntu/Debian (apt)](installation/ubuntu-debian-apt.md)
    * [Ubuntu/Debian  (deb)](installation/ubuntu-debian-deb.md)
    * [RedHat/CentOS (yum)](installation/redhat-centos-yum.md)
    * [RedHat/CentOS (rpm)](installation/redhat-centos-rpm.md)
    * [SUSE Linux Enterprise Server (rpm)](installation/sles-rpm.md)
    * [Docker (image)](installation/docker.md)
    * [Other](installation/other-distributions.md)
  * Cluster Distributions
    * [Cloudera Hadoop Distribution (CDH)](installation/cloudera.md)  	
  * Cloud Services
    * [AWS EMR](installation/aws-emr-s3.md)    
  * [Uninstalling](administration/uninstalling.md)
  * [Updating](administration/update.md)   

## Security

* [User Authentication](administration/user-authentication.md)
* [User Authorization](administration/user-authorization.md)

## Administration

  * [Overview](administration#administration)
  * [Email Client](administration/setting-up-email-client.md)
  * [Time Zone](administration/timezone.md)
  * [Allocating Memory](administration/allocating-memory.md)
  * [Data Directory](administration/changing-data-directory.md)
  * [Compaction Test](administration/compaction-test.md)
  * [Compaction](administration/compaction.md)
  * [Configuration Files](administration/editing-configuration-files.md)
  * [Network Settings](administration/networking-settings.md)  
  * [Enabling Swap Space](administration/enabling-swap-space.md)
  * [Logging](administration/logging.md)
  * [Metric Persistence Filter](administration/metric-persistence-filter.md)
  * [Monitoring](administration/monitoring.md)
  * [Replication](administration/replication.md)
  * [Restarting](administration/restarting.md)

## Data Collection Examples

  * [ActiveMQ](integration/activemq#monitoring-activemq-with-atsd)
  * [Axibase Enterprise Reporter](integration/aer#atsd-adapter)
  * [Derby](https://github.com/axibase/axibase-collector/blob/master/jobs/examples/derby#overview)
  * [HP Openview](https://github.com/axibase/axibase-collector/blob/master/jobs/examples/hp-openview#overview)
  * [IBM Tivoli Monitoring](integration/itm#ibm-tivoli-monitoring)
  * [JVM](https://github.com/axibase/axibase-collector/blob/master/jobs/examples/jvm#overview)
  * [Jetty](https://github.com/axibase/axibase-collector/blob/master/jobs/examples/jetty#overview)
  * [Microsoft System Center Operations Manager](https://github.com/axibase/axibase-collector/blob/master/jobs/examples/scom#overview)
  * [MySQL Server](https://github.com/axibase/axibase-collector/blob/master/jobs/examples/mysql#overview)
  * [NGINX](https://github.com/axibase/axibase-collector/blob/master/jobs/examples/nginx#overview)
  * [Oracle Enterprise Manager](https://github.com/axibase/axibase-collector/blob/master/jobs/examples/oracle-enterprise-manager#overview)
  * [PostgreSQL](https://github.com/axibase/axibase-collector/blob/master/jobs/examples/postgres#overview)
  * [SolarWinds](https://github.com/axibase/axibase-collector/blob/master/jobs/examples/solarwinds#overview)
  * [Tomcat Servlet Container](https://github.com/axibase/axibase-collector/blob/master/jobs/examples/tomcat#overview)
  * [VMware](https://github.com/axibase/axibase-collector/blob/master/jobs/examples/vmware#overview)
