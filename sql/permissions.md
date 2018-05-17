# Entity Permissions in SQL Queries

## Overview

ATSD implements row-level security by controlling that users can view only records that belong to an entity that they're authorized to access based on [entity permissions](../administration/user-authorization.md#entity-permissions).

The row-level security is enforced in all types of queries by filtering rows at the time they're read from the database.

## Example

The following example demonstrates how query results for different users are filtered based on the user's effective entity permissions.

### Configuration

| **Username** | **Member Of** | **Allow Entity Group** | Entities |
|---|---|---|---|
| `joe.bloggs` | `users-all` | `*` (all) | `*` (all) |
| `jane.doe` | `users-aws` | `srv-aws` | `nurswg*` (5 entities) |
| `john.doe` | `users-nur` | `srv-nur` | `awsswg*` (3 entities) |

The `joe.bloggs` user is a member of the user group that has **'Read: All Entities'** permissions.

The `jane.doe` user is a member of the `users-nur` user group that is allowed to read data for `srv-nur` entity group.

The `john.doe` user is a member of the `users-aws` user group that is allowed to read data for `srv-aws` entity group.

![](./images/sql-permissions.png)

---

### Users

* All users:

![users](./images/users.png)

* User `joe.bloggs`:

![joe-bloggs-user](./images/joe-bloggs-user.png)

* User `jane.doe`:

![](./images/jane-doe-user.png)

* User `john.doe`:

![](./images/john-doe-user.png)

---

### User Groups

* User Group `users-all`:

![](./images/users-all.png)

* User Group `users-nur`:

![](./images/users-nur.png)

* User Group `users-aws`:

![](./images/users-aws.png)

---

### Entity Groups

* Entity Group `srv-nur`:

![](./images/srv-nur.png)

* Entity Group `srv-aws`:

![](./images/srv-aws.png)

---

### SQL Query

```sql
SELECT entity, avg(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= current_day
  GROUP BY entity
ORDER BY entity
```

---

### Query Results

* Results for user `joe.bloggs`:

![](./images/joe-bloggs-sql.png)

* Results for user `jane.doe`:

![](./images/jane-doe-sql.png)

* Results for user `john.doe`:

![](./images/john-doe-sql.png)
