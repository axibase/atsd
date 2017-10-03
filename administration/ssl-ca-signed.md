# Installing CA-signed Certificate Files into ATSD

## Overview

The following instructions assume that you have obtained the following files from a certificate authority:

* `example.crt` - SSL Certificate for the DNS name where ATSD is running
* `example.key` - SSL Certificate Key File
* `example.ca-bundle` - Intermediate SSL Certificates


## Combine the Chained Certificates 

Combine the SSL Certificate for the DNS name and intermediate SSL Certificates into one file.

```bash
cat example.crt intermediate.crt [intermediate2.crt]... rootCA.crt > cert-chain.txt
```

Example:

```bash
cat example.ca-bundle example.crt > cert-chain.txt
```

## Export the Key and Certificates

Create intermediate PKCS12 keystore containing combined at previous step certificates and private key file.

```bash
openssl pkcs12 -export -inkey example.key -in cert-chain.txt -out example.pkcs12
```

```bash
Enter Export Password: EXPORT_KEYSTORE_PASS
Verifying - Enter Export Password: EXPORT_KEYSTORE_PASS
```

## Remove Keystore File

Delete the current Java keystore file from the configuration directory.

```bash
rm /opt/atsd/atsd/conf/server.keystore
```

```bash
rm: remove regular file `/opt/atsd/atsd/conf/server.keystore'? yes
```

## Import the Certificate	
	
Use the keytool to create new ATSD keystore and import the PKCS12 file.

```bash
keytool -importkeystore -srckeystore example.pkcs12 -srcstoretype PKCS12 -destkeystore /opt/atsd/atsd/conf/server.keystore
```

```bash
Enter destination keystore password: NEW_KEYSTORE_PASS
Re-enter new password: NEW_KEYSTORE_PASS
Enter source keystore password: EXPORT_KEYSTORE_PASS
Entry for alias 1 successfully imported.
Import command completed:  1 entries successfully imported, 0 entries failed or cancelled
```

## Update Keystore Passwords

Open `/opt/atsd/atsd/conf/server.properties` file.

```bash
nano /opt/atsd/atsd/conf/server.properties
```

Specify the new password in `https.keyStorePassword` and `https.keyManagerPassword` settings. Leave `https.trustStorePassword` blank.

```properties
...
https.keyStorePassword=NEW_KEYSTORE_PASS
https.keyManagerPassword=EXPORT_KEYSTORE_PASS
https.trustStorePassword=
```

## Restart ATSD

```bash
/opt/atsd/atsd/bin/stop-atsd.sh
/opt/atsd/atsd/bin/start-atsd.sh
```

## Verify Certificate

Login into ATSD by entering its DNS name in the browser address bar.


## Troubleshooting

Verify the correct settings in the `/opt/atsd/atsd/conf/server.properties` file.

```properties
...
https.port=8443
https.keyStorePassword=NEW_KEYSTORE_PASS
https.keyManagerPassword=EXPORT_KEYSTORE_PASS
https.trustStorePassword=
```

Check the content of keystore.

```bash
keytool -list -v -keystore /opt/atsd/atsd/conf/server.keystore
```