# Messages: WebHook

## Description

The endpoint converts request parameters and JSON payload into a message and stores it in the database.

## Request

The endpoint accepts `POST` and `GET` requests.

| **Method** | **Path** | **Payload** | **Content-Type Header** |
|:---|:---|---|---:|
| POST | `/api/v1/messages/webhook/*` | JSON | `application/json` |
| GET | `/api/v1/messages/webhook/*` | None | - |

The URL can include any path after the `/webhook` part, for example, `/api/v1/messages/webhook/service-1`.

## Authentication

The request must be authenticated.

When initiating the request with an http client, user credentials can be included in the request URL as follows:

```elm
https://usr:pwd@atsd_host:8443/api/v1/messages/webhook/jenkins?entity=jen01
```

## Authorization

The user must have the `API_DATA_WRITE` role and `write` permissions for the target entity.

### Parameters

Request parameters, except for reserved parameters, are converted into message **tags** where tag name equals parameter name and tag value equals parameter value. Tag names are lowercased. Non-printable characters such as whitespace in tag names are replaced with underscore.

Request URL:

`/api/v1/messages/webhook/incoming?entity=test-1&action=started&Repeat=1`

Message tags:

```ls
action=started
repeat=1
```

### Payload

JSON fields of primitive data type (string, number, boolean) are converted into message **tags**, where tag name equals the field's full name (contains parent object names, separated by `.` character) and tag value equals field value.

Tag names are lowercased. Non-printable characters such as whitespace in tag names are replaced with underscore.

Input document:


```json
{
  "event": "commit",
  "repository": {
    "name": "atsd",
    "public": true,
    "Full Name": "Axibase TSD",
    "references": []
  }
}
```

Message tags:

```ls
event = commit
repository.name = atsd
repository.public = true
repository.full_name = Axibase TSD
```

### Requirements

Since each message must be associated with an entity, the request should instruct the server how to determine the entity name from the request parameters and the payload.

1. The entity can be specified literally by adding an `entity` parameter to the query string, for example `/api/v1/messages/webhook/jenkins?entity=test-1`

  ```
  entity = test-1
  ```

2. The entity can be extracted from a JSON field by specifying the field's full name, for example `/api/v1/messages/webhook/jenkins?command.entity=server.name`

  ```json
  {
    "server": {
      "name": "test-2",
      "site": "NUR"
    }
  }
  ```

  ```
  entity = test-2
  ```

3. The entity can be extracted from request headers by specifying the header name, for example `/api/v1/messages/webhook/jenkins?header.entity=X-AXI-Region`

  HTTP request headers:

  ```
  ...
  X-AXI-Region: us-east-01
  ...
  ```

  ```
  entity = us-east-01
  ```

### Default Message Field Values

* Message `type` is 'webhook'.
* Message `source` is set to the remainder of the URL path after the `/webhook/` part (and before the query string). If the remainder is empty, the `source` is set to empty string.

  ```ls
  source = incoming for /api/v1/messages/webhook/incoming?entity=test
  source =          for /api/v1/messages/webhook?entity=test
  ```

* Message `severity` is undefined.
* Message `date` is set to current server time.
* Message tag `request_ip` is set to the remote IP address of the http client that initiated the request.

### Reserved Request Parameters

#### Literal Value Parameters

These parameters set message fields to literal values.

| **Name** | **Description** |
|---|---|
| type | Message type.|
| source | Message source. |
| entity | [**Required**] Message entity |
| date | Message datetime in ISO format. |
| message | Message text. |
| severity | Message severity specified as an integer or as a string constant. |

`/api/v1/messages/webhook/jenkins?entity=test-1&type=ci&severity=3`

```
  entity = test-1
  type = ci
  severity = WARNING
```

#### Command Parameters

Command parameters set message field values from JSON field values.

| **Name** | **Description** |
|---|---|
| command.type | Message type. If not specified, set to `webhook`. |
| command.source | Message source. If not specified, set to URL path after `./webhook/`. |
| command.entity | [**Required**] Message entity. |
| command.date | Message datetime in ISO format. |
| command.message | Message text. |
| command.severity | Message severity specified as an integer or as a constant. |

`/api/v1/messages/webhook/jenkins?command.entity=server&command.type=event`

```json
  {
    "server": "test-2",
    "event": "deploy"
  }
```

```
  entity = test-2
  type = deploy
```

#### Header Parameters

Header parameters set message field values from header values.

| **Name** | **Description** |
|---|---|
| header.type | Message type. If not specified, set to `webhook`. |
| header.source | Message source. If not specified, set to URL path after `./webhook/`. |
| header.entity | [**Required**] Message entity. |
| header.date | Message datetime in ISO format. |
| header.message | Message text. |
| header.tag.{name} | Message tag. |
| header.severity | Message severity specified as an integer or as a constant. |

`/api/v1/messages/webhook/jenkins?entity=test-3&header.tag.event=X-GitHub-Event`

```json
  User-Agent: GitHub-Hookshot/5ee1da1
  X-GitHub-Delivery: 955bf180-e573-11e7-9438-56fe67d6b38d
  X-GitHub-Event: watch
  X-Hub-Signature: sha1=b0d4aa86d17c6b77e5b35e7482769955ad9aca4d
```

```
  entity = test-3
  tag.event = watch
```

#### Filter Parameters

The filter parameters contain patterns that the converted message tags must satisfy in order to be included in the message command. The patterns support `*` as a wildcard.

| **Name** | **Description** |
|---|---|
| `include` | Include only tags with **names** that satisfy the specified pattern. |
| `exclude` | Exclude tags with **names** that satisfy the specified pattern. |
| `includeValues` | Include only tags with **values** that satisfy the specified pattern. |
| `excludeValues` | Exclude tags with **values** that satisfy the specified pattern. |

> The `include` parameter takes precedence over the `exclude` parameter. If the `include` parameter is present, the `exclude` parameter is ignored.

> The `includeValues` parameter takes precedence over the `excludeValues` parameter. If the `includeValues` parameter is present, the `excludeValues` parameter is ignored.

> The above parameters may contain multiple patterns separated by semi-colon. Alternatively, they can be repeated in the query string: `&exclude=repository.*&exclude=sender.*`.

Example:

  ```
	exclude = repository.*
  ```

  ```json
	{
	  "event": "commit",
	  "result": "ok",
	  "repository": {
	    "name": "atsd",
	    "public": true,
	    "Full Name": "Axibase TSD",
	    "references": []
	  }
	}
  ```

  Message fields:

  ```
    tag.event = commit
    tag.result = ok
  ```

#### Control Parameters

| **Name** | **Description** |
|---|---|
| debug | If set to `true`, the response includes the message record in JSON format. |

### Parameter Precedence

The reserved parameters have the following precedence:

1) Literal Value Parameters
2) Command Parameters
3) Header Parameters

Example:

* Request URL:

  ```
    /api/v1/messages/webhook/github?entity=test-1&header.entity=User-Agent&command.entity=server
  ```

* Request Headers:

  ```
    User-Agent: GitHub-Hookshot/5ee1da1
  ```

* Request Payload:

  ```
    {
      "server": "test-2"
    }
  ```

* Message Command:

  ```
	type=github
	source=webhook
	entity=test-1
	tags:
	    server=test-2
	    request_ip=...
  ```


## Example

Request:

```elm
POST https://usr:pwd@atsd_host:8443/api/v1/messages/webhook/github?debug=true&entity=github&header.tag.event=X-GitHub-Event&repo=atsd&excludeValues=http*&exclude=organization.*%3Brepository.*
```

Notes:

* Fields with name starting with `organization.` are excluded.
* Fields with name starting with `repository.` are excluded.
* Fields with values starting with `http` are excluded.
* Tag `repo` is set to `atsd` with a corresponding request parameter.
* Tag `event` is retrieved from the `X-GitHub-Event` header.

Payload:

```json
{
  "action": "started",
  "repository": {
    "id": 54949530,
    "name": "atsd",
    "full_name": "axibase/atsd",
    "owner": {
      "login": "axibase",
      "id": 10971416,
      "avatar_url": "https://avatars0.githubusercontent.com/u/10971416?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/axibase",
      "html_url": "https://github.com/axibase",
      "followers_url": "https://api.github.com/users/axibase/followers",
      "following_url": "https://api.github.com/users/axibase/following{/other_user}",
      "gists_url": "https://api.github.com/users/axibase/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/axibase/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/axibase/subscriptions",
      "organizations_url": "https://api.github.com/users/axibase/orgs",
      "repos_url": "https://api.github.com/users/axibase/repos",
      "events_url": "https://api.github.com/users/axibase/events{/privacy}",
      "received_events_url": "https://api.github.com/users/axibase/received_events",
      "type": "Organization",
      "site_admin": false
    },
    "private": false,
    "html_url": "https://github.com/axibase/atsd",
    "description": "Axibase Time Series Database Documentation",
    "fork": false,
    "url": "https://api.github.com/repos/axibase/atsd",
    "forks_url": "https://api.github.com/repos/axibase/atsd/forks",
    "keys_url": "https://api.github.com/repos/axibase/atsd/keys{/key_id}",
    "created_at": "2016-03-29T05:51:34Z",
    "updated_at": "2017-12-22T13:32:50Z",
    "pushed_at": "2017-12-22T12:56:17Z",
    "git_url": "git://github.com/axibase/atsd.git",
    "ssh_url": "git@github.com:axibase/atsd.git",
    "clone_url": "https://github.com/axibase/atsd.git",
    "svn_url": "https://github.com/axibase/atsd",
    "homepage": "https://axibase.com/products/axibase-time-series-database/",
    "size": 78274,
    "stargazers_count": 37,
    "watchers_count": 37,
    "language": "HTML",
    "has_issues": true,
    "has_projects": false,
    "has_downloads": true,
    "has_wiki": false,
    "has_pages": true,
    "forks_count": 12,
    "mirror_url": null,
    "archived": false,
    "open_issues_count": 1,
    "license": null,
    "forks": 12,
    "open_issues": 1,
    "watchers": 37,
    "default_branch": "master"
  },
  "organization": {
    "login": "axibase",
    "id": 10971416,
    "url": "https://api.github.com/orgs/axibase",
    "repos_url": "https://api.github.com/orgs/axibase/repos",
    "events_url": "https://api.github.com/orgs/axibase/events",
    "hooks_url": "https://api.github.com/orgs/axibase/hooks",
    "issues_url": "https://api.github.com/orgs/axibase/issues",
    "members_url": "https://api.github.com/orgs/axibase/members{/member}",
    "public_members_url": "https://api.github.com/orgs/axibase/public_members{/member}",
    "avatar_url": "https://avatars0.githubusercontent.com/u/10971416?v=4",
    "description": "Public Axibase repositories on GitHub"
  },
  "sender": {
    "login": "rodionos",
    "id": 2098022,
    "avatar_url": "https://avatars3.githubusercontent.com/u/2098022?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/rodionos",
    "html_url": "https://github.com/rodionos",
    "followers_url": "https://api.github.com/users/rodionos/followers",
    "following_url": "https://api.github.com/users/rodionos/following{/other_user}",
    "gists_url": "https://api.github.com/users/rodionos/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/rodionos/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/rodionos/subscriptions",
    "organizations_url": "https://api.github.com/users/rodionos/orgs",
    "repos_url": "https://api.github.com/users/rodionos/repos",
    "events_url": "https://api.github.com/users/rodionos/events{/privacy}",
    "received_events_url": "https://api.github.com/users/rodionos/received_events",
    "type": "User",
    "site_admin": false
  }
}
```

Command:

```json
{
	"entity": "github",
	"type": "webhook",
	"source": "github",
	"severity": null,
	"tags": {
		"action": "started",
		"event": "watch",
		"repo": "atsd",
		"request_ip": "192.30.253.29",
		"sender.id": "2098022",
		"sender.login": "rodionos",
		"sender.site_admin": "false",
		"sender.type": "User"
	},
	"date": "2017-12-22T13:32:50.901Z"
}
```
