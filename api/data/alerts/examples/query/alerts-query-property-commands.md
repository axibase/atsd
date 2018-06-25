# Alerts for Property Commands

## Description

Select alerts generated for `property` commands.

## Request

### URI

```elm
POST /api/v1/alerts/query
```

### Payload

```json
[
  {
    "metrics": [
      "property"
    ],
    "entity": "*",
    "startDate": "2016-06-25T04:00:00Z",
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
    "repeatCount": 4,
    "textValue": "averagemessagesize=1024;brokerid=ID:325416e3d2d6-51804-1466522137975-0:1;brokername=localhost;brokerversion=5.14.0-SNAPSHOT;currentconnectionscount=1;datadirectory=/home/axibase/activemq_last/apache-activemq-5.14.0-SNAPSHOT/data;jobschedulerstorelimit=0;jobschedulerstorepercentusage=0;maxmessagesize=1024;memorylimit=668309914;memorypercentusage=0;minmessagesize=1024;persistent=true;slave=false;statisticsenabled=true;storelimit=107374182400;storepercentusage=0;templimit=53687091200;temppercentusage=0;totalconnectionscount=3;totalconsumercount=1;totaldequeuecount=0;totalenqueuecount=407;totalmessagecount=59;totalproducercount=2;transportconnectors.amqp=amqp://325416e3d2d6:5672?maximumConnections=1000&wireFormat.maxFrameSize=104857600;transportconnectors.mqtt=mqtt://325416e3d2d6:1883?maximumConnections=1000&wireFormat.maxFrameSize=104857600;transportconnectors.openwire=tcp://325416e3d2d6:61616?maximumConnections=1000&wireFormat.maxFrameSize=104857600;transportconnectors.stomp=stomp://325416e3d2d6:61613?maximumConnections=1000&wireFormat.maxFrameSize=104857600;transportconnectors.ws=ws://325416e3d2d6:61614?maximumConnections=1000&wireFormat.maxFrameSize=104857600;uptime=7 days 16 hours;uptimemillis=663892915;vmurl=vm://localhost",
    "metric": "property",
    "severity": "WARNING",
    "rule": "activemq_broker_configuration_change",
    "openDate": "2016-06-29T07:20:21.647Z",
    "lastEventDate": "2016-06-29T07:40:31.205Z",
    "acknowledged": false,
    "openValue": 0,
    "value": 0,
    "message": "",
    "id": 13
  }
]
```