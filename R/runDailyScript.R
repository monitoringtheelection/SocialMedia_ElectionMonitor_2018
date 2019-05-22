source(file = '01_pull_daily_data.R')
source(file = '02.01_get_missing_twitter_data.R')
source(file = '02.02_add_additional_data.R')
source(file = '03_upload_backup.R')

####
# First:
#   Pull tweets up to a minimum tweet_id. 
#   If daily set to true, only keep those messages
#   sent TODAY (by system date).
####

tweets <- 
  getTweetsFromMin('1072932307718176760', con, F)

# tweets <- as_tibble(tweets)

####
# Second:
#   We run some scripts to supplement the data 
####

#   2.1:
#     Missing Twitter data. These are the fields
#     we should have been pulling with the monitor
#     but were not. In the 2020 monitor, we fix
#     this at they python level.

fullTweets <- 
  getAdditionalData(tweets, tToken)
fullTweets$full_content <-
  getFullContent(fullTweets)
fullTweets <-
  getMissingTweetsElection_2018(
  fullTweets, tToken, trackWords)


#   2.2:
#     Additional data.
#     These scripts will remain and be expanded,
#     because we supplement the raw twitter data. 

# State code based on geotags.
fullTweets <- 
  getPreciseStateCodes(fullTweets)

# State code based on location field. 
# Less precise.
fullTweets <- 
  getRegExStateCode(fullTweets,
                    checkStateCode = F)

# Fix issue with country codes.
fullTweets <- 
  fixCountryIssue(fullTweets)

####
# Third:
#   Upload a backup of the collected and 
#   supplemented data to dropbox.
####

uploadDailyData(fullTweets, 
                'test_outfile', 
                dbToken)


####
# Fourth: 
#   Run analytics. 
#   These scripts ONLY work for 
#   2018 issue categories.
####


#   4.1:
#     Hourly counts by issue category

fullTweets$full_content <- 
  str_to_lower(fullTweets$full_content)

fullTweets <- 
  getCatVar(fullTweets,
            categories_electionWords2018)

dailyHourlyCounts.cat <- 
  makeHourlyCat.df(fullTweets,
                   categories_electionWords2018)



#   4.2:
#     Maps

createMapsForWeb(fullTweets, 
                 outfile = map_outfile,
                 statePopulation,
                 'perCapita')

# 5.0 
#   Update Website

newDailyVars <-
  makeNewDailyVars(dailyHourlyCounts.cat)

updateWebsiteCounts(gitWebsiteAddress,
                    newDailyVars)

updateWebsiteMaps(gitWebsiteAddress)

gitUpdateWebsite(gitWebsiteAddress)