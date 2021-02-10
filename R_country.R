## load("twins.Rdata")

## y<-x[,c("height_1","height_2")]
## xx<-x[,c("age","survey_year")]
## z<-residualize(y=y,x=xx)
## x$htr_1<-z[,1]
## x$htr_2<-z[,2]


## tab<-table(x$country)
## countries<-names(tab)[tab>500]
## L<-split(x,x$country)
## L<-L[names(L) %in% countries]

## ###################################
## ##rho
## herit<-list()
## for (i in 1:length(L)) {
##     x<-L[[i]]
##     rho<- seq(.4,.6,by=.025)
##     f<-function(rho,x) {
##         #herit.ht<-h2(x,'height_1','height_2',rho=rho)
##         #herit.haz<-h2(x,'haz_1','haz_2',rho=rho)
##         herit.htr<-h2(x,'htr_1','htr_2',rho=rho)
##         #c(herit.ht=herit.ht,herit.haz=herit.haz,herit.htr=herit.htr)
##         herit.htr
##     }    
##     library(parallel)
##     herit[[i]]<-mclapply(rho,f,x=x,mc.cores=length(rho))
## }
## names(herit)<-names(L)


## pdf("/home/bd/Dropbox/Apps/Overleaf/twins_nozygosity/h2_country.pdf",width=4,height=4)
## mat<-lapply(herit,unlist)
## rho<- seq(.4,.6,by=.025)
## plot(NULL,xlim=c(.35,.65),ylim=c(0,.5),xlab=expression(rho),ylab=expression(h^2),xaxt='n')
## axis(side=1,seq(.4,.6,by=.1))
## cols<-colorRampPalette(c("red", "blue"))( 5)
## for (i in 1:length(mat)) {
##     lines(rho,mat[[i]],col=cols[i],lwd=2)
##     n<-length(rho)
##     text(rho[n],mat[[i]][n],pos=4,cex=.7,names(herit)[i])
##     text(rho[1],mat[[i]][1],pos=2,cex=.7,names(herit)[i])
## }
## #legend("bottomright",bty='n',title="Wealth Quintile",fill=cols,as.character(1:5))
## dev.off()
