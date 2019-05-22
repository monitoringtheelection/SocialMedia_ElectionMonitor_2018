## 
# Helper function
initializeDailyCount_Category <- 
  function(categories){
  dailyHourlyCounts.df_Category <-
    as.data.frame(
      matrix(nrow= length(categories), 
             ncol = 25))
  
  rownames(dailyHourlyCounts.df_Category) <- 
    names(categories_electionWords2018)
  colnames(dailyHourlyCounts.df_Category) <- 
    c("0:00:00",  "1:00:00",  "2:00:00",  "3:00:00",  
      "4:00:00",  "5:00:00",  "6:00:00",  "7:00:00",
      "8:00:00",  "9:00:00",  "10:00:00", "11:00:00", 
      "12:00:00", "13:00:00", "14:00:00", "15:00:00",
      "16:00:00", "17:00:00", "18:00:00", "19:00:00", 
      "20:00:00", "21:00:00", "22:00:00", "23:00:00",
      "TotalFreq")
  return(dailyHourlyCounts.df_Category)
}

# This count hour script could be made simpler
countHour <- function(timeStamps,
                      fullDays = F){
  hourFreq <- data_frame(
    dayHour = 
      paste0(unique(substr(ymd_hms(timeStamps),1,13)),":00:00"),
    freq = 0
  )
  
  
  count = 1
  for(curDate in hourFreq$dayHour){
    curDay = day(curDate)
    curHour = hour(curDate)
    dm <- (day(timeStamps) == curDay)
    hm <- (hour(timeStamps) == curHour)
    hourFreq$freq[count] <- (length(timeStamps[dm & hm]))
    count = count + 1
  }
  
  # all the hour stamps that could be missing
  extra_dayHour <- vector()
  for(date in unique(substr(ymd_hms(timeStamps),1,10))){
    extra_dayHour <- c(extra_dayHour,
                       paste0(date,
                              " ",seq(23,0),
                              ":00:00"))}
  if(fullDays==F){
    minE <- which(hourFreq$dayHour[1] == extra_dayHour)
    maxE <- which(hourFreq$dayHour[nrow(hourFreq)] == extra_dayHour)
    
    # just grab the hour stamps between the first and last time of the
    # data we pull
    t <- data.frame(dayHour = extra_dayHour[minE:maxE],
                    order = seq(1, length(extra_dayHour[minE:maxE])),
                    stringsAsFactors = F)
  } else{
    t <- data.frame(dayHour = extra_dayHour,
                    order = seq(1, length(extra_dayHour)),
                    stringsAsFactors = F)
  }
  if ( nrow(t) == nrow(hourFreq) ) {
    t2 <- hourFreq
  } else {
    # merge
    t2 <- merge(hourFreq,t, all.y = T)
    #fix the order
    t2 <- t2[order(t2$order),]
    
    # any that were missing are freq 0
    t2[is.na(t2$freq),]$freq <- 0
    t2$order <- NULL
    t2$freq <- as.integer(t2$freq)
  }

  return(t2)
}



###

getCatVar <- function(dailyTweets, 
                      categories){
  containsCat <- list()
  for(i in 1:length(categories)){
    #current word
    setOfWords <- categories[[i]]
    
    #whichTweets contain the current Word?
    containsWord <- 
      str_detect(dailyTweets$full_content, 
                 paste(setOfWords, collapse = '|'))
    
    containsCat[[i]] <-containsWord 
  }
  dailyTweets$fraud <- containsCat[[1]]
  dailyTweets$electionDayVoting <- containsCat[[2]]
  dailyTweets$pollingPlaces <- containsCat[[3]]
  dailyTweets$remoteVoting <- containsCat[[4]]
  dailyTweets$voterID <- containsCat[[5]]
  
  return(dailyTweets)
}

makeHourlyCat.df <- 
  function(dailyTweets,categories){
  dailyHourlyCounts.cat <- 
    initializeDailyCount_Category(categories)
  
  for(i in 1:length(categories)){
    columnIndex <- which(names(dailyTweets) ==
                           names(categories)[i])
    
    tweetsWithWord <- dailyTweets %>%
      filter(dailyTweets[,columnIndex] == T)
    if(nrow(tweetsWithWord) == 0){
      dailyHourlyCounts.cat[i,] <- rep(0,25)
    } else {
      hourCounts <-
        countHour(tweetsWithWord$created_at,
                  fullDays = T)
      #reverse order
      hourCounts<- hourCounts[nrow(hourCounts):1,]
      hourCounts <- rbind(hourCounts,
                          c("TotalFreq", sum(hourCounts$freq)))
      dailyHourlyCounts.cat[i,] <- hourCounts$freq
    }
    
  }
  for(i in 1:ncol(dailyHourlyCounts.cat)){
    dailyHourlyCounts.cat[,i] <-
      as.integer(dailyHourlyCounts.cat[,i] )
  }
  return(dailyHourlyCounts.cat)
}


