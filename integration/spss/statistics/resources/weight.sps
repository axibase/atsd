GET DATA
  /TYPE=ODBC
  /CONNECT='DSN=ATSD;'
  /SQL='SELECT datetime, value AS "weight", tags ' +
            'FROM inflation.cpi.categories.weight ' 
  /ASSUMEDSTRWIDTH=255.

CACHE.
EXECUTE.
DATASET NAME weights WINDOW=FRONT..
