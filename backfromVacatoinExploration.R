## jim pokes around to remember what he did

# how long does it take to decide to do hard?
winEffrt$choicetime <- winEffrt$choiceoffset - winEffrt$choiceonset
timetaken <- aggregate(choicetime~choosehard+subID+Group,winEffrt,median)
aggregate(choicetime~choosehard+Group,timetaken,mean)


ggplot(winEffrt,aes(x=expectedvalueHARD,y=choicetime,color=Group))+geom_point()+
  stat_smooth(method=lm) +facet_grid(difficulty~Group)

## extracted from /Users/Jim/Dropbox/EEFRT_analysis/SRP2.R 
p3 <- ggplot(winEffrt[winEffrt$difficulty=='h',],aes(x=expectedvalueHARD,y=xScale,color=Group))+geom_point()+stat_smooth(method=lm)
p3+facet_wrap(~Group)+ ggtitle("ev predict effort, hard only")

p3 <- ggplot(winEffrt,aes(x=expectedvalueHARD,y=xScale,color=Group))+geom_point()+stat_smooth(method=lm)
p3+facet_wrap(~Group)+ ggtitle("ev predict effort, all")

p3 <- ggplot(winEffrt[winEffrt$difficulty=='e',],aes(x=expectedvalueHARD,y=xScale,color=Group))+geom_point()+stat_smooth(method=lm)
p3+facet_wrap(~Group)+ ggtitle("ev predict effort, easy only")


> p3 <- ggplot(winEffrt,aes(x=xScale,y=expectedvalueHARD,color=Group))+geom_point()+stat_smooth(method=lm)
> p3+facet_wrap(difficulty~Group)+ ggtitle("ev predict effort, all")

#### gahhhhh
rEV<-lmer(xScale~expectedvalueHARD*GroupC2+ (1|subID),winEffrt)
rEV_hard<-lmer(xScale~expectedvalueHARD*GroupC2+ (1|subID),winEffrt[winEffrt$difficulty=='h',])
rEV_easy<-lmer(xScale~expectedvalueHARD*GroupC2+ (1|subID),winEffrt[winEffrt$difficulty=='e',])

# how much effort is not my question
rEV_inter<-lmer(xScale~expectedvalueHARD*GroupC2*difficulty+ (1|subID),winEffrt)
summary(rEV_inter)
anova(rEV_inter)


#### exploring how often look forward to things and EEFFRT more...
setdiff(lookgingfwdresp$Subject,WinEEfRTsummary$Subject)
setdiff(WinEEfRTsummary$Subject,lookgingfwdresp$Subject)

subjLevelEWinLkFwd <- merge(lookgingfwdresp,WinEEfRTsummary)
str(subjLevelEWinLkFwd)
ggplot(subjLevelEWinLkFwd,aes(x=lkfwd_pct,y=EEfRT_ratio,color=Group))+geom_point()+stat_smooth(method=lm)+facet_wrap(~Group)
ggplot(subjLevelEWinLkFwd,aes(x=lkfwd_pct,y=EEfRT_ratio))+geom_point()+stat_smooth(method=lm)

##splitting on few prompts said look forward
ggplot(subjLevelEWinLkFwd,aes(x=fewYes,y=EEfRT_ratio))+geom_boxplot()
t.test(EEfRT_ratio~fewYes,subjLevelEWinLkFwd,var.equal = TRUE)

ggplot(subjLevelEWinLkFwd,aes(x=Group,y=EEfRT_ratio,color=Group))+geom_boxplot()
ggplot(subjLevelEWinLkFwd,aes(x=Group,y=EEfRT_ratio,color=Group))+geom_boxplot()
ggplot(subjLevelEWinLkFwd,aes(x=lkfwd_pct,y=EEfRT_ratio,color=fewYes))+geom_point()+stat_smooth(method=lm)+facet_wrap(~fewYes)
ggplot(subjLevelEWinLkFwd,aes(x=lkfwd_pct,y=EEfRT_ratio,color=Group))+geom_point()+stat_smooth(method=lm)
# no split, just lm.
ggplot(subjLevelEWinLkFwd,aes(x=lkfwd_pct,y=EEfRT_ratio))+geom_point()+stat_smooth(method=lm)
lkFwdEffrt <- lm(EEfRT_ratio~lkfwd_pct,subjLevelEWinLkFwd)
summary(lkFwdEffrt)
anova(lkFwdEffrt)

#### merge lkfwd into bigger win
winEffrt2 <- merge(lookgingfwdresp,winEffrt,by.x= c("Subject","Group","GroupC2"),
                   by.y = c("subID","Group","GroupC2"))
str(winEffrt2)
ggplot(winEffrt2,aes(x=expectedvalueHARD,y=as.numeric(choosehard)))+geom_point()+
  geom_point(alpha=.05)+stat_smooth(method=glm,family='binomial') 

ggplot(winEffrt2,aes(x=expectedvalueHARD,y=as.numeric(choosehard),color = Group))+geom_point()+
  geom_point(alpha=.05)+stat_smooth(method=glm,family='binomial') + facet_grid(Group~fewYes)

ggplot(winEffrt2,aes(x=expectedvalueHARD,y=as.numeric(choosehard),color = Group))+geom_point()+
  geom_point(alpha=.05)+stat_smooth(method=glm,family='binomial') + facet_grid(~Group)


r1<-glmer(choosehard~fewYes*expectedvalueHARD+(1|Subject),family=binomial,winEffrt2)
summary(r1)
anova(r1)

r2<-glmer(choosehard~GroupC2*expectedvalueHARD+(1|Subject),family=binomial,winEffrt2)
summary(r2)
anova(r2)

r2slopes<-glmer(choosehard~GroupC2*expectedvalueHARD+(1+expectedvalueHARD|Subject),family=binomial,winEffrt2)
summary(r2slopes)
anova(r2)

### 
winEffrt2$hasPsychopathology <- winEffrt2$Group != "CTL"
# it is 
r3<-glmer(choosehard~hasPsychopathology*expectedvalueHARD+(1|Subject),family=binomial,winEffrt2)
summary(r3)
anova(r3)
r3slopes<-glmer(choosehard~hasPsychopathology*expectedvalueHARD+(1+expectedvalueHARD|Subject),family=binomial,winEffrt2)
summary(r3slopes)
anova(r3)

## is effect of having psychopathology different than main effect of few looking forward?
ggplot(winEffrt2,aes(x=expectedvalueHARD,y=as.numeric(choosehard),color = fewYes))+geom_point()+
  geom_point(alpha=.05)+stat_smooth(method=glm,family='binomial') + facet_grid(~hasPsychopathology)

r4slopes<-glmer(choosehard~hasPsychopathology*expectedvalueHARD+ fewYes+(1+expectedvalueHARD|Subject),family=binomial,winEffrt2)
anova(r3slopes,r4slopes)
summary(r4slopes)

## model comparison, start with fewyes

comp1<-glmer(choosehard~expectedvalueHARD+ fewYes+(1+expectedvalueHARD|Subject),family=binomial,winEffrt2)
comp1b<-glmer(choosehard~expectedvalueHARD* fewYes+(1+expectedvalueHARD|Subject),family=binomial,winEffrt2)
comp2<-glmer(choosehard~expectedvalueHARD+ Group+ fewYes+(1+expectedvalueHARD|Subject),family=binomial,winEffrt2)
comp2b <- glmer(choosehard~expectedvalueHARD+ hasPsychopathology + fewYes+(1+expectedvalueHARD|Subject),family=binomial,winEffrt2)
comp3b <- glmer(choosehard~expectedvalueHARD* hasPsychopathology + fewYes+(1+expectedvalueHARD|Subject),family=binomial,winEffrt2)
comp4b <- glmer(choosehard~expectedvalueHARD* fewYes + hasPsychopathology +(1+expectedvalueHARD|Subject),family=binomial,winEffrt2)
anova(comp1,comp1)
anova(comp1,comp2b,comp3b)
anova(comp1,comp2b,comp4b)


### maybe I should be doing this w/ a median split on how often ppl look forward to things?
str(winEffrt2)

median(winEffrt2$lkfwd_pct)
winEffrt2$medianLkFwd <- factor(winEffrt2$lkfwd_pct > .25, labels = c("low","high"))
subjLevelEWinLkFwd$medianLkFwd <- factor(subjLevelEWinLkFwd$lkfwd_pct > .25, labels = c("low","high"))
t.test(EEfRT_ratio~medianLkFwd,subjLevelEWinLkFwd,var.equal = TRUE) #if done w/ median, it's NS (not surprising, it was ns in model)

### well, I'm doing this crudely. one reason overall EEFRT ratios could be low is strategy - you
# can see more trials if you do more easy tasks. ugh.


ggplot(subjLevelEWinLkFwd,aes(x=lkfwd_pct,y=,color=Group))+geom_point()+stat_smooth(method=lm)





# although, the logic of all these analysis isn't *quite* what I want to say. This logic is saying that
# measuringperformance 

