# Time Zone

The time zone in which the database runs determines how [calendar](../shared/calendar.md) keywords are evaluated and how the intervals are split into DAY-based [periods](../api/data/series/period.md).

By the default, the time zone is inherited from the time zone of the operating system on which ATSD is running.

## Viewing the Time Zone

The current time zone is displayed on the **Settings > System Information** page.

![](../installation/images/server_time.png)

## Changing the Time Zone

* Select Time Zone ID from the following [list](../shared/timezone-list.md), for example, "US/Pacific".

* Uncomment the `TIME_ZONE` line block in the ATSD environment settings file `/opt/atsd/atsd/conf/atsd-env.sh`.

```bash
# Uncomment to set custom time zone
TIME_ZONE=US/Pacific
export JAVA_PROPERTIES="-Duser.timezone=${TIME_ZONE} $JAVA_PROPERTIES"
```

* Restart ATSD.

```bash
/opt/atsd/atsd/bin/stop-atsd.sh
```

```bash
/opt/atsd/atsd/bin/start-atsd.sh
```

* Open the **Settings > System Information** page and verify that the new time zone setting is set.
