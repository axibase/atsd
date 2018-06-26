# Meta API: Metrics Methods

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [get](./get.md) | `GET` `/metrics/{metric}`<br> Retrieves properties and tags for the specified metric. |
| [list](./list.md) | `GET` `/metrics` <br> Retrieves a list of metrics matching the specified filter conditions.|
| [update](./update.md) | `PATCH` `/metrics/{metric}` <br> Updates fields and tags of the specified metric.|
| [create or replace](./create-or-replace.md) | `PUT` `/metrics/{metric}`<br> Creates a metric with specified fields and tags or replaces the fields and tags of an existing metric.|
| [delete](./delete.md) | `DELETE` `/metrics/{metric}` <br> Deletes the specified metric.|
| [series](./series.md) | `GET` `/metrics/{metric}/series` <br> Returns a list of series for the metric. |
| [series tags](./series-tags.md) | `GET` `/metrics/{metric}/series/tags` <br> Returns a list of unique series tag values for the metric.|