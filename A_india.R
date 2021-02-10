## load("twins.Rdata")


## ##no zyg
## ll.no<-function(varcomps,df) {
##     like.no<-function(varcomps,y1,y2,mz) { #see expressions following eqn 2 https://www.cambridge.org/core/services/aop-cambridge-core/content/view/72C025E382D45CBC9A1DECBD00F41151/S136905230000372Xa.pdf/finite_mixture_distribution_model_for_data_collected_from_twins.pdf
##         ##actually, i don't think those are quite right. see p 119 here. https://socialsciences.mcmaster.ca/jfox/Courses/Brazil-2008/SEMs-notes.pdf
##         va<-varcomps[1]
##         vc<-varcomps[2]
##         ve<-varcomps[3]
##         ##
##         n<-length(y1)
##         x<-cbind(y1,y2)
##         x[,1]<-x[,1]-mean(x[,1])
##         x[,2]<-x[,2]-mean(x[,2])
##         ##
##         mc<-matrix(rep(1,4),2,2)
##         me<-diag(2)
##         a<-ifelse(mz==1,1,.5)
##         ma<-matrix(c(1,a,a,1),2,2)
##         sig<-va*ma+vc*mc+ve*me
##         sig.inv<-solve(sig)
##         ##
##         s1<-det(2*pi*sig)^(-1/2)
##                                         #s2<-numeric()
##                                         #for (i in 1:n) s2[i]<-exp((-1/2)*(matrix(x[i,],nrow=1) %*% sig.inv %*% matrix(x[i,],ncol=1)))
##         get.s2<-function(x) exp((-1/2)*(matrix(x,nrow=1) %*% sig.inv %*% matrix(x,ncol=1)))
##         s2<-apply(x,1,get.s2)
##         s1*s2
##     }
##     ##
##     ds<-df[df$diff.sex==1,]
##     ss<-df[df$diff.sex==0,]
##     ##ss, have to guess
##     l1<-like.no(varcomps,y1=ss$y1,y2=ss$y2,mz=1)
##     l2<-like.no(varcomps,y1=ss$y1,y2=ss$y2,mz=0)
##     p<-unique(df$p)
##     ##ds
##     l2.ds<-like.no(varcomps,y1=ds$y1,y2=ds$y2,mz=0)
##     ##
##     -1*(sum(log(p*l1+(1-p)*l2))+sum(log(l2.ds)))
## }
## h2<-function(df,nm1,nm2,rho=.5) {
##     df[[nm1]]->df$y1
##     df[[nm2]]->df$y2
##     df<-df[,c("y1","y2","diff.sex")]
##     df<-df[rowSums(is.na(df))==0,]
##     ##
##     df$p<-rho
##     v<-var(c(df$y1,df$y2))
##     est2<-optim(c(v/4,v/4,v/2),ll.no,df=df)
##     z<-est2$par
##     z[1]/(sum(z))
## }
## h2(x,'height_1','height_2')
## h2(x,'haz_1','haz_2')

## herit.ht<-herit.haz<-list()
## for (rho in seq(.35,.65,by=.01)) {
##     print(rho)
##     herit.ht[[as.character(rho)]]<-h2(x,'height_1','height_2',rho=rho)
##     herit.haz[[as.character(rho)]]<-h2(x,'haz_1','haz_2',rho=rho)
## }    

## par(mgp=c(2,1,0))
## plot(NULL,xlim=c(.35,.55),ylim=c(0,.6),xlab="rho",ylab="h2")
## lines(as.numeric(names(herit.ht)),unlist(herit.ht),col='red',lwd=2)
## lines(as.numeric(names(herit.haz)),unlist(herit.haz),col='blue',lwd=2)
## legend("topleft",bty='n',fill=c("red","blue"),c("height","haz"))
