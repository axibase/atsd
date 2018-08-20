# Entity Search

## Overview

The entity search interface finds entities by name, entity tag, and last insert date.

## Syntax

Search text can consist of multiple keywords.

* Keywords containing a colon are treated as **tag** filters, for example `example-tag:example-value` finds entities with tag `example-tag` set to `example-value`.
* Reserved keywords `min-date` and `max-date` filter entities by **last insert date** specified as literal date in `yyyy-MM-dd` or ISO [format](../shared/date-format.md) or as a [calendar keyword](../shared/calendar.md).
* Remaining keywords match **entity names**.

## Wildcards

Name patterns support the following wildcard symbols:

* `*` Matches any number of characters.
* `?` Matches any one character.

Wildcard `*` is automatically appended to the end of name patterns when performing searches, thereby matching any entities which contain a name that **begins** with the specified text.

Multiple keywords are evaluated as boolean `AND` conditions.

Entity names, tag names, and tag values are matched on a  **case-insensitive** basis.

## Examples

* Find entities which begin with keyword `nur`:

    ```ls
    nur
    ```

    **Identical query**:

    ```ls
    nur*
    ```

* Find entities which contain keyword `nur`:

    ```ls
    *nur*
    ```

* Find entities with tag `location` set to `SVL`:

    ```ls
    location:SVL
    ```

* Find entities which contain tag `location` that begins with `NORTH`:

    ```ls
    location:NORTH*
    ```

* Find entities with **any** value for tag `location` and display `location` column:

    ```ls
    location:*
    ```

* Find entities with **non-empty** value for tag `location` and display `location` column:

    ```ls
    location:
    ```

* Find entities which begin with `nur` **and** contain tag `location` set to `SVL`:

    ```ls
    nur location:SVL
    ```

* Find entities with a last insert date on or later than the specified date:

    ```ls
    min-date:2018-08-21
    ```

* Find entities **without** a last insert date:

    ```ls
    max-date:1970-01-01T00:00:00Z
    ```

* Find entities with a last insert date in the specified **range**:

    ```ls
    min-date:2018-08-01 max-date:2018-08-10
    ```

* Find entities containing `cpu` **or** `memory`:
    ```ls
    *cpu* *memory*
    ```

* Find all entities matching `server-?` which have any data for last five minutes, and display some tags:
    ```ls
    server-? min-date:"now - 5 * minute" num_cpus: mem_size: disk_size:
    ```

* Find entities with tag value containing whitespace:
    ```ls
    server_group:"Email servers"
    ```

* Find entities with a name that contains a reserved character such as a colon `:` as in `sha256:123`:
    ```ls
    sha256\:*
    ```