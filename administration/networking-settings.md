# Network Settings

Change networking settings if you’re anticipating a high data insertion rate via UDP protocol with bursts of 100,000
packets per second or more.

## Increase Receiving Buffer

Increase the maximum receiving buffer on the operating system

```sh
 sudo sysctl -w net.core.rmem_max=8388608
```

This setting would allow the operating system and ATSD to buffer up to 8
megabytes of received packets, in the case that the inserting rate is temporarily
higher than the ATSD throughput rate.

The increased buffer would also reduce or even eliminate the number of
UDP datagrams dropped due to buffer overflow.

## Increase UDP buffer in ATSD

To increase the UDP buffer in ATSD, add the following property to `server.properties` file.

```txt
# default value is 8192
udp.receive.buffer.size.kb = 20000
```

## Restart ATSD

```sh
/opt/atsd/bin/atsd-all.sh stop
```

```sh
/opt/atsd/bin/atsd-all.sh start
```