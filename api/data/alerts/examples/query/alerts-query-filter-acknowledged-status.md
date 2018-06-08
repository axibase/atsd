# Filter Alerts for Acknowledged Status

## Description

Select acknowledged alerts for all entities.

## Request

### URI

```elm
POST /api/v1/alerts/query
```

### Payload

```json
[
  {
    "entities": [],
    "startDate": "2016-06-28T04:00:00Z",
    "endDate": "now",
    "acknowledged": true
  }
]
```

## Response

### Payload

```json
[
  {
    "tags": {},
    "entity": "325416e3d2d6",
    "repeatCount": 29,
    "textValue": "averagemessagesize=1024;brokerid=ID:325416e3d2d6-51804-1466522137975-0:1;brokername=localhost;brokerversion=5.14.0-SNAPSHOT;currentconnectionscount=1;datadirectory=/home/axibase/activemq_last/apache-activemq-5.14.0-SNAPSHOT/data;jobschedulerstorelimit=0;jobschedulerstorepercentusage=0;maxmessagesize=1024;memorylimit=668309914;memorypercentusage=0;minmessagesize=1024;persistent=true;slave=false;statisticsenabled=true;storelimit=107374182400;storepercentusage=0;templimit=53687091200;temppercentusage=0;totalconnectionscount=3;totalconsumercount=1;totaldequeuecount=0;totalenqueuecount=407;totalmessagecount=59;totalproducercount=2;transportconnectors.amqp=amqp://325416e3d2d6:5672?maximumConnections=1000&wireFormat.maxFrameSize=104857600;transportconnectors.mqtt=mqtt://325416e3d2d6:1883?maximumConnections=1000&wireFormat.maxFrameSize=104857600;transportconnectors.openwire=tcp://325416e3d2d6:61616?maximumConnections=1000&wireFormat.maxFrameSize=104857600;transportconnectors.stomp=stomp://325416e3d2d6:61613?maximumConnections=1000&wireFormat.maxFrameSize=104857600;transportconnectors.ws=ws://325416e3d2d6:61614?maximumConnections=1000&wireFormat.maxFrameSize=104857600;uptime=7 days 20 hours;uptimemillis=679771698;vmurl=vm://localhost",
    "metric": "property",
    "severity": "WARNING",
    "rule": "activemq_broker_configuration_change",
    "openDate": "2016-06-29T09:40:22.660Z",
    "lastEventDate": "2016-06-29T12:05:09.464Z",
    "acknowledged": true,
    "openValue": 0,
    "value": 0,
    "message": "",
    "id": 20
  },
  {
    "tags": {
      "file_system": "/dev/sdb1",
      "mount_point": "/opt"
    },
    "entity": "nurswgvml009",
    "repeatCount": 604,
    "textValue": "69.221",
    "metric": "disk_used_percent",
    "severity": "CRITICAL",
    "rule": "disk_low_alert",
    "openDate": "2016-06-29T09:37:31.223Z",
    "lastEventDate": "2016-06-29T12:07:41.254Z",
    "acknowledged": true,
    "openValue": 69.2101,
    "value": 69.2208,
    "id": 17
  }
]
```