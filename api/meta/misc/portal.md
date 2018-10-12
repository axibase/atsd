# portal

## Description

Generates a screenshot of the specified [portal](../../../portals/README.md) in PNG format.

## Permissions

The user requesting the portal must be granted the `API_DATA_READ` role and corresponding [Portal](../../../administration/user-authorization.md#portal-permissions) and [Entity](../../../administration/user-authorization.md#entity-permissions) permissions.

## Web Driver

The method requires a [web driver](../../../rule-engine/notifications/web-driver.md) to be installed and enabled on the ATSD server.

## Request

| **Method** | **Path**         |
| :--------- | :--------------- |
| `GET`        | `/api/v1/portal/export` |

### Query Parameters

| **Parameter** | **Type** | **Description** |
| :------------ | :------- | :------------- |
| `id`  | integer   | **[Required]** Portal identifier, displayed in the **Id** column on the **Portals > Configure** page.<br>Either `id` or `name` parameter must be specified. If both parameters are specified, `id` takes precedence.|
| `name`  | string   | **[Required]** Portal name, displayed in the **Name** column on the **Portals > Configure** page. |
| `entity` | string   | Entity name. Required for template portals.|
| `width` | integer   | Screenshot width, in pixels. Default: `900`. |
| `height` | integer   | Screenshot height, in pixels. Default: `600`. |
| `theme` | string   | Portal theme.<br>Possible values: `Default`, `Black`.<br>Default value is set in portal configuration. |

Additional request parameters are passed to the target portal and are accessible using the `${parameter_name}` syntax.

## Response

PNG file.

## Examples

```elm
GET /api/v1/portal/export?id=22
```

```elm
GET /api/v1/portal/export?name=Docker%20Host&entity=nurswgvml007
```

```elm
GET /api/v1/portal/export?id=100&width=1400&height=900
```

```bash
curl 'https://atsd_hostname:8443/api/v1/portal/export?id=202' \
  --insecure --user {username}:{password} > portal.png
```
