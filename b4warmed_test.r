# -*- coding: utf-8 -*-
library(RODBC)
con <- odbcConnect("b4warmed")
sqlQuery(con, "
SELECT * FROM channels
JOIN treatments USING (treatment_id)
")
