
#### Load libraries ####
library(lubridate)
library(data.table)
library(Rmisc)

#### Read derived data into a new data table ####
data_path<-"/Volumes/disk7/b4warmed3/query_output/60min/derived60min_vf8new.csv"
dt<-fread(data_path)
Sys.setenv(TZ="America/Regina") #set timezone

#### Create functions #### 
meanrm<-function(x){ mean(x, na.rm = TRUE)} ## meantrim average
sdrm<-function(x){ sd(x, na.rm = TRUE)} ## standard deviation average
serm <- function(x){sqrt(var(x, na.rm = TRUE) / length(na.omit(x)))} ## standard error average
cirm <- function(x){CI(x, ci = 0.95)} ## still has an issue with na.rm

##### aggregate by week ####
dt$week<-week(dt$time2) ## put week info from time2 into week variable
dt[,time3:=as.POSIXct(time2)] ## add time3 variable and fill with data from time2 as.posix
dt[,time4:=ceiling_date(time3,"week")] ## add time4 and fill with data from time3 rounded up to the nearest week

exp0<-c("time4","site","canopy","power","year","doy","week","treatment_abbr") # group by or aggrigation variable
exp1<-c("time4","site","canopy","power","year","week","treatment_abbr") # group by or aggrigation variable
name1<-c("p_above_meanf2_dc2_new3","d_tsoilf2_dc2_new3","p_tabovef2_sc_new3","d_tsoilf2_sc_new3","p_tabovef2_delta_new3", "d_tsoilf2_delta_new3") # vector of original columns names
name2<-c("tabovefill_ambient","tsoilfill_ambient","tabovefill","tsoilfill","tabovefill_delta","tsoilfill_delta") # vector of new column names
namese<-c("se_tabovefill_ambient","se_tsoilfill_ambient","se_tabovefill","se_tsoilfill","se_tabovefill_delta","se_tsoilfill_delta") # vector of se column names
namesd<-c("sd_tabovefill_ambient","sd_tsoilfill_ambient","sd_tabovefill","sd_tsoilfill","sd_tabovefill_delta","sd_tsoilfill_delta") # vector of sd column names
nameci<-c("ci_tabovefill_ambient","ci_tsoilfill_ambient","ci_tabovefill","ci_tsoilfill","ci_tabovefill_delta","ci_tsoilfill_delta") # vector of ci column names

res1<-c("p_above_meanf2_dc2_new3","d_tsoilf2_dc2_new3","p_tabovef2_sc_new3","d_tsoilf2_sc_new3","d_airtemp_avg","d_airtemp_max", "d_airtemp_min","d_ws_ms_avg","d_vwc_corr_sc","dd_rh", "dd_vp","dd_airtc","p_tabovef2_delta_new3", "d_tsoilf2_delta_new3") # vector of environmental variable names
res2<-c("p_above_meanf2_dc2_new3","d_tsoilf2_dc2_new3","p_tabovef2_sc_new3","d_tsoilf2_sc_new3","p_tabovef2_delta_new3", "d_tsoilf2_delta_new3") # vector of environmental variable names

##### create subset by doy using exp0 ####
#sub0<-c(exp0,res1)  
#dt0<-subset(dt, select=sub0)
#dt0<-dt0[ year>2008,]
#dt0<-dt0[treatment_abbr=="h1"|treatment_abbr=="h2"|treatment_abbr=="dc",lapply(.SD,meanrm), by=exp0] 

sub1<-c(exp1,res1)
dt2<-subset(dt, select=sub1)
dt2<-dt2[ year>2008,] 
dt3<-dt2[treatment_abbr=="h1"|treatment_abbr=="h2"|treatment_abbr=="dc",lapply(.SD,meanrm), by=exp1]

sub2<-c(exp1,res2)
dt2<-subset(dt, select=sub2)
dt2<-dt2[ year>2008,] # krw removed power==1 & to keep full year data
dtse<-dt2[treatment_abbr=="h1"|treatment_abbr=="h2"|treatment_abbr=="dc",lapply(.SD,serm), by=exp1]

sub2<-c(exp1,res2)
dt2<-subset(dt, select=sub2)
dt2<-dt2[ year>2008,] # krw removed power==1 & to keep full year data
dtsd<-dt2[treatment_abbr=="h1"|treatment_abbr=="h2"|treatment_abbr=="dc",lapply(.SD,sdrm), by=exp1]

sub2<-c(exp1,res2)
dt2<-subset(dt, select=sub2)
dt2<-dt2[ year>2008,] # krw removed power==1 & to keep full year data
dtci<-dt2[treatment_abbr=="h1"|treatment_abbr=="h2"|treatment_abbr=="dc",lapply(.SD,cirm), by=exp1]

setnames(dt3,name1,name2)
setnames(dtse,name1,namese)
setnames(dtsd,name1,namesd)
setnames(dtci,name1,nameci)
dt5<-dt3

dt5<-merge(dt5,dtse, by=exp1, all=TRUE)  ## krw added 'by' argument explicitly
dt5<-merge(dt5,dtsd, by=exp1, all=TRUE)  ## krw added 'by' argument explicitly
dt5<-merge(dt5,dtci, by=exp1, all=TRUE)  ## krw added 'by' argument explicitly

#### Write data to file ####
write_path<-"/Volumes/disk7/b4warmed3/query_output/ambient_temps_2009-2012_week_sc.csv"
write.table(dt5, write_path, append = FALSE, quote = FALSE, sep = ",",
            , na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = c("escape", "double"))
















