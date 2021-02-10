## load("twins.Rdata")

## ###################################
## ##rho
## rho<- seq(.3,.7,by=.1)
## f<-function(rho,x) {
##     y<-x[,c("waz_1","waz_2")]
##     y<-x[rowSums(is.na(y))==0,]
##     herit.waz<-h2(y,'waz_1','waz_2',rho=rho)
##     y<-x[,c("whz_1","whz_2")]
##     y<-x[rowSums(is.na(y))==0,]
##     herit.whz<-h2(x,'whz_1','whz_2',rho=rho)
##     y<-x[,c("birthweight_1","birthweight_2")]
##     y<-x[rowSums(is.na(y))==0,]
##     herit.birthweight<-h2(x,'birthweight_1','birthweight_2',rho=rho)
##     y<-x[,c("hemoglobin_1","hemoglobin_2")]
##     y<-x[rowSums(is.na(y))==0,]
##     herit.hemoglobin<-h2(x,'hemoglobin_1','hemoglobin_2',rho=rho)
##     c(rho=rho,waz=herit.waz,whz=herit.whz,bw=herit.birthweight,hemo=herit.hemoglobin)
## }    
## library(parallel)
## herit<-mclapply(rho,f,x=x,mc.cores=length(rho))
## tmp<-do.call("rbind",herit)


## plot(NULL,xlim=c(.2,.8),ylim=0:1,xlab='rho',ylab='h2')
## for (i in 2:ncol(tmp)) {
##     lines(tmp[,1],tmp[,i],lwd=2)
##     text(tmp[1,1],tmp[1,i],pos=2,colnames(tmp)[i],cex=.7)
##     N<-nrow(tmp)
##     text(tmp[N,1],tmp[N,i],pos=4,colnames(tmp)[i],cex=.7)
## }



