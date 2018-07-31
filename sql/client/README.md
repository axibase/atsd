# Overview

**SQL Client** is a `bash` script that provides a convenient way to export SQL query results to a file or standard output in CSV or JSON format.

The client validates input parameters and executes a request to [`/api/sql`](../api.md) API endpoint using credentials stored in the `atsd.config` file.

## Download

```bash
curl -O https://raw.githubusercontent.com/axibase/atsd/master/sql/client/sql.sh
```

## Permissions

Grant execution permissions to the `sql.sh` script.

```bash
chmod +x sql.sh
```

## Configuration

Create an `atsd.config` file located in the same directory as the `sql.sh` file.

Specify the database URL and user credentials. If the URL protocol is HTTPS, the query and the results are encrypted.

```elm
url=https://192.0.2.6:8443/api/sql
insecure=true
user=username
password=password
```

The user must have the `API_DATA_READ` [role](../../administration/user-authorization.md) and necessary entity `read` permissions.

The client is stateless with each query triggering a separate HTTP request with the `Basic` authentication.

## Parameters

| **Name** | **Type** | **Description** |
|:---|:---|:---|
| `-o`, `--output` | string | Output file where results are stored. If not specified, results are printed to `stdout`. |
| `-i`, `--input` | string | Input file containing SQL query to execute. |
| `-q`, `--query` | string | SQL query text enclosed in double quotes. Ignored if query is read from input file. <br>Escape double quotes contained in query text with a backslash.|
| `-f`, `--format` | string | Output format. Default: `csv`. Supported options: `csv`, `json`. |

## Examples

Execute inline query and print results to `stdout`.

```bash
./sql.sh -q "SELECT * FROM \"mpstat.cpu_busy\" WHERE datetime > now - 1*minute LIMIT 3"
```

Execute inline query and store results in `/tmp/report-2.csv`.

```bash
./sql.sh --output /tmp/report-2.csv --query "SELECT entity, value FROM \"mpstat.cpu_busy\" WHERE datetime > now - 1*minute LIMIT 3"
```

Execute query specified in the `query.sql` file and write CSV results to `/tmp/report-1.csv`.

```bash
./sql.sh -o /tmp/report-1.csv -i query.sql -f csv
```

Execute inline query and redirect output to a file.

```bash
./sql.sh -q "SELECT * FROM \"mpstat.cpu_busy\" WHERE datetime > now-1*hour LIMIT 2" > /tmp/test.csv
```

Execute inline query with escaped double quotes.

```bash
./sql.sh -q "SELECT * FROM \"mpstat.cpu_busy\" WHERE datetime > now-1*hour LIMIT 5"
```

Execute a multi-line query.

```bash
./sql.sh -q "SELECT * FROM \"mpstat.cpu_busy\" WHERE
               datetime > now-1*hour LIMIT 5"
```