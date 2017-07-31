clear
odbc load, exec("SELECT value as price, tags.category as category, datetime FROM 'inflation.cpi.categories.price' ORDER BY datetime, category") dsn("ODBC_JDBC_SAMPLE")
save prices
clear
odbc load, exec("SELECT datetime FROM 'inflation.cpi.categories.price' GROUP BY datetime ORDER BY datetime") dsn("ODBC_JDBC_SAMPLE")
save datetimes
clear
odbc load, exec("SELECT tags.category as category, value as weight FROM 'inflation.cpi.categories.weight' ORDER BY datetime, category") dsn("ODBC_JDBC_SAMPLE")
cross using datetimes
merge 1:1 category datetime using prices
drop category _merge
generate inflation = weight * price / 1000
drop weight price
bysort datetime : egen value = total(inflation)
sort datetime value
by datetime value :  gen dup = cond(_N==1,0,_n)
drop if dup>1
drop dup inflation
generate entity = "bls.gov"
generate datetime_str = string(datetime, "%tcCCYY-NN-DD!THH:MM:SS.sss!Z")
set odbcdriver ansi
odbc insert entity datetime_str value, as("entity datetime value") table("inflation.cpi.composite.price") dsn("ODBC_JDBC_SAMPLE") block
