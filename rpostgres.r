## Fetches table with selected entries.
library(RPostgreSQL)

## load the PostgreSQL driver
drv <- dbDriver("PostgreSQL")

## Open a connection
conn <- dbConnect(drv, dbname="b4warmed3", host="truffula.fr.umn.edu", user="kirkw", password="theLor@x61", port=54321)

dbListTables(conn)

rs <- dbSendQuery(conn, "select time2,site,block,plot,dd_airtc,d_tabovef2_sc,dd_rh,dd_vp from _derived60min")

derived60min <- fetch(rs,n=-1)

derived60min <- as.data.table(derived60min)

setkey(derived60min, time2, plot) 

### Merge the two datatables. The second table [in brackets] controlls the merge
### ib <- derived60min[dib_hourly]

ib <- dib_hourly[derived60min]

write.table(ib, "~/Desktop/ib.txt", sep="\t")