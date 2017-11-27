# Telegram

https://telegram.org/

## Prerequisites

Install [WebDriver](README.md#install-web-driver)

## Create a bot

* Open a conversation with the [BotFather](https://telegram.me/botfather)

    ![](images/botfather.png)

* Send the `/newbot` command and follow the prompts to create a bot user and obtain the token

> Note: the next step is required only if you want to send notifications to groups

* Enable groups for bot:
  * send the `/mybots` command to the BotFather
  * select recently created bot > **Bot Settings > Allow Groups? > Turn groups on** if required

## Create group or channel

### Create Group

* Go to profile settings > **New Group**

   ![](images/new_group.png)

* Enter group name, click **Next**
* Add the created bot, for example, `@atsd_bot`

   ![](images/atsd_bot.png)

* Add other members to receive notifications from ATSD, click **Create**

### Create Channel

* Go to profile settings > **New Channel**

   ![](images/new_channel.png)

* Enter channel name, click **Create**
* Check (enable) type of channel, fill in the **Invite link** field if required, click **Save**

   ![](images/private_channel.png)

* Add members to receive notifications from ATSD (you can do it later) > **Invite**
* Click on **Channel Settings > View channel info**

   ![](images/channel_settings.png)       

   ![](images/channel_inf.png)

* **N administrators > Add administrator** > enter bot name to the search field, for example `@atsd_bot` 

   ![](images/add_admin.png)

   Click on bot > **Ok**

   ![](images/ok.png)
   
   Review settings and click **Save > Close**

   ![](images/admin_settings.png)

## Get the chat id

  * Log in [Telegram Web](https://web.telegram.org)
  
### 1-1 Chat

  * Go to `https://t.me/BOT_NAME`, for example https://t.me/atsd_bot
  * Click **Open in Web**
  * Click **Start**
  * Send some message to bot
  * Go to https://api.telegram.org/botBOT_TOKEN/getUpdates
  * Look at `Chat Object`
  
    ![](images/chat_object.png)
    
  * Copy id
  
### Group  

  * Click on group and look at URL: /#/im?p=g**306974066**
  
    ![](images/id_group.png)
   
  * Copy numbers and add prefix `-`, so the chat id will be like `-306974066`

### Channel

#### Private

  * Click on channel and look at URL: /#/im?p=c**1354757644**_16698643680908793939
  
    ![](images/channel_url.png)
  
  * Copy numbers before underscore and add prefix `-100`, so the chat id will be like `-1001354757644`
  
#### Public

##### Option 1

  * Click on channel and look at URL: /#/im?p=**@atsd_notifications**
    
     ![](images/public_channel_url.png)    
     
  * Copy symbols after `=`, so the chat id will be like `@atsd_notifications`

##### Option 2
  
  * Click on **Channel Settings > View channel info**
  
     ![](images/public_channel.png) 
     
  * Copy words after `https://t.me/` in invite link and add prefix `@`, so the chat id will be like `@atsd_notifications`
  
## Configure Web Notifications

* Log in ATSD web UI
* Go to **Admin > Web Notifications > Telegram**
* Specify `bot_id` with `BOT_TOKEN` and `chat_id` with chat id of group or channel
* Fill the text field 
   
   ![](images/bot_test.png)

* Click **Test**

   ![](images/test_message.png)
   
* Select **Test Portal**
 
   ![](images/new_test_portal.png)   
   
* Click **Send Screenshot**

   ![](images/send_screen.png) 
   
The following parameters are supported:

|**Field**|**Description**|
|---|---|
|Bot ID|Each bot is given a unique authentication token when it is created.|
|Chat ID|Unique identifier for the target chat or the target channel.|
|Text|Text of the message to be sent.|
|Parse Mode|Send [Markdown](https://core.telegram.org/bots/api#markdown-style) or [HTML](https://core.telegram.org/bots/api#html-style) if you want show bold, italic, fixed-width text or inline URLs in your message.|
|Disable Notifications|Sends the message silently. Users will receive a notification with no sound.|
|Disable Web Page Preview|Disables link previews for links in this message.|

If tests are ok, check **Enable**, click **Save**

## Configure Rule

* Download the file [rules.xml](resources/rules.xml)
* Open **Alerts > Rules > Import** 
* Check (enable) **Auto-enable New Rules**, click on **Choose File**, select the downloaded XML file, click **Import**
* Open the imported rule, go to the **Email Notifications** tab, replace **Recipients** field
* Go to the **Web Notifications** tab, select Telegram from **Endpoint** drop-down
* Save the rule by clicking on the **Save** button

## Test

* Wait a little, check the channel

![](images/test_1.png)

Content of _atsd.jvm.low_memory_atsd_open_20171123_1349355.txt_:

![](images/test_2.png)

## Notifications examples

![](images/example1.png)

![](images/example2.png)

![](images/example3.png)

