# Meta API: Metrics Methods

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [Get](get.md) | `GET` `/metrics/{metric}`<br> Retrieves properties and tags for the specified metric. |
| [List](list.md) | `GET` `/metrics` <br> Retrieves a list of metrics matching the specified filter conditions.|
| [Update](update.md) | `PATCH` `/metrics/{metric}` <br> Updates fields and tags of the specified metric.|
| [Create or Replace](create-or-replace.md) | `PUT` `/metrics/{metric}`<br> Creates a metric with specified fields and tags or replaces the fields and tags of an existing metric.|
| [Delete](delete.md) | `DELETE` `/metrics/{metric}` <br> Deletes the specified metric.|
| [Series](series.md) | `GET` `/metrics/{metric}/series` <br> Returns a list of series for the metric. |
| [Series Tags](series-tags.md) | `GET` `/metrics/{metric}/series/tags` <br> Returns a list of unique series tag values for the metric.|