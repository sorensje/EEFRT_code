### read and clean win
### get packages
require(reshape2)
require(ggplot2)
require(reshape2)
require(psych)
source("~/Dropbox/R/helperfunctions/fixDCastNames.R")

#constants used in analysis
readCleanEffrt <- function(eFileName,subFileName, reportStats = TRUE,
                           dropPracticeTrials = TRUE,
                           dropBadSubsChoice = TRUE,
                           dropBadSubsIncomplete = TRUE,
                           cleanChoices = TRUE, cleanIncompletes = TRUE,
                           nSkipChoice = 4, nIncomplete = 4){
  # function to load and clean effort data. If specified, will clean file of 
  # missed choices: trials in which participant failed ot choose between easy 
  # and hard tasks, incomplete trials : trials in which participants didn't press the
  # button the required number of times, and "bad subs" : participants who habitually
  # didn't choose in time or complete the button pressing
  # 
  #args: 
  # eFileName:name of csv of EFFORT data created via aggregate functions 
  # subFileName: name of csv of csv w/ sub numbers and Group membership
  # reportStats: boolean, whether to print stats on missed choices and incomplete trials
  #
  
  # load data, make data frame.
  effRTdat_raw <- read.csv(eFileName)
  effRTdat_raw$subID<-factor(effRTdat_raw$subID)
  subs <- read.csv(subFileName)
  subs$Subject<-factor(subs$Subject)
  effRTdat<-merge(effRTdat_raw,subs,all.x=T,all.y=F,by.x="subID",by.y="Subject",sort=F)
 
  #remove practice trials
  if (dropPracticeTrials){
    effRTdat <- effRTdat[effRTdat$trial >= 5, ]
  }
  
  ### find bad 'subjects', choices
  choicesmade <- dcast(effRTdat,subID+Group~choice,
                       fun.aggregate = length,value.var = "choice",drop = FALSE)
  names(choicesmade) <- fixDCastNames(choicesmade)
  badsubs_fewchoice <- choicesmade[choicesmade$NoAnswer > nSkipChoice,'subID',]
  
  ### find bad 'subjects', completed trials
  completedtrials <- dcast(effRTdat,subID+Group~completeTrue,
                           fun.aggregate = length,value.var = "choice",drop = FALSE)
  names(completedtrials) <- fixDCastNames(completedtrials)
  badsubs_incomplete <- completedtrials[completedtrials$no > nIncomplete,'subID']
  
  ## summarize possible cleaning steps
  
  if(reportStats){
    cat("Total Trials in Raw Data:", dim(effRTdat)[1])
    cat("\ncutoffs:","\n  bad choices: ", nSkipChoice,
          "\n trials incomplete: ", nIncomplete)
    cat("\nhow many trials not chosen:\n")
    print(xtabs(~choice+Group,effRTdat))
    cat("\nhow many trials not completed (not enough taps):\n")
    print(xtabs(~completeTrue+Group,effRTdat)) 
    cat("\nthese subjects missed many choices:\n")
    print(choicesmade[choicesmade$subID %in% badsubs_fewchoice & choicesmade$NoAnswer >= nSkipChoice ,]) #slight hack, if no times chose s, will not be displayed
    cat("\nthese subjects didnt finish many trials:\n")
    print(completedtrials[completedtrials$subID %in% badsubs_incomplete & completedtrials$yes>= nIncomplete ,]) 
  }
  # calculate total trials before drops
  effRTdat <- getTotalBySub(effRTdat,"RateTask","subID","totalTrialsNoDrops")
  
  # drop trials an subjects according to flags
  if(dropBadSubsChoice) {
    effRTdat <- effRTdat[!effRTdat$subID %in% badsubs_fewchoice,]
  }
  if(dropBadSubsIncomplete) {
    effRTdat <- effRTdat[!effRTdat$subID %in% badsubs_incomplete,]
  }
  if(cleanIncompletes) {
    cat( "\ndropping: ", sum(effRTdat$completeTrue!=1), "incomplete trials" )
    effRTdat <- effRTdat[effRTdat$completeTrue==1,]
  }
  if(cleanChoices) {
    totalNoChoice <- is.na(effRTdat$choice) | effRTdat$choice == "No Answer"
    cat( "\ndropping: ", sum(totalNoChoice), " trials where no choice was made" )
    effRTdat<-effRTdat[is.finite(effRTdat$choice),]
    effRTdat<- effRTdat[effRTdat$choice !="No Answer",]
  }
  
  cat("\n Dropped", length(setdiff(effRTdat_raw$subID,effRTdat$subID)), " participants")
  
  #new vars and return.
  effRTdat$choosehard<- effRTdat$difficulty=='h' #binary var   
  effRTdat
  
}


## getTotalBySub: helper function to count the total number of times event occured.
# intended to work on boolean/binary variables, but would sum up
# other numeric vars as well

### debugging vars
# sumVarName = "RateTask"
# idVarName = "subID"
# newVarName = "totalTrials"
# data = eefrtDat

getTotalBySub <- function(data, sumVarName, idVarName, newVarName, printAgg = FALSE){
  form <- as.formula(paste(sumVarName, "~", idVarName, sep=""))
  tempAgg <- aggregate(form, data,sum)
  names(tempAgg) <- c(idVarName,newVarName)
  tempMergedData <- merge(data, tempAgg)
  if(printAgg) print(tempAgg)
  if(newVarName %in% names(data)){
    cat("new variable already exists")
    return(data)
  } else {
    return(tempMergedData)
  }
}

## helper function that returns a vector of subject level values (short form) from long
# form data frame
grabSubTotals <- function(data, reqeustedVar, idVarName = "subID"){
  form <- as.formula(paste(reqeustedVar, "~", idVarName, sep=""))
  tempAgg <- aggregate(form, data,unique)
  tempAgg[,reqeustedVar]  
}