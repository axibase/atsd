# Database API

## Data API

* [Overview](data/README.md#rest-api)
* [Series](data/series/README.md): [query](data/series/query.md), [get](data/series/get.md), [insert](data/series/insert.md), [csv insert](data/series/csv-insert.md), [delete](data/series/delete.md)
* [Properties](data/properties/README.md): [get](data/properties/get.md), [query](data/properties/query.md), [insert](data/properties/insert.md), [list types](data/properties/list-types.md), [delete](data/properties/delete.md)
* [Messages](data/messages/README.md): [query](data/messages/query.md), [insert](data/messages/insert.md), [webhook](data/messages/webhook.md), [delete](data/messages/delete.md), [stats](data/messages/stats.md)
* [Alerts](data/alerts/README.md): [query](data/alerts/query.md), [update](data/alerts/update.md), [delete](data/alerts/delete.md), [history query](data/alerts/history-query.md)
* [Extended](data/ext/README.md): [csv-upload](data/ext/csv-upload.md), [nmon-upload](data/ext/nmon-upload.md), [command](data/ext/command.md)

## Meta API

* [Overview](meta/README.md#overview)
* [Metrics](meta/metric/README.md): [list](meta/metric/list.md), [get](meta/metric/get.md), [update](meta/metric/update.md), [delete](meta/metric/delete.md), [create/replace](meta/metric/create-or-replace.md), [series](meta/metric/series.md), [series tags](meta/metric/series-tags.md)
* [Entities](meta/entity/README.md): [list](meta/entity/list.md), [get](meta/entity/get.md), [update](meta/entity/update.md), [delete](meta/entity/delete.md), [create/replace](meta/entity/create-or-replace.md), [metrics](meta/entity/metrics.md), [entity-groups](meta/entity/entity-groups.md), [property-types](meta/entity/property-types.md)
* [Entity Groups](meta/entity-group/README.md): [list](meta/entity-group/list.md), [get](meta/entity-group/get.md), [update](meta/entity-group/update.md), [delete](meta/entity-group/delete.md), [create/replace](meta/entity-group/create-or-replace.md), [get-entities](meta/entity-group/get-entities.md), [add-entities](meta/entity-group/add-entities.md), [set-entities](meta/entity-group/set-entities.md), [delete-entities](meta/entity-group/delete-entities.md)
* [Miscellaneous](meta/misc/README.md): [search](meta/misc/search.md), [portal export](meta/misc/portal.md), [ping](meta/misc/ping.md), [version](meta/misc/version.md), [permissions](meta/misc/permissions.md)

## Network API

* [Overview](network/README.md#network-api)
* [series](network/series.md)
* [property](network/property.md)
* [message](network/message.md)
* [csv](network/csv.md)
* [nmon](network/nmon.md)
* [entity](network/entity.md)
* [metric](network/metric.md)
* [extended](network/extended-commands.md)

## SQL

* [Overview](../sql/README.md#sql)
* [Syntax](../sql/README.md#syntax)
* [Grouping](../sql/README.md#grouping)
* [Partitioning](../sql/README.md#partitioning)
* [Ordering](../sql/README.md#ordering)
* [Limiting](../sql/README.md#limiting)
* [Interpolation](../sql/README.md#interpolation)
* [Regularization](../sql/README.md#regularization)
* [Joins](../sql/README.md#joins)
* [API Endpoint](../sql/api.md#sql-query-api-endpoint)
* [Examples](../sql/examples/README.md)

## API Clients

* [Python](https://github.com/axibase/atsd-api-python)
* [Java](https://github.com/axibase/atsd-api-java)
* [NodeJS](https://github.com/axibase/atsd-api-nodejs)
* [R language](https://github.com/axibase/atsd-api-r)
* [PHP](https://github.com/axibase/atsd-api-php)
* [Go](https://github.com/axibase/atsd-api-go)
* [Ruby](https://github.com/axibase/atsd-api-ruby)

## Drivers

* [JDBC](https://github.com/axibase/atsd-jdbc)
* [ODBC](../integration/odbc/README.md)