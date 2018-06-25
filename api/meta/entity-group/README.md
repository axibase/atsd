# Meta API: Entity groups Methods

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [Get](get.md) | `GET` `/entity-groups/{group}`<br> Retrieves information about the specified entity group including its tags.|
| [List](list.md) | `GET` `/entity-groups` <br> Retrieves a list of entity groups.|
| [Update](update.md) | `PATCH` `/entity-groups/{group}` <br> Updates fields and tags of the specified entity group.|
| [Create or Replace](create-or-replace.md) | `PUT` `/entity-groups/{group}`<br> Creates an entity group with specified fields and tags or replaces the fields and tags of an existing entity group.|
| [Delete](delete.md) | `DELETE` `/entity-groups/{group}` <br> Deletes the specified entity group.|
| [Get Entities](get-entities.md) | `GET` `/entity-groups/{group}/entities`<br> Retrieves a list of entities that are members of the specified entity group and are matching the specified filter conditions. |
| [Add Entities](add-entities.md) | `POST` `/entity-groups/{group}/entities/add`<br> Adds entities as members to the specified entity group.|
| [Set Entities](set-entities.md) | `POST` `/entity-groups/{group}/entities/set`<br> Sets members of the entity group from the specified entity list.|
| [Delete Entities](delete-entities.md) | `POST` `/entity-groups/{group}/entities/delete`<br> Removes specified entities from members of the specified entity group. |