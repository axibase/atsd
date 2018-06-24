# File Upload

Uploading `nmon` files can be done using a `wget` command or using the ATSD web interface.

Below are the commands and settings for uploading `nmon` files using a `wget` command.

## Plain

```sh
wget --header="Content-type: text/csv" --post-file=file.nmon 'http://server:port/nmon/wget?config=config_name&amp;entity=entity_name&amp;timeZone=time_zone_id'
```

## GZIP

```sh
wget --header="Content-type: text/csv" --header="Content-Encoding: gzip" \
  --post-file=file.nmon.gz 'http://server:port/nmon/wget?config=config_name&amp;entity=entity_name&amp;timeZone=time_zone_id'
```

## Special Parameters

* `config` (required) – name of nmon parser configuration in ATSD.
* `entity` (optional) – name of entity. If left blank, the parser uses the host record from the [nmon header](headers.md "Headers") as the entity name.
* `timeZone` (optional) – time zone where the data was recorded.

Multiple `nmon` files can be uploaded simultaneously if archived. The archive can contain multiple `nmon` files from different hosts. In this case, leave the entity field blank in which case the parser defaults to the host record from the [nmon header](headers.md "Headers") as the entity name.

## Supported Compression Formats

> .zip, .tar, .tar.gz, .tar.bz2

## File Web Interface Upload Example

![](./resources/upload-nmon-file.png "upload nmon file")
