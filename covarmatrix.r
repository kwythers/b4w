dl = read.csv('/Volumes/disk7/modeling/pnet_dev/matlab/input/detroitlakes_monthly.dat')
dlcovmatrix = cov(foo, foo)
for(i in 1:12){
	dl_i = subset(dl, month == i,select=c('tmax','tmin','par','precip'))
	dlcovmatrix_i = cov(dl_i, dl_i)
	file_i = paste("/Volumes/disk7/modeling/pnet_dev/matlab/input/dlcovmatrix_",i,".csv",sep="")
	write.csv(dlcovmatrix_i,file=file_i,row.names=FALSE,col.names=NA)	
}