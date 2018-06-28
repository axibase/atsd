# Collector R/W Account

The document describes how to create a [collector](collector-account.md) account with additional entity `read` permissions.

## Create User Group

* Open the **Settings > Users > User Groups > Create** page.
* Create the `collectors-rw` group with **All Entities: Read** and **All Entities: Write** permissions.

![collectors group](./images/collectors-rw-permissions.png)

## Create User

* Open the **Settings > Users > Create** page.
* Create a `collector-rw` user with `API_DATA_READ`, `API_META_READ`, `API_DATA_WRITE`, `API_META_WRITE` roles.
* Check the `collectors-rw` row in the User Groups table to add the user to the `collectors-rw` group.

![collector user](./images/collector-rw-roles.png)
