# Entity Search

## Overview

The entity search interface can find entities by name, entity tag, and last insert date.

## Syntax

The search text can consist of multiple keywords.

* Keywords containing a colon are treated as **tag** filters, for example `tag1:val1` finds entities with tag `tag1` set to `val1`.
* Reserved keywords `min-date` and `max-date` filter entities by **last insert date**.
* The remaining keywords match **entity names**.

The following wildcards are supported in name patterns:

* `*` matches any number of characters.
* `?` matches any one character.

The `*` wildcard is automatically appended to name patterns, thereby matching entities with a name **starting** with the specified text.

Multiple keywords are evaluated as boolean `AND` conditions.

Entity names, tag names and tag values are matched in case-**insensitive** manner.

## Examples

* Find entities starting with `nur`.

    ```ls
    nur
    ```

    > Same results as `nur*`

* Find entities starting with `nur`.

    ```ls
    nur*
    ```

* Find entities containing `nur`.

    ```ls
    *nur*
    ```

* Find entities with tag `location` set to `SVL`.

    ```ls
    location:SVL
    ```

* Find entities with **any** value for tag `location` and display `location` column.

    ```ls
    location:*
    ```

* Find entities with **non-empty** value for tag `location` and display `location` column.

    ```ls
    location:
    ```

* Find entities starting with `nur` **and** tag `location` set to `SVL`.

    ```ls
    nur location:SVL
    ```

* Find entities with last insert date on the specified date or later.

    ```ls
    min-date:2018-08-21
    ```

* Find entities **without** last insert date.

    ```ls
    max-date:1970-01-01T00:00:00Z
    ```

* Find entities with last insert date in the specified **range**.

    ```ls
    min-date:2018-08-01 max-date:2018-08-10
    ```
