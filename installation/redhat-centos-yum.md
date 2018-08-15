# Installation: YUM

## Supported Versions

* RedHat Enterprise Linux `7.x`
* CentOS `7.x`
* Amazon Linux `2014.09.x+`

## Requirements

* Minimum RAM: `2` GB
* See [Requirement Specifications](./requirements.md) for additional information.

## Configuration

The database is installed in `/opt/atsd` directory under `axibase` user.

To customize the installation directory, use [`rpm`](redhat-centos-rpm.md) option.

## Installation Steps

Add **`axibase.com/public/repository/rpm/`** repository:

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

Install ATSD:

```sh
sudo yum install -y atsd
```

It can take up to five minutes to initialize the database.

## Check Installation

```sh
tail -f /opt/atsd/atsd/logs/start.log
```

Watch for **ATSD start completed** message at the end of the `start.log`.

Web interface is now accessible on port `8443` (HTTPS).

## Troubleshooting

* Review [Troubleshooting Guide](troubleshooting.md).

## Validation

* [Verify database installation](verifying-installation.md).

## Post-installation Steps

* [Basic configuration](post-installation.md).
* [Getting Started guide](../tutorials/getting-started.md).
