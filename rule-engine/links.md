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
   
```bash
https://axibase.com:8443/rule/edit.xhtml?name=docker-container-lifecycle-restart
```

### `chartLink`

```bash
${chartLink}
```
Retrieves link to default chart. 

Example:

```bash
https://axibase.com:8443/portals/series?metric=docker&entity=test&add%20params=%7B%22markers%22%3A%22false%22%2C%22seriesParameters%22%3A%5B%7B%22statistic%22%3A%22detail%22%7D%5D%2C%22timespan%22%3A%221%20HOUR%22%2C%22endTime%22%3A%221516302092533%22%7D
```

### `csvExportLink`

```bash
${csvExportLink}
```
Retrieves link to csv file for the current entity that is initialized in the rule window.

Example:

```bash
https://axibase.com:8443/export?settings=%7B%22m%22%3A%22docker%22%2C%22e%22%3A%22test%22%2C%22si%22%3A%221-DAY%22%2C%22t%22%3A%22HISTORY%22%2C%22f%22%3A%22CSV%22%2C%22np%22%3A-1%2C%22v%22%3Afalse%2C%22tf%22%3A%22LOCAL%22%2C%22ms%22%3Afalse%2C%22ro%22%3Afalse%2C%22am%22%3Afalse%2C%22eft%22%3A%22NAME%22%2C%22tglfmt%22%3Afalse%2C%22tglftr%22%3Afalse%2C%22tc%22%3Afalse%2C%22ost%22%3A%5B%5D%2C%22efv%22%3A%22test%22%7D
```

### `htmlExportLink`

```bash
${csvExportLink}
```
Retrieves link to **Data > Export** page for the current entity that is initialized in the rule window.

Example:

```bash
https://axibase.com:8443/export?settings=%7B%22m%22%3A%22docker%22%2C%22e%22%3A%22test%22%2C%22si%22%3A%221-HOUR%22%2C%22et%22%3A%222018-01-18+19%3A52%3A56%22%2C%22l%22%3A10000%2C%22t%22%3A%22HISTORY%22%2C%22f%22%3A%22HTML%22%2C%22np%22%3A-1%2C%22v%22%3Afalse%2C%22tf%22%3A%22LOCAL%22%2C%22ms%22%3Afalse%2C%22ro%22%3Afalse%2C%22am%22%3Afalse%2C%22eft%22%3A%22NAME%22%2C%22tglfmt%22%3Afalse%2C%22tglftr%22%3Afalse%2C%22tc%22%3Afalse%2C%22ost%22%3A%5B%5D%2C%22efv%22%3A%22test%22%7D
```

### `serverLink`

```bash
${serverLink}
```
Retrieves link to the server specified in `server.url` property at **Settings > Server Properties > Other** page.

Example:

```bash
https://axibase.com:8443/
```

### `entityLink`

```bash
${entityLink}
```
Retrieves link to entity that is initialized in the rule window.

Example:

```bash
https://axibase.com:8443/entities/test
```


