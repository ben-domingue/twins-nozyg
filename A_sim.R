twinsim<-function(N=1000,per.mz=.5,va,vc,ve) {
    ##see https://arxiv.org/pdf/1710.09326.pdf
    mc<-matrix(rep(1,4),2,2)
    me<-diag(2)
    library(MASS)
    L<-list()
    mz<-rbinom(N,1,per.mz)
    nm<-sum(mz)
    nd<-N-nm
    ##mz
    ma<-matrix(c(1,1,1,1),2,2)
    zm<-cbind(1,mvrnorm(nm,mu=rep(0,2),Sigma=va*ma+vc*mc+ve*me))
    ##dz
    ma<-matrix(c(1,.5,.5,1),2,2)
    zd<-cbind(0,mvrnorm(nd,mu=rep(0,2),Sigma=va*ma+vc*mc+ve*me))
    ##
    df<-data.frame(rbind(zm,zd))
    names(df)<-c("mz","y1","y2")
    ##
    df
}


df<-twinsim(10000,va=.5,vc=.5,ve=.5)
del<-(df$y1-df$y2)
plot(density(del[df$mz==0]),col="blue")
den<-density(del[df$mz==1])
lines(den$x,den$y,col='red')

    
