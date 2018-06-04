# Getting Started: Insert Data

## Network Commands

In the previous section we inserted data manually, using the built-in user interface forms. Lets proceed with inserting data in the network command format.

The [network commands](../api/network/README.md) provide a compact [syntax](../api/network/README.md#syntax) to insert both time series data as well as meta data.

```elm
command_name field_prefix:[field_name=]field_value
```

Open command prompt and send the following commands into the database.

```bash
echo -e "series e:br-1905 m:temperature=25" \
  > /dev/tcp/atsd_hostname/8081
```

```bash
echo -e "entity e:br-1905 t:serial_number=N12002" \
  > /dev/tcp/atsd_hostname/8081
```

Reload  the **Series Statistics** page and the entity editor to verify that a new temperature sample has been received and a new entity tag `series_number` has been set.

![](./resources/network-entity-command.png)

You can insert and validate commands on the **Data > Data Entry Page** for convenience.

![](./resources/network-commands-data.png)

## REST API

Unlike network commands, which are used for writing data, the REST API provides endpoints both to insert data as well as to query it, using JSON format.

### Send Value at Specific Time

Open command prompt and send a single value with a specific datetime into the [Series: Insert](../api/data/series/insert.md) endpoint. Replace `<USER>` with your username.

```bash
curl https://atsd_hostname:8443/api/v1/series/insert \
  --insecure -w "%{http_code}\n" \
  --user <USER> \
  --header "Content-Type: application/json" \
  --data '[{"entity": "br-1905", "metric": "temperature", "data": [{ "d": "2018-06-01T14:00:00Z", "v": 17.0 }]}]'
```

The payload transmitted to the database is a JSON document containing the series key and an array of `datetime:value` samples. In this case, you sent just one value with a pre-set datetime, but the array `d` may contain any number of `d:v` objects.

```json
[{
  "entity": "br-1905",
  "metric": "temperature",
  "data": [
    { "d": "2018-06-01T14:00:00Z", "v": 17.0 }
  ]
}]
```

### Send Value at Current Time

Send a modified version where the datetime is set to current instant using the `date -u +"%Y-%m-%dT%H:%M:%SZ"` bash function.

```bash
curl https://atsd_hostname:8443/api/v1/series/insert \
  --insecure -w "%{http_code}\n" \
  --user <USER> \
  --header "Content-Type: application/json" \
  --data '[{"entity": "br-1905", "metric": "temperature", "data": [{ "d": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'", "v": 19.0 }]}]'
```

Reload the **Series Statistics** page and observe new values.

### Send Values Continuously

Replace `<USER>:<PASSWORD>` with user credentials in the `curl` command provided below to send random values between `20` and `40` into the database every five seconds.

```bash
for i in {1..100}; do \
RANDOM_TEMPERATURE=$((20 + RANDOM % 20)); echo "send ${RANDOM_TEMPERATURE}"; \
curl https://atsd_hostname:8443/api/v1/series/insert \
  --insecure -w "%{http_code}\n" \
  --user <USER>:<PASSWORD> \
  --header "Content-Type: application/json" \
  --data '[{"entity": "br-1905", "metric": "temperature", "data": [{ "d": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'", "v": '"$RANDOM_TEMPERATURE"' }]}]'; \
sleep 5; \
done
```

Refer to [API reference](../api/data/series/insert.md) and [examples](../api/data/series/README.md#additional-examples) for more information.

## CSV File

CSV is one of the most commonly used tabular formats. Despite its widespread use, the format remains non-standardized. ATSD provides a flexible CSV parser so that CSV files of any composition can be converted into structured database records.

Create a CSV file `temperature.csv`.

```txt
date,asset,temperature
2018-Jun-01 00:00:00,BR-1905,32.5
2018-Jun-01 00:30:00,BR-1905,31.5
2018-Jun-01 01:00:00,BR-1905,30.0
2018-Jun-01 01:30:00,BR-1905,29.0
2018-Jun-01 02:00:00,BR-1905,25.0
```

Open **Data > CSV Parsers** page, click **Import** in the split button located below.

Attach [temperature_parser.xml](./resources/temperature_parser.xml) and import the parser.

Open **Data > CSV File Upload** page, attach the `temperature.csv` file and process it with the newly created `temperature_parser`.

![](./resources/csv_upload.png)

Open **CSV Tasks** page and check the number of processed rows is six.

![](./resources/csv_upload_report.png)

For this basic example, the parser maps file columns to series command fields based on column names specified in the header:

* `date` column is mapped to `datetime` field and parsed with `yyyy-MMM-dd HH:mm:ss` pattern in the `UTC` timezone which is set explicitly.
* `asset` column is mapped to `entity` field.
* The remaining columns, including `temperature`, are automatically classified as metric columns.

```javascript
date = '2018-Jun-01 00:00:00' -> datetime = '2018-06-01T00:00:00Z'
asset = 'BR-1905'             -> entity = 'br-1905'
temperature = 32.5            -> metric (temperature) = 32.5
```

Refresh the **Series Statistics** page to check that the values from the CSV file are present in the database.

Refer to [CSV Parser](https://axibase.com/docs/atsd/parsers/csv/) documentation for more examples.

Continue to [Part 3: Portals](getting-started-portal.md).