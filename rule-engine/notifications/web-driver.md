# Web Driver Installation

## Overview

There are two types of supported Web Drivers: [PhantomJS](http://phantomjs.org/) and [Chrome Driver](https://sites.google.com/a/chromium.org/chromedriver/).

## Option 1: PhantomJS

* Check if bzip2 compression codec is installed.

```bash
sudo apt-get install bzip2
```

* Download and install PhantomJS:

```bash
cd /home/axibase
wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
tar xjf phantomjs-2.1.1-linux-x86_64.tar.bz2
```

* Set path to `/home/axibase/phantomjs-2.1.1-linux-x86_64/bin/phantomjs` in **Settings > Server Properties > webdriver.phantomjs.path**.

    ![](images/webdriver.phantomjs.path.png)
    
* Open Rules > Web Notifications page. Create and test one of TYPE-specific web notifications such as [Telegram](telegram.md) or [Slack](slack.md). Verify that screenshot was successfully received in the chat client.
    
* Review Web Driver settings on **Settings > System** Information page, no error should be displayed.

    ![](images/webdriver-settings_1.png)


## Option 2: Chrome Driver

* Install Сhrome (see https://www.google.com/linuxrepositories/).

Ubuntu:

```bash
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt-get update && sudo apt-get install google-chrome-stable --no-install-recommends
```

RedHat, CentOS:

```bash
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo yum install ./google-chrome-stable_current_*.rpm
```

* Install `chromedriver`

Ubuntu:

```bash
sudo apt-get install unzip
wget https://chromedriver.storage.googleapis.com/2.33/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo mv chromedriver /usr/bin/chromedriver
```

RedHat, CentOS:

```bash
sudo yum install unzip
wget https://chromedriver.storage.googleapis.com/2.33/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo mv chromedriver /usr/bin/chromedriver
```
* Set path to `/usr/bin/chromedriver` and `/usr/bin/google-chrome-stable` in **Settings > Server Properties > webdriver.chromedriver.path** and **webdriver.chromebrowser.path**.

    ![](images/webdriver-google.png)

* Open Rules > Web Notifications page. Create and test one of TYPE-specific web notifications such as Telegram or Slack. Verify that screenshot was successfully received in the chat client.

* Review Web Driver settings on **Settings > System** Information page, no error should be displayed.

    ![](images/webdriver-settings_2.png)