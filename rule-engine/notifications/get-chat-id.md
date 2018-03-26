## Get Chat Id

### For Private Channel

  * Click on the channel name and check its URL, for example `/#/im?p=c1354757644_16698643680908793939`

     ![](images/channel_url.png)

  * Copy numbers before the underscore and replace `c` with `-100`, so that the chat id looks like this, `-1001354757644`.

### For Public Channel

  * Click on the channel name and check its URL, for example `/#/im?p=@atsd_notifications`

     ![](images/public_channel_url.png)    

  * Copy symbols after `=`, so the chat id looks like this, `@atsd_notifications`

### For Direct Message Chat

  * Start conversation with the bot and send any message.
  * Go to https://api.telegram.org/botBOT_TOKEN/getUpdates (replace BOT_TOKEN with the actual value).
  * Review the `Chat Object`

    ![](images/chat_object.png)