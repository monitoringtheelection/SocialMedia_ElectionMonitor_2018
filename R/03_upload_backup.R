


uploadDailyData <- function(data,
                            db_destFile,
                            dbToken,
                            maxUpload =
                              (2.0 * 10^9)){
  # For Max_Min pull might be two dates. 
  # This will allow the file to be labeled correctly.
  maxDate = as.Date(head(data$created_at,1))
  minDate = as.Date(tail(data$created_at,1))
  if (maxDate == minDate){
    curDate = maxDate
  } else {
    curDate = paste0(minDate,
                     '_',
                     maxDate)
  }
  
  # Tweet size might be too big for dropbox upload.
  # Here I split file.

  tweetSize <-
    object.size(data)
  numberSplits <-
    as.integer(ceiling(tweetSize/maxUpload))
  
  
  if (numberSplits <= 1){
    # We need to save this locally before uploading
    # we simply name the file by the current data
    localFileName <-
      paste0(curDate,'_fullTweets.rds')
    
    saveRDS(data,
            file = localFileName)
    
    # upload to dropbox
    tryCatch({
      drop_upload(localFileName, 
                  path = db_destFile,
                  dtoken = dbToken)
      
      # now that its uploaded to dropbox, we can 
      # safely remove local copy
      file.remove(localFileName)
      
    }, error=function(e){
      cat("ERROR :",conditionMessage(e), "\n")})
  } else {
    nRowTweet = nrow(data)
    # chunking up full data
    chunk = nrow(data)/numberSplits
    
    for (i in 1:numberSplits){
      # destFile with i so segmented
      localFileName <-  
        paste0(curDate,'_', i,
               '_fullTweets.rds')
      if(i!=numberSplits){
        dataChunk <-
          data[((i-1) * floor(chunk) + 1): 
                           (i * floor(chunk)), ]
        # When last split, need to use total row number
        # in order to get last tweet
      } else if (i == numberSplits){
        dataChunk <-
          data[((i-1) * floor(chunk) + 1): 
                           nRowTweet,]
      }
      
      # save chunk
      saveRDS(dataChunk,
              file = localFileName)
      
      # Try to upload.
      tryCatch({
        drop_upload(localFileName, 
                    path = db_destFile,
                    dtoken = dbToken)
        file.remove(localFileName)
      }, error=function(e){
        cat("ERROR :",conditionMessage(e), "\n")})
    }
    
  }
}

