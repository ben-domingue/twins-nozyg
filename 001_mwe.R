##this is the the function that we're going to optimize over
ll.no<-function(varcomps,df) { #this will compute the weighted average of likelihood (where weights are based on guesses as to mz-ness)
    like.no<-function(#this computes the likelihood
                      varcomps, # vector (length 3) containing the variance components
                      y1, #the phenotype for one twin
                      y2, #the phenotype for the other
                      mz #an indicator of mz-ness
                      ) {
        #see expressions following eqn 2 https://www.cambridge.org/core/services/aop-cambridge-core/content/view/72C025E382D45CBC9A1DECBD00F41151/S136905230000372Xa.pdf/finite_mixture_distribution_model_for_data_collected_from_twins.pdf
        ##see also p 119 here. https://socialsciences.mcmaster.ca/jfox/Courses/Brazil-2008/SEMs-notes.pdf
        va<-varcomps[1]
        vc<-varcomps[2]
        ve<-varcomps[3]
        ##
        n<-length(y1)
        x<-cbind(y1,y2)
        x[,1]<-x[,1]-mean(x[,1])
        x[,2]<-x[,2]-mean(x[,2])
        ##
        mc<-matrix(rep(1,4),2,2) #C matrix
        me<-diag(2) #diagonal matrix 
        a<-ifelse(mz==1,1,.5)
        ma<-matrix(c(1,a,a,1),2,2)
        sig<-va*ma+vc*mc+ve*me
        sig.inv<-solve(sig) #solve gives matrix inverse
        ##
        s1<-det(2*pi*sig)^(-1/2) #det gives matrix determinant
        get.s2<-function(x) exp((-1/2)*(matrix(x,nrow=1) %*% sig.inv %*% matrix(x,ncol=1))) #%*% is matrix product
        s2<-apply(x,1,get.s2)
        s1*s2
    }
    ##we'll analyze same sex and different sex twins separately
    ds<-df[df$diff.sex==1,]
    ss<-df[df$diff.sex==0,]
    ##ss, have to guess
    l1<-like.no(varcomps,y1=ss$y1,y2=ss$y2,mz=1)
    l2<-like.no(varcomps,y1=ss$y1,y2=ss$y2,mz=0)
    p<-unique(df$p) #this is 'rho'
    ##ds
    l2.ds<-like.no(varcomps,y1=ds$y1,y2=ds$y2,mz=0)
    ##
    -1*(sum(log(p*l1+(1-p)*l2))+sum(log(l2.ds)))
}

#this is the function that will do the optimmization
h2<-function(diff.sex, #indicator of whether the twins are different sex
             y1, #phenotype for one twin
             y2, #phenotype for second
             rho=.5
             ) { 
    df<-data.frame(diff.sex=diff.sex,y1=y1,y2=y2)
    df<-df[rowSums(is.na(df))==0,]
    ##
    df$p<-rho
    v<-var(c(df$y1,df$y2))
    est2<-optim(c(v/4,v/4,v/2),ll.no,df=df)
    z<-est2$par
    c(va=z[1],vc=z[2],ve=z[3],h2=z[1]/(sum(z)))
}

x<-read.csv("/home/bd/Dropbox/projects/twins_nozyg/data/twins_India.csv")
x$diff.sex<- ifelse(x$female_1!=x$female_2,1,0)
h2(x$diff.sex,x$haz_1,x$haz_2)

##my results
## > h2(x$diff.sex,x$haz_1,x$haz_2)
##    va    vc    ve    h2 
## 1.130 1.509 0.067 0.417 
