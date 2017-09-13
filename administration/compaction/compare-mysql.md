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

* Download [dataset](http://api.kibot.com/?action=history&symbol=IBM&interval=1&unadjusted=0&bp=1&user=guest) file and test [script](scripts/test.sql) and put them in one directory (here **/home/alexey/Downloads/data**)

* Install MySQL docker image. Mount directory to container filesystem (-v parameter).

```
docker run --name mysql \
    -e MYSQL_ROOT_PASSWORD=root_password \
    -e MYSQL_DATABASE=mysqldb \
    -e MYSQL_USER=user \
    -e MYSQL_PASSWORD=password \
    -e MYSQL_ROOT_HOST=172.17.0.1 \
    --publish 3306:3306  \
    -v /home/alexey/Downloads/data:/data \
    -d mysql/mysql-server:5.7
```

MYSQL_ROOT_HOST option is required to allow external connections to the docker container. *172.17.0.1* is a default docker gateway.

* Enter **mysql** container

```
docker exec -it mysql bash
```

* Run **test.sql**. Note that test may last up to 30 minutes.

```
mysql mysqldb -u user -p < /data/test.sql 
```

* Data consumption statistics will be printed after test finish

```
Table with metrics columns size (not compressed) in MB
145.26562500
Table with metrics columns size (compressed) in MB
79.66406250
Table with foreign key to metrics size (not compressed) in MB
849.70312500
Table with foreign key to metrics size (not compressed) in MB
389.35937500

```