# Uninstalling

Execute the commands below to uninstall ATSD or to re-install it.

The commands will **not** remove the data stored in ATSD, it will remain in the `/opt/atsd` directory.

## Debian Package

To remove ATSD, components and configuration files use:

```sh
sudo dpkg --purge atsd
```

To remove ATSD and components but retain the configuration files use:

```sh
sudo dpkg -r atsd
```

In both cases, follow on screen instructions to uninstall ATSD.

## RPM Package

To remove ATSD and components use:

```sh
sudo rpm -e atsd
```
