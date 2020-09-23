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
    #
    sex1<-rbinom(nrow(df),1,.5)
    sex2<-rbinom(nrow(df),1,.5)
    df$diff.sex<-ifelse(sex1!=sex2 & df$mz==0,1,0)
    ##
    df
}



##with zyg
ll<-function(varcomps,df) {
    like<-function(varcomps,y1,y2,mz) { #see expressions following eqn 2 https://www.cambridge.org/core/services/aop-cambridge-core/content/view/72C025E382D45CBC9A1DECBD00F41151/S136905230000372Xa.pdf/finite_mixture_distribution_model_for_data_collected_from_twins.pdf
        ##actually, i don't think those are quite right. see p 119 here. https://socialsciences.mcmaster.ca/jfox/Courses/Brazil-2008/SEMs-notes.pdf
        va<-varcomps[1]
        vc<-varcomps[2]
        ve<-varcomps[3]
        ##
        n<-length(y1)
        x<-cbind(y1,y2)
        S<-cov(x)
        ##
        mc<-matrix(rep(1,4),2,2)
        me<-diag(2)
        a<-ifelse(mz==1,1,.5)
        ma<-matrix(c(1,a,a,1),2,2)
        sig<-va*ma+vc*mc+ve*me
        ##
        s1<-log(det(sig))
        s2<-sum(diag(S %*% solve(sig)))
        -(n/2)*(s1+s2)
    }
    dfm<-df[df$mz==1,]
    dfd<-df[df$mz==0,]
    l1<-like(varcomps,y1=dfm$y1,y2=dfm$y2,mz=1)
    l2<-like(varcomps,y1=dfd$y1,y2=dfd$y2,mz=0)
    -1*(l1+l2)
}

##no zyg
ll.no<-function(varcomps,df) {
    like.no<-function(varcomps,y1,y2,mz) { #see expressions following eqn 2 https://www.cambridge.org/core/services/aop-cambridge-core/content/view/72C025E382D45CBC9A1DECBD00F41151/S136905230000372Xa.pdf/finite_mixture_distribution_model_for_data_collected_from_twins.pdf
        ##actually, i don't think those are quite right. see p 119 here. https://socialsciences.mcmaster.ca/jfox/Courses/Brazil-2008/SEMs-notes.pdf
        va<-varcomps[1]
        vc<-varcomps[2]
        ve<-varcomps[3]
        ##
        n<-length(y1)
        x<-cbind(y1,y2)
        x[,1]<-x[,1]-mean(x[,1])
        x[,2]<-x[,2]-mean(x[,2])
        ##
        mc<-matrix(rep(1,4),2,2)
        me<-diag(2)
        a<-ifelse(mz==1,1,.5)
        ma<-matrix(c(1,a,a,1),2,2)
        sig<-va*ma+vc*mc+ve*me
        sig.inv<-solve(sig)
        ##
        s1<-det(2*pi*sig)^(-1/2)
                                        #s2<-numeric()
                                        #for (i in 1:n) s2[i]<-exp((-1/2)*(matrix(x[i,],nrow=1) %*% sig.inv %*% matrix(x[i,],ncol=1)))
        get.s2<-function(x) exp((-1/2)*(matrix(x,nrow=1) %*% sig.inv %*% matrix(x,ncol=1)))
        s2<-apply(x,1,get.s2)
        s1*s2
    }
    ##
    ds<-df[df$diff.sex==1,]
    ss<-df[df$diff.sex==0,]
    ##ss, have to guess
    l1<-like.no(varcomps,y1=ss$y1,y2=ss$y2,mz=1)
    l2<-like.no(varcomps,y1=ss$y1,y2=ss$y2,mz=0)
    p<-unique(df$p)
    ##ds
    l2.ds<-like.no(varcomps,y1=ds$y1,y2=ds$y2,mz=0)
    ##
    -1*(sum(log(p*l1+(1-p)*l2))+sum(log(l2.ds)))
}

df<-twinsim(10000,per.mz=.5,va=.5,vc=.1,ve=.5)
v<-var(c(df$y1,df$y2))
est1<-optim(c(v/4,v/4,v/2),ll,df=df)
.5->df$p ##a perfect match for per.mz
est2<-optim(c(v/4,v/4,v/2),ll.no,df=df)


v<-list()
for (i in 1:300) v[[i]]<-runif(2,0,1)
library(parallel)
parfun<-function(v) {
    va<-v[1]
    vc<-v[2]
    df<-twinsim(15000,per.mz=.5,va=va,vc=vc,ve=1)
    s2<-var(c(df$y1,df$y2))
    est1<-optim(c(s2/4,s2/4,s2/2),ll,df=df)
    .5->df$p ##a perfect match for per.mz
    est2<-optim(c(s2/4,s2/4,s2/2),ll.no,df=df)
    list(va,vc,est1$par,est2$par)
}
out<-mclapply(v,parfun,mc.cores=30)
save(out,file="out.Rdata")



mse<-function(x1,x2) mean((x1-x2)^2)
f<-function(x) c(x[[1]],x[[3]][1],x[[4]][1])
tab1<-t(sapply(out,f))
f<-function(x) c(x[[2]],x[[3]][2],x[[4]][2])
tab2<-t(sapply(out,f))
par(mfrow=c(2,2),mgp=c(2,1,0),mar=c(3,3,1,1),oma=rep(.5,4))
plot(tab1[,1],tab1[,2],xlab="True",ylab="w/ zyg",xlim=c(0,1),ylim=c(-.5,1.5),pch=19,col='blue')
legend("topleft",bty='n',"vA")
legend("bottomright",bty='n',paste("MSE",round(mse(tab1[,1],tab1[,2]),4)))
plot(tab1[,1],tab1[,3],xlab="True",ylab="wo/ zyg",xlim=c(0,1),ylim=c(-.5,1.5),pch=19,col='blue')
legend("bottomright",bty='n',paste("MSE",round(mse(tab1[,1],tab1[,3]),4)))
plot(tab2[,1],tab2[,2],xlab="True",ylab="w/ zyg",xlim=c(0,1),ylim=c(-.5,1.5),pch=19,col='blue')
legend("topleft",bty='n',"vC")
legend("bottomright",bty='n',paste("MSE",round(mse(tab2[,1],tab2[,2]),4)))
plot(tab2[,1],tab2[,3],xlab="True",ylab="wo/ zyg",xlim=c(0,1),ylim=c(-.5,1.5),pch=19,col='blue')
legend("bottomright",bty='n',paste("MSE",round(mse(tab2[,1],tab2[,3]),4)))
