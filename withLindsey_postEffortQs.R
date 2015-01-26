# read in post effort Qs
library('reshape2')
library('lme4')
###
# complete: VAS left: 0% right: 100%
# effortful: VAS, left: not at all, right: extremely
# liked: Bipolar, left: very much disliked, right: very much liked

## read in loss, win post Qs and combine responses (only) into one df
lossPostQs <- read.csv("~/Dropbox/PACO_JS/EEfRT_analysis/postEffortQs_Loss_combined.csv")
str(lossPostQs)
tagVarNames <- grep("*.Tag",names(lossPostQs),value=TRUE)

lossPostQsSmall <- lossPostQs[,c('subID','Group.y', tagVarNames)]
names(lossPostQsSmall) <- c('subID',"GroupLoss",paste0("Loss_",tagVarNames))


winPostQs <- read.csv("~/Dropbox/PACO_JS/EEfRT_analysis/postEffortQs_Win_combined.csv")
tagVarNames <- grep("*.Tag",names(winPostQs),value=TRUE)

winPostQsSmall <- winPostQs[,c('subID','winfirst','gotnewinstructions','Group.y', tagVarNames)]
names(winPostQsSmall) <- c('subID','winfirst','gotnewinstructions','GroupWin',paste0("Win_",tagVarNames))

# issues with data
# two entries for 2507 in win, no data on loss first (possible one of these is loss?)
# no loss data for: 2653, 2507
# no win data for: 2629, 2643, 2687
# no post-Q data (win or loss) : 2622, 2634


### why missing in one and not other?
setdiff(winPostQsSmall$subID,lossPostQsSmall$subID) # no loss
setdiff(lossPostQsSmall$subID,winPostQsSmall$subID) # no win

# # 
# xtabs(~subID,winPostQsSmall)
# xtabs(~subID,lossPostQsSmall)

PostQsSmall <- merge(winPostQsSmall,lossPostQsSmall,all.x=T, all.y=T)

## merge Group info where missing into Group
PostQsSmall$Group <- PostQsSmall$GroupWin
for(i in 1:length(PostQsSmall$Group)){
  if(is.na(PostQsSmall$Group[i])){
    PostQsSmall$Group[i] <- PostQsSmall$GroupLoss[i]
  }
}


### do stuff
library('ggplot2')

str(PostQsSmall)

# like hard V easy
ggplot(PostQsSmall,aes(x=Win_Like_or_Dislike_Hard_BipolVAS.Tag, y = Win_Like_or_Dislike_Easy_BipolVAS.Tag, color = Group)) + 
  geom_point() + geom_smooth(method="lm") + facet_wrap(~Group)

# like hard vs effort hard
ggplot(PostQsSmall,aes(x=Win_EffortfulHard_VAS.Tag, y = Win_Like_or_Dislike_Hard_BipolVAS.Tag, color = Group)) + 
  geom_point() + geom_smooth(method="lm",se=FALSE) + facet_wrap(~Group)

ggplot(PostQsSmall,aes(x=Loss_EffortfulHard_VAS.Tag, y = Loss_Like_or_Dislike_Hard_BipolVAS.Tag, color = Group)) + 
  geom_point() + geom_smooth(method="lm",se=FALSE) + facet_wrap(~Group)

### get # choose hard
# loss summaries retrieved from .rrmd files
names(EEfRTLossSummary) <- c("subID", "Group","Loss_n_hard","Loss_n_Choices","Loss_EEfRT_ratio")
names(WinEEfRTsummary) <- c("subID", "Group","Win_n_hard","Win_n_Choices","Win_EEfRT_ratio")
# PostQsSmall <- PostQsSmall2
PostQsSmall <- merge(PostQsSmall,EEfRTLossSummary,all.x = T, all.y = T)
PostQsSmall <- merge(PostQsSmall,WinEEfRTsummary,all.x = T, all.y = T)

#### like / effortful subjective ratings driving overall pct of choice
ggplot(PostQsSmall,aes(x=Win_EffortfulHard_VAS.Tag, y = Win_EEfRT_ratio, color = Group)) + 
  geom_point() + geom_smooth(method="lm",se=FALSE) + facet_wrap(~Group)

ggplot(PostQsSmall,aes(x=Win_Like_or_Dislike_Hard_BipolVAS.Tag, y = Win_EEfRT_ratio, color = Group)) + 
  geom_point() + geom_smooth(method="lm",se=FALSE) + facet_wrap(~Group)



ggplot(PostQsSmall,aes(x=Loss_EffortfulHard_VAS.Tag, y = Loss_EEfRT_ratio, color = Group)) + 
  geom_point() + geom_smooth(method="lm",se=FALSE) + facet_wrap(~Group)

ggplot(PostQsSmall,aes(x=Loss_Like_or_Dislike_Hard_BipolVAS.Tag, y = Loss_EEfRT_ratio, color = Group)) + 
  geom_point() + geom_smooth(method="lm",se=FALSE) + facet_wrap(~Group)







ggplot(PostQsSmall,aes(x=Win_Like_or_Dislike_Easy_BipolVAS.Tag, y = Win_EffortfulEasy_VAS.Tag, color = Group)) + 
  geom_point()

### like hard win vs. loss
ggplot(PostQsSmall,aes(x=Loss_Like_or_Dislike_Hard_BipolVAS.Tag, y = Win_Like_or_Dislike_Hard_BipolVAS.Tag, color = Group)) + 
  geom_point()+ geom_smooth(method="lm")

ggplot(PostQsSmall,aes(x=Loss_Like_or_Dislike_Easy_BipolVAS.Tag, y = Win_Like_or_Dislike_Easy_BipolVAS.Tag, color = Group)) + 
  geom_point()+ geom_smooth(method="lm")

# need to get this into testable frame?
aggregate(Win_Like_or_Dislike_Hard_BipolVAS.Tag~Group,PosQsSmall,mean)
aggregate(Win_Like_or_Dislike_Easy_BipolVAS.Tag~Group,PosQsSmall,mean)

aggregate(Loss_Like_or_Dislike_Hard_BipolVAS.Tag~Group,PosQsSmall,mean) # gotta test this. psychopathology group thinks hard sucks. 
aggregate(Loss_Like_or_Dislike_Easy_BipolVAS.Tag~Group,PosQsSmall,mean)

#interssant...
ggplot(PostQsSmall,aes(x= Group, y = Loss_Like_or_Dislike_Easy_BipolVAS.Tag, color = Group))  + geom_boxplot()
ggplot(PostQsSmall,aes(x= Group, y = Loss_Like_or_Dislike_Hard_BipolVAS.Tag, color = Group))  + geom_boxplot()
ggplot(PostQsSmall,aes(x= Group, y = Win_Like_or_Dislike_Easy_BipolVAS.Tag, color = Group))  + geom_boxplot()
ggplot(PostQsSmall,aes(x= Group, y = Win_Like_or_Dislike_Hard_BipolVAS.Tag, color = Group))  + geom_boxplot()


str(PosQsSmall)
# effort
aggregate(Win_Like_or_Dislike_Hard_BipolVAS.Tag~Group,PosQsSmall,mean)
aggregate(Win_Like_or_Dislike_Easy_BipolVAS.Tag~Group,PosQsSmall,mean)

aggregate(Loss_Like_or_Dislike_Hard_BipolVAS.Tag~Group,PosQsSmall,mean) # gotta test this. psychopathology group thinks hard sucks. 
aggregate(Loss_Like_or_Dislike_Easy_BipolVAS.Tag~Group,PosQsSmall,mean)

# effort 
ggplot(PostQsSmall,aes(x= Group, y = Loss_EffortfulEasy_VAS.Tag, color = Group))  + geom_boxplot()
ggplot(PostQsSmall,aes(x= Group, y = Loss_EffortfulHard_VAS.Tag, color = Group))  + geom_boxplot()
ggplot(PostQsSmall,aes(x= Group, y = Win_EffortfulEasy_VAS.Tag, color = Group))  + geom_boxplot()
ggplot(PostQsSmall,aes(x= Group, y = Win_EffortfulHard_VAS.Tag, color = Group))  + geom_boxplot()

str(PostQsSmall)
### completion rates
ggplot(PostQsSmall,aes(x = Win_YouCompleteHardVAS.Tag, fill = Group)) + geom_histogram() +
  facet_grid(~Group)

ggplot(PostQsSmall,aes(x= Group, y = Win_YouCompleteHardVAS.Tag, color = Group))  + geom_boxplot()
ggplot(PostQsSmall,aes(x= Group, y = Win_YouCompleteEasyVAS.Tag, color = Group))  + geom_boxplot()
ggplot(PostQsSmall,aes(x= Group, y = Loss_YouCompleteHardVAS.Tag, color = Group))  + geom_boxplot()
ggplot(PostQsSmall,aes(x= Group, y = Loss_YouCompleteEasyVAS.Tag, color = Group))  + geom_boxplot()


#### completion rates. get 'truth'
str(winEffrt)
completeWin <- aggregate(completeTrue~subID + difficulty, winEffrt_raw,sum)
names(completeWin) <- c('subID','difficulty','win_complete_yes')
completeWin_len <- aggregate(completeTrue~subID+difficulty, winEffrt_raw,length)
names(completeWin_len) <- c('subID','difficulty','win_complete_length')
completeWin <- merge(completeWin_len,completeWin)
completeWin$win_complete_pct <- completeWin$win_complete_yes/ completeWin$win_complete_length
completeWin <- dcast(completeWin[c('subID','win_complete_pct','difficulty')],subID~difficulty,value.var ='win_complete_pct' )
names(completeWin) <- c('subID','win_complete_easy_pct','win_complete_hard_pct')

# for loss
completeloss <- aggregate(completeTrue~subID + difficulty, lossEffrt_raw,sum)
names(completeloss) <- c('subID','difficulty','loss_complete_yes')
completeloss_len <- aggregate(completeTrue~subID+difficulty, lossEffrt_raw,length)
names(completeloss_len) <- c('subID','difficulty','loss_complete_length')
completeloss <- merge(completeloss_len,completeloss)
completeloss$loss_complete_pct <- completeloss$loss_complete_yes/ completeloss$loss_complete_length
completeloss <- dcast(completeloss[c('subID','loss_complete_pct','difficulty')],subID~difficulty,value.var ='loss_complete_pct' )
names(completeloss) <- c('subID','loss_complete_easy_pct','loss_complete_hard_pct')


PostQsSmall4 <- merge(PostQsSmall,completeWin, all.x = T, all.y = T)
PostQsSmall <- merge(PostQsSmall,completeloss, all.x = T)

ggplot(PostQsSmall,aes(x = Win_YouCompleteHardVAS.Tag, y = win_complete_hard_pct, color = Group)) +
  geom_point() + geom_smooth(method= "lm") + facet_grid(~Group)


### perception of completion vs actual
ggplot(PostQsSmall,aes(x = Win_YouCompleteHardVAS.Tag, y = win_complete_hard_pct, color = Group)) +
  geom_point() + geom_smooth(method= "lm") + facet_grid(~Group)

ggplot(PostQsSmall,aes(x = Loss_YouCompleteHardVAS.Tag, y = loss_complete_hard_pct, color = Group)) +
  geom_point() + geom_smooth(method= "lm") + facet_grid(~Group)
ggplot(PostQsSmall,aes(x = Loss_YouCompleteHardVAS.Tag/10, y = loss_complete_hard_pct*100, color = Group, ymin = 0, xmin= 0)) +
  geom_point() + facet_wrap(~Group) + geom_abline(slope = 1)
# loss completion rates might be interesting place for dif scores

### perception of self vs. other completion
#loss hard
ggplot(PostQsSmall,aes(x = Loss_YouCompleteHardVAS.Tag, y = Loss_OthersHardVASg.Tag, color = Group)) +
  geom_point() + geom_smooth(method= "lm") + facet_grid(~Group)

ggplot(PostQsSmall,aes(x = Loss_YouCompleteHardVAS.Tag, y = Loss_OthersHardVASg.Tag, color = Group)) +
  geom_point() + geom_abline(slope = 1) + facet_wrap(~Group)

# 
ggplot(PostQsSmall,aes(x = Win_YouCompleteHardVAS.Tag, y = Win_OthersHardVASg.Tag, color = Group)) +
  geom_point() + geom_abline(slope = 1) + facet_wrap(~Group)

#
ggplot(PostQsSmall,aes(x = Win_YouCompleteHardVAS.Tag, y = Win_OthersHardVASg.Tag, color = Group,ymin=0,xmin=0)) +
  geom_point() + geom_abline(slope = 1) + facet_wrap(~Group)
# 
ggplot(PostQsSmall,aes(x = Loss_YouCompleteHardVAS.Tag, y = Loss_OthersHardVASg.Tag, color = Group,ymin=0,xmin=0)) +
  geom_point() + geom_abline(slope = 1) + facet_wrap(~Group)

#### difference scores.
PostQsSmall$Win_like_hardMeasy  <- PostQsSmall$Win_Like_or_Dislike_Hard_BipolVAS.Tag - PostQsSmall$Win_Like_or_Dislike_Easy_BipolVAS.Tag
PostQsSmall$Loss_like_hardMeasy  <- PostQsSmall$Loss_Like_or_Dislike_Hard_BipolVAS.Tag - PostQsSmall$Loss_Like_or_Dislike_Easy_BipolVAS.Tag
PostQsSmall$Win_effort_hardMeasy <- PostQsSmall$Win_EffortfulHard_VAS.Tag - PostQsSmall$Win_EffortfulEasy_VAS.Tag
PostQsSmall$Loss_effort_hardMeasy <- PostQsSmall$Loss_EffortfulHard_VAS.Tag - PostQsSmall$Loss_EffortfulEasy_VAS.Tag
##### MLM

# combine 
PostQsSmall$subID <- factor(PostQsSmall$subID)
str(winEffrt)
winEffrt_postQs <- merge(winEffrt,PostQsSmall, all.x = T)

## recoding.
con<-cbind(CtlvsAll=c(-1,3,-1,-1),GADPUREvMDD=c(-1,0,2,-1),MDDpurevCOmo=c(-1,0,0,1)) # create matrix of desired contrasts, give sensible names to each
winEffrt_postQs$GroupC2<-C(winEffrt_postQs$Group,con)  #create new factor variable w/ new contrasts 
contrasts(winEffrt_postQs$GroupC2)

# modeling
library('lme4')
library('effects')



r1 <- glmer(choosehard~GroupC2*expectedvalueHARD + (1|subID),winEffrt_postQs, family='binomial')
# slope model doesn't converge... interesting.
r1slope <- glmer(choosehard~GroupC2*expectedvalueHARD + (1+expectedvalueHARD| subID),winEffrt_postQs, family='binomial')
# no convergge, dif optimizer? see: http://stackoverflow.com/questions/21344555/convergence-error-for-development-version-of-lme4
r1slopeBOBYQA <- glmer(choosehard~GroupC2*scale(expectedvalueHARD,scale=F) + (1+scale(expectedvalueHARD,scale=F)| subID),
                 winEffrt_postQs, family='binomial',control=glmerControl(optimizer="bobyqa"))
#no tfor this, but yes for BOBYQ
r1slopeNedler <- glmer(choosehard~GroupC2*expectedvalueHARD + (1+expectedvalueHARD| subID),
                       winEffrt_postQs, family='binomial',control=glmerControl(optimizer="Nelder_Mead"))


# shite.  I think we should be modeling slopes for individuals..? 
# summary(r1)
summary(r1slopeBOBYQA)

anova(r1)
anova(r1, r1slopeBOBYQA)
anova(r1slopeBOBYQA) # not worth modeling group interaction in 4 group context


rMixed <- glmer(choosehard~GroupC2*expectedvalueHARD +  (1| subID),
      winEffrt_postQs, family='binomial')

### if measure w/ gee...



