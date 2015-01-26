
# function use:

# rtFileName <- "~/Dropbox/PACO_JS/EEfRT_analysis/Effort_Data/EEfRT_LOSS_RTs.csv"
# # winE2 <- addKeyPresses(winEffrt,winRTfile)
eefrtDat <- winEffrt
rtFileName <- "~/Dropbox/PACO_JS/EEfRT_analysis/Effort_Data/EEfRT_WIN_RTs.csv"

# eefrtDat <- winEffrt2
# eefrtDat <- readCleanEffrt(eFileNameLoss,subFileName)

require("reshape2")
findCheatTrials <- function(eefrtDat, rtFileName, cheatCutOff = 1){
  
  # add RT data to EfffRT 
  rtDat <- read.csv(rtFileName)
  rtDat$subID <- factor(rtDat$subID)
  eefrtDat$trialForMerge <- eefrtDat$resultcounter - 1
  rtDat$trialChecker <- rtDat$trial
  
  # remove practice trials from RTs if needed
  if(sum(eefrtDat$trial < 5) == 0 ){
    rtDat <- rtDat[rtDat$trial >= 5,]
  }
  
  # will drop trials not found in original
  tryMerge <- merge(eefrtDat, rtDat, by.x = c("subID", "trialForMerge"),
                    by.y = c("subID", "trial"), sort = FALSE, all.x = TRUE, all.y = FALSE)
   
  # cheaters: one press, trial complete, not practice
  tryMerge$didCheat <- tryMerge$uniquepresses <= cheatCutOff & tryMerge$completeTrue == TRUE 
  
  # will use this var for RT sanity check
  tryMerge$durationCalculated <- tryMerge$EndTime - tryMerge$start
  
  # sanity checks
  if (sum(tryMerge$trialForMerge != tryMerge$trial) == 0
      && dim(eefrtDat)[1] == dim(tryMerge)[1]
      && sum(abs(tryMerge$durationCalculated - tryMerge$trialduration) > 1) == 0){
    cat("\nnew d.f. is same length, trials of RTs and passed df match, RTs lined up",
        "\n added RT info and defined cheat Trials as fewer than ",cheatCutOff,
        " unique button press")
    eefrtDat <- tryMerge
    } else{
      cat ("df did not pass checks. original data fram returned")
    }
  eefrtDat #return df. if it passed checks will have cheaters defined
}


