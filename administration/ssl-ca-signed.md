# Installing CA-signed Certificate

## Overview

The following instructions assume that you have obtained certificate files in `PEM` format from a certificate authority.

* `atsd.company.com.crt` - SSL certificate for the DNS name
* `atsd.company.com.ca-bundle` - Intermediate and Root CA SSL certificates
* `atsd.company.com.key` - Private key file

## Combine Chained Certificates

Combine the SSL certificates into one file to create a full certificate chain containing both the DNS and intermediate certificates.

```sh
cat atsd.company.com.crt atsd.company.com.ca-bundle > atsd.company.com.fullchain
```

## Install Certificates in ATSD

The certificates can be either [uploaded](#upload-certificates-to-atsd) into ATSD or installed by [deploying](#deploy-keystore-file) a keystore file on the local file system.

### Upload Certificates to ATSD

If the certificate files are in `PEM` format, you can upload them to ATSD using `curl`.

Alternatively, create a PKCS12 keystore as described [below](#deploy-keystore-file).

Replace `{USR}` with the username, `{PWD}` with the password and `{HOST}` with the hostname or IP address of the target ATSD server in the command below.

```sh
sudo curl -k -u {USR}:{PWD} https://{HOST}:8443/admin/certificates/import/atsd \
  -F "privkey=@atsd.company.com.key" \
  -F "fullchain=@atsd.company.com.fullchain" \
  -w "\n%{http_code}\n"
```

The certificates will be installed without an ATSD restart.

### Deploy Keystore File

#### Create PKCS12 Keystore

Log in to ATSD server shell.

Create a PKCS12 keystore.

```sh
openssl pkcs12 -export -inkey atsd.company.com.key -in atsd.company.com.fullchain -out atsd.company.com.pkcs12
```

```sh
Enter Export Password: NEW_PASS
Verifying - Enter Export Password: NEW_PASS
```

#### Remove Old Keystore File

Backup the current `server.keystore` file.

```sh
mv /opt/atsd/atsd/conf/server.keystore /opt/atsd/atsd/conf/server.keystore.backup 
```

#### Create JKS Keystore

Use the `keytool` command to create a new JKS keystore by importing the PKCS12 keystore file.

```sh
keytool -importkeystore -srckeystore atsd.company.com.pkcs12 -srcstoretype PKCS12 -alias 1 -destkeystore /opt/atsd/atsd/conf/server.keystore -destalias atsd
```

```
Enter destination keystore password: NEW_PASS
Re-enter new password: NEW_PASS
Enter source keystore password: NEW_PASS
```

#### Update Keystore Passwords

Open `/opt/atsd/atsd/conf/server.properties` file.

```sh
nano /opt/atsd/atsd/conf/server.properties
```

Specify the new password (in plain or [obfuscated](passwords-obfuscation.md) text) in `https.keyStorePassword` and `https.keyManagerPassword` settings. 

Leave `https.trustStorePassword` blank.

```elm
...
https.keyStorePassword=NEW_PASS
https.keyManagerPassword=NEW_PASS
https.trustStorePassword=
```

#### Restart ATSD

```sh
/opt/atsd/atsd/bin/stop-atsd.sh
/opt/atsd/atsd/bin/start-atsd.sh
```

## Verify Certificate

Log in to ATSD by entering its DNS name in the browser address bar and check its certificate by clicking on the SSL security icon.

## Troubleshooting

Check the contents of the keystore.

```sh
keytool -list -v -keystore /opt/atsd/atsd/conf/server.keystore
```

The output should contain an entry for `atsd` alias, for example:

```
Enter keystore password:  
Keystore type: JKS
Keystore provider: SUN

Your keystore contains 1 entry

Alias name: atsd
Creation date: Apr 18, 2018
Entry type: PrivateKeyEntry
Certificate chain length: 2
Certificate[1]:
Owner: CN=nur.axibase.com
Issuer: CN=Let's Encrypt Authority X3, O=Let's Encrypt, C=US
...
```
