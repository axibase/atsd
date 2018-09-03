# Property Search Syntax

```ls
{property_type}:[{key_name}={key_value}[,{key_name}={key_value}]]:{tag_name}
```

The above expression returns tag values for the specified property type, optional key-value pairs, and the tag name.

* `{property_type}` is required.
* `{key_name}={key_value}` section is optional. Multiple key-value pairs must be separated by comma. <br>`{key_value}` supports `?` and `*` wildcards.
* `{tag_name}` is required, supports `?` and `*` wildcards.

The returned set contains distinct tag values.

## Examples

```javascript
/*
type = docker.container
key = empty
tag = image
*/

docker.container::image
```

---

```javascript
/*
type = linux.disk
key = fstype=ext4
tag = mount_point
*/

linux.disk:fstype=ext4:mount_point
```

---

```javascript
/*
type = linux.disk
key = fstype=ext4,name=sda
tag = mount_point
*/

linux.disk:fstype=ext4,name=sda:mount_point
```

---

```javascript
/*
Returns all tags for disks with key 'id' starting with 'sd'
*/

disk:id=sd*:*
```

---

```javascript
/*
Returns tags ending with 'kb/s' for records with key 'id' starting with 'sd'
*/

disk:id=sd*:*kb/s
```
