# ATSD - MySQL compression comparison

## Comparison results

| Database | Size after data input, Mb |
| -------- | --------------------- |
| ATSD | |
| MySQL (metrics columns / not compressed) | 145.27 |
| MySQL (metrics columns / compressed) | 79.66 |
| MySQL (foreign key to metrics / not compressed) | 849.70 |
| MySQL (foreign key to metrics / compressed) | 389.36 |

## Test description

* Create directory **/tmp/storage-test**

```
mkdir /tmp/storage-test
cd /tmp/storage-test
```

* Download dataset and script files

```
curl -o IBM_adjusted.txt "http://api.kibot.com/?action=history&symbol=IBM&interval=1&unadjusted=0&bp=1&user=guest"
curl -o test.sql "https://raw.githubusercontent.com/axibase/atsd/administration/compaction/mysql-trade-table.sql"
curl -o test.sql "https://raw.githubusercontent.com/axibase/atsd/administration/compaction/mysql-universal-table.sql"
```

* Check that files are not empty

```
wc -l *
```

Output should look like the following

```
2045926 IBM_adjusted.txt
       95 mysql-trade-table.sql
      182 mysql-universal-table.sql
  2046203 total

```

* Install MySQL docker image. Mount directory to container filesystem (-v parameter).

```
docker run --name mysql-axibase-storage-test \
    -e MYSQL_ROOT_PASSWORD=axibase \
    -e MYSQL_DATABASE=axibase \
    -e MYSQL_USER=axibase \
    -e MYSQL_PASSWORD=axibase \
    --publish 3306:3306  \
    -v /tmp/storage-test:/data \
    -d mysql/mysql-server:5.7
```

* Run **mysql-trade-table.sql** and **mysql-universal-table.sql**

```
docker exec mysql-axibase-storage-test bash -c "mysql --user=axibase --password=axibase --database=axibase < /data/mysql-trade-table.sql"
docker exec mysql-axibase-storage-test bash -c "mysql --user=axibase --password=axibase --database=axibase < /data/mysql-universal-table.sql"
```

* Data consumption statistics will be printed after the test is completed

```
Data (not compressed)	Index (not compressed)	Total (not compressed)
127582208	42565632	170147840
Data (compressed)	Index (compressed)	Total (compressed)
62758912	21815296	84574208
```