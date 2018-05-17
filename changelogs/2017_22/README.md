# Weekly Change Log: May 29, 2017 - June 04, 2017

## ATSD

| Issue| Category    | Type    | Subject              |
|------|-------------|---------|----------------------|
| 4236 | sql | Bug | Resolved error when using [`JOIN`](../../sql#joins)  and [`INTERPOLATE(DETAIL)`](../../sql#interpolation) clauses together. |
| 4224 | sql | Bug | Fixed a bug which caused the `datetime` column to be rendered in milliseconds when referenced by the [`CONCAT`](../../sql#string-functions) function.|
| 4199 | admin | Bug | Fixed a bug which failed to update `HOSTNAME` and server URL in Admin: Server Properties at runtime. |
| [4163](#issue-4163) | UI | Feature | Several enhancements to the User Interface: tooltips, column visibility, icons, auto-completes. |
| [4144](#issue-4144) | rule engine | Feature | Add a page displaying all active email subscribers in the Rule Engine.|
| 4107 | UI | Bug | Layout of several forms refactored to adhere to the latest guidelines. |
| 3900 | UI | Bug | Fixed an issue with message counter chart failing to render on timespan change. |

### ATSD

#### Issue 4163

Admin > Server Properties, modified to display differences between actual and default property values:

![4163](./Images/4163.1.png)

Admin > System Information, table headers added to user interface:

![4163.2](./Images/4163.2.png)

Configuration > Portals, `View` button allows for viewing of
Portal during configuration:

![4163.3](./Images/4163.3.1.png)

'Remember Me' tooltip added:

![4163.4](./Images/4163.4.png)

Admin > Users. `ROLE_` prefix removed:

![4163.5](./Images/4163.5.png)

Detailed columns removed from the Entities tab.

Alerts, second precision added to date column, `ACKNOWLEDGE` column shortened to `ACK`:

![4163.6](./Images/4163.6.png)

Messages, Millisecond precision added to date column.

#### Issue 4144

Configuration > Rules

![4144](./Images/4144.png)

Subscribers button displays all email subscribers.