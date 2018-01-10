# Installing Self-signed SSL Certificate

## Overview

The default certificate installed in ATSD is generated for DNS name 'atsd'. This document describes the process of creating and installing a self-signed SSL certificate to match the actual DNS name used by clients when accessing ATSD user interface and HTTP API. 

As with all self-signed certificates, the new certificate will still cause a security exception in user browsers and will require passing `-k/--insecure` parameter when connecting to ATSD using `curl` and similar tools in order to skip certificate validation.

## Remove Keystore File

Delete the current Java keystore file from the configuration directory.

```bash
rm /opt/atsd/atsd/conf/server.keystore
```
## Generate Certificate

Generate a new self-signed certificate using the [`keytool`](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/keytool.html) utility.

```bash
keytool -genkeypair -keystore /opt/atsd/atsd/conf/server.keystore -alias atsd -keyalg RSA -keysize 2048 -validity 3650
```

The self-signed certificate requires only `first and last name` question to be answered. It should be set to the DNS name used by clients when connecting to the ATSD server, such as `atsd.customer_domain.com` in the example below. The remaining fields are optional.
  
```bash
Enter keystore password: NEW_PASS  
Re-enter new password: NEW_PASS
What is your first and last name?
  [Unknown]:  atsd.customer_domain.com
What is the name of your organizational unit?
  [Unknown]:  
What is the name of your organization?
  [Unknown]:  
What is the name of your City or Locality?
  [Unknown]:  
What is the name of your State or Province?
  [Unknown]:  
What is the two-letter country code for this unit?
  [Unknown]:  
Is CN=atsd.customer_domain.com, OU=Unknown, O=Unknown, L=Unknown, ST=Unknown, C=Unknown correct?
  [no]:  yes

Enter key password for <mykey>
	(RETURN if same as keystore password): <press RETURN>
```

## Update Keystore Passwords

Open `/opt/atsd/atsd/conf/server.properties` file.

```bash
nano /opt/atsd/atsd/conf/server.properties
```

Specify the new password in `https.keyStorePassword` and `https.keyManagerPassword` settings. Leave `https.trustStorePassword` blank.

```properties
...
https.keyStorePassword=NEW_PASS
https.keyManagerPassword=NEW_PASS
https.trustStorePassword=
```

## Restart ATSD

```bash
/opt/atsd/atsd/bin/stop-atsd.sh
/opt/atsd/atsd/bin/start-atsd.sh
```

## Verify Certificate

Login into ATSD by entering its DNS name in the browser address bar.

Review the new certificate and check its validity date which is set to 10 years from now.
