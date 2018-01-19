# Verifying Installation

Depending on the available resources, it can take 5-20 minutes for ATSD to initialize.

## User Interface

At the end of the installation process the script displays the ATSD IP address and ports.

![](images/atsd_install_shell.png )

Access the ATSD web interface on the secure port (8443 by default):

```
https://10.102.0.116:8443
```

Open your browser and navigate to port `8443` on the target machine.

## Administrator Account

When accessing the ATSD web interface for the first time, you will need to
setup an administrator account.

## Portals

Click on Portals tab in the ATSD web interface. A pre-defined **ATSD**
portal displays application, operating system, and usage metrics for the database itself
and the machine where it's installed.

![](images/atsd_portal.png "ATSD Host")

> Note *Data Tables* chart  can be empty for a few minutes after start

## Reboot Verification

Verify that the database is able to auto-start in case of system reboot.

On RHEL:

```sh
sudo systemctl stop atsd
sudo systemctl start atsd
```

On other Linux distributions:

```sh
sudo service atsd stop
sudo service atsd start
```

If running ATSD on a shared server with heavy workloads, edit the `/etc/systemd/system/atsd.service` file and replace type 'oneshot' with 'forking'

```yaml
[Service]
#Type=oneshot
Type=forking
User=axibase
ExecStart=/etc/init.d/atsdService start
ExecStop=/etc/init.d/atsdService stop
RemainAfterExit=true
TimeoutSec=600
```
