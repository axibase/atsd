# Hardware and OS Requirements

## CPU and Memory

| Deployment Mode | Single Node | Distributed |
| --- | :--- | :--- |
| RAM | `4+` GB | `16+` GB |
| Processor | `10+` GHz | `10+` GHz |
| Disk Type | Magnetic or SSD | SSD |

> Processor capacity is calculated as the number of CPU cores multiplied by clock speed, for example `4` x `2.5` GHz = `10` GHz.

## Disk Space

* Application files: `5` GB.
* Data Files: `10` GB **minimum**. This total depends on the amount of collected data, [compression](compaction/README.md), [retention](data_retention.md), and replication settings.

## Processor Architecture

* `x86_64` / `64` bit

## Operating Systems

* Ubuntu `16.04`
* RedHat Enterprise Linux `7.x`
* CentOS `7.x`
* SUSE Linux Enterprise Server `12.x`
* Debian `8.x`/`9.x`
