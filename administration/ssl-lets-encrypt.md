# Installing Let's Encrypt Certificate

## Overview

[Let’s Encrypt](https://letsencrypt.org) is a certificate authority (CA) established by the [EFF Foundation](https://www.eff.org/) in 2016 to automate the SSL certificate issuance process.

Background information on **Let’s Encrypt** is available [here](https://github.com/axibase/atsd-use-cases/blob/master/workshop/lets-encrypt.md).

This instruction describes the process of installing and renewing SSL certificates in ATSD using [EFF Certbot](https://certbot.eff.org) agent.

The Certbot maybe located on the same machine where ATSD is running or on a remote machine in a centralized PKI management environment.

Before you start, determine the DNS name where ATSD is installed. For the purpose of examples below, lets assume the DNS name is `atsd.company.com`.

## Reference

* [Certbot Installation](#certbot-installation)
* [Install Certificate](#install-certificate)
* [Renew Certificate](#renew-certificate)

## Certbot Installation

Enable to the `certbot/certbot` repository and install the `certbot` package.

```sh
sudo apt install software-properties-common
```

```sh
sudo add-apt-repository ppa:certbot/certbot
```

```sh
sudo apt update
```

```sh
sudo apt install certbot
```

## Install Certificate

### HTTP-01 Challenge

> The `HTTP-01` challenge verifies your full control of the machine by sending it a request on port 80.

Make sure that port `80` is open and not bound to any process on the machine where certbot is running.

```sh
sudo netstat -nao | grep ":80\s"
```

Create a working directory for certbot which is required in standalone mode.

```sh
sudo mkdir -p /var/www/certbot
```

Execute the certificate request [command](https://certbot.eff.org/docs/using.html#certbot-command-line-options). Replace `atsd.company.com` with the actual DNS name.

```sh
sudo certbot certonly --standalone --agree-tos --no-eff-email \
  -w /var/www/certbot -d atsd.company.com
```

The following message will be displayed if the request was successfully processed.

```sh
- Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/atsd.company.com/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/atsd.company.com/privkey.pem
   Your cert will expire on 2018-04-24. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
```

Check that the `/etc/letsencrypt/live/` directory contains a sub-directory with the target DNS name.

```sh
$ sudo ls -all /etc/letsencrypt/live/
total 12
drwx------ 3 root root 4096 Mar 17 12:03 .
drwxr-xr-x 9 root root 4096 Apr 18 12:47 ..
drwxr-xr-x 2 root root 4096 Mar 17 12:03 atsd.company.com
```

### DNS Challenge

> The `DNS` challenge verifies your full control of the machine by reading a `TXT` record from the DNS registrar that you create as part of the challenge.

```sh
sudo certbot --preferred-challenges dns --manual certonly
```

```
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator manual, Installer None
Please enter in your domain name(s) (comma and/or space separated)  (Enter 'c'
to cancel): atsd.company.com
Cert not yet due for renewal

You have an existing certificate that has exactly the same domains or certificate name you requested and isn't close to expiry.
(ref: /etc/letsencrypt/renewal/atsd.company.com.conf)

What would you like to do?
-------------------------------------------------------------------------------
1: Keep the existing certificate for now
2: Renew & replace the cert (limit ~5 per 7 days)
-------------------------------------------------------------------------------
Select the appropriate number [1-2] then [enter] (press 'c' to cancel): 2
Renewing an existing certificate
Performing the following challenges:
dns-01 challenge for atsd.company.com

-------------------------------------------------------------------------------
NOTE: The IP of this machine will be publicly logged as having requested this
certificate. If you're running certbot in manual mode on a machine that is not
your server, please ensure you're okay with that.

Are you OK with your IP being logged?
-------------------------------------------------------------------------------
(Y)es/(N)o: Y

-------------------------------------------------------------------------------
Please deploy a DNS TXT record under the name
_acme-challenge.atsd.company.com with the following value:

Mq4jQ2F4LvDWxTq14m7hNgJsPaddwg1IzPz6Ltonu-c

Before continuing, verify the record is deployed.
-------------------------------------------------------------------------------
Press Enter to Continue
Waiting for verification...
Cleaning up challenges
```

### Verify Key Location

Check that the sub-directory for the requested DNS name contains `privkey.pem` and `fullchain.pem` files.

```sh
$ sudo ls /etc/letsencrypt/live/atsd.axibase.com
cert.pem  chain.pem  fullchain.pem  privkey.pem  README
```

### Create ATSD User

The user account is required to upload certificates into ATSD, both during the initial installation and as part of subsequent renewals.

Login into ATSD web interface.

Open the **Settings > Users** page and click **Create**.

* Specify `certbot` as the username (or a username of your choice).
* Assign Role `USER` to the user.
* Do not grant user any group membership.
* Add `127.0.0.1` to the list of `Allowed IPs`. Add additional IP addresses to the whitelist if the certbot is running on a remote machine.

![certbot upload](images/certbot-user.png)

### Upload Certificate Files into ATSD

Upload the certificates files (private key and the certificate chain) into ATSD using `curl`.

Replace `{USR}` with the username, `{PWD}` with the password and `{HOST}` with the hostname or IP address of the target ATSD server in the command below.

Replace `atsd.company.com` below with the actual DNS name.

```sh
sudo curl -k -u {USR}:{PWD} https://{HOST}:8443/admin/certificates/import/atsd \
  -F "privkey=@/etc/letsencrypt/live/atsd.company.com/privkey.pem" \
  -F "fullchain=@/etc/letsencrypt/live/atsd.company.com/fullchain.pem" \
  -w "\n%{http_code}\n"
```

Example command:

```sh
sudo curl -k -u certbot:Dmj_per1S https://10.102.0.6:8443/admin/certificates/import/atsd \
  -F "privkey=@/etc/letsencrypt/live/atsd.cert.org/privkey.pem" \
  -F "fullchain=@/etc/letsencrypt/live/atsd.cert.org/fullchain.pem" \
  -w "\n%{http_code}\n"
```

ATSD will accept the files, validate the certificates and automatically reload the SSL context without restarting the database itself.

The server will respond with code `200` if the installation was successful.

## Renew Certificate

### Create Deployment Script

Since Let's Encrypt certificates are issued for a short period of time (90 days), it's important to setup a fully automated procedure to replace expiring certificates.

Create a shell script `deploy-atsd.sh` to upload certificates files into ATSD. This script will be invoked by certbot.

```sh
#!/bin/bash

USR=certbot
PWD=**********
HOST=127.0.0.1
PORT=8443
DNS=atsd.company.com

echo "Uploading private key and certificate for ${DNS}"

curl -k -u $USR:$PWD https://$HOST:$PORT/admin/certificates/import/atsd \
  -F "privkey=@/etc/letsencrypt/live/${DNS}/privkey.pem" \
  -F "fullchain=@/etc/letsencrypt/live/${DNS}/fullchain.pem" \
  -w "\n%{http_code}\n"
```

Replace the parameters `USR`,`PWD`, `HOST`, `PORT`, and `DNS` with the actual settings.

Protect the file so that root privileges are required for reading and executing the file.

```sh
sudo chown root:root deploy-atsd.sh
```

```sh
sudo chmod 700 deploy-atsd.sh
```

Verify that the script is functional by executing it manually.

```sh
$ sudo ./deploy-atsd.sh
Uploading private key and certificate for atsd.company.com
200
```

### Test Renewal Manually

Execute `certbot renew` command with `--deploy-hook` parameter.

Update the path to `deploy-atsd.sh` script below.

```sh
sudo certbot renew --deploy-hook "/opt/certbot/deploy-atsd.sh"
```

The certbot will skip the renewal if the certificate is valid for more than 30 days.

```
Saving debug log to /var/log/letsencrypt/letsencrypt.log

-------------------------------------------------------------------------------
Processing /etc/letsencrypt/renewal/atsd.company.com.conf
-------------------------------------------------------------------------------
Cert not yet due for renewal
-------------------------------------------------------------------------------
The following certs are not due for renewal yet:
  /etc/letsencrypt/live/atsd.company.com/fullchain.pem expires on 2018-06-15 (skipped)
No renewals were attempted.
No hooks were run.
-------------------------------------------------------------------------------
```

The `--force-renewal` flag forces the certbot to request new certificates.

```sh
sudo certbot renew --force-renewal --deploy-hook "/opt/certbot/deploy-atsd.sh"
```

Be aware that renewal requests are subject to [rate limits](https://letsencrypt.org/docs/rate-limits/) and too many requests may cause 
temporarily rejections.

### Enable Auto-Renewal

The certbot automatically enables certificate renewal which is performed twice a day by default.

```sh
cat /etc/cron.d/certbot
```

The `certbot -q renew` command is executed as root.

```
# ...
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

0 */12 * * * root test -x /usr/bin/certbot -a \! -d /run/systemd/system && perl -e 'sleep int(rand(3600))' && certbot -q renew
```

Note that the cron entry does not contain any references to `--deploy-hook` because the hooks are specific to each DNS name.

To check if the `--deploy-hook` is enabled for the specific DNS name, search the `/etc/letsencrypt` directory for `renew_hook` setting.

> `renew_hook` and `deploy-hook` are synonyms.

```sh
sudo grep -nr /etc/letsencrypt -e "renew_hook"
```

The `/etc/letsencrypt/renewal/atsd.company.com.conf` file should contain the following file with the correct path.

```
/etc/letsencrypt/renewal/atsd.company.com.conf:14:renew_hook = /opt/certbot/deploy-atsd.sh
```

If the `renew_hook` is missing, open the `/etc/letsencrypt/renewal/atsd.company.com.conf` file and add the line manually.

```elm
# renew_before_expiry = 30 days
version = 0.22.2
archive_dir = /etc/letsencrypt/archive/atsd.company.com
cert = /etc/letsencrypt/live/atsd.company.com/cert.pem
privkey = /etc/letsencrypt/live/atsd.company.com/privkey.pem
chain = /etc/letsencrypt/live/atsd.company.com/chain.pem
fullchain = /etc/letsencrypt/live/atsd.company.com/fullchain.pem

# Options used in the renewal process
[renewalparams]
installer = None
account = ***********************
authenticator = standalone
webroot_path = /var/www/certbot,
# ATSD hook to upload certificate files
renew_hook = /opt/certbot/deploy-atsd.sh
[[webroot_map]]
```

Test the automated renewal configuration using the `--dry-run` flag.

```sh
sudo certbot renew --dry-run
```

Note that deploy hook command is skipped during the `--dry-run` test.
