# Timezone

The timezone in which the database runs determines how [endtime](../end-time-syntax.md) keywords are evaluated and how the intervals are split into DAY-based [periods](../api/data/series/period.md).

By the default, the timezone is inherited from the timezone of the operating system on which ATSD is running.

## Viewing the Time Zone

The current timezone is displayed on the **Admin > System Information** page.

![](../installation/images/server_time.png)

## Changing the Time Zone

* Select Timezone ID from the following [list](../api/network/timezone-list.md), for example, "US/Pacific".

* Open `/opt/atsd/atsd/bin/start-atsd.sh` file and scroll down to the section with uncommented $java_command for "GC logs disabled".

  ```
  echo " * [ATSD] ATSD `$java_command -version 2>&1 | head -n 1`"
  #GC logs disabled
  if grep -qi "arm" /proc/cpuinfo; then
      JAVA_OPTS="$JAVA_OPTS -XX:+PrintCommandLineFlags $DParams"
      "$java_command" $JAVA_OPTS -classpath "$atsd_home"/conf:"$atsd_executable""${lib_jars}" com.axibase.tsd.Server >/dev/null 2>${errorLog} &
      #uncomment to enable atsd output logging
      #"$java_command" $JAVA_OPTS -classpath "$atsd_home"/conf:"$atsd_executable""${lib_jars}" com.axibase.tsd.Server >>${outLog} 2>>${errorLog} &
  else
      JAVA_OPTS="$JAVA_OPTS $DParams"
      "$java_command" $JAVA_OPTS -classpath "$atsd_home"/conf:"$atsd_executable""${lib_jars}" com.axibase.tsd.Server >/dev/null 2>>${errorLog} &
      #uncomment to enable atsd output logging
      #"$java_command" $JAVA_OPTS -classpath "$atsd_home"/conf:"$atsd_executable""${lib_jars}" com.axibase.tsd.Server >>${outLog} 2>>${errorLog} &
  fi
  ```

* Add property `-Duser.timezone` to the second command (not "arm").

  ```
  echo " * [ATSD] ATSD `$java_command -version 2>&1 | head -n 1`"
    #GC logs disabled
    if grep -qi "arm" /proc/cpuinfo; then
        JAVA_OPTS="$JAVA_OPTS -XX:+PrintCommandLineFlags $DParams"
        "$java_command" $JAVA_OPTS -classpath "$atsd_home"/conf:"$atsd_executable""${lib_jars}" com.axibase.tsd.Server >/dev/null 2>${errorLog} &
        #uncomment to enable atsd output logging
        #"$java_command" $JAVA_OPTS -classpath "$atsd_home"/conf:"$atsd_executable""${lib_jars}" com.axibase.tsd.Server >>${outLog} 2>>${errorLog} &
    else
        JAVA_OPTS="$JAVA_OPTS $DParams"
        "$java_command" $JAVA_OPTS -Duser.timezone=US/Pacific -classpath "$atsd_home"/conf:"$atsd_executable""${lib_jars}" com.axibase.tsd.Server >/dev/null 2>>${errorLog} &
        #uncomment to enable atsd output logging
        #"$java_command" $JAVA_OPTS -classpath "$atsd_home"/conf:"$atsd_executable""${lib_jars}" com.axibase.tsd.Server >>${outLog} 2>>${errorLog} &
    fi
  ```

* Restart ATSD.

```bash
/opt/atsd/atsd/bin/stop-atsd.sh
/opt/atsd/atsd/bin/start-atsd.sh
```

* Open the **Admin > System Information** page and verify that the new timezone setting is set.
