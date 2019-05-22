# API Tokens #####

# the location in directory for a 
# twitter access token
tokenLocation <- "XXXXX"

# the location in directory for a 
# dropbox access token
dbTokenLocation <- "XXXXX"

tToken = readRDS(tokenLocation)
dbToken <- readRDS(dbTokenLocation)

# MySQL #####

# the name of the database storing twitter data
dbName <- 'election_monitor_2018'

#the password for MySQL
dbPassword <- "XXXXX"

# the yser for MySQL
dbUser <- "XXXXX"

# Connect to MySQL
con <- 
  DBI::dbConnect(RMariaDB::MariaDB(),
                 host = "127.0.0.1",
                 user = dbUser,
                 db = dbName,
                 password = dbPassword)

# Website ####

# Location of website code
gitWebsiteAddress <- 
  '/home/nadamsco/njadamscohen.github.io'

# location of map images.
map_outfile <-
  paste0('/home/nadamsco/',
         'njadamscohen.github.io/',
         'pages/maps/')

