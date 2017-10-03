# Installing CA-signed Certificate Files into ATSD

The following instructions assume that you have obtained the following files from a certificate authority:

* `example.crt` - SSL Certificate for the DNS name where ATSD is running
* `example.key` - SSL Certificate Key File
* `example.ca-bundle` - Intermediate SSL Certificates

### Combine the Chained Certificates 

Combine the SSL Certificate for the DNS name and intermediate SSL Certificates into one file.

```bash
cat example.crt intermediate.crt [intermediate2.crt]... rootCA.crt > cert-chain.txt
```

Example:

```bash
cat example.ca-bundle example.crt > cert-chain.txt
```

### Export the Key and Certificates

Create intermediate PKCS12 keystore containing combined at previous step certificates and private key file.

```bash
openssl pkcs12 -export -inkey example.key -in cert-chain.txt -out example.pkcs12
```

```bash
Enter Export Password: EXPORT_KEYSTORE_PASS
Verifying - Enter Export Password: EXPORT_KEYSTORE_PASS
```

## Remove old ATSD keystore

```bash
rm /opt/atsd/atsd/conf/server.keystore
```
### Import the Certificate	
	
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

## Update passwords in the server.properties file

Replace default password at `https.keyStorePassword` and `https.keyManagerPassword` with `NEW_PASS` in /opt/atsd/atsd/conf/server.properties file.

```bash
nano /opt/atsd/atsd/conf/server.properties
```

```bash
...
https.keyStorePassword=NEW_KEYSTORE_PASS
https.keyManagerPassword=EXPORT_KEYSTORE_PASS
...
```

### Restart ATSD

```bash
/opt/atsd/atsd/bin/stop-atsd.sh
/opt/atsd/atsd/bin/start-atsd.sh
```

### Verify SSL

Enter ATSD SSL url in the browser address bar: https://ATSD_DNS_NAME:8443


### Troubleshooting

Verify the correct settings in the `/opt/atsd/atsd/conf/server.properties` file

```bash
...
https.port=8443
https.keyStorePassword=
https.keyManagerPassword=
https.trustStorePassword=
...
```
