# Headers

[Header Extract](#header-extract)

[System Commands Extract](#system-command-extract)

[Configuration Properties](#properties)

The header of the nmon file contains all the system configuration details and system commands.

Below are the header and system commands extracts from an nmon file.

#### Header Extract

```txt
AAA,progname,topas_nmon
AAA,command,/usr/bin/topas_nmon -ftdTWALM -s 1200 -c 72 -o /opt/NMON/day/ -youtput_dir=/opt/NMON/day/ -ystart_time=20:00:01,Oct14,2014
AAA,version,TOPAS-NMON
AAA,build,AIX
AAA,disks_per_line,150
AAA,host,itm-aix
AAA,user,root
AAA,AIX,6.1.7.16
AAA,TL,07
AAA,runname,
AAA,time,20:00:02
AAA,date,11-AUG-2014
AAA,interval,1200
AAA,snapshots,72
AAA,hardware,Architecture PowerPC Implementation POWER7_in_P7_mode 64 bit
AAA,cpus,512,256
AAA,kernel, HW-type=CHRP=Common H/W Reference Platform Bus=PCI LPAR=Dynamic Multi-Processor 64 bit
AAA,SerialNumber,223344B
AAA,LPARNumberName,6,itm-aix
AAA,MachineType,IBM,9119-FHB
AAA,NodeName,itm-aix
AAA,timestampsize,0
```

#### System Command Extract

```txt
BBBB,0000,name,size(GB),disc attach type
BBBB,0001,hdisk10,343.42,Hitachi-HDS
BBBC,000,hdisk10:
BBBC,001,LV NAME LPs PPs DISTRIBUTION MOUNT POINT
BBBC,002,PDIoriglogALv 18 18 00..18..00..00..00 /oracle/PDI/origlogA
BBBC,003,PDIoriglogBLv 18 18 00..18..00..00..00 /oracle/PDI/origlogB
BBBC,004,PDImirrlogALv 18 18 00..18..00..00..00 /oracle/PDI/mirrlogA
BBBC,005,PDImirrlogBLv 18 18 00..18..00..00..00 /oracle/PDI/mirrlogB
BBBC,006,PDIsapdata3Lv 46 46 00..00..00..00..46 /oracle/PDI/sapdata3
BBBC,007,PDIsapdata2Lv 111 111 00..00..00..00..111 /oracle/PDI/sapdata2
BBBC,008,PDIsapmntLv 80 80 00..80..00..00..00 /sapmnt/PDI
BBBC,009,PDIusrsap 136 136 00..96..00..00..40 /usr/sap/PDI
BBBC,010,PDIusrsaptransL 80 80 00..80..00..00..00 /usr/sap/trans/PDI
BBBC,011,PDIoracleLv 112 112 00..56..00..00..56 /oracle/PDI
BBBC,012,PDIorabinLv 64 64 00..64..00..00..00 /oracle/PDI/102_64
BBBC,013,PDIoraarchLv 1982 1982 537..89..536..536..284 /oracle/PDI/oraarch
…..
BBBC,210,LV NAME LPs PPs DISTRIBUTION MOUNT POINT
BBBC,211,PDIsapdata5Lv 670 670 256..95..210..00..109 /oracle/PDI/sapdata5
BBBC,212,PDIsapdata3Lv 1329 1329 144..305..189..400..291 /oracle/PDI/sapdata3
BBBB,0047,hdisk47,255.87,Hitachi-HDS
BBBC,213,hdisk47:
BBBC,214,LV NAME LPs PPs DISTRIBUTION MOUNT POINT
BBBC,215,PDIsapdata2Lv 776 776 00..400..376..00..00 /oracle/PDI/sapdata2
BBBB,0048,hdisk48,255.87,Hitachi-HDS
BBBC,216,hdisk48:
BBBC,217,LV NAME LPs PPs DISTRIBUTION MOUNT POINT
BBBC,218,PDIsapdata5Lv 1999 1999 400..400..399..400..400 /oracle/PDI/sapdata5
```
<a name="properties"></a>
#### List of nmon Configuration Properties with Examples

```txt
"aix": "7.1.3.16",
"build": "AIX",
"capped": "0",
"command": "/usr/bin...,Nov11,2014 ",
"cpu in sys": "16",
"cpus": "16,8",
"date": "11-NOV-2014",
"disks_per_line": "150",
"entitled capacity": "0.5",
"hardware": "Architecture Po...64 bit",
"host": "itm-aix",
"ibm": "8286-42A",
"interval": "60",
"kernel": "HW-type=CHRP=Common...64 bit",
"logical cpu": "8",
"lparname": "ITM-AIX",
"lparno": "16",
"lparnumbername": "16,ITM-AIX",
"machinetype": "IBM,8286-42A",
"max capacity": "1.0",
"max logical": "16",
"max memory mb": "6144",
"max virtual": "4",
"min capacity": "0.1",
"min logical": "1",
"min memory mb": "1024",
"min virtual": "1",
"nodename": "itm-aix",
"nov11": "2014",
"online memory": "3072",
"pool cpu": "16",
"pool id": "0",
"progname": "topas_nmon",
"runname": "itm-aix",
"serialnumber": "102CA4V",
"smt threads": "4",
"snapshots": "10000",
"time": "04:26:57",
"timestampsize": "0",
"tl": "03",
"user": "root"
"version": "TOPAS-NMON",
"virtual cpu": "2",
"weight": "128",
```

