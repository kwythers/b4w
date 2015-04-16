# Purpose: altering timestamp from ibuttons data from B4WARMED

# open raw data file
ibuttons <- fread("~/Desktop/Ibutton_2012_2013.txt",header=TRUE)
ibuttons$minute2 = round(ibuttons$Minute/15)*15
ibuttons$minute2[ibuttons$minute2==60]=0
ibuttons$timestamp_15min = as.POSIXct(paste(ibuttons$Year,"-",ibuttons$Month,"-",ibuttons$Day," ",ibuttons$Hour,":",ibuttons$minute2,":00",sep=""))

library (data.table)
ib<-ibuttons

###fix col names with setnames
setnames(ib,"Date/Time","date_time")
setnames(ib,"Year","year")
setnames(ib,"Month","month")
setnames(ib,"Day","day")
setnames(ib,"DOY","doy")
setnames(ib,"Hour","hour")
setnames(ib,"Minute","minute")
setnames(ib,"Plot ID","plot_id")
setnames(ib,"RH %","rh")
setnames(ib,"Temp C","temp")
setnames(ib,"Site","site")
setnames(ib,"canopy condition","canopy")
setnames(ib,"station name","station")
setnames(ib,"treatement name","warm_trt")
setnames(ib,"soil cable condition","soil_trt")
setnames(ib,"treatment code","trt_code")
setnames(ib,"treatment abbreviation","trt_abbr")
setnames(ib,"water trt","water_trt")
setnames(ib,"vwc heat code","vwc_code")

setkey(ib,timestamp_15min)

###columns I give a shit about
cols <- c("timestamp_15min","site","canopy","block","plot_id","station","warm_trt","soil_trt","trt_code","trt_abbr","water_trt","vwc_code","vwc","rh","temp")

###columns I give a shit about, excluding aggregated variables
cols2 <- c("timestamp_15min","site","canopy","block","plot_id","station","warm_trt","soil_trt","trt_code","trt_abbr","water_trt","vwc_code","vwc")

cols3 <- c("timestamp_15min","plot_id")

ib2 <- subset(ib,select=cols)

drh <- ib2[,mean(rh, na.rm=TRUE),by = cols2]
setnames(drh,"V1","rh")
setkey(drh, timestamp_15min, plot_id) 

dtemp<-ib2[,mean(temp, na.rm=TRUE),by = cols3]
setnames(dtemp,"V1","temp")
setkey(dtemp, timestamp_15min, plot_id)

dib <- drh[dtemp]


##hourly aggrigation
dib_hourly <- dib[,newtime:=update(timestamp_15min,min=0),]

cols4 <- c("newtime","site","canopy","block","plot_id","station","warm_trt","soil_trt","trt_code","trt_abbr","water_trt","vwc_code","vwc")

cols5 <- c("newtime","plot_id")

drh_hourly <- dib_hourly[,mean(rh, na.rm=TRUE),by = cols4]
setnames(drh_hourly,"V1","rh")
setkey(drh_hourly, newtime, plot_id) 

dtemp_hourly <- dib_hourly[,mean(temp, na.rm=TRUE),by = cols5]
setnames(dtemp_hourly,"V1","temp")
setkey(dtemp_hourly, newtime, plot_id)

dib_hourly <- drh_hourly[dtemp_hourly]

###Onestep hourly
#dib2 <- dib
#dib2[,rh_hourly:=mean(rh, na.rm=TRUE),by =cols5]
#dib2
