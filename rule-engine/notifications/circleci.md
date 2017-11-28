# CircleCI Integration

## Overview

The following documentation demonstrates starting CircleCI build using CircleCI HTTP API and ATSD custom web notifications

## Request

[CircleCI API v1.1](https://circleci.com/docs/api/v1-reference/)

```
Endpoint Type: CUSTOM
Method: POST
Content Type: application/json
Endpoint URL: https://circleci.com/api/v1.1/project/<vcs-type>/<username>/<project>/tree/master?circle-token=<circleci-user-token>
Headers:
    Accept: application/json
Body:
    {}
```

## Response

```
{
  "compare": null,
  "previous_successful_build": {
    "build_num": 192,
    "status": "success",
    "build_time_millis": 559440
  },
  "build_parameters": {},
  "oss": true,
  "all_commit_details_truncated": false,
  "committer_date": "2017-11-03T13:09:46Z",
  "body": "Version updated to 1.0.1",
...
```