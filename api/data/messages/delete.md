# Messages: Delete

## Description

The ability to delete specific message records via the Data API is not implemented. 

## TTL

The messages are deleted from the database by background tasks once their insertion time is older than current time minus the time-to-live (TTL) interval.

The TTL is displayed on the **Settings: Server Properties** page, under the `messages.timeToLive` setting. It's measured in seconds.

The message expiration time is calculated based on its **insertion** time, and not based on its **record** time.

## Modifying the Default TTL

Convert the desired TTL to seconds, for example `14 days` is `14 * 24 * 3600 = 1209600`.

Login into the ATSD server and execute the following administrative commands in HBase shell one by one to modify the TTL attribute.

> The procedure is different in distributed installations.

```sh
echo "disable 'atsd_message'" | /opt/atsd/hbase/bin/hbase shell

echo "alter 'atsd_message', NAME => 'c', TTL => 1209600, MIN_VERSIONS => 0" | /opt/atsd/hbase/bin/hbase shell

echo "alter 'atsd_message', NAME => 'e', TTL => 1209600, MIN_VERSIONS => 0" | /opt/atsd/hbase/bin/hbase shell

echo "alter 'atsd_message', NAME => 'm', TTL => 1209600, MIN_VERSIONS => 0" | /opt/atsd/hbase/bin/hbase shell

echo "alter 'atsd_message', NAME => 't', TTL => 1209600, MIN_VERSIONS => 0" | /opt/atsd/hbase/bin/hbase shell

echo "enable 'atsd_message'" | /opt/atsd/hbase/bin/hbase shell

echo "major_compact 'atsd_message'" | /opt/atsd/hbase/bin/hbase shell

```

The response should look as follows:

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

Execute the following administrative command in HBase shell to truncate the 'atsd_message' table which will cause all records to be removed.

```sh
echo "truncate 'atsd_message'" | /opt/atsd/hbase/bin/hbase shell
```
