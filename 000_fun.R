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
    df<-df[rowSums(is.na(df))==0,]
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

h2<-function(df,nm1,nm2,rho=.5,printz=FALSE) {
    df[[nm1]]->df$y1
    df[[nm2]]->df$y2
    df<-df[,c("y1","y2","diff.sex")]
    df<-df[rowSums(is.na(df))==0,]
    ##
    df$p<-rho
    v<-var(c(df$y1,df$y2))
    est2<-optim(c(v/4,v/4,v/2),ll.no,df=df)
    z<-est2$par
    if (printz) return(c(h2=z[1]/(sum(z)),z)) else return(z[1]/(sum(z)))
}

residualize<-function(y,x) { #y is a Nx2 block for dyads, x is a Nxk block of k dyad-level covariates
    nr<-nrow(y)
    yy<-c(y[,1],y[,2])
    xx<-rbind(x,x)
    tmp<-data.frame(y=yy,xx)
    1:nrow(tmp)->rownames(tmp)
    m<-lm(tmp)
    rr<-rep(NA,length(yy))
    rr[as.numeric(names(resid(m)))]<-resid(m)
    matrix(rr,byrow=FALSE,ncol=2,nrow=nr)
}
