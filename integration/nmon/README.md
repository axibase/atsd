# nmon

## Overview

`nmon` is a system performance monitoring tool designed by Nigel Griffiths at IBM, originally for AIX, and later ported by the same author to Linux.

`nmon` remains the preferred data collection daemon on AIX and is gaining traction with Linux administrators. Some of the advantages of `nmon` include:

* Single binary, easy to install.
* Console and batch mode.
* Scheduled with `cron`.
* Collects server configuration in addition to statistics.
* Optional process-level statistics with customizable thresholds.
* Compact data format.

On AIX, `nmon` is pre-installed on AIX 5.3 and 6.1 and newer versions by default. On older AIX versions 4.1.5, 4.2, 4.3, 5.1, and 5.2, `nmon` can be installed manually.

On Linux, `nmon` is [released under GPL license](https://github.com/axibase/nmon). It can be downloaded as an [executable binary](https://github.com/axibase/nmon/releases) or compiled from source. Supported distributions include Ubuntu, Debian, RHEL, CentOS, Fedora, SLES, and OpenSUSE.

Axibase Time Series Database (ATSD) supports `nmon` file natively and can consolidate statistics from AIX and Linux systems in a single repository for long-term retention and ad-hoc analysis.

## Integration Options

The database implements several methods of loading `nmon` files.

* [Manual upload](ad-hoc.md) provides a convenient web interface to upload `nmon` data files and instantly view statistics stored in the files.
* [Scheduled upload](https://github.com/axibase/nmon#upload-hourly-files-to-atsd-with-wget) provides API to push nmon files from remote systems using `wget`, `nc`, or `bash` [`tcp/udp` pseudo-device](http://tldp.org/LDP/abs/html/devref1.html#DEVTCP) files.
* Streaming transmission of `nmon` snapshots as they are written into `nmon` output file using [sender script](sender-script.md). This method results in no latency, however it requires more effort to implement.

`nmon` source code repository:
[https://github.com/axibase/nmon](https://github.com/axibase/nmon)

## Resources

* [Format](format.md)
* [Headers](headers.md)
* [Parser](parser.md)
* [File Upload](file-upload.md)
* [File Streaming](file-streaming.md)
* [Script deployment](deploy.md)
* [SSH Tunnel Setup](ssh-tunneling.md)

## Portals

[AIX `nmon` Portal](https://axibase.com/chartlab/b69e4fcd/3/)

![](./resources/nmon-aix-portal-1500.png "nmon aix portal 1500")

[Linux `nmon` Portal](https://axibase.com/chartlab/ac003f06)

![](./resources/linux_nmon_portal.png "linux_nmon_portal")
