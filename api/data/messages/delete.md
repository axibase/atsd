# Messages: Delete

## Description

Currently the ability to delete message records via the Data API is not implemented. 

The messages are stored in the database within the TTL (time-to-live) interval, measured in seconds, specified on Admin: Server Properties `messages.timeToLive` setting. The message TTL is measured based on its insertion time, not the record datetime.

### Modifying the Default TTL

Login into HBase shell:

```bash
/opt/atsd/hbase/bin/hbase shell
```

Convert the desired TTL to seconds, for example `3600 * 24 * 14 = 1209600` (14 days).

Execute the following administrative commands one by one in the HBase shell to modify the TTL attribute:

```bash
disable 'atsd_message'

alter 'atsd_message', NAME => 'c', TTL => 1209600, MIN_VERSIONS => 0

alter 'atsd_message', NAME => 'e', TTL => 1209600, MIN_VERSIONS => 0

alter 'atsd_message', NAME => 'm', TTL => 1209600, MIN_VERSIONS => 0

alter 'atsd_message', NAME => 't', TTL => 1209600, MIN_VERSIONS => 0

enable 'atsd_message'

major_compact 'atsd_message'

exit
```

The response should look as follows:

```
hbase(main):004:0> disable 'atsd_message'
0 row(s) in 2.3310 seconds

hbase(main):005:0> alter 'atsd_message', NAME => 'c', TTL => 1209600
Updating all regions with the new schema...
1/1 regions updated.
Done.
0 row(s) in 1.4560 seconds

hbase(main):006:0> alter 'atsd_message', NAME => 'e', TTL => 1209600
Updating all regions with the new schema...
1/1 regions updated.
Done.
0 row(s) in 1.1890 seconds

hbase(main):007:0> alter 'atsd_message', NAME => 'm', TTL => 1209600
Updating all regions with the new schema...
1/1 regions updated.
Done.
0 row(s) in 1.0550 seconds

hbase(main):008:0> alter 'atsd_message', NAME => 't', TTL => 1209600
Updating all regions with the new schema...
1/1 regions updated.
Done.
0 row(s) in 1.0760 seconds

hbase(main):010:0> enable 'atsd_message'
0 row(s) in 2.7690 seconds

hbase(main):011:0> major_compact 'atsd_message'
0 row(s) in 0.4270 seconds
```

### Deleting All Messages

Login into HBase shell:

```bash
/opt/atsd/hbase/bin/hbase shell
```

Execute the following administrative commands one by one in the HBase shell:

```bash
truncate 'atsd_message'

exit
```
