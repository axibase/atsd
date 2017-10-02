# Installing self-signed Certificate Files into ATSD

## Remove old ATSD keystore

```bash
rm /opt/atsd/atsd/conf/server.keystore
```
## Create keystore, keypair and certificate

Follow the prompts to create certificate.
 
> Note since self-signed certificates mean the lack of the root CA signature only `first and last name` require to be specified.

```bash
keytool -genkeypair -keystore /opt/atsd/atsd/conf/server.keystore -keyalg RSA -keysize 2048 -validity 365
```
  
```bash
Enter keystore password: NEW_PASS  
Re-enter new password: NEW_PASS
What is your first and last name?
  [Unknown]:  ATSD_HOSTNAME
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
Is CN=ATSD_HOSTNAME, OU=Unknown, O=Unknown, L=Unknown, ST=Unknown, C=Unknown correct?
  [no]:  yes

Enter key password for <mykey>
	(RETURN if same as keystore password): <press RETURN>
```

## Update passwords in the server.properties file

Replace default password at `https.keyStorePassword` and `https.keyManagerPassword` with `NEW_PASS` in /opt/atsd/atsd/conf/server.properties file.

```bash
nano /opt/atsd/atsd/conf/server.properties
```

```bash
...
https.keyStorePassword=NEW_PASS
https.keyManagerPassword=NEW_PASS
...
```

## Restart ATSD

```bash
/opt/atsd/atsd/bin/stop-atsd.sh
/opt/atsd/atsd/bin/start-atsd.sh
```
