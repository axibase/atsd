# RedHat/CentOS: YUM

## Supported Versions

- RedHat Enterprise Linux 7.x
- CentOS 7.x
- Amazon Linux 2014.09.x+

## Requirements

- Minimum RAM: 2 GB
- See [Requirements](../administration/requirements.md) for additional information.

## Configuration

The database will be installed in `/opt/atsd` directory under `axibase` user.

To customize the installation directory, use [`rpm`](redhat-centos-rpm.md) option instead.

## Installation Steps

Add **axibase.com/public/repository/rpm/** repository:

```sh
sudo sh -c "cat << EOF > /etc/yum.repos.d/axibase.repo
[axibase]
name=Axibase Repository
baseurl=https://axibase.com/public/repository/rpm
enabled=1
gpgcheck=0
protect=1
EOF"
```

Update repositories:

```sh
sudo yum clean expire-cache
```

Follow the prompts to install ATSD:

```sh
sudo yum install -y atsd
```

It may take up to 5 minutes to initialize the database.

## Check Installation

```sh
tail -f /opt/atsd/atsd/logs/start.log
```

You should see an **ATSD start completed** message at the end of the `start.log`.

Web interface is accessible on port 8088 (http) and 8443 (https).

> You may need to add [firewall](firewall.md) rules if the above ports are not reachable.

## Troubleshooting

* Review [troubleshooting guide](troubleshooting.md).

## Validation

* [Verify database installation](verifying-installation.md).

## Post-installation Steps

* [Basic configuration](post-installation.md).
* [Getting Started guide](../tutorials/getting-started.md).
