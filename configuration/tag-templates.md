# Tag Templates

## Overview

Tag Templates provide a way to organize similar groups of tags together and apply a single template to multiple entities or metrics.

![](./images/tag-templates.png)

Several Tag Templates are included in ATSD by default. You can create new tag templates on the **Tag Templates** page.

![](./images/tag-templates-menu.png)

To modify an existing Tag Template click the link in the **Name** column. To create a new Tag Template, expand the split button and select **Create**. Either action opens the Tag Template Editor.

## Tag Template Editor

Tag Template Editor contains the following options for managing Tag Templates:

* **Type**: Define whether the Tag Template applies to metric or entity [tags](../README.md#glossary).
* **Name**: User-defined or default name applied to the Tag Template.
* **Enabled**: Whether or not the tag template is enabled determines if the template is available for selection on the **Tag Set** drop-down list on the **Entities** page.
* **Expression**: Invoke Tag Template using user-defined expression for metrics, entities, or other tag templates.
* **Tag Set Name**: Filter name for tag template. Select **Tag Set** on **Entities** page to include specific tags in Entity Table.
* **Display Index**: Controls the order that **Tag Set** appears in **Tag Set** drop-down list on **Entities** page.
* **Parent Template**: Automatically import a set of tags for Tag Templates which are derived from existing templates.

## Tags Table

* **Type** drop-down list contains several options which control a remaining fields for the given tag:
  * **Text**: Define any text value.
  * **Numeric**: Define any integer value.
  * **Boolean**: Selectable values are `yes` and `no`.
  * **Dictionary**: Define tag value based on pre-defined.
  * **Entity Link**: Define tag value as an entity name. Tag value links to the appropriate entity.
* **Name**: Tag name.
* **Default Value**: Default value, if applicable.
* **Values**: Tag values. Not applicable to **Boolean** tag type.

## Toolbar

* **Save**: Store edits in to the database.
* **Clone**: Create and store a copy of the current Tag Template in the database. Cloned Tag Template will include the `_clone` suffix.
* **Delete**: Remove the current Tag Template from the database.
* **Cancel**: Discard changes made to the current Tag Template.