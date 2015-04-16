###load lubridate package wihich has lots of good time code functions
library(lubridate)

## reorder and rename to final format (f15)
title2<-read.csv(f15)
name2<-gsub("\\.", "", names(dat))
name1<-toupper(name2)
names(dat)<-name1
dat<-dat[,(names(dat) %in% names(title2))]
t_add<-title2[,!(names(title2) %in% names(dat))]
dat3 <- data.frame(matrix("NA", nrow=nrow(dat),ncol=length(t_add)))
names(dat3)<-names(t_add)
dat2<-cbind(dat,dat3)
dat2<-dat2[,(names(title2))]
dat<-unique(dat2)

#gsub() and grep() are substitution and replacement functions


### Round times by increment and clean out of sequence data
### Test ladder data
### Load lubridate package
### Update.date will integrate new data into any component of POSIX.ct function
### Merges data into the gapless time series of time-related variables

# Sets the time zone to match the time zone in which the data were collected. We always kept our dataloggers on Central Standard Time.
Sys.setenv(TZ="America/Regina")

dat<-subset(dat,grepl("20..-..-.. ..:..:..", dat$TIMESTAMP))

dat$TIMESTAMP<-as.POSIXct(dat$TIMESTAMP)
#dat<-subset(dat,!minute(dat$TIMESTAMP)>0)
dat3<-round(minute(dat$TIMESTAMP)/increment)*increment
dat$TIME2<-update(dat$TIMESTAMP, min=dat3)

YEAR<-unique(year(dat$TIME2))
BLK<-unique(dat$BLOCK)
tn<- merge(YEAR,BLK)
names(tn)<-c("YEAR","BLK")
tn<-data.frame(tn)

p<-c(1:nrow(tn))
for (n in p)

{dat3<- subset(dat, year(dat$TIME2)==tn$YEAR[n] & dat$BLOCK==tn$BLK[n])

d<-c(paste(prefix,tn$YEAR[n],tn$BLK[n],sep="_"))
d<-c(paste(d,"csv",sep="."))
d<-c(paste(output_dir,d,sep="/"))

write.table(dat3,d, append = TRUE, quote = FALSE, sep = ",",
           , na = "NA", dec = ".", row.names = FALSE,
          col.names = FALSE, qmethod = c("escape", "double"))

df<-read.csv (d)
df<-unique(df) 

write.table(df,d, append = FALSE, quote = FALSE, sep = ",",
           , na = "NA", dec = ".", row.names = FALSE,
          col.names = FALSE, qmethod = c("escape", "double"))    
} 
}

j<-list.files(output_dir, pattern = NULL, all.files = FALSE,
           full.names = TRUE, recursive = TRUE,
           ignore.case = FALSE)

p<-c(1:length(j))
for (n in p)
{
dat<-read.csv(j[n])
names(dat)<- names(title2)
#dat<-unique(dat)
d<-j[n]
write.table(dat,d, append = FALSE, quote = FALSE, sep = ",",
           , na = "NA", dec = ".", row.names = FALSE,
          col.names = TRUE, qmethod = c("escape", "double"))

}}