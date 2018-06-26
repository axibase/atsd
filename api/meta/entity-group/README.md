# Meta API: Entity groups Methods

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [get](./get.md) | `GET` `/entity-groups/{group}`<br> Retrieves information about the specified entity group including its tags.|
| [list](./list.md) | `GET` `/entity-groups` <br> Retrieves a list of entity groups.|
| [update](./update.md) | `PATCH` `/entity-groups/{group}` <br> Updates fields and tags of the specified entity group.|
| [create or replace](./create-or-replace.md) | `PUT` `/entity-groups/{group}`<br> Creates an entity group with specified fields and tags or replaces the fields and tags of an existing entity group.|
| [delete](./delete.md) | `DELETE` `/entity-groups/{group}` <br> Deletes the specified entity group.|
| [get entities](./get-entities.md) | `GET` `/entity-groups/{group}/entities`<br> Retrieves a list of entities that are members of the specified entity group and are matching the specified filter conditions. |
| [add entities](./add-entities.md) | `POST` `/entity-groups/{group}/entities/add`<br> Adds entities as members to the specified entity group.|
| [set entities](./set-entities.md) | `POST` `/entity-groups/{group}/entities/set`<br> Sets members of the entity group from the specified entity list.|
| [delete entities](./delete-entities.md) | `POST` `/entity-groups/{group}/entities/delete`<br> Removes specified entities from members of the specified entity group. |