nmon File Streaming over Telnet
===============================

Execute the steps in this guide in order to start streaming nmon data into the Axibase Time Series Database over Telnet.

If you would like to stream nmon data using an SSH Tunnel, use our [nmon File Streaming using an SSH Tunnel guide](ssh-tunneling.md "nmon File Streaming using an SSH Tunnel").

If you would like to monitor multiple machines using nmon, use our [Installing nmon on Multiple Machines guide](deploy.md).

The main purpose of the nmon tool is to monitor performance information for CPU, memory, network, disk, virtual memory, top process, and other parts of the server or virtual machine.

This tool provides valuable information with a single binary. Currently, nmon is primarily supported on AIX and Linux systems, with limited support provided for Solaris systems. It can monitor IBM Power systems, x86, and amd64 processors, and even ARM based systems like Raspberry Pi.

nmon can be run either in interactive or recording modes. ATSD uses the recording mode to stream data as it is written into the nmon file.

All AIX systems come with nmon pre-installed, but Linux systems need the nmon tool installed.

## nmon Resources

- [IBM](https://www.ibm.com/developerworks/aix/library/au-analyze_aix/)
- [Nmon SourceForge](http://nmon.sourceforge.net/pmwiki.php?n=Main.HomePage)

### Install nmon

Create nmon directories:

```sh
sudo mkdir -p /opt/nmon/nmon_logs                 
sudo chown -R `whoami` /opt/nmon                  
cd /opt/nmon                                      
```

#### Option 1: install nmon from repositories – Ubuntu/Debian

```sh
sudo apt-get install nmon                         
```

#### Option 2: install nmon from Axibase GitHub

 - Download nmon from Axibase github:
    - See releases and branches available for download: [https://github.com/axibase/nmon/releases](https://github.com/axibase/nmon/releases "Available nmon releases") and [https://github.com/axibase/nmon/branches](https://github.com/axibase/nmon/branches "Available nmon branches")

```sh
    git clone git://github.com/axibase/nmon.git -b 15e
```

- Move the downloaded nmon files to the `/opt/nmon` directory:

```sh
    mv nmon/* /opt/nmon                               
    rm -r nmon                                        
```

```sh
    wget -O nmon https://github.com/axibase/nmon/releases/download/15e/nmon_
    x86_ubuntu134                                     
```

- Set permissions for nmon:

```sh
    sudo chmod 774 nmon                               
```

- Make nmon executable:

```sh
    chmod +x nmon                                     
```

#### Option 3: install nmon from binaries

- Download the appropriate nmon binary: [http://nmon.sourceforge.net/pmwiki.php?n=Site.Download](http://nmon.sourceforge.net/pmwiki.php?n=Site.Download "nmon Binaries")

```sh
    wget http://sourceforge.net/projects/nmon/files/nmon15d_power.tar.gz     
```

- Extract nmon

```sh
    tar xzf nmon15d_power.tar.gz                      
```

- After extracting the downloaded nmon archive, choose the appropriate binary file for your system. For example: `nmon\_linux\_x86\_64`
- Change the name of the correct binary to nmon

```sh
    mv nmon_linux_x86_64 nmon                         
```

- Set permissions for nmon

```sh
    sudo chmod 774 nmon                               
```

#### Download Sender Script from Axibase GitHub

```sh
wget https://github.com/axibase/nmon/blob/master/nmon_sender_telnet.sh   
```

#### Test nmon File Streaming

nmon will run and the collected data will be streamed into ATSD. New entity and metrics will be available in the Entities and Metrics tabs. Metrics will have the `nmon.` prefix.

#### Test nmon with Sender Script – Installed from Repositories

```sh
/usr/bin/nmon -F `hostname`.nmon -s 2 -c 30       
./nmon_sender_telnet.sh {atsdhostname} -p 8081 -s 2 -c 30 -f `hostname`.
nmon
```

#### Test nmon with Sender Script – Installed from Axibase GitHub or Binaries

```sh
./nmon -F `hostname`.nmon -s 2 -c 30              
./nmon_sender_telnet.sh {atsdhostname} -p 8081 -s 2 -c 30 -f `hostname`.
nmon
```

#### Setup nmon File Streaming

Setup crontab so that the nmon daemon collects the data continuously.

ATSD will receive the stream of data as it is written into the nmon file.

#### Setup nmon File Streaming with Sender Script – Installed from Repositories

```sh
0 0 * * * /usr/bin/nmon -f -s 60 -c 1440 -T -m /opt/nmon/nmon_logs/      
0 0 * * * /opt/nmon/nmon_sender_telnet.sh {atsdhostname} -p 8081 -s 60 -
c 1440 -m /opt/nmon/nmon_logs/ >> /opt/nmon/full.log 2>&1                
```

**Setup nmon File Streaming with Sender Script – Installed from Axibase
GitHub or Binaries:**

```sh
0 0 * * * /opt/nmon/nmon -f -s 60 -c 1440 -T -m /opt/nmon/nmon_logs/     
0 0 * * * /opt/nmon/nmon_sender_telnet.sh {atsdhostname} -p 8081 -s 60 -
c 1440 -m /opt/nmon/nmon_logs/ >> /opt/nmon/full.log 2>&1         `
```

Entities collecting nmon data are automatically added to the `nmon-linux` and `nmon-aix` entity groups.

Entities collecting nmon data are also automatically assigned predefined nmon portals.

Predefined AIX and Linux nmon portals cover a variety of key metrics and have been designed to provide useful insight into the performance of the target machine.

Custom portals can be created using [HTML5 Widgets](https://axibase.com/products/axibase-time-series-database/visualization/ "Visualization") to visualize any combination of collected [nmon metrics](https://axibase.com/products/axibase-time-series-database/writing-data/nmon/format/ "Format").

[![](resources/widget-bar-2.png "widget bar 2")](https://axibase.com/products/axibase-time-series-database/visualization/widgets/)

#### Predefined nmon AIX Portal

![](resources/portal-4.png "portal 4")

##### Predefined nmon Linux Portal

![](resources/nmon-linux-portal.png "nmon linux portal")

Once nmon data is streamed into ATSD and predefined portals are working, you can use the [Rule Engine](../../rule-engine "Rule Engine") and
[Forecasting](https://axibase.com/products/axibase-time-series-database/forecasts/ "Forecasts") tools for analyzing and planning capacity. Custom portals can be created using [HTML5 widgets](https://axibase.com/products/axibase-time-series-database/visualization/ "Visualization").
