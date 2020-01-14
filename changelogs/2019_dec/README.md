# Monthly Change Log: December 2019

## ATSD

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
6153|api-rest|Feature|Series Query: VWAP calculation and MVEL UDF.
6511|api-rest|Bug|Series Query: add correlation and covariance functions.
6519|rule editor|Feature|[Rule Editor](../../rule-engine/README.md): **Test** tab layout.
6606|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): data availability monitoring.
6616|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): placeholder error does not contain rule name.
6650|portal|Feature|[Portal](../../portals/README.md#portals) placeholders and saving.
6653|core|Feature|Calendar expression: [`current_working_day`](../../shared/calendar.md#previous-time) in database.
6665|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): load history on **Date Filter** activation.
6666|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): add **Time Zone** and **Workday Calendar** settings.
6677|sql|Bug|[SQL](../../sql/README.md): slow query due to [`date_format`](../../sql/README.md#date_format) condition not passed to filer.
6679|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): validation command ignores **Entity Filter**.
6689|api-rest|Bug|REST API: [interpolate](../../api/data/series/interpolate.md#interpolation) `PREVIOUS` with `OUTER` fails to retrieve prior value.
6690|api-rest|Feature|Series Query: add [`timezone`](../../api/data/series/query.md#control-fields) parameter.
6700|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): event script cannot invoke method.
6703|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): data availability triggered despite report filter.
6708|UI|Bug|Replacement Table: formatting issues in CSV format.
6713|sql|Bug|[SQL](../../sql/README.md): add line numbers or query substring in error messages.
6716|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): alerts not closed when testing multiple days with **ActivateOn** filter.
6721|api-rest|Feature|REST API: intraday [filter](../../api/data/series/query.md#sample-filter) function for series query.
6722|UI|Bug|SQL Query Plan: move **Query Console** and **Cancel Query** buttons to the top.
6723|UI|Bug|[SQL Console](../../sql/sql-console.md): disable **Store** button after it is clicked once.
6725|rule editor|Feature|[Rule Engine](../../rule-engine/README.md): **Test** enhancements.
6730|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): speed up mock RE data loading for rules with **ActivateOn** filter.
6733|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): cannot compare [`entity.label`](../../rule-engine/placeholders.md#syntax) to string.
6734|api-rest|Bug|REST API: return entity metadata if entity is specified in the [group](../../api/data/series/group.md) request.
6737|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): track state for wildcard entities produces incorrect portal and CSV links.
6738|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): history not loaded during **Test**.
6740|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): add entity to filtered series.
6743|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): default date format with custom time zone.
6745|rule engine|Bug|[Rule Editor](../../rule-engine/README.md): report filter not accepted.
6747|search|Bug|Search: limit properties per entity.
6749|rule engine|Feature|[Rule Engine](../../rule-engine/README.md): [`preciseNow`](../../rule-engine/functions-date.md#precise_now) function to get current time with microsecond precision.
6752|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): entity not present in error message.
6754|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): initialisation script is not evaluated during rule validation.
6755|data-in|Feature|Property writes: configurable persistence.
6756|portal|Bug|[Portal](../../portals/README.md#portals): persist user variables in browser storage.
6757|portal|Bug|[Portal](../../portals/README.md#portals): function error.
6758|portal|Bug|[Portal](../../portals/README.md#portals): portal image in email is broken.
6760|core|Bug|Series schema: incorrect dictionary value returned.
6761|rule engine|Bug|[Rule Engine](../../rule-engine/README.md): сan not use [`date_format`](../../rule-engine/functions-date.md#date_format) on calendar in **Webhooks** tab.
6765|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): message [search](../../search/README.md#search) condition incorrect.
6766|rule engine|Bug|[Rule Error](../../rule-engine/README.md#rule-errors): entity missing in details.
6768|rule engine|Feature|[Rule Editor](../../rule-engine/README.md): configurable entity filter on [filter](../../rule-engine/filters.md#filter-expression) results page.
6776|rule editor|Bug|[Rule Editor](../../rule-engine/README.md): store validation command with a rule.
6778|core|Bug|[Workday Calendar](../../administration/workday-calendar.md#workday-calendar): update calendars for 2020.

## Charts

 Issue| Category    | Type    | Subject
------|-------------|---------|--------
5007|property|Feature|[Property widget](https://axibase.com/docs/charts/widgets/property-table/#property-table): differentiate key and tag columns.
6688|core|Bug|Time processing: provide access to general time-related methods.
6691|interval|Feature|Time parser: support mixed [expression](https://axibase.com/docs/charts/syntax/date-expressions.html#date-expressions).
6729|widget-settings|Feature|Settings: range-scale [settings](https://axibase.com/docs/charts/widgets/time-chart/#delta) to control auto-scaling.
6732|widget-settings|Bug|Functions: implement [lookup functions](https://axibase.com/docs/charts/syntax/csv.html#functions) for CSV object.
6736|core|Bug|[Time parser](https://axibase.com/docs/charts/widgets/shared/#date-filter): wrong string is successfully parsed.
6742|widget-settings|Feature|Implement [`[axis]`](https://axibase.com/docs/charts/widgets/time-chart/#axis-settings) section.
6770|table|Bug|[Icon](https://axibase.com/docs/charts/widgets/shared-table/#icon) setting became broken.
6771|widget-settings|Feature|Settings: [`fix-start-time`](https://axibase.com/docs/charts/widgets/shared/#fix-start-time) setting to prevent changes in initial [`start-time`](https://axibase.com/docs/charts/widgets/shared/#date-filter).
6777|core|Feature|Default label for series with [alias](https://axibase.com/docs/charts/widgets/shared/#alias).
