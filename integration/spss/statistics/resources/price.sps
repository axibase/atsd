GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=ATSD;'
  /SQL='SELECT datetime, value AS "price", tags ' +
            'FROM inflation.cpi.categories.price '
  /ASSUMEDSTRWIDTH=255.

CACHE.
EXECUTE.
DATASET NAME prices WINDOW=FRONT..
