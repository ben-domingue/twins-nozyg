x<-read.csv("twins_allDHS_24nov2020.csv")
x$diff.sex<- ifelse(x$female_1!=x$female_2,1,0)

x1<-x[,c("twin_id","height_1","female_1","age")]
x2<-x[,c("twin_id","height_2","female_2","age")]
x1$id<-1
names(x1)<-gsub("_1","",names(x1))
x2$id<-2
names(x2)<-gsub("_2","",names(x2))
df<-data.frame(rbind(x1,x2))
#plot(df$age,df$height)


test<-is.na(df$height) | is.na(df$age)
hold<-df[test,]
df<-df[!test,]

L<-split(df,df$female)
f<-function(x) {
    #plot(x$age,x$height,pch=19)
    m<-loess(height~age,x)
    #points(x$age,predict(m),col='red',pch=19)
    x$del<-x$height-ifelse(is.na(x$height) | is.na(x$age),NA,predict(m))
    ##
    s<-by(x$del,x$age,sd,na.rm=TRUE)
    a<-as.numeric(names(s))
    m<-loess(s~a)
    spred<-predict(m,x$age)
    x$del<-x$del/spred
    x
}
L<-lapply(L,f)
df<-data.frame(do.call("rbind",L))
plot(df$age,df$del)


NA->hold$del
hold<-hold[,names(df)]
df<-data.frame(rbind(df,hold))
L<-split(df,df$id)
L$`1`->z
z<-z[,c("twin_id","del")]
names(z)[2]<-"del_1"
x<-merge(x,z)
L$`2`->z
z<-z[,c("twin_id","del")]
names(z)[2]<-"del_2"
x<-merge(x,z)

save(x,file="twins.Rdata")

