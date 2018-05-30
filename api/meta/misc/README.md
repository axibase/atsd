# Meta API: Miscellaneous Methods

| **Name** | **Method** | **Path** | **Content-Type** | **Description** |
|:---|:---|:---|:---|:---|
| [Version](version.md) | GET | `/api/v1/version` |  | Returns database version including licensing details as well as a date object with local time and offset. |
| [Ping](ping.md) | GET | `/api/v1/ping` |  | Returns `200` status code to check connectivity, authentication and to maintain an active session. |
| [Permissions](permissions.md)| GET | `/api/v1/permissions` | | Returns roles and permissions for the current user.|
| [Search](search.md) | GET | `/api/v1/search` |  | Search series by expression. |