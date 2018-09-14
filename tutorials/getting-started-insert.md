# Getting Started: Inserting Data

## Contents

1. [Introduction](./getting-started.md)
1. Inserting Data
1. [Portals](./getting-started-portal.md)
1. [Exporting Data](./getting-started-export.md)
1. [SQL](./getting-started-sql.md)
1. [Alerting](./getting-started-alert.md)

## Network Commands

In the previous section you inserted data manually using the web interface. Proceed by inserting data in network command format.

[Network commands](../api/network/README.md) provide a compact [syntax](../api/network/README.md#syntax) to insert both time series data as well as metadata.

```elm
command_name field_prefix:[field_name=]field_value
```

Open the terminal and send these commands into ATSD.

```bash
echo -e "series e:br-1905 m:temperature=25" \
  > /dev/tcp/atsd_hostname/8081
```

```bash
echo -e "entity e:br-1905 t:serial_number=N12002" \
  > /dev/tcp/atsd_hostname/8081
```

Refresh the **Series Statistics** page and **Entity Editor** to verify that the temperature sample is received and the entity tag `series_number` is set by the database.

![](./resources/network-entity-command.png)

You can also insert the same network commands on the **Data > Data Entry** page for convenience.

![](./resources/network-commands-data.png)

## REST API

While the network commands are optimized for writing data, the [REST API](../api/data/README.md) provides endpoints to both write and read data by sending HTTP requests in JSON format.

### Sending Values at a Specific Time

Open the terminal and send a single observation with a specific `datetime` into the [Series: Insert](../api/data/series/insert.md) endpoint. Replace `<username>` with your username.

```bash
curl https://atsd_hostname:8443/api/v1/series/insert \
  --insecure -w "%{http_code}\n" \
  --user <username> \
  --header "Content-Type: application/json" \
  --data '[{"entity": "br-1905", "metric": "temperature", "data": [{ "d": "2018-06-01T14:00:00Z", "v": 17.0 }]}]'
```

The payload transmitted to the database is a JSON document containing the series key and an array of `datetime:value` samples. The array `data` can contain any number of samples.

```json
[{
  "entity": "br-1905",
  "metric": "temperature",
  "data": [
    { "d": "2018-06-01T14:00:00Z", "v": 17.0 },
    { "d": "2018-06-01T14:05:00Z", "v": 17.5 }
  ]
}]
```

### Sending Values at the Current Time

Send a modified version, where the datetime is set to present time using the `date -u +"%Y-%m-%dT%H:%M:%SZ"` command.

```bash
curl https://atsd_hostname:8443/api/v1/series/insert \
  --insecure -w "%{http_code}\n" \
  --user <USER> \
  --header "Content-Type: application/json" \
  --data '[{"entity": "br-1905", "metric": "temperature", "data": [{ "d": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'", "v": 19.0 }]}]'
```

Reload the **Series Statistics** page and observe new values.

### Sending Values Continuously

Replace `<username>:<password>` with user credentials in the `curl` command provided below to send random values between `20` and `40` into the database every five seconds.

```bash
for i in {1..100}; do \
RANDOM_TEMPERATURE=$((20 + RANDOM % 20)); echo "send ${RANDOM_TEMPERATURE}"; \
curl https://atsd_hostname:8443/api/v1/series/insert \
  --insecure -w "%{http_code}\n" \
  --user <username>:<password> \
  --header "Content-Type: application/json" \
  --data '[{"entity": "br-1905", "metric": "temperature", "data": [{ "d": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'", "v": '"$RANDOM_TEMPERATURE"' }]}]'; \
sleep 0.5; \
done
```

Refer to [API Documentation](../api/data/series/insert.md) and [examples](../api/data/series/insert.md#additional-examples) for more information.

## CSV Files

CSV is one of the most commonly used tabular formats. Despite widespread use, the format remains non-standardized. ATSD provides a flexible **CSV Parser** that converts CSV files of any composition into structured database records.

Create a CSV file `temperature.csv`.

```txt
date,asset,temperature
2018-Jun-01 00:00:00,BR-1905,32.5
2018-Jun-01 00:30:00,BR-1905,31.5
2018-Jun-01 01:00:00,BR-1905,30.0
2018-Jun-01 01:30:00,BR-1905,29.0
2018-Jun-01 02:00:00,BR-1905,25.0
```

Open **Data > CSV Parsers** and select **Import** from the split-button located at the bottom of the page.

Attach [`temperature_parser.xml`](./resources/temperature_parser.xml) and [import the parser](https://axibase.com/use-cases/tutorials/shared/import-csv-parser.html).

Open **Data > CSV File Upload**, attach the `temperature.csv` file and process it with the newly created `temperature_parser`.

![](./resources/csv_upload.png)

Open the **CSV Tasks** page and check the number of processed rows is `6`.

![](./resources/csv_upload_report.png)

For this basic example, the parser maps file columns to series command fields based on column names specified in the header. The parser performs the following specific actions:

* `date` column is mapped to `datetime` field and parsed with `yyyy-MMM-dd HH:mm:ss` pattern in UTC time zone which is set explicitly.
* `asset` column is mapped to `entity` field.
* The remaining columns, including `temperature`, are automatically classified as metric columns.

```javascript
date = '2018-Jun-01 00:00:00' -> datetime = '2018-06-01T00:00:00Z'
asset = 'BR-1905'             -> entity = 'br-1905'
temperature = 32.5            -> metric (temperature) = 32.5
```

Refresh the **Series Statistics** page to check that the values from the CSV file are present in the database.

Refer to [CSV Parser Documentation](../parsers/csv/README.md) for more examples.

Continue to [Part 3: Portals](getting-started-portal.md).
