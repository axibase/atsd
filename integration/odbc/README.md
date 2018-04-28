## ODBC-JDBC Bridge

### Overview

This document describes how to install an ODBC-JDBC bridge on a Windows machine. The bridge serves as a data link between the Axibase Time Series Database and Windows applications that do not support [JDBC](https://docs.oracle.com/javase/tutorial/jdbc/overview/) driver technology.

The bridge intercepts SQL queries from the client applications via the Microsoft [ODBC](https://docs.microsoft.com/en-us/sql/odbc/microsoft-open-database-connectivity-odbc) protocol and transmits the queries into ATSD using the [ATSD JDBC driver](https://github.com/axibase/atsd-jdbc).

### Prerequisites

* Windows 7, 8, 10 operating system, **64-bit edition**.
* Java 7.
* [ODBC-JDBC](https://www.easysoft.com/products/data_access/odbc_jdbc_gateway/#section=tab-1) bridge.

### Downloads

1. Download and install **Java 7**. Note that **Java 8** is not fully supported by the ODBC-JDBC bridge vendor.
2. [Register](https://www.easysoft.com/cgi-bin/account/register.cgi) an account with the bridge vendor. The account is required for trial license activation.
3. [Download](https://www.easysoft.com/products/data_access/odbc_jdbc_gateway/#section=tab-1) the trial version of the ODBC-JDBC bridge.
4. [Download](https://github.com/axibase/atsd-jdbc/releases) ATSD JDBC driver with dependencies.

### Bridge Installation

Install and activate the bridge:

* Run the installer under an Administrator account

  ![](images/easysoft_install_0.PNG)

* Skip the welcome page

  ![](images/easysoft_install_1.PNG)

* Accept the license agreement

  ![](images/easysoft_install_2.PNG)

* Choose an installation path

  ![](images/easysoft_install_3.PNG)

* Confirm the installation

  ![](images/easysoft_install_4.PNG)

* Check the **License Manager** box and finish

  ![](images/easysoft_install_5.PNG)

### License Activation

A license manager window will appear after exiting from the installation wizard. If the window fails to appear go to **Start** and search for **License Manager**. Fill out the form fields as entered in the registered account and click **Request License**

  ![](images/easysoft_activate_1.PNG)

* Choose **Trial**, click Next

  ![](images/easysoft_activate_2.PNG)

* Choose **ODBC JDBC Gateway**, click Next

  ![](images/easysoft_activate_3.PNG)

* Click **Online request**

  ![](images/easysoft_activate_4.PNG)

* If the activation succeeds, a pop-up window will appear

  ![](images/easysoft_activate_5.PNG)

* Also a window with the new license will be displayed in the License Manager

  ![](images/easysoft_activate_6.PNG)

### Configure ODBC Data Source

* Go to **Start**, type `ODBC` and launch ODBC Data Source Manager under an Administrator account.

  ![](images/ODBC_1.PNG)

* Open **System DSN** tab, click **Add...**.

  ![](images/ODBC_2.PNG)

* Choose the **ODBC-JDBC Gateway**, click **Finish**.

  ![](images/ODBC_3.PNG)

* Enter the following settings in the DSN Setup window:

```txt
DSN         :   ATSD
User name   :   <atsd username>
Password    :   <atsd password>
Driver class:   com.axibase.tsd.driver.jdbc.AtsdDriver
Class Path  :   <path to ATSD driver, e.g. C:\drivers\atsd-jdbc-1.3.2-DEPS.jar>
URL         :   jdbc:atsd://atsd_hostname:8443
```

Refer to ATSD JDBC [documentation](https://github.com/axibase/atsd-jdbc#jdbc-connection-properties-supported-by-driver)  for additional details about the URL format and the driver properties.

 ![](images/ODBC_conf.png)

* Check (enable) **'Strip Quote'** option to remove the quotes from table and column names.

* Check (enable) **'Strip Escape'** option to remove [ODBC escape sequences](https://docs.microsoft.com/en-us/sql/odbc/reference/appendixes/odbc-escape-sequences). 

* Click **Test** to verify the settings. If result is correct, save the settings. 

> In case of 'Unable to create JVM' error, run a Repair task in Windows Program for the bridge program. The error may occur if the bridge was installed prior to Java installation.

* The System DSN tab should now display the new data source.

  ![](images/ODBC_5.PNG)
