# Editing Configuration Files

The configuration file editor is located on the **Settings > Configuration Files** page and allows the editing of configuration
files in the web interface.

<!-- markdownlint-enable MD032 -->
:::warning
Only files located in the
`/opt/atsd/atsd/conf` directory can be edited.
:::
<!-- markdownlint-disable MD032 -->

Modifying files via the user interface is useful for files that are automatically reloaded, such as `logback.xml` to adjust [logging levels](./logging.md#applying-changes) or `graphite.conf` to customize command [mapping rules](../integration/graphite/graphite-format.md).

![](./images/config-editor.png "configuration_files_editor")
