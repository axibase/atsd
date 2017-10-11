# Property Search Syntax

```sh
<property_type>:[<key>=<value>[,<key>=<value>]]:<tag_name>
```

The expression returns a collection of unique tag values located for the given property type, optional keys, and tag.

* <property_type> is required
* \<key>=\<value> section is optional
* <tag_name> is required

## Examples

```
docker.container::image
```

```
linux.disk:fstype=ext4:mount_point
```

```
linux.disk:fstype=ext4,name=sda:mount_point
```
