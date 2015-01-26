#### script to check cheaters. looking at number of unique presses

require('ggplot2')
require("psych")

# read in data
winRTs <- read.csv("~/Dropbox/PACO_JS/EEfRT_analysis/Effort_Data/EEfRT_WIN_RTs.csv")
winRaw <- read.csv("~/Dropbox/PACO_JS/EEfRT_analysis/Effort_Data/EEfRTwin_agg_matlab_Sept2014.csv")

## have a problem - need to match up trials, 
# look at winRaw vars 
View(winRaw[winRaw$subID == 2622,])
winRaw$icounter
winRaw[winRaw$subID == 2622,'icounter']
winRaw[winRaw$subID == 2622,'resultcounter']
# and RTs
View(winRTs[winRTs$subID == 2622,])
winRTs[winRTs$subID == 2622,'trial']

# can we use icounter or result counter if subtract one?
winRTs[winRTs$subID == 2622,'trial'] ==  winRaw[winRaw$subID == 2622,'icounter'] - 1
winRTs[winRTs$subID == 2622,'trial'] == winRaw[winRaw$subID == 2622,'resultcounter'] - 1

# possibly... let's try
winRaw$trialForMerge <- winRaw$resultcounter - 1

tryMerge <- merge(winRaw, winRTs, by.x = c("subID", "trialForMerge"),
                  by.y = c("subID", "trial"), sort = FALSE)
sum(tryMerge$trialForMerge != tryMerge$trial) # it worked, great!


# ok, now let's figure out cheaters. 
View(tryMerge[tryMerge$subID == 2622,])

## visualize number of unique presses, question: how variable is the unique press metric

# look at trials greater than 4 (first 4 are practice)
str(tryMerge)

# look at button presses
ggplot(tryMerge, aes(x = uniquepresses)) + geom_histogram() + facet_grid(completeTrue~difficulty)
ggplot(tryMerge[tryMerge$uniquepresses < 10,], aes(x = uniquepresses)) + geom_histogram() + facet_grid(completeTrue~difficulty)

describeBy(tryMerge$uniquepresses,tryMerge$difficulty)
tryMerge$onePress <- tryMerge$uniquepresses == 1
tryMerge$fewPress <- tryMerge$uniquepresses < 10 & tryMerge$difficulty == 'h'

ggplot(tryMerge[tryMerge$medRTpress > 1, ], aes(x = medRTpress)) + geom_histogram() + facet_grid(onePress~difficulty)
ggplot(tryMerge, aes(x = medRTpress)) + geom_histogram() + facet_grid(onePress~difficulty)

View(tryMerge[tryMerge$onePress == TRUE,])
View(tryMerge[tryMerge$fewPress == TRUE,])
describeBy(tryMerge$medRTpress,tryMerge$difficulty)

## who are the cheaters? 
tabbedSubs <- xtabs(~fewPress + subID, tryMerge)
xtabs(~onePress  + subID, tryMerge)
# looks like
probCheaters <- c(2747,2755,2680)


###### now for the loss ones. 





# read in data
lossRTs <- read.csv("~/Dropbox/PACO_JS/EEfRT_analysis/Effort_Data/EEfRTloss_RTs.csv")
lossRaw <- read.csv("~/Dropbox/PACO_JS/EEfRT_analysis/Effort_Data/EEfRTloss_agg_network_nov_2014.csv")

## have a problem - need to match up trials, 
# look at lossRaw vars 
View(lossRTs[lossRTs$subID == 2622,])
lossRaw$icounter
lossRaw[lossRaw$subID == 2622,'icounter']
lossRaw[lossRaw$subID == 2622,'resultcounter']
# and RTs
View(lossRTs[lossRTs$subID == 2622,])
lossRTs[lossRTs$subID == 2622,'trial']

# can we use icounter or result counter if subtract one?
lossRTs[lossRTs$subID == 2622,'trial'] ==  lossRaw[lossRaw$subID == 2622,'icounter'] - 1
lossRTs[lossRTs$subID == 2622,'trial'] == lossRaw[lossRaw$subID == 2622,'resultcounter'] - 1

# possibly... let's try
lossRaw$trialForMerge <- lossRaw$resultcounter - 1

tryMergeLoss <- merge(lossRaw, lossRTs, by.x = c("subID", "trialForMerge"),
                      by.y = c("subID", "trial"), sort = FALSE)
sum(tryMergeLoss$trialForMerge != tryMergeLoss$trial) # it worked, great!


# ok, now let's figure out cheaters. 
View(tryMergeLoss[tryMergeLoss$subID == 2622,])

## visualize number of unique presses, question: how variable is the unique press metric

# look at trials greater than 4 (first 4 are practice)
str(tryMergeLoss)

# look at button presses
ggplot(tryMergeLoss, aes(x = uniquepresses)) + geom_histogram() + facet_grid(completeTrue~difficulty)
ggplot(tryMergeLoss[tryMergeLoss$uniquepresses < 10,], aes(x = uniquepresses)) + geom_histogram() + facet_grid(completeTrue~difficulty)

describeBy(tryMergeLoss$uniquepresses,tryMergeLoss$difficulty)
tryMergeLoss$onePress <- tryMergeLoss$uniquepresses == 1 & tryMergeLoss$completeTrue == TRUE
tryMergeLoss$fewPress <- tryMergeLoss$uniquepresses < 10 & tryMergeLoss$difficulty == 'h'

ggplot(tryMergeLoss[tryMergeLoss$medRTpress > 1, ], aes(x = medRTpress)) + geom_histogram() + facet_grid(onePress~difficulty)
ggplot(tryMergeLoss, aes(x = medRTpress)) + geom_histogram() + facet_grid(onePress~difficulty)

View(tryMergeLoss[tryMergeLoss$onePress == TRUE,])
View(tryMergeLoss[tryMergeLoss$fewPress == TRUE,])
describeBy(tryMergeLoss$medRTpress,tryMergeLoss$difficulty)

## who are the cheaters? 
xtabs(~fewPress + subID, tryMergeLoss)
xtabs(~ difficulty + onePress  + subID, tryMergeLoss)
# looks like
# probCheatersLoss <- c(2671,2776,2846) #this is "few presses"
tryMergeLoss$key <- 1

cheatersLoss <- aggregate(key ~ fewPress + subID, tryMergeLoss, sum)
cheatersLoss <- dcast(cheatersLoss, subID ~ fewPress)



##### is there systematic pattern to cheeting trials? 

#reread in data, make sure we have correct versions

# possibly... let's try
winRTs <- read.csv("~/Dropbox/PACO_JS/EEfRT_analysis/Effort_Data/EEfRT_WIN_RTs.csv")


winEffrt <- readCleanEffrt(eFileNameWin,subFileName,dropBadSubsChoice = F,dropBadSubsIncomplete = F)
winEffrt$trialForMerge <- winEffrt$resultcounter - 1
tryMerge <- merge(winEffrt, winRTs, by.x = c("subID", "trialForMerge"),
                  by.y = c("subID", "trial"), sort = FALSE)
sum(tryMerge$trialForMerge != tryMerge$trial) # it worked, great!
# cheaters: one press, trial complete, not practice
tryMerge$didCheat <- tryMerge$uniquepresses == 1 & tryMerge$completeTrue == TRUE & tryMerge$trial > 4



str(tryMerge)

ggplot(tryMerge,aes(x=expectedvalueHARD,y=as.numeric(choosehard)),group=Group,color=Group)+geom_point(alpha=.05)+
  stat_smooth(method=glm,family='binomial')+ facet_grid(~)

# on average cheating trials look to be cheating trials
ggplot(tryMerge, aes(x = varAmount, y = prob )) + geom_point(alpha=.3) +  facet_grid(~)
ggplot(tryMerge, aes(x = factor(prob), y = varAmount )) + geom_boxplot() +  facet_grid(difficulty~)

## how many people have cheating trials (and how many?)
cheatersDifficulty <- aggregate(~ subID + Group + difficulty, tryMerge, sum)
ggplot(cheatersDifficulty, aes( x =  )) + geom_histogram() + facet_grid(~difficulty)



# it looks like there's a clear cutoff after 5 
cheatersNoDif <- aggregate(~ subID + Group , tryMerge, sum)
sum(cheatersNoDif$ > 5)
ggplot(cheatersNoDif, aes( x =  )) + geom_histogram()

cheatersNoDif$[cheatersNoDif$ > 2]
describe(cheatersNoDif$)


### pcts? 
cheatersNoDif <- aggregate(~ subID + Group , tryMerge[tryMerge$difficulty == 'h',], sum)
names(cheatersNoDif) <- c("subID", "Group", "n1Press")
cheatersHowMany <- aggregate(~ subID + Group , tryMerge[tryMerge$difficulty == 'h',], length)
names(cheatersHowMany) <- c("subID","Group","nTrials")
cheatersWin <- merge(cheatersNoDif,cheatersHowMany)

cheatersWin$pct <- cheatersWin$n1Press /(cheatersWin$nTrials)
describe(cheatersWin$pct)
ggplot(cheatersWin, aes( x = pct )) + geom_histogram()
sum (cheatersWin$pct > .1)
View(cheatersWin[cheatersWin$pct > .1,])
badMonkeys <- cheatersWin[cheatersWin$pct > .1,'subID']


# did those with small cheating numbers figure it out late in the task?

View(tryMerge[tryMerge$subID %in% badMonkeys,])
aggregate(trial ~  + subID , tryMerge[tryMerge$subID %in% badMonkeys,],mean)

ggplot(tryMerge, aes(x = trial, y = subID, color = )) + 
  geom_point() + facet_grid(difficulty~)
cheatersDifficulty[cheatersDifficulty$subID %in% badMonkeys,]

### the cheaters cheat on worthwhile trials...
fewTrialCheaters <- cheatersWin[cheatersWin$pct > .1 & cheatersWin$pct < .3,'subID']
ggplot(tryMerge[tryMerge$subID %in% fewTrialCheaters,], aes(x = varAmount, y = prob )) + geom_point(alpha=.3) +  facet_grid(~)



