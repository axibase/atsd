Weekly Change Log: July 31, 2017 - August 06, 2017
==================================================

### ATSD

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
| 4452 | UI | Bug | ** UI: API Client: Format Body check box does not work ** |
| 4443 | email | Bug | Cyrillic symbols enabled for reporting emails. |
| 4435 | security | Bug | ** Security: unauthorized view ** |
| 4433 | UI | Bug | Delete button repaired in Portal Editor. |
| 4432 | core | Bug | ** Hostname discovery ** |
| 4428 | installation | Bug | ** UserGroup set to root ** |
| 4421 | sql | Bug | Modified handling procedure to return error, instead of empty table, for queries to metrics which do not exist |
| 4420 | sql | Bug | Data return type standardized to bigint in [SQL Console](https://github.com/axibase/atsd/tree/master/api/sql). |
| 4406 | UI | Bug | ** UI: Metric Editor - display and highlight unexpected value in tag set ** |
| [4405](#issue-4405) | UI | Feature | ** Tag Templates: import and export ** (please tell me what you'd like me to show here) |
| [4395](#issue-4395) | jdbc | Feature | Support added for [wildcard expressions](https://github.com/axibase/atsd/tree/master/api/sql#sql-compatibility) in `getTables` and `getColumns` methods. |
| [4389](#issue-4389) | jdbc | Feature | Support added for metric and entity tags and fields in INSERT statements (can't find INSERT statement documentation to link to, please recommend a link to post below as well) |
| [4388](#issue-4388) | jdbc | Feature | Support added for the following [datetime](https://github.com/axibase/atsd/tree/master/api/sql#predefined-columns) format: `yyyy-MM-dd HH:mm:ss[.fffffffff]` |
| [4385](#issue-4385) | jdbc | Feature | Support added for configurable behavior on 'Metric not found' error (please tell me what kind of screenshot you'd like to show here)|
| 4383 | jdbc | Bug | Fixed a bug which did not include atsd_series when tables were queried with a [wildcard expressions](https://github.com/axibase/atsd/tree/master/api/sql#sql-compatibility). |
| 4379 | jdbc | Bug | Fixed an error which raised an exception upon invalid text insertion using an INSERT statement. |
| [4374](#issue-4374) | sql | Feature | ** SQL: /api/sql/meta to obtain query metadata for non-existent metric ** (please tell me what you'd like to show for a screenshot here.)|
| 4373 | jdbc | Bug | ** JDBC driver: fails on tags column ** |
| 4372 | jdbc | Bug | ** JDBC driver: fails on tags column **|
| 4371 | jdbc | Bug | Bug fixed which caused INSERT statements to not be applied to tables with escaped symbols |
| 4370 | jdbc | Bug | ** JDBC driver: duplicate metadata query ** |
| 4369 | jdbc | Bug | ** JDBC: Connection timezone ** |
| 4368 | sql | Bug | Placeholder recognition enabled in prepared statements in [SQL Console](https://github.com/axibase/atsd/tree/master/api/sql) |
| 4366 | jdbc | Bug | ** JDBC driver: refactor settings and JDBC url ** |
| 4365 | sql | Bug | Fixed a bug which incorrectly modified [datetime](https://github.com/axibase/atsd/tree/master/api/sql#predefined-columns) based on local timezone. |
| [4363](#issue-4363) | sql | ** Feature | SQL: /api/sql/meta to obtain query metadata without executing the query ** (Please tell me what kind of screenshot you'd like to see here) |
| 4345 | forecast | Bug | ** Forecast improperly calculates prediction when series contains multiple tags **|
| 4328 | sql | Bug | Fixed an exception error which resulted from using the [`Lag` function](https://github.com/axibase/atsd/blob/master/api/sql/README.md#lag) in a [`WHERE` clause](https://github.com/axibase/atsd/blob/master/api/sql/README.md#where-clause) |
| [4303](#issue-4303) | jdbc | Feature | Support enabled for `INSERT` queries. (Do we have documentation for this?) |
| 4278 | core | Bug | ** ATSD: compaction hangs when multiple detailed column families are present ** |
| 3983 | api-rest	| Bug |	** Data API: tags are incorrectly concatenated with 'group' processor ** |
| 3874 | api-network | Bug | ** Data API: series command fails to overwrite value when inserted in batch with append flag ** |

### ATSD

##### Issue 4405

##### Issue 4395

_Sample Syntax_

```sql
//will match disk_used
 ResultSet rs = dmd.getTables(null, null, "_isk_%", null);
 ```
 The above query uses standard wildcard expressions `%` and `_` to match tables and columns by name.
 
##### Issue 4389

##### Issue 4388

_Sample Query and Result_

```sql
INSERT INTO 'my-metric' (entity, value, datetime) VALUES ('e-1', 123, '2017-07-12 04:05:00.34567')
```

If `timestamp = true`, the query returns the following:

```sql
series e:e-1 d:2017-07-12T04:05:00.345Z m:my-metric=123
```

If `timestamp = false`, the query returns the following:

```sql
series e:e-1 d:2017-07-12T00:05:00.345Z m:my-metric=123
```

##### Issue 4385

##### Issue 4374

##### Issue 4363

##### Issue 4303
