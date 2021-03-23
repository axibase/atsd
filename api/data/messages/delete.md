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

[Restart](../../../administration/restarting.md) the ATSD process. Restarting HBase and HDFS is not necessary.

```sh
/opt/atsd/bin/atsd-tsd.sh stop
```

```sh
/opt/atsd/bin/atsd-tsd.sh start
```

## Deleting All Messages

Open the **Settings > Storage > Clear Messages** page.

Click **Clear Messages** to remove all message records.
