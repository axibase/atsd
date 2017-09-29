# Installing CA-signed Certificate Files into ATSD

## Create certificate

Replace `example.key`, `example.crt` with appropriate names of private key file and CA-certificate file to be created. Follow the prompts to create Distinguished Name:

```bash
openssl req -x509 -newkey rsa:2048 -keyout example.key -out example.crt -days 365 
```

```bash
Enter PEM pass phrase: PRIVATE_KEY_PASS
Verifying - Enter PEM pass phrase: PRIVATE_KEY_PASS

Country Name (2 letter code) [AU]:US
State or Province Name (full name) [Some-State]:CA
Locality Name (eg, city) []:Cupertino
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Axibase Corporation
Organizational Unit Name (eg, section) []:Software Group
Common Name (e.g. server FQDN or YOUR name) []:atsd
Email Address []:example@example.com
```

## Create keystore with custom password

Replace `example.key`, `example.crt` with appropriate names of private key file and CA-certificate file created early, replace `example.pkcs12`, `example` with appropriate names of keystore file and alias to be created.

```bash
openssl pkcs12 -export -inkey example.key -in example.crt -out example.pkcs12 -name example
```

```bash
Enter pass phrase for example.key: PRIVATE_KEY_PASS 
Enter Export Password: EXPORT_KEYSTORE_PASS 
Verifying - Enter Export Password: EXPORT_KEYSTORE_PASS
```
## Import certificate into the keystore

Remove old ATSD keystore.

```bash
rm /opt/atsd/atsd/conf/server.keystore
```

Create new keystore at `/opt/atsd/atsd/conf/`and import PKCS12 keystore created at previous step.

```bash
keytool -importkeystore -srckeystore example.pkcs12 -srcstoretype PKCS12 -destkeystore /opt/atsd/atsd/conf/server.keystore -alias example
```

```bash
Enter destination keystore password: NEW_KEYSTORE_PASS
Re-enter new password: NEW_KEYSTORE_PASS
Enter source keystore password: EXPORT_KEYSTORE_PASS
```
## Update passwords in the server.properties file

Replace `NEW_KEYSTORE_PASS`, `EXPORT_KEYSTORE_PASS` with appropriate passwords of server.keystore and *.pkcs12 keystores.

```bash
sed -i "s,^https.keyStorePassword=.*,https.keyStorePassword=NEW_KEYSTORE_PASS,g" /opt/atsd/atsd/conf/server.properties; \
sed -i "s,^https.keyManagerPassword=.*,https.keyManagerPassword=EXPORT_KEYSTORE_PASS,g" /opt/atsd/atsd/conf/server.properties
```

## Restart ATSD

```bash
/opt/atsd/atsd/bin/stop-atsd.sh
/opt/atsd/atsd/bin/start-atsd.sh
```