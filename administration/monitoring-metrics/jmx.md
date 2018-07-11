# Monitoring Metrics using JMX

JMX tools can be used to fetch ATSD metrics, for example:
[JConsole](https://docs.oracle.com/javase/7/docs/technotes/guides/management/jconsole.html "jconsole"), [jmxterm](http://wiki.cyclopsgroup.org/jmxterm/ "jmxterm"), or any other application that support JMX.

## Setup JMX in ATSD

In `/etc/hosts` change `127.0.1.1 atsd_hostname` to `atsd_ip atsd_hostname`
where `atsd_ip` is the ip v4 address of the ATSD host.

Configure the JMX username and password in two separate files located in
the `/opt/atsd/atsd/conf/` directory: `jmx.access` and `jmx.password`

Add the following lines to the `/opt/atsd/atsd/conf/server.properties`
file:

```elm
jmx.port=1099
jmx.host=atsd_ip
jmx.access.file=/opt/atsd/atsd/conf/jmx.access
jmx.password.file=/opt/atsd/atsd/conf/jmx.password
jmx.enabled=true
```

Restart ATSD:

```sh
/opt/atsd/bin/atsd-tsd.sh stop
```

```sh
/opt/atsd/bin/atsd-tsd.sh start
```

Now you can access ATSD on `service:jmx:rmi:///jndi/rmi://atsd_ip:1099/atsd`, with the username and password established earlier in the guide.

## Connect to JMX Server

Uncomment JMX settings in the `/opt/atsd/atsd/conf/server.properties`
file:

* set `jmx.host` to local ip
* set `jmx.access.file` and `jmx.password.file`

Now you can access ATSD from a remote JMX client on: `service:jmx:rmi:///jndi/rmi://{ip}:1099/jmxrmi`
