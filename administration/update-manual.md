# Manual Update

## Login into Axibase Time Series Database Server

```sh
su axibase
```

## Download the Latest ATSD Distribution Files

Select an archive to download based on **HBase Version** displayed on the **Admin > System Information** page.

* [hbase 1.2.5](https://www.axibase.com/public/atsd_update_latest.htm)

The archive will contain the latest ATSD release with the revision number included in the file name, for example `atsd_17239.tar.gz`.

Copy the archive to the ATSD server.

## Unpack the Archive

```sh
tar xzf atsd.tar.gz
```

## View Files in the Archive

```sh
cd target
ls
atsd-executable.jar
atsd-hbase.jar
```

## Stop ATSD

```sh
/opt/atsd/bin/atsd-all.sh stop
```

## Copy JAR Files

```sh
rm -rf /opt/atsd/hbase/lib/atsd*jar
cp atsd-hbase.jar /opt/atsd/hbase/lib/atsd.hbase.jar
```

```sh
rm -rf /opt/atsd/atsd/bin/atsd*jar
cp atsd-executable.jar /opt/atsd/atsd/bin/atsd.executable.jar
```

## Start ATSD

```sh
/opt/atsd/bin/atsd-all.sh start
```

It may take up to 5 minutes for the database to initialize.

## Login into ATSD user interface

```sh
https://atsd_host:8443/
```

* Open the **Admin: System Information** page.
* Verify that the Revision Number has been updated.

![](images/revision.png)
