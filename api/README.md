# Axibase Time Series Database API

## Network API

* [Overview](network#network-api)
* [series](network/series.md)
* [property](network/property.md)
* [message](network/message.md)
* [csv](network/csv.md)
* [nmon](network/nmon.md)
* [entity](network/entity.md)  
* [metric](network/metric.md)
* [extended](network/extended-commands.md)

## Data API

* [Overview](data#overview)
* [Series](data/series/README.md): [query](data/series/query.md), [insert](data/series/insert.md), [csv insert](data/series/csv-insert.md), [url query](data/series/url-query.md)
* [Properties](data/properties/README.md): [query](data/properties/query.md), [insert](data/properties/insert.md), [url query](data/properties/url-query.md), [type query](data/properties/type-query.md), [delete](data/properties/delete.md)
* [Messages](data/messages/README.md): [query](data/messages/query.md), [insert](data/messages/insert.md), [delete](data/messages/delete.md), [statistics](data/messages/stats-query.md)
* [Alerts](data/alerts/README.md): [query](data/alerts/query.md), [update](data/alerts/update.md), [delete](data/alerts/delete.md), [history query](data/alerts/history-query.md)
* [Extended](data/ext/README.md): [csv-upload](data/ext/csv-upload.md), [nmon-upload](data/ext/nmon-upload.md), [command](data/ext/command.md)

## Meta API

* [Overview](meta#overview)
* [Metrics](meta/metric/README.md): [list](meta/metric/list.md), [get](meta/metric/get.md), [update](meta/metric/update.md), [delete](meta/metric/delete.md), [create/replace](meta/metric/create-or-replace.md), [series](meta/metric/series.md)
* [Entities](meta/entity/README.md): [list](meta/entity/list.md), [get](meta/entity/get.md), [update](meta/entity/update.md), [delete](meta/entity/delete.md), [create/replace](meta/entity/create-or-replace.md), [metrics](meta/entity/metrics.md), [entity-groups](meta/entity/entity-groups.md), [property-types](meta/entity/property-types.md)
* [Entity Groups](meta/entity-group/README.md): [list](meta/entity-group/list.md), [get](meta/entity-group/get.md), [update](meta/entity-group/update.md), [delete](meta/entity-group/delete.md), [create/replace](meta/entity-group/create-or-replace.md), [get-entities](meta/entity-group/get-entities.md), [add-entities](meta/entity-group/add-entities.md), [set-entities](meta/entity-group/set-entities.md), [delete-entities](meta/entity-group/delete-entities.md)
* [Miscellaneous](meta/misc/README.md): [search](meta/misc/search.md), [ping](meta/misc/ping.md), [version](meta/misc/version.md)

## SQL

* [Overview](sql#overview)  
* [Syntax](sql#syntax)
* [Grouping](sql#grouping)
* [Partitioning](sql#partitioning)
* [Ordering](sql#ordering)
* [Limiting](sql#limiting)
* [Interpolation](sql#interpolation)
* [Regularization](sql#regularization)
* [Joins](sql#joins)
* [API Endpoint](sql/api.md#sql-query-api-endpoint)
* [Examples](sql#examples)

## API Clients

* [R language](https://github.com/axibase/atsd-api-r)
* [PHP](https://github.com/axibase/atsd-api-php)
* [Java](https://github.com/axibase/atsd-api-java)
* [Python](https://github.com/axibase/atsd-api-python)
* [Ruby](https://github.com/axibase/atsd-api-ruby)
* [NodeJS](https://github.com/axibase/atsd-api-nodejs)

## Drivers

* [JDBC Driver](https://github.com/axibase/atsd-jdbc)
