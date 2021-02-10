load("twins.Rdata")

#################################


##rolling window
L<-list()
for (i in seq(20,100,by=5)) {
    tmp<-x[abs(x$imr-i)<=4,]
    L[[as.character(i)]]<-data.frame(del_1=tmp$del_1,del_2=tmp$del_2,diff.sex=tmp$diff.sex)
}

library(parallel)
f<-function(x,rho=.5) {
    herit<-h2(x,'del_1','del_2',rho=rho)
    tmp<-list()
    herit
}    
herit<-lapply(L,f)

#save(herit,file="h2_age.Rdata")


herit <-
list(`20` = 0.385747185210658, `25` = 0.319681746250482, `30` = 0.356446673664611, 
    `35` = 0.404660482720419, `40` = 0.45567796299143, `45` = 0.484576161747383, 
    `50` = 0.471338198984632, `55` = 0.587940024179699, `60` = 0.594058671388091, 
    `65` = 0.506455460673231, `70` = 0.461455342547387, `75` = 0.475199693289977, 
    `80` = 0.537456565379671, `85` = 0.636025218778287, `90` = 0.57773294816378, 
    `95` = 0.545442751264842, `100` = 0.444848094652461)
mat<-do.call("rbind",herit)
ages<-as.numeric(rownames(mat))
par(mgp=c(2,1,0))
plot(ages,mat,xlab="IMR",ylab="h2",type='l',ylim=c(0,.7))
