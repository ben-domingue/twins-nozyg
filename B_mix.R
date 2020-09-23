source("A_sim.R")


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
    l1<-like.no(varcomps,y1=df$y1,y2=df$y2,mz=1)
    l2<-like.no(varcomps,y1=df$y1,y2=df$y2,mz=0)
    p<-unique(df$p)
    -1*sum(log(p*l1+(1-p)*l2))
}

df<-twinsim(10000,per.mz=.5,va=.5,vc=.1,ve=.5)
v<-var(df$y1)
est1<-optim(c(v/4,v/4,v/2),ll,df=df)
.5->df$p ##a perfect match for per.mz
est2<-optim(c(v/4,v/4,v/2),ll.no,df=df)



v<-list()
for (i in 1:100) v[[i]]<-runif(2,0,1)
library(parallel)
parfun<-function(v) {
    va<-v[1]
    vc<-v[2]
    df<-twinsim(15000,per.mz=.5,va=va,vc=vc,ve=1)
    sig<-var(df$y1)
    est1<-optim(c(sig/4,sig/4,sig/2),ll,df=df)
    .5->df$p ##a perfect match for per.mz
    est2<-optim(c(v/4,v/4,v/2),ll.no,df=df)
    list(va,vc,est1$par,est2$par)
}
out<-mclapply(v,parfun,mc.cores=30)
save(out,file="out.Rdata")

cl<-lapply(out,class)
out<-out[cl=='list']

f<-function(x) c(x[[1]],x[[3]][1],x[[4]][1])
tab1<-sapply(out,f)
plot(data.frame(t(tab1)))


f<-function(x) c(x[[2]],x[[3]][2],x[[4]][2])
tab1<-sapply(out,f)
plot(data.frame(t(tab1)))
