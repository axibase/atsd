# Editing Configuration Files

The configuration file editor is located on the **Settings > Configuration Files** page and allows the editing of configuration
files in the web interface.

:::warning
Only files located in the
`/opt/atsd/atsd/conf` directory can be edited.
:::

Modifying files via the user interface is helpful for files that are automatically reloaded, such as `logback.xml` to adjust [logging levels](./logging.md#applying-changes) or `graphite.conf` to customize command [mapping rules](../integration/graphite/graphite-format.md).

![](./images/config-editor.png "configuration_files_editor")
