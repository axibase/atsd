# Holiday Calendar

## Overview

Holiday Calendar is a data structure containing national holiday and work day information. [`DateTime` objects](object-datetime.md) method `is_workday` use Holiday Calendar to
 accurately determine the working days of a given country.

## Usage

Holiday calendars can be used in:

* [`IS_WORKDAY`](../sql/README.md#is_workday) SQL function
* `is_workday([c])` [`DateTime`](object-datetime.md) function
* `next_workday` and `previous_workday` [`DateTime`](object-datetime.md) properties
* `next_non_working_day` and `previous_non_working_day` [`DateTime`](object-datetime.md) properties

### Example

```sql
SELECT datetime, value, IS_WORKDAY(time) AS "workday" FROM metric
```

```javascript
now.is_workday()
```

## Default calendars

ATSD contains pre-defined holiday calendars for several countries in calendar year 2018.
These calendars include national holidays and additional non-working days.

List of default holiday calendars:

 **Country** | **Calendar Code** | **Download**
----|----|----
Australia | `aus` | [![](./images/button-download.png)](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/calendars/aus_2018.json)
Austria| `aut` | [![](./images/button-download.png)](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/calendars/aut_2018.json)
Brazil | `bra` | [![](./images/button-download.png)](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/calendars/bra_2018.json)
Canada | `can` | [![](./images/button-download.png)](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/calendars/can_2018.json)
China | `chn` | [![](./images/button-download.png)](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/calendars/chn_2018.json)
Germany | `deu` | [![](./images/button-download.png)](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/calendars/deu_2018.json)
France | `fra` | [![](./images/button-download.png)](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/calendars/fra_2018.json)
Great Britain | `gbr` | [![](./images/button-download.png)](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/calendars/gbr_2018.json)
Israel | `isr` | [![](./images/button-download.png)](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/calendars/isr_2018.json)
Japan | `jpn` | [![](./images/button-download.png)](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/calendars/jpn_2018.json)
Korea | `kor` | [![](./images/button-download.png)](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/calendars/kor_2018.json)
Russia | `rus` | [![](./images/button-download.png)](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/calendars/rus_2018.json)
Singapore | `sgp` | [![](./images/button-download.png)](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/calendars/sgp_2018.json)
USA | `usa` | [![](./images/button-download.png)](https://raw.githubusercontent.com/axibase/atsd/master/rule-engine/resources/calendars/usa_2018.json)

## Calendars Modification

### Schema

Calendars are stored as JSON documents with a strict [schema](holiday-calendar-schema.md). Calendar key is the file name prefix.
The file with calendar data structure can be named as follows:

* `{calendar_key}.json`
* `{calendar_key}_{yyyy}.json`

### Import to ATSD

Go to **Settings > Workday Calendars**. Click **Choose Files** button and select one or more prepared calendars, click **Import**.

![](./images/holiday-calendars.png)

The selected files are copied to the `/opt/atsd/atsd/conf/calendars` directory. The workday calendar cache is refreshed, and the updates are loaded.

The other option is to put the calendar files into the `/opt/atsd/atsd/conf/calendars` directory manually.

### Example

The example below illustrates a custom holiday calendar for New York Stock Exchange.
Create a file `nyse_2018.json`.

```json
[
  {
    "date": "2018-01-01",
    "description": "New Years Day",
    "type": "Holiday"
  },
  {
    "date": "2018-01-15",
    "description": "Martin Luther King, Jr. Day",
    "type": "Holiday"
  },
  {
    "date": "2018-02-19",
    "description": "Washington's Birthday",
    "type": "Holiday"
  },
  {
    "date": "2018-03-30",
    "description": "Good Friday",
    "type": "Holiday"
  },
  {
    "date": "2018-05-28",
    "description": "Memorial Day",
    "type": "Holiday"
  },
  {
    "date": "2018-07-04",
    "description": "Independence Day",
    "type": "Holiday"
  },
  {
    "date": "2018-09-03",
    "description": "Labor Day",
    "type": "Holiday"
  },
  {
    "date": "2018-11-22",
    "description": "Thanksgiving Day",
    "type": "Holiday"
  },
  {
    "date": "2018-12-25",
    "description": "Christmas",
    "type": "Holiday"
  }
]
```

## Troubleshooting

### `is_workday` Function Throws Exception After ATSD Upgrade

Holiday calendars are included with new ATSD installations.
Download the required [calendars](#default-calendars) and [import](#import-to-atsd) them to ATSD.
