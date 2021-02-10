load("twins.Rdata")

#h2(x,'height_1','height_2')
#h2(x,'haz_1','haz_2')

y<-x[,c("height_1","height_2")]
xx<-x[,c("age","survey_year")]
z<-residualize(y=y,x=xx)
x$htr_1<-z[,1]
x$htr_2<-z[,2]



f<-function(rho,x,...) {
    herit.ht<-h2(x,'height_1','height_2',rho=rho,...)
    herit.haz<-h2(x,'haz_1','haz_2',rho=rho,...)
    herit.htr<-h2(x,'htr_1','htr_2',rho=rho,...)
    herit.del<-h2(x,'del_1','del_2',rho=rho,...)
    c(herit.ht=herit.ht,
      herit.haz=herit.haz,herit.htr=herit.htr,herit.del=herit.del)
}

###################################
##rho

library(parallel)
rho<- seq(.3,.7,by=.025)
herit<-mclapply(rho,f,x=x,mc.cores=length(rho))
tmp<-do.call("rbind",herit)
tmp<-data.frame(tmp)
tmp$rho<-rho

#pdf("/home/bd/Dropbox/Apps/Overleaf/twins_nozygosity/vanilla_h2.pdf",width=4,height=4)
nn<-nrow(tmp)
par(mgp=c(2,1,0))
plot(NULL,ylim=c(0,.6),xlab=expression(rho),ylab=expression(h^2),xaxt='n',xlim=c(0.15,0.85),bty='n')
axis(side=1,seq(.3,.7,by=.2))
lines(tmp$rho,tmp$herit.ht,lwd=2,col='blue')
text(tmp$rho[1],tmp$herit.ht[1],'Height',pos=2,cex=.8,col='blue')
#
lines(tmp$rho,tmp$herit.htr,lwd=2,lty=1)
text(tmp$rho[nn],tmp$herit.htr[nn],'Height\nresidualized',pos=4,cex=.8)
#
lines(tmp$rho,tmp$herit.haz,lwd=2)
text(tmp$rho[nn],tmp$herit.haz[nn],'HAZ',pos=4,cex=.8)
#
lines(tmp$rho,tmp$herit.del,lwd=2,lty=1,col='blue')
text(tmp$rho[1],tmp$herit.del[1],'Height,\nflexible\nresidualization',pos=2,cex=.8,col='blue')
#legend("topleft",bty='n',fill=c("red","blue"),c("height","haz"))
#dev.off()

## ###
## y<-x[!is.na(x$age),]
## y1<-y[y$age<24,]
## y2<-y[y$age>=24,]
## f(0.5,y1)
## f(0.5,y2)

## ##
## f(0.5,x,printz=TRUE)
