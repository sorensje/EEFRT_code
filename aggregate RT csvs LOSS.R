### aggregate csv files created by link RT scrubber


# setwd("~/My Dropbox/EEfRT for grant/EEfRT_5202013/")
# setwd("~/Dropbox/EEfRT for grant/EEfRT_5202013")
setwd("~/Dropbox/EEfRT for grant/EEFRT_data_06302014/")

library('stringr')

files<-dir(pattern="*.csv")
files<-files[grep("*LOSS*",files)]

subs<-str_extract(files,"\\d+")
subs<-as.numeric(subs)
subs<-subs[subs>1000] #clean 
subs<-subs[subs<4000]

subs<-subs[!subs %in% 2507] ##2507 is a trouble maker.
uberdata<-NULL

for (ii in 1:length(subs)){
  filetouse<-files[grep(subs[ii],files)]
  if(length(filetouse)>0){
    print(subs[ii])
    filename<-paste("./",filetouse,sep="")
    subdat<- read.csv(filename)  
    subdat$X<-NULL
#     if( dim(subdat)[2]==21){
      subdat$subID<-subs[ii]
      subdat$trial<-1:length(subdat$subID)
      uberdata<-rbind(uberdata,subdat)
#     } else{
#       cat('Suject',subs[ii],'has wrong number of vars, they have',dim(subdat)[2],'\n')
#     }
    
  }else      (cat(subs[ii],'nogo','\n'))
  
}


# setwd("~/My Dropbox/EEfRT for grant")
# setwd("~/Dropbox/EEfRT for grant/")
# write.csv(uberdata,"EEfRTloss_RTs.csv",row.names=F)

write.csv(uberdata,"~/Dropbox/PACO_JS/EEfRT_analysis/EEfRT_LOSS_RTs.csv",row.names=F)

