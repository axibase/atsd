# Installing CA-signed Certificate

## Overview

The following instructions assume that you have obtained the following files from a certificate authority:

* `example.crt` - SSL сertificate for the DNS name where ATSD is running
* `example.key` - SSL сertificate key file
* `example.ca-bundle` - Intermediate SSL сertificates

## Combine the Chained Certificates 

Combine the SSL сertificate for the DNS name and intermediate SSL сertificates into one file.

```bash
cat example.crt intermediate.crt [intermediate2.crt]... rootCA.crt > cert-chain.txt
```

Example:

```bash
cat example.crt example.ca-bundle > cert-chain.txt
```

## Create PKCS12 Keystore

Create a PKCS12 keystore containing the chained certificate file and the private key file.

```bash
openssl pkcs12 -export -inkey example.key -in cert-chain.txt -out example.pkcs12
```

```bash
Enter Export Password: NEW_PASS
Verifying - Enter Export Password: NEW_PASS
```

## Remove Keystore File

Delete the current Java keystore file from the configuration directory.

```bash
rm /opt/atsd/atsd/conf/server.keystore
```

## Create JKS Keystore	
	
Use the keytool to create a new JKS keystore by importing the PKCS12 keystore file.

```bash
keytool -importkeystore -srckeystore example.pkcs12 -srcstoretype PKCS12 -alias 1 -destkeystore /opt/atsd/atsd/conf/server.keystore -destalias atsd
```

```bash
Enter destination keystore password: NEW_PASS
Re-enter new password: NEW_PASS
Enter source keystore password: NEW_PASS
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


## Troubleshooting

Check the contents of the keystore.

```bash
keytool -list -v -keystore /opt/atsd/atsd/conf/server.keystore
```

The output should contain at least 1 entry consisting of the DNS certificate and intermediate certificates.

```
Keystore type: JKS
Keystore provider: SUN

Your keystore contains 1 entries

Alias name: atsd
Creation date: Jan 18, 2017
Entry type: PrivateKeyEntry
Certificate chain length: 4
Certificate[1]:
Owner: CN=atsd.customer_domain.com, OU=PositiveSSL Wildcard, OU=Domain Control Validated
...
```
