# Meta API: Entities Methods

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [Get](get.md) | `GET` `/entities/{entity}` <br> Retrieves information about the specified entity including its tags. |
| [List](list.md) | `GET` `/entities` <br> Retrieves a list of entities matching the specified filter conditions.|
| [Update](update.md) | `PATCH` `/entities/{entity}` <br> Updates fields and tags of the specified entity.|
| [Create or Replace](create-or-replace.md) | `PUT` `entities/{entity}` <br> Creates an entity with specified fields and tags or replaces the fields and tags of an existing entity.|
| [Delete](delete.md) | `DELETE` `/entities/{entity}` <br> Deletes the specified entity and delete it as member from any entity groups that it belongs to.|
| [Entity Groups](entity-groups.md) | `GET` `/entities/{entity}/groups` <br> Retrieves a list of entity groups to which the specified entity belongs. |
| [Metrics](metrics.md) | `GET` `/entities/{entity}/metrics` <br> Retrieves a list of metrics collected by the entity.|
| [Property Types](property-types.md) | `GET` `/entities/{entity}/property-types` <br> Retrieves a list property types for the entity.|