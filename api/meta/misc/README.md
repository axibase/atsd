# Meta API: Miscellaneous Methods

| **Name** | **Method** | **Path** | **Content-Type** | **Description** |
|:---|:---|:---|:---|:---|
| [Version](version.md) | GET | `/api/v1/version` |  | Returns database version including licensing details as well as a date object with local time and offset. |
| [Ping](ping.md) | GET | `/ping` |  | Returns `200` status code. Typically used to check connectivity, authentication and to maintain an active session. |
| [Search](search.md) | GET | `/api/v1/search` |  | Search series by expression. |
| [Permissions](permissions.md)|GET|`/api/v1/permissions`||Information about user permissions.|
