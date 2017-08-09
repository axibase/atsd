# Messages: Delete

## Description

Currently the ability to delete message records via the Data API is not implemented. 

The messages are stored in the database within the TTL (time-to-live) interval, measured in seconds, specified on Admin: Server Properties `messages.timeToLive` setting. The message TTL is measured based on its insertion time, not the record datetime.

### Modifying the Default TTL

Convert the desired TTL to seconds, for example `3600 * 24 * 14 = 1209600` (14 days).

Execute the following administrative commands one by one to modify the TTL attribute:

```bash
echo "disable 'atsd_message'" | /opt/atsd/hbase/bin/hbase shell

echo "alter 'atsd_message', NAME => 'c', TTL => 1209600, MIN_VERSIONS => 0" | /opt/atsd/hbase/bin/hbase shell

echo "alter 'atsd_message', NAME => 'e', TTL => 1209600, MIN_VERSIONS => 0" | /opt/atsd/hbase/bin/hbase shell

echo "alter 'atsd_message', NAME => 'm', TTL => 1209600, MIN_VERSIONS => 0" | /opt/atsd/hbase/bin/hbase shell

echo "alter 'atsd_message', NAME => 't', TTL => 1209600, MIN_VERSIONS => 0" | /opt/atsd/hbase/bin/hbase shell

echo "enable 'atsd_message'" | /opt/atsd/hbase/bin/hbase shell

echo "major_compact 'atsd_message'" | /opt/atsd/hbase/bin/hbase shell

```

The response should look as follows:

```
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

### Deleting All Messages

Execute the following administrative command:

```bash
echo "truncate 'atsd_message'" | /opt/atsd/hbase/bin/hbase shell
```
