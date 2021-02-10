## “height” (y) against age (x)
## “Ben’s height measure”(y) against age (x)
## “haz” (y) against age (x)

load("twins.Rdata")
std<-function(x) (x-mean(x,na.rm=TRUE))/sd(x,na.rm=TRUE)
m<-list()
for (nm in c("height","del","haz")) {
    yv<-c(x[[paste(nm,"_1",sep="")]],x[[paste(nm,"_2",sep="")]])
    xv<-c(x$age,x$age)
    yv<-std(yv)
    m[[nm]]<-loess(yv~xv,x)
}

cols<-c("black","blue","red")
plot(NULL,xlim=c(0,60),ylim=c(-2,2),xlab='age',ylab='')
for (i in 1:length(m)) {
    xx<-seq(0,60,length.out=1000)
    lines(xx,predict(m[[i]],xx),col=cols[i],lwd=2)
}
legend("topleft",fill=cols,names(m))
