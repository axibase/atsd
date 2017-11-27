# Slack

https://slack.com/

## Prerequisites

Install a [Web Driver binary](README.md#install-web-driver)

## Create workspace and channel

* Go to https://slack.com/create and follow the prompts to create a new workspace
* Create a new channel:

    ![](images/create_channel.png)
    
    * check (enable) **Private** to restrict access
    * invite members to receive notifications from ATSD (you can do it later)
      
    ![](images/create_channel2.png)   
    
    * click **Create Channel**

## Add bot integration 

* Go to https://my.slack.com/services/new/bot 
* Check Workspace 

    ![](images/check_workspace.png)  

* Fill in the username field , click **Add bot integration**

    ![](images/atsd_bot_slack.png)  

* Review setup instructions
* Copy API Token, click **Save Integration**

![](images/api_token.png) 

* Invite bot to the channel: 
    * go back to https://my.slack.com/
    * click **Invite others to this private channel**
    
    ![](images/add_atsd_bot.png) 
    
    * choose any option for the channel
    
    ![](images/channel_option.png) 
    
    * enter bot name to the search field
    
    ![](images/add_atsd_bot_to_slack.png) 
    
    * click **Invite**

    ![](images/bot_joined.png) 
 
## Configure Web Notifications

* Log in to ATSD web UI
* Go to **Admin > Web Notifications > Slack**
* Specify `Auth Token` and `Channels`
* Fill in the text field 

    ![](images/slack_parameters_new.png)

* Click **Test**

   ![](images/slack_message_test.png)
   
* Select **Test Portal**
 
   ![](images/new_test_portal.png)   
   
* Click **Send Screenshot**

   ![](images/slack_send_screen.png) 
   
The following parameters are supported:

|**Parameter**|**Description**|
|---|---|
|Auth Token|Authentication token bearing required scopes.|
|Channels|Comma-separated list of channels, private groups, or IM channels to send message to. Each entry can be an encoded ID, or a name.|
|Text|Text of the message to be sent. This field is usually required, unless you're providing only alert details instead.|
|Parse Mode|Change how messages are treated. See [Basic message formatting](https://api.slack.com/docs/message-formatting)|
|Names as Links|Find and link channel names and usernames.|
|Bot Username|Set your bot's user name.|

If tests are ok, check **Enable**, click **Save**   

## Configure Rule

* Download the file [rules.xml](resources/rules.xml)
* Open **Alerts > Rules > Import** 
* Check (enable) **Auto-enable New Rules**, click on **Choose File**, select the downloaded XML file, click **Import**
* Open the imported rule, go to the **Email Notifications** tab, replace **Recipients** field
* Go to the **Web Notifications** tab, select Slack from **Endpoint** drop-down
* Save the rule by clicking on the **Save** button

## Test

* Wait a little, check the channel

![](images/slack_test_1.png) 

![](images/slack_test_2.png)