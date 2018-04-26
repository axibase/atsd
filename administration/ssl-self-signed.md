# Installing Self-signed SSL Certificate

## Overview

The default certificate installed in ATSD is generated for DNS name 'atsd'. This document describes the process of creating and installing a self-signed SSL certificate to match the actual DNS name used by clients when accessing ATSD user interface and HTTP API.

As with all self-signed certificates, the new certificate will still cause a security exception in user browsers and will require passing `-k/--insecure` parameter when connecting to ATSD using `curl` and similar tools in order to skip certificate validation.

## Create and Import Certificate

There are to options to create and import self-signed certificates into ATSD:

* [ATSD UI](#atsd-ui)
* [HTTP Query](#http-query)

### ATSD UI

Navigate to **Settings > Certificates** page and click on **Self Signed Certificate** on the multi-action button:

![](images/ssl_self_signed_1.png)

![](images/ssl_self_signed_2.png)

Fill in the fields and click on **Create And Import**:

![](images/ssl_self_signed_3.png)

> Note only _Domain Name_ field is required, _Country Code_ must contain two letters if specified.

### HTTP Query

Replace `{USR}` with the username, `{PWD}` with the password, `{HOST}` with the hostname or IP address of the target ATSD server and specify appropriate parameters in the command below.

```elm
curl -k -u {USR}:{PWD} https://{HOST}:8443/admin/certificates/self-signed \
  -d "domainName=atsd.customer_domain.com" \
  -d "organizationalUnit=Software Group" \
  -d "organization=Axibase Corporation" \
  -d "cityOrLocality=Cupertino" \
  -d "stateOrProvince=CA" \
  -d "countryCode=US" \
  -w "\n%{http_code}\n"

302
```
> Note only _domainName_ field is required, _countryCode_ must contain two letters if specified.

## Verify Certificate

Log in to ATSD by entering DNS name in the browser address bar.

Review the new certificate and check its **Days to Expiration**, which is set to 364 from now.