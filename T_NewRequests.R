
## load("twins.Rdata")

## #################################




## ff<-function(L) {
##     library(parallel)
##     f<-function(x,rho=.5) {
##         herit<-h2(x,'del_1','del_2',rho=rho)
##         tmp<-list()
##         ## for (i in 1:100) tmp[[i]]<-x[sample(1:nrow(x),nrow(x),replace=TRUE),]
##         ## se<-mclapply(tmp,h2,mc.cores=20,
##         ##              nm1='del_1',nm2='del_2',rho=rho
##         ##              )
##         #c(herit,quantile(unlist(se),c(.025,.975)))
##         herit
##     }    
##     herit<-lapply(L,f)
##     mat<-do.call("rbind",herit)
## }

## ## - percent stunting (area level)
## L<-list()
## for (i in seq(.05,.75,by=.05)) {
##     tmp<-x[abs(x$stunted_strata-i)<=.1,]
##     L[[as.character(i)]]<-data.frame(del_1=tmp$del_1,del_2=tmp$del_2,diff.sex=tmp$diff.sex)
## }
## mat<-ff(L)
## ages<-as.numeric(rownames(mat))
## plot(ages,mat,xlab="stunted strata",ylab="h2",type='l',ylim=c(0,.7))

## ## - quantiles of child haz (so may be less than -3SD, -3to-2SD, -2to-1 and then the positive side. Or if we can simplify the 3rd category to be rest of the kids
## z<-rowMeans(x[,c("del_1","del_2")])
## qu<-quantile(z,1:4/5)
## x$gr<-cut(z,c(-Inf,qu,Inf))
## L<-split(x,x$gr)    
## mat<-ff(L)
## mat



## ## - categories of maternal height
## qu<-quantile(x$mother_cm,1:4/5,na.rm=TRUE)
## x$gr<-cut(x$mother_cm,c(-Inf,qu,Inf))
## L<-split(x,x$gr)    
## mat<-ff(L)
## mat
