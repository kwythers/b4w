library(data.table)
library(lubridate)
library(reshape2)

fulltable <- fread("~/Google Drive/b4w/user_2009-2012_hourly.csv")
as.POSIXct(fulltable$timestamp)
cols <- c("site","block","plot","canopy","power","timestamp","year","month","week","hour","doy","daylight","tabovefill")

meanrm<-function(x){ mean(x, na.rm = TRUE)} ## meantrim average

gddtable <- subset(fulltable, select=cols)

gdd2009 <- gddtable[year==2009,]
gddr2010 <- gddtable[year==2010,]
gdd2011 <- gddtable[year==2011,]
gdd2012 <- gddtable[year==2012,]

gdd2009[,time3:=ceiling_date(timestamp,"day")]







