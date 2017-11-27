# Discord

https://discordapp.com/

## Prerequisites

Install a [Web Driver binary](README.md#install-web-driver)

## Create server

 * Click on the big plus at the left panel

     ![](images/create_server.png)
 
 * Click on **Create a Server**

     ![](images/create_server2.png)
 
 * Fill in the field **Server Name**, click **Create**
 
     ![](images/create_server3.png)
    
 * Invite members to receive notifications from ATSD (you can do it later), click **Done**
 
## Create channel
 
 * Click on **Create Channel**
 
     ![](images/create_discord_channel.png)
    
 * Fill in the **Channel name** field, check (enable) **Text Channel**, click **Create Channel**
 
     ![](images/create_discord_channel2.png)
 
 * Click **Edit channel**
 
     ![](images/create_discord_channel3.png)
     
 * Go to **Permissions** tab and review settings

     ![](images/create_discord_channel4.png)
     
> At the **Invite** tab you can create invite link and send it to users.  To join server created for notifications user should click **Create new server**, select **Join** and paste received invite.

## Create webhook

 * Go to **Webhook** tab, click **Create Webhook**, specify name, select channel 

      ![](images/create_webhook.png)
 
 * Copy Webhook URL, click **Save**
 
## Configure Web Notifications

* Log in to ATSD web UI
* Go to **Admin > Web Notifications > Discord**
* Specify `Webhook URL` 
* Fill in the `Content` field 

    ![](images/discord_parameters.png)

* Click **Test**

   ![](images/discord_message_test.png)
   
* Select **Test Portal**
 
   ![](images/new_test_portal.png)   
   
* Click **Send Screenshot**

   ![](images/discord_send_screen.png)
   
The following parameters are supported:

|**Parameter**|**Description**|
|---|---|
|Webhook URL|Webhook URL generated at **Webhook** tab at the channel settings.|
|Content|Text of the message to be sent.|
|Bot Username|Overwrite your bot's user name.|

If tests are ok, check **Enable**, click **Save**   

## Configure Rule

* Download the file [rules.xml](resources/rules.xml)
* Open **Alerts > Rules > Import** 
* Check (enable) **Auto-enable New Rules**, click on **Choose File**, select the downloaded XML file, click **Import**
* Open the imported rule, go to the **Email Notifications** tab, replace **Recipients** field
* Go to the **Web Notifications** tab, select Discord from **Endpoint** drop-down
* Save the rule by clicking on the **Save** button

## Test

* Wait a little, check the channel

    ![](images/discord_test_1.png)

    Content of _atsd.jvm.low_memory_atsd_open_20171127_1408043.txt_:

    ![](images/discord_test_2.png)

