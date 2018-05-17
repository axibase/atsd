# Weekly Change Log: May 22, 2017 - May 28, 2017

## ATSD

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
| 4222 | export | Bug | Optimize export scan by adding entity to the scan filter. |
| 4219 | UI | Bug | Add series tags to SQL queries generated on the Series Statistics page. |
| 4216 | api-rest | Bug | Fix OutOfMemory error by applying limit on the server for [`/api/v1/messages/query`](../../api/data/messages/query.md#result-filter-fields) method. |
| 4214 | api-rest | Feature | Enable support for gzip compression of the payload in [`/api/v1/command`](../../api/data/ext/command.md) method. |
| 4212 | data-in| Bug| Fix Number Format Exception in `ChannelHandler`. |
| 4211 | sql | Bug | Error when evaluating interval condition if end date is earlier than '1970-01-01T00:00:00Z'. |
| 4208 | data-in| Bug | Clear long command buffer if disconnect on error is disabled. |
| 4195 | sql | Bug | Fix exception when multiple conditions are enclosed in parentheses. |
| 4181 | sql | Bug | Fixed an interpolation error is start date is '1970-01-01T00:00:00Z'. |
| 4152 | sql | Bug | Failure to parse complex metric condition in `atsd_series` syntax: `(metric  LIKE 'tv6.pack*' OR metric LIKE 'tv6.ela*')`. |
| [3834](#issue_3834) |UI | Feature| Client-side formatting on series statistics page. |

### ATSD

#### Issue 3834

![](./Images/3834.2.png)

Modifying these fields no longer requires performing the query a second time.

![](./Images/3834.3.png)
