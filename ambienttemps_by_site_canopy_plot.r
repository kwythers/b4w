## create a 4 pannel figure of weekly airtemp means and standard devitations by site and canopy
library(ggplot2)
library(scales)

read_path <- "/Volumes/disk7/b4warmed3/query_output/ambient_temps_2009-2012_week_sc.csv"

#df <- read.table(path, header = T, sep = ",")
#df <- df[df[,7] == "dc",]

dt <- fread(read_path)
dt <- dt[treatment_abbr == 'dc',]
dt1 <- dt[, time4:=as.POSIXct(time4)]
dt2 <- dt1[year>2009,]
dt3 <- dt2[, year:=as.factor(year)]


qplot(time4, tabovefill_ambient, data = dt2,
#scale_y_continuous(limits = c(-15, 25)),
#scale_x_continuous(limits = 2011, 2012), 
geom = c("point", "smooth"),
method = "lm",
facets = ~ site + canopy,
xlab="Time",
ylab="Ambient Aboveground Temperature (C)")



ggplot(dt3, aes(x = as.Date(time4), y = tabovefill_ambient)) + 
  geom_line() + 
  geom_ribbon(aes(ymin = tabovefill_ambient - sd_tabovefill_ambient, ymax = tabovefill_ambient +sd_tabovefill_ambient), alpha=0.2) + 
  #geom_errorbar(aes(ymin=tabovefill_ambient - sd_tabovefill_ambient, ymax=tabovefill_ambient + sd_tabovefill_ambient), width=.1) + 
  #stat_smooth() + 
  facet_wrap(~ site + canopy) + 
  theme_bw() + 
  #labs(title = "Aboveground weekly mean temp by site and canopy") +
  xlab("Year") + 
  ylab("Temperature (°C)") + 
  scale_y_continuous(breaks = seq(-15, 25, 5)) +
  scale_x_date(labels = date_format("%m-%Y"),breaks = "6 month") 
  


ggplot(dt3, aes(x = as.Date(time4), y = tabovefill_ambient, color = factor(year))) + 
  geom_point() + 
  geom_errorbar(aes(ymin=tabovefill_ambient - se_tabovefill_ambient, ymax=tabovefill_ambient + se_tabovefill_ambient), width=.1) + 
  stat_smooth() + 
  facet_wrap(~ site + canopy) + 
  theme_bw() + 
  labs(title = "Aboveground ambient temp by site and canopy") +
  xlab("") + 
  ylab("°C") + 
  scale_y_continuous(breaks = seq(-15, 25, 5)) + 
  scale_x_date(breaks = date_breaks("years"))

