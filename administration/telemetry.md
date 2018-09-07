# Telemetry

## Overview

ATSD contains modules that are designed to improve user experience and enhance product quality while delivering timely notifications to customer about new database releases. The modules collect usage information that helps us prioritize product development with the customer priorities in mind.

## Version Check

ATSD instance checks availability of new versions by sending a request via HTTPS protocol to `axibase.com`.

The request is submitted at start time and on a daily basis.

The request payload contains the current version number, OS name and version, hardware memory size, as well as basic usage statistics (counters) for the database itself.

No information about named records (such as entity names or configuration objects) is included in the payload.

## Referrer

When opening external documentation links in the ATSD web interface, the browser transmits HTTP referrer header containing the ATSD URL to `axibase.com`.

## Support Notification

For users with administrative roles, the **Support** tab in the ATSD user interface performs a check of the latest available ATSD version by sending a request via HTTPS protocol to `axibase.com`. The payload does not contain any database information.

## Email Subject

When a user clicks an email link on the **Support** tab, the link opens a message in the local email client with the subject line containing the database version. The subject can be modified by the user.