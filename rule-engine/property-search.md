# Property Search Syntax

```ls
<property_type>:[<key>=<value>[,<key>=<value>]]:<tag_name>
```

The expression returns tag values for the specified property type, optional key-value pairs, and the tag name.

* `<property_type>` is required.
* `<key>=<value>` section is optional. Multiple key-value pairs must be separated with comma. <br>`<value>` supports `?` and `*` wildcards.
* `<tag_name>` is required, supports `?` and `*` wildcards.

The returned set contains only distinct values.

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
