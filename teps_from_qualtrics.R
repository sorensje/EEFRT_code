source("QualtricsHelperFunctions.R")
library('stringr')


### pull teps from qualtrics data
QUESTIONNAIRES_TO_PULL <- 'TEPS'

# "ResponseID"  "BookKeeping" "subID"       "Roles"       "QAD"         "PSWQ"       
# "CTQ"         "LES"         "PANAS"       "TMMS"        "APS-R"       "TEPS"    

# QUALTRICS_FILE_NAME <- "~/Dropbox/PACO/Qualtrics/PaCo_Session_1_Questionnaires_JSannotate.csv"
QUALTRICS_FILE_NAME <- "~/Dropbox/PACO/Qualtrics/PaCo_Session_1_Questionnaires_ESTHER_check_jsAnnotate.csv"
Q_ROW <- 2 #row containing annotated data

qList <- c(QUESTIONNAIRES_TO_PULL,"subID")

### use it
allQualtrics <- read.csv(QUALTRICS_FILE_NAME)
newDat <- getQualDat(qList,allQualtrics)

namesToDrop <- grep('BookKeeping',names(newDat),value=TRUE)
newDat <- newDat [, setdiff(names(newDat),namesToDrop)]

teps_all <- newDat
# names(teps_all)
names(teps_all) <- c("Subject",paste("teps",1:18,sep="_"))
# str(teps_all)
for(tepQ in paste("teps",1:18,sep="_")){
  teps_all[,tepQ] <-as.numeric(teps_all[,tepQ])
}



## PACO version
teps_all$teps_7r<-7-teps_all$teps_7 #reverse code: don't look forward to eating out at restaraunts...
anticipatory<- c(18,1,3,"7r",11,12,14,15,16,17,18)  
teps_all$ant<-rowSums(teps_all[,paste("teps_",anticipatory,sep="")]) #sum anticipatory
teps_all$ant_ignormiss<-rowSums(teps_all[,paste("teps_",anticipatory,sep="")],na.rm=T) #sum anticipatory
consummatory <-c(6,2,4,5,8,9,10,13)
teps_all$cons<-rowSums(teps_all[,paste("teps_",consummatory,sep="")]) #sum anticipatory
teps_all$cons_ignormiss<-rowSums(teps_all[,paste("teps_",consummatory,sep="")],na.rm=T) #sum anticipatory

subdat <- read.csv("~/Dropbox/PACO/subject_tracking/subsGroups.csv")
teps2merge <- merge(teps_all[,c('cons','ant','Subject')],subdat,all.x=TRUE)

# newDat[,2] == teps_all$teps_1 #check everything's ok

rm(subdat,qList,Q_ROW,tepQ,namesToDrop,newDat, allQualtrics)

#### double check 2507 - might be inaccurate! 
# teps_all<-teps_all[teps_all$Subject!=2507,]


### commented out exploration.
# 
# library('ggplot2')
# library('psych')
# library('lme4')
# subdat <- read.csv("~/Dropbox/PACO/subject_tracking/subsGroups.csv")
# teps2merge <- merge(teps_all[,c('cons','ant','Subject')],subdat,all.x=TRUE)
# describeBy(teps2merge$cons,teps2merge$Group)
# describeBy(teps2merge$ant,teps2merge$Group)
# 
# ## graph distrns
# ggplot(teps2merge,aes(x=cons,fill=Group))+geom_histogram()+facet_grid(~Group)
# ggplot(teps2merge,aes(x=ant,fill=Group))+geom_histogram()+facet_grid(~Group)
# 
# 
# 
# teps.m <- melt(teps2merge)
# names(teps.m) <- c("Subject","Group","anhedoniaType","score")
# 
# source("~/Dropbox/R/helperfunctions/simpleGraphFormatting.R")
# 
# #### graph teps (consummatory )
# graphdat <- summarySE(teps2merge,measurevar="ant",groupvars='Group')
# p2 <- ggplot(graphdat,aes(x=Group,y=ant,fill=Group))+geom_bar(stat='identity',position=position_dodge(.9))+
#   geom_errorbar(position=position_dodge(.9), width=.25, aes(ymin=ant-ci, ymax=ant+ci))+
# 
# # scale_fill_manual(values=c("purple","palegreen4", "red","blue"))
# scale_fill_manual(values=c("#984ea3","#4daf4a", "#e41a1c","#377eb8"))
# p2 <-p2+  ggtitle(label="Anticipatory Hedonia")+scale_y_continuous(name="raw score")
# makeagraph(p2)
# 
# 
# #useful color codes
# #e41a1c
# #377eb8
# #4daf4a
# #984ea3
# 
# graphdat <- summarySE(teps2merge,measurevar="cons",groupvars='Group')
# p2 <- ggplot(graphdat,aes(x=Group,y=cons,fill=Group))+geom_bar(stat='identity',position=position_dodge(.9))+
#   geom_errorbar(position=position_dodge(.9), width=.25, aes(ymin=cons-ci, ymax=cons+ci))+
#   scale_fill_manual(values=c("#984ea3","#4daf4a", "#e41a1c","#377eb8"))
# p2 <-p2+  ggtitle(label="Consummatory Hedonia")+scale_y_continuous(name="raw score")
# makeagraph(p2)
# 
# 
# 
# 
# # 
# # graphdat <- summarySEwithin(teps.m,'score',betweenvars='Group',withinvars='anhedoniaType',idvar='Subject')
# # 
# # p2 <- ggplot(graphdat,aes(x=Group,y=score,fill=Group))+geom_bar(stat='identity',position=position_dodge(.9))+
# #   geom_errorbar(position=position_dodge(.9), width=.25, aes(ymin=score-ci, ymax=score+ci)) + facet_wrap(~anhedoniaType)
# # p2 <-p2+  ggtitle(label="")+scale_y_continuous(name="Hedonia score")
# # p2
# # 
# 
