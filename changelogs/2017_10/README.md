# Weekly Change Log: March 6 - March 12, 2017

## ATSD

| Issue| Category    | Type    | Subject                                                                              |
|------|-------------|---------|--------------------------------------------------------------------------------------|
| 3978 | portal | Bug | Display disabled portals on Entity Group portal assignment page. |

## Collector

| Issue| Category    | Type    | Subject                                                                              |
|------|-------------|---------|--------------------------------------------------------------------------------------|
| 3972 | json | Bug | Replace non-printable characters to underscores in generated entity names. |
| 3931 | json | Bug | Add support for referencing field names containing dots by quoting the field name. |
| 3828 | admin | Bug | Expose atsd-api-java request logging via logback configuration. |
| [3827](#issue-3827) | file | Feature | Add support for [placeholders](https://github.com/axibase/axibase-collector/blob/master/jobs/placeholders.md#overview) in `First Line Contains` field. |
| 3990 | collection | Bug | Ignore `stderr` when reading SCRIPT Item List. |

## Charts

| Issue| Category    | Type    | Subject                                                                              |
|------|-------------|---------|--------------------------------------------------------------------------------------|
| [3956](#issue-3956) | data-loading | Bug | Treat [tags] containing comma as separate tag values. |
| [3975](#issue-3975) | widget-settings | Feature | Implement `tag-expression` setting to filter series by tag values. |

### Issue 3827

![](./Images/Figure1.png)

![](./Images/Figure2.png)

### Issue 3956

[ChartLab](https://apps.axibase.com/chartlab/558ba4c1)

### Issue 3975

| Setting | Description |
|---------|-------------|
| tag-expression | Applies server-side filter to series based on series tag values. |

[ChartLab](https://apps.axibase.com/chartlab/906238e2/4/)
