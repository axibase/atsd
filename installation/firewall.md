# Firewall Configuration

## Allow Access

Allow access to particular ports on the target ATSD server.

* Login into the ATSD server.
* Add 'allow' rules for specific ATSD ports.

```sh
iptables -I INPUT -p tcp --dport 8081 -j ACCEPT
iptables -I INPUT -p udp --dport 8082 -j ACCEPT
iptables -I INPUT -p tcp --dport 8088 -j ACCEPT
iptables -I INPUT -p tcp --dport 8443 -j ACCEPT
```

## Persisting Firewall Rules

### Ubuntu/Debian

#### Install the iptables-persistent Package

```
apt-get install iptables-persistent
```

During the install process you will be asked to save existing rules.

Rules will be saved to `/etc/iptables/rules.v4` and `/etc/iptables/rules.v6` for IPv4 and IPv6, respectively.

The saved rules can be updated:

* By running `dpkg-reconfigure iptables-persistent`, or

* By executing the `iptables-save` commands:

```
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6
```

### RHEL / CentOS

```sh
sed -i "s/IPTABLES_SAVE_ON_STOP=\"no\"/IPTABLES_SAVE_ON_STOP=\"yes\"/g" /etc/sysconfig/iptables-config
sed -i "s/IPTABLES_SAVE_ON_RESTART=\"no\"/IPTABLES_SAVE_ON_RESTART=\"yes\"/g" /etc/sysconfig/iptables-config
/etc/init.d/iptables save
```

### SUSE

```
echo "FW_SERVICES_EXT_TCP=\"8081 8082 8088 8443\"" >> /etc/sysconfig/SuSEfirewall2
/sbin/SuSEfirewall2
```
