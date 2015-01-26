## accept df of all qualrics questionaires return DF of just questionnaire


getQualDat <- function (QUESTIONNAIRES_TO_PULL=QUESTIONNAIRES_TO_PULL,allQualtrics=allQualtrics){
  refVec <- as.vector(t(allQualtrics[1,])) #transpose cause it's a row
  wantedCols <- which(refVec %in% c('BookKeeping','subID',QUESTIONNAIRES_TO_PULL))
  # strip instructions
  Qsasked <- as.vector(t(allQualtrics[2,]))
  for(i in 1:length(Qsasked)){
    Qsasked[i] = gsub(".*...-","",Qsasked[i]) #get rid of instructions
    Qsasked[i] = paste(refVec[i],Qsasked[i],"") # don't let
    Qsasked[i] = gsub("<br/>","",Qsasked[i]) 
    Qsasked[i] = gsub("<br>","",Qsasked[i]) 
    Qsasked[i] = gsub("&nbsp;","",Qsasked[i])
    
    print(Qsasked[i])
  }
  Qsasked = str_trim(Qsasked)
  
  ## get subset of data
  questDat <- allQualtrics[(Q_ROW+1):length(allQualtrics[,1]),wantedCols]
  oldnames <- names(questDat)
  #rename vars
  names(questDat) <- Qsasked[wantedCols]
  str(data.frame(questDat))
  
  #   str(data.frame(questDat))
  return(questDat)
}
### 