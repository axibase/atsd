# Firewall Configuration

To allow external clients to connect to ATSD services, grant access to specific ports on which the database is listening or disable the firewall on the database server.

## Database Ports

Port | Network<br> Protocol | Application/<br>Data Protocol | Service
---|---|---|---
1099 | TCP | JMX | JMX server
8081 | TCP | line | Network command processor
8082 | UDP | line | Network command processor
8084 | TCP | pickle | Graphite command processor
8088 | TCP | HTTP | Web interface, REST API
8443 | TCP | HTTPS | Web interface, REST API

## Disable Firewall

### Ubuntu/Debian

```bash
ufw disable
```

### CentOS / RHEL

```bash
systemctl disable firewalld
```

## Allow Port Access

```sh
iptables -I INPUT -p tcp --dport 8081 -j ACCEPT
```

```sh
iptables -I INPUT -p udp --dport 8082 -j ACCEPT
```

```sh
iptables -I INPUT -p tcp --dport 8088 -j ACCEPT
```

```sh
iptables -I INPUT -p tcp --dport 8443 -j ACCEPT
```

## Persisting Firewall Rules

### Ubuntu/Debian

Install the `iptables-persistent` package

```sh
apt-get install iptables-persistent
```

During the installation you are asked to save existing rules.

Rules are saved to `/etc/iptables/rules.v4` and `/etc/iptables/rules.v6` for IPv4 and IPv6, respectively.

The saved rules can be updated:

* By running `dpkg-reconfigure iptables-persistent`, or

* By executing the `iptables-save` commands:

```sh
iptables-save > /etc/iptables/rules.v4
```

```sh
ip6tables-save > /etc/iptables/rules.v6
```

### CentOS / RHEL

```sh
sed -i "s/IPTABLES_SAVE_ON_STOP=\"no\"/IPTABLES_SAVE_ON_STOP=\"yes\"/g" \
/etc/sysconfig/iptables-config
```

```sh
sed -i "s/IPTABLES_SAVE_ON_RESTART=\"no\"/IPTABLES_SAVE_ON_RESTART=\"yes\"/g" \
 /etc/sysconfig/iptables-config
```

```sh
/etc/init.d/iptables save
```

### SUSE

```sh
echo "FW_SERVICES_EXT_TCP=\"8081 8082 8088 8443\"" \
 >> /etc/sysconfig/SuSEfirewall2
```

```sh
/sbin/SuSEfirewall2
```
