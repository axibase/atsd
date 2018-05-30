# Ping

## Description

Returns `200` status code if the user credentials are valid and the user is allowed to access the database.

The endpoint is used to check connectivity, authentication, and to maintain an active session.

## Request

| **Method** | **Path** |
|:---|:---|---:|
| GET | `/api/v1/ping` |

## Response

### Fields

The response is empty with status code `200` if the request is valid.

Otherwise a `4xx` error is returned with an [error code](../../../administration/user-authentication.md#authentication-and-authorization-errors) in JSON format.

```json
{
  "error": "code 03"
}
```

## Example

### Request

#### URI

```elm
GET /api/v1/ping
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/ping \
  --insecure --include --user {username}:{password}
```

### Response

None.