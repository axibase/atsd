# SQL Report Scheduling

## Overview

SQL scheduler allows for SQL query reports to be generated at pre-determined times of the day.

The frequency is controlled with the **Schedule** field specifying a `cron` expression that determines when the task should be executed.

## Syntax

Fields in a cron expression have the following order:

* seconds
* minutes
* hours
* day-of-month
* month
* day-of-week
* year **(optional)**

For example, `0 0 8 * * ? *` means that the query will be executed at 08:00:00 every day.

```txt
seconds minutes hours day-of-month month day-of-week year
   0       0      8        *         *        ?        *
```

![Cron Expressions](https://axibase.com/wp-content/uploads/2016/03/cron_expressions.png)

 > Either '0' or '7' can be used for Sunday in the day-of-week field.

## Time Zone

The `cron` expression is evaluated based on the time zone of the server where the database is running. The time zone is displayed on the **Admin: System Information** page.

## Examples

**Expression** | **Description**
:---|:---
`0/10 * * * * ?` | Every 10 seconds.
`0 0/15 * * * ?` | Every 15 minutes.
`0 * * * * ?` | Every minute.
`0 0 0 * * ?` | Every day at 0:00.
`0 5,35 * * * ?` | Every hour at 5th and 35th minute.