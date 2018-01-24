# Installing Let's Encrypt Certificate

## Overview

[Let’s Encrypt](https://letsencrypt.org) is a free, automated, and open certificate authority (CA), run for the public’s benefit. 
This manual is based on [Installing CA-signed Certificate](ssl-ca-signed.md) and [Certbot](https://certbot.eff.org/#ubuntuxenial-other) instructions.

## Installing software

Install Apache web server. It is required for domain name check. After check web server can be removed.

```sh
sudo apt update
sudo apt install apache2
sudo service apache2 start
```

Install Certbot

```sh
sudo apt install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt update
sudo apt install certbot
```

## Obtaining certificate

Make sure that port 80 is accessible using your domain name (here `example.com`) - it is required for domain name check.
Obtain certificate

```sh
sudo certbot certonly --webroot -w /var/www/html -d example.com
```

If certificate is successfully obtained, following message will be displayed

```sh
- Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/example.com/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/example.com/privkey.pem
   Your cert will expire on 2018-04-24. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

Now Apache web server can be removed.

## Create PKCS12 Keystore

Create a PKCS12 keystore containing the chained certificate file and the private key file.

```bash
cd /etc/letsencrypt/live/example.com/
openssl pkcs12 -export -inkey privkey.pem -in fullchain.pem -out keystore.pkcs12
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
keytool -importkeystore -srckeystore keystore.pkcs12 -srcstoretype PKCS12 -alias 1 -destkeystore /opt/atsd/atsd/conf/server.keystore -destalias atsd
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

Specify the new password (in plain text or [obfuscated](https://docs.oracle.com/cd/E35822_01/server.740/es_admin/src/tadm_ssl_jetty_passwords.html)) in `https.keyStorePassword` and `https.keyManagerPassword` settings. Leave `https.trustStorePassword` blank.

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
