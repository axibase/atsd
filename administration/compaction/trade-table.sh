#!/bin/bash

printf "Database size provided by storage engine\n"
cat mysql-trade-table-raw.sql | docker exec -i mysql-axibase-storage-test mysql --user=axibase --password=axibase --database=axibase --table

printf $"\nDatabase file size\n"
docker exec mysql-axibase-storage-test sh -c "stat -c '%s %n'  /var/lib/mysql/axibase/TradeHistory.ibd"

printf $"\nDatabase size provided by storage engine\n"
cat mysql-trade-table-compressed.sql | docker exec -i mysql-axibase-storage-test mysql --user=axibase --password=axibase --database=axibase --table

printf $"\nDatabase file size\n"
docker exec mysql-axibase-storage-test sh -c "stat -c '%s %n'  /var/lib/mysql/axibase/TradeHistory.ibd"

