# Monitoring Metrics using JMX

ATSD includes a built-in JMX server which allows remote JMX clients to retrieve ATSD metrics using the JMX protocol.

## Setup JMX in ATSD

In `/etc/hosts` change `127.0.1.1 atsd_hostname` to `atsd_ip atsd_hostname`
where `atsd_ip` is the ip v4 address of the ATSD host.

Specify the JMX username and password in two separate files located in
the `/opt/atsd/atsd/conf/` directory: `jmx.access` and `jmx.password`.

Add the following lines to the `/opt/atsd/atsd/conf/server.properties` file.

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

Now you can access ATSD on `service:jmx:rmi:///jndi/rmi://atsd_ip:1099/atsd` with credentials set in `jmx.access` and `jmx.password` files.