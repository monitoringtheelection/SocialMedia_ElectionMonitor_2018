# This takes my dataframe input and 
# outputs raw text in the form of js objects.
makeNewDailyVars <-function(datainput){
  fraudText <- 
    getVarText(datainput, 'fraud')
  eDayVoteText <-
    getVarText(datainput, 'electionDayVoting')
  pollPlaceText <-
    getVarText(datainput, 'pollingPlaces')
  remoteVotingText <-
    getVarText(datainput, 'remoteVoting')
  voteIdText <- 
    getVarText(datainput, 'voterID')
  
  fraudText_Total <- 
    getVarText_Total(datainput, 'fraud')
  eDayVoteText_Total <-
    getVarText_Total(datainput, 'electionDayVoting')
  pollPlaceText_Total <-
    getVarText_Total(datainput, 'pollingPlaces')
  remoteVotingText_Total <-
    getVarText_Total(datainput, 'remoteVoting')
  voteIdText_Total <- 
    getVarText_Total(datainput, 'voterID')
  
  space = ''
  
  allVars <- c(fraudText, eDayVoteText,
               pollPlaceText, remoteVotingText,
               voteIdText, 
               space,
               fraudText_Total, eDayVoteText_Total,
               pollPlaceText_Total, 
               remoteVotingText_Total,
               voteIdText_Total)
  return(allVars)
  
}

getVarText<- function(datainput, 
                      typeText,
                      typeDF = 'cat'){
  if(typeDF == 'cat') {
    t <- datainput %>% 
      filter(row.names(.) == typeText)
  } else if (typeDF == 'word') {
    t <- datainput %>% 
      filter(type == typeText) %>% 
      select(-type) %>%
      colSums() 
  }
  nums <- glue::collapse(as.character(t[1:24]), sep = ",")
  fraudText<- 
    paste('var', typeText,
          '= [',
          nums,
          '];')
  return(fraudText)
}

getVarText_Total <- function(datainput, 
                             typeText,
                             typeDF = 'cat'){
  if(typeDF == 'cat') {
    t <- datainput %>% 
      filter(row.names(.) == typeText)
  } else if (typeDF == 'word') {
    t <- datainput %>% 
      filter(type == typeText) %>% 
      select(-type) %>%
      colSums() 
  }
  nums <- as.character(t[25])
  returnText<- 
    paste0('var ', typeText,
           '_total ',
           '= [ ',
           nums,
           ' ];')
  return(returnText)
}


###

# Get web address and edit js and html files
#   This ONLY works for the specific html and js 
#   code I wrote for the 2018 monitor

# change webcode for counts
updateWebsiteCounts <-
  function(gitWebsiteAddress,
           newDailyVars){
    jsText = readLines(
      paste0(gitWebsiteAddress, '/script.js'),-1)
    
    jsText[4:14] <- newDailyVars 
    
    writeLines(jsText,paste0(
      gitWebsiteAddress, '/script.js'))
    
    htmlText <- 
      readLines(paste0(
        gitWebsiteAddress,
        '/index.html'))
    
    htmlText[30] <-
      paste0("      <h2>",
             format(Sys.Date()-1,
                    "%b %d, %Y"),"</h2>")
    writeLines(htmlText, 
               (paste0(gitWebsiteAddress,
                       '/index.html')))
  }

# change webcode for maps
updateWebsiteMaps <-
  function(gitWebsiteAddress){
    htmlText <- 
      readLines(paste0(gitWebsiteAddress,
                       '/pages/secondary.html'))
    htmlText[30] <-
      paste0("      <h2>",
             format(Sys.Date()-1,
                    "%b %d, %Y"),"</h2>")
    writeLines(htmlText, 
               (paste0(gitWebsiteAddress,
                       '/pages/secondary.html')))
  }

# git commands to update website ####
gitUpdateWebsite <- 
  function(gitWebsiteAddress){
    system(paste0("git -C ",
                  gitWebsiteAddress, 
                  " add index.html"))
    
    system(paste0("git -C ",
                  gitWebsiteAddress, 
                  " add script.js"))
    
    system(paste0("git -C ",
                  gitWebsiteAddress, 
                  " add pages/maps/"))
    
    system(paste0("git -C ",
                  gitWebsiteAddress, 
                  " add pages/secondary.html"))
    
    system(paste0("git -C ",
                  gitWebsiteAddress, 
                  " commit -m 'auto daily update for ",
                  Sys.Date(),"'"))
    
    system(paste0("git -C ",
                  gitWebsiteAddress, 
                  " push"))
  }
