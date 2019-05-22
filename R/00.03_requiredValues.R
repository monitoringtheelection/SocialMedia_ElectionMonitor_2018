Sys.setenv(TZ = "America/Los_Angeles")

# state population (for maps percapita)
statePopulation <-
  read.csv('map_values/statePopulation.csv')


categories_electionWords2018 <- 
  list(fraud = 
         c('election fraud', 'election manipulation',
           'illegal voters','illegal votes','dead voters',
           'noncitizen voting','noncitizen votes', 'illegal voting', 
           'illegal vote','illegal ballot', 'illegal ballots', 
           'dirty voter rolls','vote illegally', 'voting illegally', 
           'voter intimidation','voter suppression', 'rigged election', 
           'vote rigging','voter fraud', 'voting fraud', 'vote buying',
           'vote flipping', 'flipped votes', 'voter coercion',
           'ballot stuffing', 'ballot box stuffing', 'ballot destruction',
           'voting machine tampering', 'rigged voting machines',
           'voter impersonation', 'election integrity',
           'election rigging', 'duplicate voting',
           'duplicate vote', 'ineligible voting', 'ineligible vote'),
       
       electionDayVoting =
         c('provisional ballot', 'voting machine', 'ballot') ,
       
       pollingPlaces =
         c('polling place line', 'precinct line', 
           'pollworker', 'poll worker'),
       
       remoteVoting = 
         c('absentee ballot', 'mail ballot', 'vote by mail', 
           'voting by mail', 'early voting'),
       
       voterID = 
         c('voter identification', 
           'voting identification', 'voter id'))


trackWords <- 
  as.vector(unlist(categories_electionWords2018))

trackWordsCol <-
  paste(trackWords, collapse = '|')
