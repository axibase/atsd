# Overview

SQL client provides a convenient way to query the Axibase Time Series Database using SQL and export results to a file or standard output in a variety of formats.

The client is a bash script that parses and validates input parameters and executes an http/s request to `/api/sql` API endpoint in the database using credentials stored in the `atsd.config` file.

## Permissions

Make sure that `sql.sh` has execution permissions.

```bash
chmod +x sql.sh
```

Username and password of the user executing the query must be specified in the `atsd.config` file located in the same directory as the `sql.sh` file.

The user should have an `API_DATA_READ` role and necessary entity `read` permissions.

The client is stateless with each query triggering a separate http request with the `Basic` authentication.

If the database url specified in the `atsd.config` file is secure, both the query as well as results are encrypted.

## Configuration File

```elm
url=https://10.102.0.6:8443/api/sql
insecure=true
user=axibase
password=********
```

## Parameters

| **Name** | **Type** | **Description** |
|:---|:---|:---|
| -o, --output | string | Output file to store the result set. If not specified, results are printed to `stdout`. |
| -i, --input | string | Input file containing SQL query to execute. |
| -q, --query | string | SQL query text enclosed with double quotes. Ignored if query is read from input file. <br>Double quotes contained in query text can be escaped with a backslash.|
| -f, --format | string | Format. Default: `csv`. Supported options: `csv`, `json`. |

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
