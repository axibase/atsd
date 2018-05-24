# Collector Account with Read/Write Permissions

## Create `collectors-rw` User Group

* Login into ATSD as administrator.
* Open the **Settings > Users > User Groups > Create** page.
* Create the `collectors-rw` group with **[All Entities] Read** and **[All Entities] Write** permissions.

![collectors group](./images/collectors-rw-permissions.png)

## Create `collector-rw` User

* Open the **Settings > Users > Create** page.
* Create a `collector-rw` user with **API_DATA_READ, API_META_READ, API_DATA_WRITE, API_META_WRITE** roles.
* Check the `collectors-rw` row in the User Groups table to add the user to the `collectors-rw` group.

![collector user](./images/collector-rw-roles.png)
