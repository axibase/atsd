* Encoding: UTF-8.

GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=ATSD;'
  /SQL='SELECT datetime, value ' +
            'FROM gc_time_percent ' +
            'LIMIT 10'
  /ASSUMEDSTRWIDTH=255.

CACHE.
EXECUTE.
DATASET NAME DataSet5 WINDOW=FRONT.