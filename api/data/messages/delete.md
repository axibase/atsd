# Messages: delete

## Description

The ability to delete specific message records via the Data API is not implemented.

## TTL

The messages are deleted from the database by background tasks once their insertion time is older than current time minus the time-to-live (TTL) interval.

The TTL is displayed on the **Settings > Server Properties** page, under the `messages.timeToLive` setting. The setting is specified in seconds.

The message expiration time is calculated based on its **insertion** time, and not based on its **record** time.

## Modifying the Default TTL

Convert the TTL to seconds, for example 14 days is `14 * 24 * 3600 = 1209600`.

Log in to the ATSD server.

Modify the `TTL` attribute of the `atsd_message` table in HBase by executing the below commands.

> The procedure is different in distributed installations.

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

Truncate the `atsd_message` table to remove all records from the table.

```sh
echo "truncate 'atsd_message'" | /opt/atsd/hbase/bin/hbase shell
```
