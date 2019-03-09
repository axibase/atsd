# Messages: delete

## Overview

The Data API does not support deleting specific message records.

Instead the database automatically deletes expired messages records. The message expires when its **insertion time** is older than current time minus the Time to Live (TTL) interval.

> Expiration is based on the **insertion** time (time when the database received the message), as opposed to the message **record** time.

## Retention Settings

The TTL interval is set with the `messages.timeToLive` setting on the [**Settings > Server Properties**](../../../administration/server-properties.md) page. The setting is specified in **seconds**. The default interval is `31536000` (`365 * 24 * 3600` = 1 year).

To modify the TTL, open the **Settings > Configuration File** page or the `/opt/atsd/atsd/conf/server.properties` file.

Calculate the new retention interval in seconds, for example 14 days is `14 * 24 * 3600 = 1209600`.

Add or modify `messages.timeToLive` setting with the new value.

```elm
messages.timeToLive = 1209600
```

To avoid the restart, modify HBase settings as described below.

Alternatively, [restart](../../../administration/restarting.md) the ATSD process. Restarting HBase and HDFS is not necessary.

```sh
/opt/atsd/bin/atsd-tsd.sh stop
```

```sh
/opt/atsd/bin/atsd-tsd.sh start
```

### Modify HBase Settings

Modify the `TTL` attribute of the `atsd_message` table in HBase by executing the below commands.

:::tip Note
The procedure is different in distributed installations.
:::

```sh
echo "disable 'atsd_message'" | /opt/atsd/hbase/bin/hbase shell
```

```sh
echo "alter 'atsd_message', NAME => 'c', TTL => 1209600, MIN_VERSIONS => 0" | /opt/atsd/hbase/bin/hbase shell
```

```sh
echo "alter 'atsd_message', NAME => 'e', TTL => 1209600, MIN_VERSIONS => 0" | /opt/atsd/hbase/bin/hbase shell
```

```sh
echo "alter 'atsd_message', NAME => 'm', TTL => 1209600, MIN_VERSIONS => 0" | /opt/atsd/hbase/bin/hbase shell
```

```sh
echo "alter 'atsd_message', NAME => 't', TTL => 1209600, MIN_VERSIONS => 0" | /opt/atsd/hbase/bin/hbase shell
```

```sh
echo "enable 'atsd_message'" | /opt/atsd/hbase/bin/hbase shell
```

```sh
echo "major_compact 'atsd_message'" | /opt/atsd/hbase/bin/hbase shell
```

The sample response for the above commands is provided below.

```txt
HBase Shell; enter 'help<RETURN>' for list of supported commands.
Type "exit<RETURN>" to leave the HBase Shell
Version 0.94.27, rfb434617716493eac82b55180b0bbd653beb90bf, Thu Mar 19 06:17:55 UTC 2015

disable 'atsd_message'
0 row(s) in 1.4720 seconds

HBase Shell; enter 'help<RETURN>' for list of supported commands.
Type "exit<RETURN>" to leave the HBase Shell
Version 0.94.27, rfb434617716493eac82b55180b0bbd653beb90bf, Thu Mar 19 06:17:55 UTC 2015

alter 'atsd_message', NAME => 'c', TTL => 1209600, MIN_VERSIONS => 0
Updating all regions with the new schema...
1/1 regions updated.
Done.
0 row(s) in 1.4390 seconds

HBase Shell; enter 'help<RETURN>' for list of supported commands.
Type "exit<RETURN>" to leave the HBase Shell
Version 0.94.27, rfb434617716493eac82b55180b0bbd653beb90bf, Thu Mar 19 06:17:55 UTC 2015

alter 'atsd_message', NAME => 'e', TTL => 1209600, MIN_VERSIONS => 0
Updating all regions with the new schema...
1/1 regions updated.
Done.
0 row(s) in 1.3900 seconds

HBase Shell; enter 'help<RETURN>' for list of supported commands.
Type "exit<RETURN>" to leave the HBase Shell
Version 0.94.27, rfb434617716493eac82b55180b0bbd653beb90bf, Thu Mar 19 06:17:55 UTC 2015

alter 'atsd_message', NAME => 'm', TTL => 1209600, MIN_VERSIONS => 0
Updating all regions with the new schema...
1/1 regions updated.
Done.
0 row(s) in 1.3870 seconds

HBase Shell; enter 'help<RETURN>' for list of supported commands.
Type "exit<RETURN>" to leave the HBase Shell
Version 0.94.27, rfb434617716493eac82b55180b0bbd653beb90bf, Thu Mar 19 06:17:55 UTC 2015

alter 'atsd_message', NAME => 't', TTL => 1209600, MIN_VERSIONS => 0
Updating all regions with the new schema...
1/1 regions updated.
Done.
0 row(s) in 1.4120 seconds

HBase Shell; enter 'help<RETURN>' for list of supported commands.
Type "exit<RETURN>" to leave the HBase Shell
Version 0.94.27, rfb434617716493eac82b55180b0bbd653beb90bf, Thu Mar 19 06:17:55 UTC 2015

enable 'atsd_message'
0 row(s) in 1.3640 seconds

HBase Shell; enter 'help<RETURN>' for list of supported commands.
Type "exit<RETURN>" to leave the HBase Shell
Version 0.94.27, rfb434617716493eac82b55180b0bbd653beb90bf, Thu Mar 19 06:17:55 UTC 2015

major_compact 'atsd_message'
0 row(s) in 0.2950 seconds
```

## Deleting All Messages

Open the **Settings > Storage > Clear Messages** page.

Click **Clear Messages** to remove all message records.
