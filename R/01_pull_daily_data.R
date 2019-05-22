# This function returns all tweets from a minimum
# status id.
# INPUT:  min_TweetID - all tweets from this status
#         con - the connection the the SQL server
#         daily - if true, only return tweets in 
#                 the last 24 hour period.
# Output: all tweets from the min_TweetID

getTweetsFromMin <- 
  function(min_TweetID, 
           con, daily = T){
    
    pwt <- proc.time()
    
    dailyTweets <- 
      DBI::dbGetQuery(con,
            paste("SELECT CAST(tweet_id AS CHAR),",
                  "user_id,", "content,",
                  "timestamp,", "follows,",    
                  "location,", "coordinates,", 
                  "place",
                  "FROM tweets",
                  "NATURAL JOIN", 
                  "metadata WHERE",
                  "tweet_id >",
                  min_TweetID,
                  "ORDER BY tweet_id DESC;"))
    timeTook <- proc.time() - pwt
    message(paste('Pulled from MySQL in ',
                  timeTook[3],
                  'seconds'))
    # print(timeTook)
    #Fix Timestamp
    names(dailyTweets)[1] <- 'status_id'
    dailyTweets$timestamp <- 
      strptime(dailyTweets$timestamp,
               "%Y-%m-%d %H:%M:%S",
               tz="GMT")
    dailyTweets$timestamp <- 
      as.POSIXct(dailyTweets$timestamp)
    dailyTweets$timestamp <- 
      changeTZ(dailyTweets$timestamp, 
               "America/Los_Angeles")
    if(daily==T){
      dailyTweets<- dailyTweets %>% 
        filter(as.Date(timestamp) == Sys.Date()-1)
    }
    
    return(dailyTweets)
}


getTweetsSpanningMinMax <- 
  function(min_TweetID, max_TweetID, 
           con){
    
    pwt <- proc.time()
    dailyTweets <- 
      DBI::dbGetQuery(con, 
                      paste("SELECT CAST(tweet_id AS CHAR),",
                            "user_id,", "content,",
                            "timestamp,", "follows,",    
                            "location,", "coordinates,", 
                            "place",
                            "FROM tweets",
                            "NATURAL JOIN", 
                            "metadata WHERE",
                            "tweet_id >",
                            min_TweetID,
                            "AND tweet_id <",
                            max_TweetID,
                            "ORDER BY tweet_id DESC;"))
    timeTook <- proc.time() - pwt
    print(paste('Pulled from MySQL in ',
                timeTook[3],
                'seconds'))
    # print(timeTook)
    #Fix Timestamp
    names(dailyTweets)[1] <- 'status_id'
    dailyTweets$timestamp <- 
      strptime(dailyTweets$timestamp,"%Y-%m-%d %H:%M:%S",
               tz="GMT")
    dailyTweets$timestamp <- as.POSIXct(dailyTweets$timestamp)
    dailyTweets$timestamp <- 
      changeTZ(dailyTweets$timestamp, 
               "America/Los_Angeles")
    
    DBI::dbDisconnect(con)
    
    return(dailyTweets)
  }