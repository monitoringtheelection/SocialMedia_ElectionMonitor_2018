# Input: tweets - twitter data from MySQL
#        tToken - Twitter API token
# Output: more complete set of Twitter variables
#         in the future, fix the Python script
#         to pull and store this data automatically.
getAdditionalData <- 
  function(tweets, tToken){
  inputSeq <- 1:length(tweets$status_id)
  multiples <- (inputSeq %% 90000) == 0
  if(length(tweets$status_id) %% 90000 != 0){
    iterations <- sum(multiples) + 1
  } else {
    iterations <- sum(multiples)
  }
  print(paste('Starting to pull data.',
              'There are', iterations,
              'pull required.'))
  for(i in 1:iterations){
    minSeq <- 1 + (i-1) * 90000
    maxSeq <- i * 90000
    if(i == iterations){
      maxSeq <- length(tweets$status_id)
    }
    currentBatch <- tweets$status_id[minSeq:maxSeq]
    if(i == 1){
      extraInfoDaily <- lookup_statuses(currentBatch, token = tToken)
      print(paste('Finished iteration', i, 'of', 
                  iterations))
      if (i == iterations){
        print('Done!')
      } else {
        print('Sleeping for 15 minutes zzz.')
        Sys.sleep(902)
        print('Awake')
      }
    } else if (i == iterations) {
      currentBatchInfo <- 
        lookup_statuses(currentBatch, token = tToken)
      extraInfoDaily <- 
        rbind(extraInfoDaily,currentBatchInfo)
      print(paste('Finished iteration', i, 'of', 
                  iterations))
      print(paste('Finally done!'))
    } else {
      currentBatchInfo <- 
        lookup_statuses(currentBatch, token=tToken)
      extraInfoDaily <- 
        rbind(extraInfoDaily,currentBatchInfo)
      print(paste('Finished iteration', i, 'of', 
                  iterations))
      print('Sleeping for 15 minutes zzz.')
      Sys.sleep(902)
      print('Awake!')
    }
  }
  extraInfoDaily <- 
    extraInfoDaily[order(extraInfoDaily$status_id,
                         decreasing = T),]
  variablesToKeep <- c('text','retweet_text', 
                       'source', 'reply_to_status_id',
                       'reply_to_user_id', "is_quote",              
                       "is_retweet", "favorite_count",
                       'retweet_count', 'hashtags',
                       'urls_t.co', 'media_t.co',
                       'media_type', 'mentions_user_id',
                       'lang', 'quoted_text', 
                       'retweet_status_id')
  
  # There is some data we do not get from this pull
  # that is in the SQL tweets. We grab these variables
  # and merge.
  # The if statement is here in case we just want to input
  # Twitter data with status ids
  if(ncol(tweets) >1){
    tweets <- tweets %>% 
      select('status_id', 'follows', 'location')
    
    extraInfoDaily <- right_join(tweets, 
                                 extraInfoDaily)
  }

  # Only keep what we have extraInfoFor

  
  extraInfoDaily <- as_tibble(extraInfoDaily)
  return(extraInfoDaily)
}

# Pulls the text content from across all fields,
# including the retweet twxt, quote text, and
# extended URL text.
# OUPUT:
#       A single 'content' field.
getFullContent <- 
  function(extraMetaData){
  content <- vector(length = nrow(extraMetaData))
  rt <- extraMetaData$is_retweet
  quote <- extraMetaData$is_quote
  extendedURL <- 
    !is.na(extraMetaData$urls_expanded_url)
  
  content[rt] <- 
    paste(extraMetaData$text[rt],
          extraMetaData$retweet_text[rt])
  
  content[quote] <- 
    paste(extraMetaData$text[quote],
          extraMetaData$quoted_text[quote])
  
  content[!(rt|quote)] <- 
    extraMetaData$text[!(rt|quote)]
  
  content[extendedURL] <-
    paste(content[extendedURL], 
          extraMetaData$urls_expanded_url[
            extendedURL])
  
  return(content)
}
getMissingTweetsElection_2018 <- 
  function(inputTweets, tToken, trackWords){
    trackWords_Collapsed <-
      paste(trackWords, collapse = '|')

  # Which tweets still have missing data for issues
  missing <- 
    which(!str_detect(
      tolower(inputTweets$full_content),
      tolower(trackWords_Collapsed)))
  missingTweets <- inputTweets[missing,]
  if(nrow(missingTweets) == 0){
    return(inputTweets)
    message('No Missing Tweets')
  } else {  
    missingTweets$missingRetweetID <- NA
  # Problem: Some have two links
  numberLinks <- sapply(
    missingTweets$urls_expanded_url, 
    length)
  # Which links have only one link and are twitter links
  twitterLink <- 
    which(str_detect(missingTweets$urls_expanded_url, 
                     'https://twitter.com/') & 
            (numberLinks ==1) ) 
  missingTweets_TwitterLinks <- 
    unlist(missingTweets[twitterLink,]$urls_expanded_url)
  # statues are the tweet_id of linked tweet
  statuses <- 
    basename(missingTweets_TwitterLinks)
  missingTweets[twitterLink,]$missingRetweetID <- 
    statuses
  
  # dealing with quoted retweets
  quotedRetweet <- 
    which(missingTweets$is_retweet)
  quotedRetweetIds <- 
    missingTweets[quotedRetweet,]$retweet_status_id
  missingTweets[quotedRetweet,]$missingRetweetID <- 
    quotedRetweetIds
  
  statuses <- c(statuses, quotedRetweetIds)
  # Grab data about the linked tweet
  print(paste('Getting additional data for', 
              length(unique(statuses)), 
              'missing tweets'))
  missingTweets_statusids <-
    data.frame('status_id' = unique(statuses))
  
  statusMissing <- 
    getAdditionalData(missingTweets_statusids, 
                      tToken = tToken)
  # full data of the linked tweet.
  statusMissing$full_content <- 
    getFullContent(statusMissing)
  statusMissing <- 
    statusMissing %>% 
    select(status_id, full_content)
  names(statusMissing) <- 
    c('missingRetweetID', 'missingRetweetContent')
  # Fix merge.
  missingTweets <- 
    left_join(missingTweets,statusMissing)
  inputTweets[missing,]$full_content <- 
    paste(inputTweets[missing,]$full_content,
          missingTweets$missingRetweetContent)
  # print(nrow(inputTweets))
  return(inputTweets)}
  
}



# 
