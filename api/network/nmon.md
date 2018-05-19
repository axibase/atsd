# `nmon` Command

## Description

Initiate line-by-line streaming of a `nmon` file. The transmission can be resumed without a full header in case of disconnect.

## Syntax

```ls
nmon p:{parser} e:{entity} f:{file_name} z:{timezone} t:{timeout}
... nmon file header ...
... nmon snapshot ...
```

## Fields

| **Field** | **Type** | **Description**                            |
|:---|:---|:---|
| p         | string          | **[Required]**  nmon parser name from **Data > nmon Parsers** page. <br>Specify `p:default` to use the default parser. |
| e         | string          | **[Required]**  Entity name.                                     |
| f         | string          | **[Required]**  Name of the nmon file.                      |
| z         | string          | Time zone ID applied to dates specified in snapshot samples, for example `America/New_York` or `EST`.<br>Refer to [Time Zone](../../shared/timezone-list.md) table for a list of supported Time Zone IDs.|
| v         | string          | nmon script version for debugging purposes. |
| o         | integer         | Read timeout in seconds. <br>Set to 2x snapshot interval to prevent the server from terminating an idle connection.|

The `f` nmon file name is used to re-read the file header from its copy on the server in case of disconnect.

## ABNF Syntax

Rules inherited from [Base ABNF](base-abnf.md).

```elm
  ; parser, entity, and filename are required
command = "nmon" MSP parser MSP entity MSP filename [MSP timezone] [MSP timeout]
entity = "e:" entity-name
  ; entity name, typically hostname where nmon is running
entity-name = NAME
  ; alphanumeric and underscore
parser = "p:" 1*(%x41-5A / %x61-7A / "_")
  ; file name should start with entity name and end with .nmon
filename = "f:" entity-name [NAME] ".nmon"
timezone = "z:" TIMEZONE
timeout = "o:" POSITIVE_INTEGER
```

## Examples

```ls
nmon p:default e:nurswgvml007 f:nurswgvml007_141014_2000.nmon z:PST
```

```ls
nmon e:server-001 p:default f:server-001.nmon
```

```ls
nmon e:server-001 p:default f:server-001.nmon z:UTC
```
