produceStateByStateFreq <- function(stateCodes){
  # add one if zero. Helps with maps. 
  # TODO: fix
  missingStates <- 
    state.abb[which(!state.abb %in% names(table(stateCodes)))]
  stateCodes <-
    rbind(stateCodes, data.frame(regExStateCodes = missingStates))
  # This will often be one column in the twitter data.
  stateByStateFreq <- data.frame(table(stateCodes))
  
  # First: Prepare state freq for proper format
  names(stateByStateFreq)[1] <- "region"
  
  # from two-letter state abbreviation to name of state lowercased.
  stateByStateFreq$region <- state.name[match(stateByStateFreq$region,state.abb)]
  stateByStateFreq$region<- tolower(stateByStateFreq$region)
  
  statePopulation[1] <- tolower(unlist(statePopulation[1]))
  names(statePopulation)[1] <- "region"
  statePopulation$Census <- as.numeric(gsub(",","",statePopulation$Census))
  stateByStateFreq <- stateByStateFreq[!is.na(stateByStateFreq$region),]
  
  return(stateByStateFreq)
}
produceUSMap <- function(stateFreq, statePop, type = "perCapita"){
  
  all_states <- map_data("state")
  
  # Merging state data with frequency and per capita data
  all_states <- merge(all_states, statePop[,1:2], by="region")
  TotalFreq <- merge(all_states, stateFreq, by = "region")
  
  TotalFreq <- TotalFreq[order(TotalFreq$order),]
  # Remove DC
  TotalFreq <- TotalFreq[TotalFreq$region!="district of columbia",]
  
  statePopulationCen <- 
    statePopulation %>% 
    select(region, Census)
  # merge population
  TotalFreq <- merge(TotalFreq,  
                     statePopulationCen,
                     by = "region")
  
  # The map
  p <- ggplot()
  if(type == "perCapita"){
    TotalFreq$perCaptia <- (TotalFreq$Freq / TotalFreq$Census)
    p <- p + geom_polygon(data= TotalFreq, aes(x=long, y=lat, group = group, 
                                               fill=TotalFreq$perCaptia),colour="white") + 
      scale_fill_continuous(low = "lightblue", high = "blue", guide="colorbar")
    fillLabel <- 'Tweets per Capita\n'
  } else if (type == "rawFreq"){
    p <- p + geom_polygon(data= TotalFreq, aes(x=long, y=lat, group = group, 
                                               fill=TotalFreq$Freq),colour="white") + 
      scale_fill_continuous(low = "lightblue", high = "blue", guide="colorbar")
    fillLabel <- 'Number of \nTweets\n'
  }
  
  P1 <- p + theme_minimal()  + labs(fill = fillLabel, title = "", x="", y="")
  P1  <- P1 + scale_y_continuous(breaks=c()) + 
    scale_x_continuous(breaks=c())
  P1 <- P1 + theme(legend.text = element_text(size = 20),
                   text=element_text(size=20)) +
    guides(color = guide_legend(title.position = "top", 
                                # hjust = 0.5 centres the title horizontally
                                title.hjust = 0.5,
                                label.position = "bottom")) 
  # + 
  # theme( legend.text=element_text(size=14) )
  return(P1)
}


# This map is for the 2018 website.
createMapsForWeb <- function(inputData, 
                             outfile, 
                             statePopulation,
                             typeMap = 'perCapita'){
  t.fraud <- inputData %>% 
    filter(!is.na(regExStateCodes)) %>%
    filter(fraud==T) %>%
    select(regExStateCodes)  
  
  t.electionDayVoting <- inputData %>% 
    filter(!is.na(regExStateCodes)) %>%
    filter(electionDayVoting==T) %>%
    select(regExStateCodes)  
  
  t.remoteVoting <- inputData %>% 
    filter(!is.na(regExStateCodes)) %>%
    filter(remoteVoting ==T) %>%
    select(regExStateCodes)  
  
  t.voterID <- inputData %>% 
    filter(!is.na(regExStateCodes)) %>%
    filter(voterID ==T) %>%
    select(regExStateCodes) 
  
  
  
  stateByStateFreq.fraud <- 
    produceStateByStateFreq(t.fraud)
  
  stateByStateFreq.electionDayVoting <- 
    produceStateByStateFreq(t.electionDayVoting)
  
  stateByStateFreq.remoteVoting <- 
    produceStateByStateFreq(t.remoteVoting)
  
  stateByStateFreq.voterID <- 
    produceStateByStateFreq(t.voterID)
  
  jpeg(paste0(outfile,"map_fraud.jpg"),
       width = 1344, height=768)
  print(produceUSMap(stateByStateFreq.fraud, 
                     statePopulation, 
                     type = typeMap))
  dev.off()
  
  jpeg(paste0(outfile,"map_electionDayVoting.jpg"),
       width = 1344, height=768)
  print(produceUSMap(stateByStateFreq.electionDayVoting, 
                     statePopulation, 
                     type = typeMap))
  dev.off()
  
  jpeg(paste0(outfile,"map_remoteVoting.jpg"),
       width = 1344, height=768)
  print(produceUSMap(stateByStateFreq.remoteVoting, 
                     statePopulation, 
                     type = typeMap))
  dev.off()
  
  jpeg(paste0(outfile,"map_voterID.jpg"),
       width = 1344, height=768)
  print(produceUSMap(stateByStateFreq.voterID, 
                     statePopulation, 
                     type = typeMap))
  dev.off()
  
}
