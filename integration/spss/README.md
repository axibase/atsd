**Windows / Easysoft**

1) Install JRE 8
2) Register an Easysoft account here http://www.easysoft.com/cgi-bin/account/register.cgi . This account will be used further during trial activation process.
3) Download attached ATSD JDBC driver (atsd-jdbc-1.2.22-SNAPSHOT-DEPS.jar) or download from here, with DEPS https://github.com/axibase/atsd-jdbc/releases 
4) Download attached Easysoft ODBC JDBC Bridge (odbc-jdbc-gateway-2_5_3-windows.exe)
5) Install and activate Easysoft 

Run installer as administrator

![](easysoft_install_0.PNG)

Skip welcom page

![](easysoft_install_1.PNG)

Accept license agreement

![](easysoft_install_2.PNG)

Choose install path

![](easysoft_install_3.PNG)

Confirm install

![](easysoft_install_4.PNG)

After installation ends check **Launch Easysoft license manager** checkbox and finish

![](easysoft_install_5.PNG)

License manager window appear after exit from install wizard (if it don't go to **Start** and search for **License Manager**). In this widow fill all fields same as in registered account from previous step and click **Request License**

![](easysoft_activate_1.PNG)

Choose **Trial**, click Next

![](easysoft_activate_2.PNG)

Choose **ODBC JDBC Gateway**, click Next

![](easysoft_activate_3.PNG)

Click **Online request**

![](easysoft_activate_4.PNG)

If activation succeeds, popup window will appear

![](easysoft_activate_5.PNG)

Also in License Manager window should appear new license

![](easysoft_activate_6.PNG)

6) Add new ODBC data source

Go to **Start** , type ODBC and launch ODBC Data source manager as administrator

![](ODBC_1.png)

Go to **System DSN** tab and click **Add...**

![](ODBC_2.png)

Choose **Easysoft ODBC-JDBC Gateway**, click Finish

![](ODBC_3.png)

In DSN Setup window enter following settings

```
DSN: ATSD
User name: <atsd login>
Password: <atsd password>
Driver class: com.axibase.tsd.driver.jdbc.AtsdDriver
Class Path: <path to ATSD JDBC Driver, for example C:\atsd-jdbc-1.2.22-SNAPSHOT-DEPS.jar>
URL: <ATSD URL, for example jdbc:axibase:atsd:https://nur.axibase.com/api/sql;trustServerCertificate=true>
```

ATSD JDBC URL format and parametres decribed here https://github.com/axibase/atsd-jdbc#jdbc-connection-properties-supported-by-driver

![](ODBC_4.png)

Click Test to check your settings. If result is OK, save settings. After this in System DSN tab should appear new data source

![](ODBC_5.png)

For using this datasource in SPSS Statistics, open attached script (Syntax1.sps)

![](spss_1.PNG)

```
﻿* Encoding: UTF-8.

GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=ATSD;'
  /SQL='SELECT datetime, value FROM test_m'
  /ASSUMEDSTRWIDTH=255.

CACHE.
EXECUTE.
DATASET NAME DataSet5 WINDOW=FRONT.
```

In this script CONNECT='DSN=ATSD' is DSN of created connection, SQL is query. Select all statements and run them. Some dataset should be returned

![](spss_2.PNG)
