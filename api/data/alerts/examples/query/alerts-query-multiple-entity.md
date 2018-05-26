# Alerts Query: Entity Array

## Description

Select alerts for multiple entities.

## Request

### URI

```elm
POST /api/v1/alerts/query
```

### Payload

```json
[
  {
    "entities": [
      "nurswgvml007",
      "nurswgvml006",
      "325416e3d2d6"
    ],
    "startDate": "2016-06-28T04:00:00Z",
    "endDate": "now"
  }
]
```

## Response

### Payload

```json
[
  {
    "entity": "325416e3d2d6",
    "tags": {},
    "repeatCount": 9,
    "textValue": "averagemessagesize=1024;brokerid=ID:325416e3d2d6-51804-1466522137975-0:1;brokername=localhost;brokerversion=5.14.0-SNAPSHOT;currentconnectionscount=1;datadirectory=/home/axibase/activemq_last/apache-activemq-5.14.0-SNAPSHOT/data;jobschedulerstorelimit=0;jobschedulerstorepercentusage=0;maxmessagesize=1024;memorylimit=668309914;memorypercentusage=0;minmessagesize=1024;persistent=true;slave=false;statisticsenabled=true;storelimit=107374182400;storepercentusage=0;templimit=53687091200;temppercentusage=0;totalconnectionscount=3;totalconsumercount=1;totaldequeuecount=0;totalenqueuecount=407;totalmessagecount=59;totalproducercount=2;transportconnectors.amqp=amqp://325416e3d2d6:5672?maximumConnections=1000&wireFormat.maxFrameSize=104857600;transportconnectors.mqtt=mqtt://325416e3d2d6:1883?maximumConnections=1000&wireFormat.maxFrameSize=104857600;transportconnectors.openwire=tcp://325416e3d2d6:61616?maximumConnections=1000&wireFormat.maxFrameSize=104857600;transportconnectors.stomp=stomp://325416e3d2d6:61613?maximumConnections=1000&wireFormat.maxFrameSize=104857600;transportconnectors.ws=ws://325416e3d2d6:61614?maximumConnections=1000&wireFormat.maxFrameSize=104857600;uptime=7 days 16 hours;uptimemillis=665407705;vmurl=vm://localhost",
    "metric": "property",
    "severity": "WARNING",
    "rule": "activemq_broker_configuration_change",
    "openDate": "2016-06-29T07:20:21.647Z",
    "lastEventDate": "2016-06-29T08:05:45.559Z",
    "acknowledged": false,
    "openValue": 0,
    "value": 0,
    "message": "",
    "id": 13
  },
  {
    "entity": "nurswgvml006",
    "tags": {
      "file_system": "/dev/sdc1",
      "mount_point": "/media/datadrive"
    },
    "repeatCount": 205,
    "textValue": "65.857",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T07:19:02.979Z",
    "lastEventDate": "2016-06-29T08:10:22.825Z",
    "acknowledged": false,
    "openValue": 65.8734,
    "value": 65.8573,
    "id": 4
  },
  {
    "entity": "nurswgvml006",
    "tags": {},
    "repeatCount": 6,
    "textValue": "16.3",
    "metric": "nmon.cpu_total.busy%",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "openDate": "2016-06-29T08:04:24.733Z",
    "lastEventDate": "2016-06-29T08:10:24.799Z",
    "acknowledged": false,
    "openValue": 15.4,
    "value": 16.3,
    "id": 55
  },
  {
    "entity": "nurswgvml007",
    "tags": {
      "file_system": "/dev/mapper/vg_nurswgvml007-lv_root",
      "mount_point": "/"
    },
    "repeatCount": 206,
    "textValue": "65.783",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T07:19:01.131Z",
    "lastEventDate": "2016-06-29T08:10:35.423Z",
    "acknowledged": false,
    "openValue": 65.8802,
    "value": 65.7828,
    "id": 3
  },
  {
    "entity": "nurswgvml007",
    "tags": {},
    "repeatCount": 5,
    "textValue": "52.6",
    "metric": "nmon.cpu_total.busy%",
    "severity": "WARNING",
    "rule": "nmon_cpu_alert",
    "openDate": "2016-06-29T08:05:15.112Z",
    "lastEventDate": "2016-06-29T08:10:15.190Z",
    "acknowledged": false,
    "openValue": 12.4,
    "value": 52.6,
    "id": 56
  }
]
```