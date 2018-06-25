# Select Entity Tags as Columns

## Query

```sql
SELECT entity, entity.tags.os AS os, entity.tags.ip AS ip, avg(value), tags.*
  FROM "df.disk_used"
WHERE time > now - 1*HOUR
  GROUP BY entity, tags
ORDER BY time
```

## Results

```ls
| entity       | os    | ip          | avg(value)   | tags.file_system                                       | tags.mount_point          |
|--------------|-------|-------------|--------------|--------------------------------------------------------|---------------------------|
| nurswgvml009 | null  | 192.0.2.8  | 12385323.0   | /dev/mapper/vg_nurswgvml009-lv_root                    | /                         |
| nurswgvml009 | null  | 192.0.2.8  | 31157038.7   | /dev/sdb1                                              | /opt                      |
| nurswgvml010 | Linux | 192.0.2.9  | 1698750587.0 | //u113452.your-backup.de/backup                        | /mnt/u113452              |
| nurswgvml010 | Linux | 192.0.2.9  | 1698750587.0 | //u113452.your-backup.de/backup/jenkins_data           | /mnt/u113452/jenkins_data |
| nurswgvml010 | Linux | 192.0.2.9  | 7054849.2    | /dev/sda1                                              | /                         |
| nurswgvml010 | Linux | 192.0.2.9  | 31646605.9   | /dev/sdb1                                              | /app                      |
| nurswgvml006 | Linux | 192.0.2.5  | 1698750587.0 | //u113452.your-backup.de/backup                        | /mnt/u113452              |
| nurswgvml102 | Linux | 192.0.2.1  | 1698750587.0 | //u113452.your-backup.de/backup                        | /mnt/u113452              |
| nurswgvml102 | Linux | 192.0.2.1  | 1550235.9    | /dev/disk/by-uuid/8a5a178f-4dba-4282-803a-1fe43fc6220a | /                         |
| nurswgvml006 | Linux | 192.0.2.5  | 5735890.2    | /dev/mapper/vg_nurswgvml006-lv_root                    | /                         |
| nurswgvml006 | Linux | 192.0.2.5  | 50264651.5   | /dev/sdc1                                              | /media/datadrive          |
| nurswgvml102 | Linux | 192.0.2.1  | 1550235.9    | rootfs                                                 | /                         |
| nurswgvml502 | null  | null        | 1698750587.0 | //u113452.your-backup.de/backup                        | /mnt/u113452              |
| nurswgvml502 | null  | null        | 31223464.6   | /dev/sda1                                              | /                         |
| nurswgvml007 | Linux | 192.0.2.6  | 1698750587.0 | //u113452.your-backup.de/backup                        | /mnt/u113452              |
| nurswgvml007 | Linux | 192.0.2.6  | 9198061.4    | /dev/mapper/vg_nurswgvml007-lv_root                    | /                         |
| nurswgvml011 | Linux | 192.0.2.10 | 1698750587.0 | //u113452.your-backup.de/backup                        | /mnt/u113452              |
| nurswgvml011 | Linux | 192.0.2.10 | 6811290.5    | /dev/sda1                                              | /                         |
```