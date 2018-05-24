# Post-Installation Steps

## Configure Firewall

* Allow remote access to the ATSD network services by [adding `iptables` rules](firewall.md).

## Setup Email Client

* See [note](../administration/mail-client.md).

## Verify System Time

* Open the **Settings > System Information** tab in the ATSD web interface and verify the time and  time zone information.
* [Synchronize](../administration/timezone.md#changing-the-time-zone) system time or setup NTP in order to keep the server time accurate.

![Server\_time](./images/server_time.png)

## Increase Network Buffers

> If you're anticipating insertion rate with bursts of 100K+ packets per second,
increase maximum receiving buffer.

* See [note](../administration/networking-settings.md).

## Enable Swap Memory

* See [note](../administration/enabling-swap-space.md).

## Increase Java Memory Allocations

* See [note](../administration/allocating-memory.md).

## Review Log Files

* See [note](../administration/logging.md).

## Relocate ATSD

* [Move ATSD](relocation.md) to a different file system, if the `/opt/atsd` directory doesn't provide sufficient free space.
