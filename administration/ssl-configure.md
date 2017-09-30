# Installing CA-signed Certificate Files into ATSD

## Remove old ATSD keystore

```bash
rm /opt/atsd/atsd/conf/server.keystore
```
## Create keystore, keypair and certificate

Follow the prompts to create certificate.
 
> Note since self-signed certificates mean the lack of the root CA signature only `first and last name` must be specified.

```bash
keytool -genkeypair -keystore /opt/atsd/atsd/conf/server.keystore -alias atsd -keyalg RSA -keysize 2048 -validity 365
```
  
```bash
Enter keystore password: NEW_KEYSTORE_PASS  
Re-enter new password: NEW_KEYSTORE_PASS
What is your first and last name?
  [Unknown]:  localhost
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
Is CN=localhost, OU=Unknown, O=Unknown, L=Unknown, ST=Unknown, C=Unknown correct?
  [no]:  yes

Enter key password for <atsd>
	(RETURN if same as keystore password): NEW_ALIAS_PASS
Re-enter new password: NEW_ALIAS_PASS
```

## Update passwords in the server.properties file

Replace `NEW_KEYSTORE_PASS` server.keystore.

```bash
sed -i "s,^https.keyStorePassword=.*,https.keyStorePassword=NEW_KEYSTORE_PASS,g" /opt/atsd/atsd/conf/server.properties; \
sed -i "s,^https.keyManagerPassword=.*,https.keyManagerPassword=NEW_ALIAS_PASS,g" /opt/atsd/atsd/conf/server.properties
```

## Restart ATSD

```bash
/opt/atsd/atsd/bin/stop-atsd.sh
/opt/atsd/atsd/bin/start-atsd.sh
```