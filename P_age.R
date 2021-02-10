## load("twins.Rdata")

## #################################


## y<-x[,c("height_1","height_2")]
## xx<-x[,c("age","survey_year")]
## z<-residualize(y=y,x=xx)
## x$htr_1<-z[,1]
## x$htr_2<-z[,2]

## ##split at 2y
## y<-x[x$age<=24,]
## h2(y,'htr_1','htr_2',rho=0.5)
## y<-x[x$age>24,]
## h2(y,'htr_1','htr_2',rho=0.5)


## ##rolling window
## L<-list()
## for (i in seq(6,48,by=1)) {
##     tmp<-x[abs(x$age-i)<=3,]
##     y<-tmp[,c("height_1","height_2")]
##     xx<-tmp[,c("age","survey_year")]
##     z<-residualize(y=y,x=xx)
##     L[[as.character(i)]]<-data.frame(htr_1=z[,1],htr_2=z[,2],diff.sex=tmp$diff.sex)
## }
## library(parallel)
## f<-function(x,rho=.5) {
##     herit<-h2(x,'htr_1','htr_2',rho=rho)
##     tmp<-list()
##     for (i in 1:100) tmp[[i]]<-x[sample(1:nrow(x),nrow(x),replace=TRUE),]
##     se<-mclapply(tmp,h2,mc.cores=20,
##                  nm1='htr_1',nm2='htr_2',rho=rho
##                  )
##     c(herit,quantile(unlist(se),c(.025,.975)))
## }    
## herit<-lapply(L,f)
## save(herit,file="h2_age.Rdata")


## mat<-do.call("rbind",herit)
## ages<-as.numeric(rownames(mat))
## pdf("/home/bd/Dropbox/Apps/Overleaf/twins_nozygosity/h2_age.pdf",width=4,height=4)
## par(mgp=c(2,1,0),mar=c(3,3,1,1))
## plot(ages,mat[,1],type='l',pch=19,lwd=2,ylim=c(0,.7),xlab='age (m)',ylab=expression(h^2))
## cc<-col2rgb("blue")
## cc<-rgb(cc[1],cc[2],cc[3],alpha=100,max=255)
## polygon(c(ages,rev(ages)),c(mat[,2],rev(mat[,3])),col=cc)
## legend("bottomright",bty='n',legend=bquote(rho==0.5))
## dev.off()



## #################################
## ##unresidualized
## x<-read.csv("twins_allDHS.csv")
## x$diff.sex<- ifelse(x$female_1!=x$female_2,1,0)
## L<-list()
## for (i in seq(6,48,by=1)) {
##     tmp<-x[abs(x$age-i)<=3,]
##     L[[as.character(i)]]<-data.frame(htr_1=tmp$height_1,htr_2=tmp$height_2,diff.sex=tmp$diff.sex)
## }
## library(parallel)
## f<-function(x,rho=.5) {
##     herit<-h2(x,'htr_1','htr_2',rho=rho)
##     tmp<-list()
##     #for (i in 1:100) tmp[[i]]<-x[sample(1:nrow(x),nrow(x),replace=TRUE),]
##     #se<-mclapply(tmp,h2,mc.cores=20,
##     #             nm1='htr_1',nm2='htr_2',rho=rho
##     #             )
##     #c(herit,quantile(unlist(se),c(.025,.975)))
##     herit
## }    
## herit<-lapply(L,f)

## mat<-do.call("rbind",herit)
## ages<-as.numeric(rownames(mat))
## plot(ages,mat[,1],type='l',pch=19,lwd=2,ylim=c(0,.7),xlab='age (m)',ylab=expression(h^2))






    
