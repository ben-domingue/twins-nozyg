load("twins.Rdata")


par(mfrow=c(1,2),mgp=c(2,1,0),mar=c(3,3,1,1))
h<-c(x$del_1,x$del_2)
ht<-c(x$height_1,x$height_2)
a<-c(x$age,x$age)
s<-c(x$female_1,x$female_2)
w<-c(x$wealth_quintile,x$wealth_quintile)
imr<-c(x$imr,x$imr)
y<-data.frame(h=h,a=a,s=s,w=w,imr=imr,ht=ht)
plot(y$imr,y$h,pch=19,cex=.5,xlab="IMR",ylab="Residualized Height")
loess(h~imr,y)->m
xv<-sort(y$imr)
lines(xv,predict(m,data.frame(imr=xv)),col='red',lwd=3)

plot(NULL,xlim=c(0,150),ylim=c(55,113),bty='n',xlab='IMR',ylab="Height")
ages<-seq(5,55,by=5)
cols<-colorRampPalette(c("red", "blue"))( length(ages))
for (i  in 1:length(ages)) {
    age<-ages[i]
    tmp<-y[abs(y$a-age)<=3,]
    xv<-sort(y$imr)
    loess(ht~imr,tmp)->m
    yv<-predict(m,data.frame(imr=xv))
    lines(xv,yv,col=cols[i],lwd=3)
    text(xv[1],yv[1],ages[i],cex=.75,col=cols[i],pos=2)
    n<-length(xv)
    text(xv[n],yv[n],ages[i],cex=.75,col=cols[i],pos=4)
}

##variances
xv<-seq(20,120,by=5)
s<-numeric()
for (i in xv) {
    tmp<-y[abs(y$imr-i)<4,]
    s[as.character(i)]<-sd(tmp$h)
}
plot(xv,s,type='b')


###################
del<-(x$del_1-x$del_2)^2
age<-x$age
df<-data.frame(age=age,del=del,ds=x$diff.sex)
df$imr<-x$imr
plot(NULL,xlim=c(0,150),ylim=c(0,5),xlab="IMR")
loess(del~imr,df)->m
xv<-sort(df$imr)
lines(xv,predict(m,data.frame(imr=xv)),col='red')




## pdf("/home/bd/Dropbox/Apps/Overleaf/twins_nozygosity/desc.pdf",width=7,height=6)
## par(mar=c(4,4,1,1),mfrow=c(2,2),mgp=c(2,1,0))
## ## hold<-x
## ## for (s in 0:1) {
## ##     x<-hold[hold$s==s,]
## ##     mat<-list()
## ##     quL<-c(.1,.25,.5,.75,.9)
## ##     for (y in 0:60) {
## ##         tmp<-x[abs(x$a-y)<=3,]
## ##         hq<-list()
## ##         for (qu in quL) hq[[as.character(qu)]]<-quantile(tmp$h,qu,na.rm=TRUE)
## ##         c(y,unlist(hq))->mat[[as.character(y)]]
## ##     }
## ##     mat<-do.call("rbind",mat)
## ##     plot(NULL,xlim=c(0,70),ylim=c(40,120),xlab="Age (m)",ylab="Height",bty='n',xaxt='n')
## ##     axis(side=1,seq(0,60,by=10))
## ##     for (i in 2:ncol(mat)) {
## ##         lines(mat[,1],mat[,i],col='blue',lwd=1.5)
## ##         nrow(mat)->n
## ##         text(mat[n,1],mat[n,i],pos=4,paste('q',quL[i-1]),cex=.7)
## ##     }
## ##     nm<-ifelse(s==0,'Males','Females')
## ##     legend("topleft",bty='n',nm)
## ##     print(mat)
## ## }
## ## hold->x
## hold<-x
## for (s in 0:1) {
##     x<-hold[hold$s==s,]
##     mat<-list()
##     for (y in 0:60) {
##         tmp<-x[abs(x$a-y)<=3,]
##         hq<-list()
##         hq<-by(tmp$h,tmp$w,mean,na.rm=TRUE)
##         mat[[as.character(y)]]<-c(y,as.numeric(hq))
##     }
##     mat<-do.call("rbind",mat)
##     cols<-colorRampPalette(c("red", "blue"))( 5)
##     plot(NULL,xlim=c(0,60),ylim=c(40,120),xlab="Age (m)",ylab="Height",bty='n',xaxt='n')
##     axis(side=1,seq(0,60,by=10))
##     for (i in 2:ncol(mat)) {
##         lines(mat[,1],mat[,i],col=cols[i-1],lwd=1.5)
##         #nrow(mat)->n
##         #text(mat[n,1],mat[n,i],pos=4,paste('q',quL[i-1]),cex=.7)
##     }
##     nm<-ifelse(s==0,'Males','Females')
##     legend("topleft",bty='n',nm)
##     legend("bottomright",fill=cols,as.character(1:5),bty='n')
## }
## hold->x
## ##
## plot(density(df$del[df$ds==0]),type='l',col='red',xlim=c(0,40),main='',sub='',xlab="Sq diff in height",lwd=2)
## lines(density(df$del[df$ds==1]),col='blue',lwd=2)
## ##
## plot(NULL,xlim=c(0,60),xlab="Age (m)",ylab="Sq diff in height",pch=19,col='gray',cex=.2,ylim=c(0,30),bty='n')
## mat<-list()
## for (ds in 0:1) {
##     x<-df[df$ds==ds,]
##     for (y in 0:60) {
##         tmp<-x[abs(x$age-y)<=3,]
##         q<-mean(tmp$del)
##         c(y,q)->mat[[as.character(y)]]
##     }
##     tmp<-do.call("rbind",mat)
##     col<-ifelse(ds==0,'red','blue')
##     lines(tmp,col=col,lwd=3)
## }
## legend("topleft",fill=c("red","blue"),c("Same Sex","Different Sex"),bty='n')
## dev.off()
