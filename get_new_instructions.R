####
# this code finds the dates that participants completed EEfRT based on the file
# creation time stamp. new instructions were implemented on April 27.
# also specifies order of when participants completed task


library('stringr')

### go to data folder

# dattfolder<-"~/My Dropbox/EEfRT for grant/EEfRT_5202013"
dattfolder<-"~/Dropbox/EEfRT for grant/EEFRT_data_06302014"
outputFile <- "~/Dropbox/EEfRT for grant/when_win_loss_complete.csv"
setwd(dattfolder)



files<-dir(pattern="*.mat")
files<-files[grep("*WIN*",files)] ## just find 

#extract sub numbers
subs<-str_extract(files,"\\d+")
subs<-as.numeric(subs)
subs<-subs[subs>1000] #clean 
subs<-subs[subs<4000]

subs<-subs[!subs %in% 2507] ##2507 is a trouble maker.
ii=NULL
losstimes<-NULL
wintimes<-NULL

for (ii in 1:length(subs)){
  
  lossfilename<-paste("dataStruct_",subs[ii],"_LOSS.mat",sep="")
  winfilename<-paste("dataStruct_",subs[ii],"_WIN.mat",sep="")
  whenloss<-file.info(lossfilename)$mtime
  losstimes<-c(losstimes,whenloss)
  
  whenwin<-file.info(winfilename)$mtime
  wintimes<-c(wintimes,as.numeric(whenwin))
  
  timedif<-difftime(whenwin,whenloss)
  
#   rm(list('lossfilename','winfilename','whenloss','whenwin'))
}
subdat<-data.frame(subID=subs,wintime=wintimes,losstime=losstimes)
subdat$timefromwin<-(subdat$wintime-subdat$losstime)/60
subdat$winfirst<-subdat$timefromwin>0
blah<-as.POSIXct("2012-04-27 0:00:01 PDT") #added new instructions in april?
# blah<-as.POSIXct("2012-08-22 0:00:01 PDT")
subdat$cutoff<-as.numeric(blah)
subdat$gotnewinstructions<-subdat$wintime-subdat$cutoff>0


# setwd("~/My Dropbox/EEfRT for grant")
# write.csv(subdat,"when_win_loss_complete.csv")
write.csv(subdat,outputFile)




