# Visualizing nmon Files in ad-hoc Mode

ATSD provides ad-hoc visualization of Linux and AIX `nmon` files.

This means that you can upload any `nmon` file or an archive of `nmon` files into ATSD and instantly view the data in a pre-configured portal.

![](./resources/nmon_adhoc_process.gif)

## Visualizing Data in nmon Files

### Download nmon Portals

`nmon` Linux: [nmon_Linux](https://axibase.com/public/nmon_Linux.xml)

`nmon` AIX: [nmon_AIX.xml](https://axibase.com/public/nmon_AIX.xml)

#### Import the portal

This is a one time task.

* Open the **Portals > Configure** page.
* At the bottom of the page click **Import** and select either the downloaded `nmon_AIX` or `nmon_Linux` portal. If you are collecting data from AIX systems, choose `nmon_AIX`. If you are collecting data from Linux systems, choose `nmon_Linux`.
* On the **Portals** page, keep a note of the unique portal ID that you just imported.

![](./resources/portals_import.png)

### Upload the nmon File

* Open the **Data > `nmon` Parsers** page.
* At the bottom of the page, click **Upload** to import your `nmon` file or archive of `nmon` files using the default `nmon` parser.
* Keep a note of the hostname for which you have just uploaded the data.

You can learn more about uploading `nmon` files into ATSD
[here](./file-upload.md).

![](./resources/nmon_upload1.png "nmon_upload")

### View the Data

* Open the below URL. Replace `atsd_hostname` with your ATSD URL, **hostname** with the hostname for which you have uploaded the `nmon` file, and `portal_id` with your portal ID:

    `https://atsd_hostname:8443/portal/tabs?entity=hostname&id=portal_id`

![](./resources/AIX_nmon_portal1.png "AIX_nmon_portal")
