# Deploy nmon

To install `nmon` and the Axibase sender script on multiple Linux machines use the `nmon_deploy.sh` script to automate the below tasks:

* Connect to the remote machine over ssh
* Copy the `nmon` binary file
* Copy the ATSD sender script
* Add a `cron` task to restart the `nmon` data collection on a schedule

Download `nmon_deploy.sh` and sender script from the `nmon` repository: [https://github.com/axibase/nmon](https://github.com/axibase/nmon)

`nmon_deploy.sh` accepts the following arguments:

| Argument | Description |
| --- | --- |
|  `-c`  |  Set path to the `deploy.properties` file, that contains all the configurations required by the `nmon_deploy.sh` script.  |
|  `-n`  |  Does not modify `cron`. Only updates `nmon` binary file and ATSD sender script.<br>Useful to update `nmon` or sender script to a new version.  |
|  `-d`  |  Comments out all `nmon` `cron` tasks. Stops `nmon` data collection and delivery to ATSD  |
|  `-i`  |  While `nmon` does not have any dependencies, the ATSD sender script has the following dependencies: `crontab`, telnet.<br>With `-i` argument the script only checks and installs dependencies.<br>Requires `sudo` privileges defined in the `deploy.properties` file.<br>After installing the dependencies, run the script again without the `-i` argument to install the `nmon` and sender script.  |

The `deploy.properties` file contains the target machine parameters, user details, and paths to `nmon` and `crontab` settings:

Use `#` to uncomment optional parameters.

The following files must be located in the same directory as the `nmon_deploy.sh` script (path to files is set in the `deploy.properties` file):

* `nmon` binary file
* Sender script
* Target machine user ssh key
* `atsdreadonly` ssh key

| Setting | Description |
| --- | --- |
|  `nmon.s`  |  Pause between `nmon` snapshots.  |
|  `nmon.c`  |  `nmon` snapshot count.  |
|  `nmon.cron.hour`  |  `cron` task start hour.  |
|  `nmon.cron.minute`  |  `cron` task start minute.  |
|  `atsd.protocol`  |  Data transfer protocol.<br>Possible values: telnet, ssh.  |
|  `atsd.port`  |  ATSD TCP port.  |
|  `atsd.key`  |  Path to ssh key for readonly account.<br>`id_rsa_atsdreadonly` by default.<br>Optional parameter.  |
|  `atsd.user`  |  Readonly user account.<br>`atsdreadonly` by default.<br>Optional parameter.  |
|  `atsd.hostname`  |  ATSD server.  |
|  `deploy.user`  |  User of target machines.  |
|  `deploy.key`  |  Path to the ssh key to access target machines by the user set in `deploy.user`.  |
|  `deploy.password`  |  Password of target machine user set in the `deploy.user` setting.<br>Password takes priority over ssh key.  |
|  `deploy.sudo.user`  |  `sudo` user on target machines.<br>Optional parameter.  |
|  `deploy.sudo.key`  |  Path to `sudo` user ssh key to access target machines.<br>Optional parameter.  |
|  `deploy.sudo.password`  |  Password of target machine `sudo` user set in the `deploy.sudo.user` setting.<br>Password takes priority over ssh key.<br>Optional Parameter.  |
|  `deploy.nmon-binary`  |  Path to `nmon` binary file to be installed on target machines.  |
|  `deploy.directory`  |  Directory used on target machines to install `nmon` and the sender script.<br>The user must have write access to this directory.  |
|  `deploy.target`  |  Target server hostname or ip address and ssh connection port separated by `:`<br>Can be set to multiple servers, one server per line.  |

Example `deploy.properties` file:

```elm
nmon.s = 60
nmon.c = 1440
nmon.cron.hour = 12
nmon.cron.minute = 19

atsd.protocol = telnet
atsd.port = 8081
#atsd.key=./id_rsa_atsdreadonly
#atsd.user=atsdreadonly
atsd.hostname = atsdserver.com

deploy.user = nmonuser
deploy.key = ./id_dsa_nmonuser
deploy.password=secret-pwd
#deploy.sudo.user = root
#deploy.sudo.key = ./id_dsa_root
#deploy.sudo.password=secret-root-pwd
deploy.nmon-binary = nmon_x86_64_sles11
deploy.directory = /home/nmonuser/nmon
deploy.target = nurswgvml006:22
deploy.target = nurswgvml007:22
deploy.target = nurswgvml008:22
deploy.target = nurswgvml009:22
```

Once the `deploy.properties` file is set up and paths to the required files are set, deploy `nmon` and the sender script to remote target machines:

```sh
./nmon_deploy.sh
```

The script checks each machine for dependencies and shows installation progress/results in the console.
