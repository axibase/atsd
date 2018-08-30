# Hardware and OS Requirements

## CPU and Memory

| Deployment Mode | Single Node | Distributed |
| --- | :--- | :--- |
| RAM | `4+` GB | `16+` GB |
| Processor | `10+` GHz | `10+` GHz |
| Disk Type | Magnetic or SSD | Magnetic or SSD |

> To calculate the available CPU capacity, multiply the number of cores by CPU clock speed, for example `4` x `2.5` GHz = `10` GHz.

## Disk Space

* Application files: `5` GB.
* Data Files: `10` GB **minimum**. 

> The required disk space depends on the amount of collected data, [compression](../administration/compaction/README.md), and [retention](../administration/data_retention.md) settings.

## Processor Architecture

* `x86_64` / `64` bit

## Operating Systems

* Ubuntu `16.04`
* RedHat Enterprise Linux `7.x`
* CentOS `7.x`
* SUSE Linux Enterprise Server `12.x`
* Debian `8.x`/`9.x`
