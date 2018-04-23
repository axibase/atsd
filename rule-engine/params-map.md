# Parameters Mapping For Built-In Notifications

## [Discord](./notifications/discord.md)

| Parameter Label | `p` map alias |
| ---| ---|
|Bot Username|`username`|
|Content|`content`|

Example:

```javascript
queryConfig("Discord", ["username":"ATSD BOT", "content":"Hello, Discord!"])
```

## [HipChat Data Center](./notifications/hipchat.md)

| Parameter Label | `p` map alias |
| ---| ---|
|Bot Nickname|`from`|
|Room ID|`room`|
|Message|`message`|
|Message Format|`message_format`|
|Notify|`notify`|

Example:

```javascript
queryConfig("HipChat", ["from":"ATSD BOT", "message":"Hello, HipChat!", "notify":"true"])
```

## [Slack](./notifications/slack.md)

| Parameter Label | `p` map alias |
| ---| ---|
|Bot Username|`username`|
|Channels|`channels`|
|Text|`text`|

Example:

```javascript
queryConfig("Slack", ["username":"ATSD BOT", "channels":"devops", "text":"Hello, Slack!"])
```
> Note only first channel in "channels" parameter will receive notification.

## [Telegram](./notifications/telegram.md)

| Parameter Label | `p` map alias |
| ---| ---|
|Chat ID|`chat_id`|
|Text|`text`|
|Notifications|`disable_notification`|
|Web Page Preview|`disable_web_page_preview`|

Example:

```javascript
queryConfig("Telegram", ["text":"Hello, Telegram! https://axibase.com", "disable_web_page_preview":"false"])
```