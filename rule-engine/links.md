# Link Placeholders

## Overview

Link placeholders allow to retrieve links based on `server.url` property at **Settings > Server Properties > Other** page.

To resolve links in messengers following settings must be checked at Web Notification editor:

* Slack
 
   **Parse Mode** must be set to *Default*.
   
* HipChat Data Center 
 
   **Message Format** must be set to *html*.
   
## Reference

* [ruleLink](#rulelink)
* [chartLink](#chartlink)
* [csvExportLink](#csvexportlink)
* [htmlExportLink](#htmlexportlink)
* [serverLink](#serverlink)
* [entityLink](#entitylink)

### `ruleLink`

```bash
${ruleLink}
```
Retrieves link to rule. 

Example: 
   
```elm
https://atsd_host:8443/rule/edit.xhtml?name=docker-container-lifecycle-restart
```

### `chartLink`

```bash
${chartLink}
```
Retrieves link to default chart. 

Example:

```elm
https://atsd_host:8443/portals/series?metric=docker&entity=nurswgvml007&add%20params%3D%7B%22markers%22%3A%22false%22%2C%22timespan%22%3A%221%20HOUR%22%7D
```

### `csvExportLink`

```bash
${csvExportLink}
```
Retrieves link to csv file for the current entity that is initialized in the rule window.

Example:

```elm
https://atsd_host:8443/export?settings=%7B%22m%22%3A%22docker%22%2C%22e%22%3A%22nurswgvml007%22%2C%22si%22%3A%221-DAY%22%2C%22t%22%3A%22HISTORY%22%2C%22v%22%3Afalse%7D
```

### `htmlExportLink`

```bash
${htmlExportLink}
```
Retrieves link to **Data > Export** page for the current entity that is initialized in the rule window.

Example:

```elm
https://atsd_host:8443/export?settings=%7B%22m%22%3A%22docker%22%2C%22e%22%3A%22nurswgvml007%22%2C%22si%22%3A%221-HOUR%22%2C%22t%22%3A%22HISTORY%22%7D
```

### `serverLink`

```bash
${serverLink}
```
Retrieves link to the server specified in `server.url` property at **Settings > Server Properties > Other** page.

Example:

```elm
https://atsd_host:8443/
```

### `entityLink`

```bash
${entityLink}
```
Retrieves link to entity that is initialized in the rule window.

Example:

```elm
https://atsd_host:8443/entities/nurswgvml007
```
