# Installation: Cloudera / CDH

## Create User

Create an `axibase` user on the server where you plan to install ATSD.

```sh
sudo adduser axibase
```

## Install Java

[Install Oracle JDK or Open JDK](../administration/migration/install-java-8.md).

Add the `JAVA_HOME` path to the `axibase` user environment in `.bashrc`.

```sh
sudo su axibase
```

```sh
jp=`dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"`; \
  sed -i "s,^export JAVA_HOME=.*,export JAVA_HOME=$jp,g" ~/.bashrc ; \
  echo $jp
```

## Verify Connectivity

Check connection from the ATSD server to the Zookeeper service.

```sh
telnet zookeeper-host 2181
```

```txt
Trying 192.0.2.6...
Connected to zookeeper-host.
Escape character is '^]'.
```

The Zookeeper client port is specified in:

* Zookeeper host: `/etc/zookeeper/conf.dist/zoo.cfg` > `clientPort` setting
* HBase host: `/etc/hbase/conf.dist/hbase-site.xml` > `hbase.zookeeper.property.clientPort` setting

## Download ATSD

### CDH (Cloudera Distribution Hadoop) 5.5.x

```sh
curl -O https://axibase.com/public/atsd_ee_hbase_1.0.3.tar.gz
```

### Extract Files

```sh
sudo tar -xzvf atsd_ee_hbase_1.0.3.tar.gz -C /opt
```

```sh
sudo chown -R axibase:axibase /opt/atsd
```

## Request License

To obtain a license key, contact Axibase support with the following information from the server where you plan to install ATSD.

* Output of the `ip addr` command.

```sh
ip addr
```

```txt
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 00:50:56:b9:35:31 brd ff:ff:ff:ff:ff:ff
    inet 192.0.2.6/24 brd 192.0.2.255 scope global eth1
    inet6 2a01:4f8:140:53c6::7/64 scope global
       valid_lft forever preferred_lft forever
    inet6 fe80::250:56ff:feb9:3531/64 scope link
       valid_lft forever preferred_lft forever
```

* Output of the `hostname -f` command.

```sh
hostname -f
```

```txt
NURSWGVML007
```

Provide output of the above commands to Axibase support and copy the returned license key to `/opt/atsd/atsd/conf/license/key.properties`.

## Setup HBase Connection

Open the `hadoop.properties` file.

```sh
nano /opt/atsd/atsd/conf/hadoop.properties
```

Set `hbase.zookeeper.quorum` to Zookeeper hostname `zookeeper-host`

If Zookeeper client port is different from 2181, set `hbase.zookeeper.property.clientPort` accordingly.

If Zookeeper Znode parent is not `/hbase`, set `zookeeper.znode.parent` to the actual value.

```elm
hbase.zookeeper.quorum = zookeeper-host
hbase.zookeeper.property.clientPort = 2181
zookeeper.znode.parent = /hbase
hbase.rpc.timeout = 120000
hbase.client.scanner.timeout.period = 120000
```

## Kerberos Authentication

ATSD can be enabled for Kerberos authentication with Zookeeper and Hadoop services by following these steps.

### Generate `keytab` File for `axibase` Principal

Create an `axibase` principal and generate a corresponding `keytab` on the Cloudera Manager server, or on the server where KDC service is installed.

Replace realm `HADOOP.EXAMPLE.ORG` with the actual value specified in the `/etc/krb5.conf` file on the Cloudera Manager server.

```ls
kadmin.local <<eoj
addprinc -pw PASSWORD axibase@HADOOP.EXAMPLE.ORG
ktadd -k axibase.keytab axibase@HADOOP.EXAMPLE.ORG
eoj
```

Copy the `axibase.keytab` file to the `/opt/atsd/atsd/conf` directory on the ATSD server.

### Authorize `axibase` Principal

Check the **HBase Secure Authorization** setting in the Cloudera HBase configuration.

![](./images/cloudera-manager-authorization.png)

If the **HBase Secure Authorization** is disabled you can access HBase with no modifications. Proceed to [Kerberos Settings](#kerberos-settings).

Otherwise, you need to allow the newly created `axibase` principal to access HBase using one of the following options:

#### Option 1. Add the `axibase` principal to the HBase super users via HBase Configuration

> Do not forget to deploy updated configuration and restart HBase.

![](./images/cloudera-manager-superuser.png)

#### Option 2. Grant **RWXC** (read,write,execute,create) permissions to the `axibase` principal

Log in to the HMaster server and locate the `hbase.keytab` file.

```sh
find / -name "hbase.keytab" | xargs ls -la
-rw------- 1 hbase        hbase        448 Jul 29 16:44 /var/run/cloudera-scm-agent/process/30-hbase-MASTER/hbase.keytab
```

Obtain the fully qualified hostname of the HMaster server.

```sh
hostname -f
```

Authenticate with Kerberos using the `hbase.keytab` file and HMaster full hostname.

```sh
kinit -k -t /var/run/cloudera-scm-agent/process/30-hbase-MASTER/hbase.keytab hbase/{master_full_hostname}
```

Grant **RWXC** permissions to `axibase` principal in HBase shell.

```sh
echo "grant 'axibase', 'RWXC'" | hbase shell
```

### Configure Kerberos Configuration Information in `krb5.conf` File

Copy the `/etc/krb5.conf` file from an HBase Master server to the ATSD server at the same path: `/etc/krb5.conf`.

```ls
[libdefaults]
default_realm = HADOOP.EXAMPLE.ORG
dns_lookup_kdc = true
dns_lookup_realm = false
ticket_lifetime = 86400
renew_lifetime = 604800
forwardable = true
default_tgs_enctypes = rc4-hmac arcfour-hmac aes256-cts-hmac-sha1-96 des3-hmac-sha1 des-cbc-md5 des-cbc-crc aes256-cts aes128-cts des-hmac-sha1 aes128-cts-hmac-sha1-96
default_tkt_enctypes = rc4-hmac arcfour-hmac aes256-cts-hmac-sha1-96 des3-hmac-sha1 des-cbc-md5 des-cbc-crc aes256-cts aes128-cts des-hmac-sha1 aes128-cts-hmac-sha1-96
permitted_enctypes = rc4-hmac arcfour-hmac aes256-cts-hmac-sha1-96 des3-hmac-sha1 des-cbc-md5 des-cbc-crc aes256-cts aes128-cts des-hmac-sha1 aes128-cts-hmac-sha1-96
udp_preference_limit = 1
verify_ap_req_nofail = false

[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[realms]
HADOOP.EXAMPLE.ORG = {
kdc = nurswgkrb01.example.org
admin_server = nurswgkrb01.example.org
kdc = nurswgkrb02.example.org
}

[domain_realm]
.example.org = HADOOP.EXAMPLE.ORG
axibase.com  = HADOOP.EXAMPLE.ORG
.apps.example.org = HADOOP.EXAMPLE.ORG
apps.example.org = HADOOP.EXAMPLE.ORG
```

Verify that the hostname specified in the `kdc` and `admin_server` properties above is resolvable on the ATSD server. Add it to `/etc/hosts` if necessary.

### Kerberos Settings

Specify the `axibase` principal and `keytab` path settings in the `/opt/atsd/atsd/conf/server.properties` file in ATSD:

```ls
# Kerberos principal, identified with username and realm.
kerberos.login=axibase@HADOOP.EXAMPLE.ORG
# Absolute path to Kerberos keytab file, containing encrypted key for the above principal.
kerberos.keytab.path=/opt/atsd/atsd/conf/axibase.keytab
```

> The `keytab` file needs to be updated whenever the password is changed.
> For added security, ensure that the `keytab` file has 400 permission (read by owner).

### `hbase-site.xml` File

Remove comments in the `/opt/atsd/atsd/conf/hbase-site.xml` file and replace the `HADOOP.EXAMPLE.ORG` realm with the actual value from the `krb5.conf` file.

```xml
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>hbase.master.kerberos.principal</name>
    <value>hbase/_HOST@HADOOP.EXAMPLE.ORG</value>
  </property>
  <property>
    <name>hbase.regionserver.kerberos.principal</name>
    <value>hbase/_HOST@HADOOP.EXAMPLE.ORG</value>
  </property>
</configuration>
```

### Authentication Log Messages

```txt
2016-07-24 13:28:41,468;INFO;main;com.axibase.tsd.hbase.KerberosBean;Setting up kerberos auth: login:axibase@HADOOP.EXAMPLE.ORG keytab:/opt/atsd/atsd/conf/axibase.keytab
2016-07-24 13:28:41,723;INFO;main;com.axibase.tsd.hbase.KerberosBean;Login user from keytab starting...
2016-07-24 13:28:41,811;INFO;main;org.apache.hadoop.security.UserGroupInformation;Login successful for user axibase@HADOOP.EXAMPLE.ORG using keytab file /opt/atsd/atsd/conf/axibase.keytab
2016-07-24 13:28:41,811;INFO;main;com.axibase.tsd.hbase.KerberosBean;Login user from keytab successful
2016-07-24 13:28:42,879;INFO;main;com.axibase.tsd.hbase.SchemaBean;Checking ATSD schema
2016-07-24 13:28:42,973;INFO;main;org.apache.hadoop.hbase.zookeeper.RecoverableZooKeeper;Process identifier=hconnection-0x14aa12c3 connecting to ZooKeeper ensemble=nurswgvml303.example.org:2181
```

### Debugging Kerberos

Kerberos debugging can be enabled in the ATSD environment settings file `/opt/atsd/atsd/conf/atsd-env.sh`.

```ls
# Uncomment to enable Kerberos debug
#export JAVA_PROPERTIES="-Dsun.security.krb5.debug=true"

# Uncomment to enable ATSD output logging
#export outLog="${atsd_home}/logs/out.log"
```

Kerberos debug output is redirected to the `${outLog}` file, which is set to `/opt/atsd/atsd/logs/out.log` by default.

```txt
5921 [main] INFO  com.axibase.tsd.hbase.KerberosBean - Setting up kerberos auth: login:axibase@HADOOP.EXAMPLE.ORG keytab:/opt/atsd/atsd/conf/axibase.keytab
Java config name: null
Native config name: /etc/krb5.conf
Loaded from native config
6085 [main] WARN  o.a.hadoop.util.NativeCodeLoader - Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
6213 [main] INFO  com.axibase.tsd.hbase.KerberosBean - Login user from keytab starting...
Java config name: null
Native config name: /etc/krb5.conf
Loaded from native config
>>> KdcAccessibility: reset
>>> KdcAccessibility: reset
>>> KeyTabInputStream, readName(): HADOOP.EXAMPLE.ORG
>>> KeyTabInputStream, readName(): axibase
...
>>> KrbAsReq creating message
>>> KrbKdcReq send: kdc=nurswgkrb01.example.org TCP:88, timeout=3000, number of retries =3, #bytes=137
>>> KDCCommunication: kdc=nurswgkrb01.example.org TCP:88, timeout=3000,Attempt =1, #bytes=137
>>>DEBUG: TCPClient reading 620 bytes
>>> KrbKdcReq send: #bytes read=620
>>> KdcAccessibility: remove nurswgkrb01.example.org
Added key: 1version: 2
Added key: 16version: 2
Added key: 23version: 2
Added key: 18version: 2
Ordering keys wrt default_tkt_enctypes list
default etypes for default_tkt_enctypes: 23 18.
>>> EType: sun.security.krb5.internal.crypto.ArcFourHmacEType
>>> KrbAsRep cons in KrbAsReq.getReply axibase
6246 [main] INFO  o.a.h.security.UserGroupInformation - Login successful for user axibase@HADOOP.EXAMPLE.ORG using keytab file /opt/atsd/atsd/conf/axibase.keytab
6247 [main] INFO  com.axibase.tsd.hbase.KerberosBean - Login user from keytab successful
```

## Configure HBase

### Deploy ATSD Coprocessors to HBase Region Servers

Copy `/opt/atsd/hbase/lib/atsd.jar` to the `/usr/lib/hbase/lib` directory on each HBase region server.

### Enable ATSD Coprocessors

Open Cloudera Manager, select the target HBase cluster/service, open Configuration tab, search for the setting `hbase.coprocessor.region.classes` and enter the following names.

* `com.axibase.tsd.hbase.coprocessor.CompactRawDataEndpoint`
* `com.axibase.tsd.hbase.coprocessor.DeleteDataEndpoint`
* `com.axibase.tsd.hbase.coprocessor.MessagesStatsEndpoint`

![](./images/cloudera-manager-coprocessor-config.png)

### Increase Maximum Heap Size on Region Servers

![](./images/cdh-region-heap.png)

### Restart HBase Service

## Check for Port Conflicts

```sh
sudo netstat -tulpn | grep "8081\|8082\|8084\|8088\|8443"
```

If some of the above ports are taken, open the `/opt/atsd/atsd/conf/server.properties` file and change ATSD listening ports accordingly.

```elm
http.port = 8088
input.port = 8081
udp.input.port = 8082
pickle.port = 8084
https.port = 8443
```

## Disable Compactions

By default ATSD initiates a major HBase compaction of its key data tables on a daily schedule.

Since major compactions place a heavy load on the cluster, increase the default interval or initiate the compactions externally, for example via Cloudera Manager:

![](./images/cm_major_compaction.png)

To disable built-in compaction of data tables, adjust the following settings on the **Settings > Server Properties** page:

```txt
# this compacts only 'entity' table once a week on Saturday
hbase.compaction.list = entity
hbase.compaction.schedule = 0 0 12 * * SAT
```

## Allocate Memory

Allocate Java Heap memory to ATSD java process as described [here](../administration/memory-allocation.md).

Increase the number of worker threads and maximum queue size the **Settings > Server Properties** page:

```ls
# maximum number of concurrent HBase storage worker threads, default: 4
series.queue.pool.size = 8
# maximum number of commands in queue
series.queue.limit = 500000
```

## RPC Encryption

To enable encryption of RPC traffic between ATSD and HBase, add the following property to the `/opt/atsd/atsd/conf/hbase-site.xml` file in ATSD:

```ls
<property>
        <name>hbase.rpc.protection</name>
        <value>privacy</value>
</property>
```

Similarly, enable the `hbase.rpc.protection` property on the HBase cluster:

![](./images/rpc-hbase.png)

## Start ATSD

```sh
/opt/atsd/atsd/bin/start-atsd.sh
```

Review the start log for any errors:

```sh
tail -f /opt/atsd/atsd/logs/atsd.log
```

Watch for **ATSD start completed** message at the end of the `start.log`.

Web interface is now accessible on port `8443` (https).

## Enable ATSD Auto-Start

To configure ATSD for automated restart on server reboot, add the following line to `/etc/rc.local` before the `return 0` line.

```sh
su - axibase -c /opt/atsd/atsd/bin/start-atsd.sh
```

## Troubleshooting

* Review [troubleshooting guide](troubleshooting.md).

## Validation

* [Verify database installation](verifying-installation.md).

## Post-installation Steps

* [Basic configuration](post-installation.md).
* [Getting Started guide](../tutorials/getting-started.md).

## Updating ATSD

### Option 1. Co-processor Update is NOT Required

Login as an `axibase` user into the server where ATSD is installed.

Download the latest ATSD release, or a specific version based on the link provided by Axibase support.

```sh
cd ~
curl -O https://axibase.com/public/atsd_ee_hbase_1.0.3.tar.gz
```

Extract the files.

```sh
tar -xvf atsd_ee_hbase_1.0.3.tar.gz
```

Stop the ATSD process.

```sh
/opt/atsd/atsd/bin/stop-atsd.sh
```

Update start/script files. Required for ATSD installations older than revision 15060.

```sh
sed -i 's~^atsd_executable="$atsd_home/bin/atsd.*~atsd_executable=`ls $atsd_home/bin/atsd*.jar`~g' /opt/atsd/atsd/bin/stop-atsd.sh
```

```sh
sed -i 's~^atsd_executable="$atsd_home/bin/atsd.*~atsd_executable=`ls $atsd_home/bin/atsd*.jar`~g' /opt/atsd/atsd/bin/start-atsd.sh
```

Delete previous ATSD jar files on the ATSD server.

```sh
rm /opt/atsd/atsd/bin/atsd*.jar
```

Copy new ATSD jar files on the ATSD server.

```sh
cp atsd/atsd/bin/atsd*.jar /opt/atsd/atsd/bin/
```

Compare atsd-hbase jar revision with the revision installed on HBase region servers

```sh
ls atsd/hbase/lib/atsd-hbase.*.jar
```

Compare the displayed revision with atsd-hbase file revision in `/usr/lib/hbase/lib` directory located on the HBase region servers. If the revision is the same, skip HBase region server upgrades. Otherwise, if the revision of the new file is greater than what is installed on HBase region servers, shutdown each region server and replace old versions of the jar file with the current copy.

Start ATSD process.

```sh
/opt/atsd/atsd/bin/start-atsd.sh
```
