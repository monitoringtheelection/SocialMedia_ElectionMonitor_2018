# Helper functions
fixCountryCode <- 
  function(data){
    countryIssue <- 
      which(!(data$country_code %in% 
                ISO_3166_1$Alpha_2))
    data$country_code[countryIssue] <- NA
    return(data)
  }

changeTZ <- 
  function(timestamps,
           changeTo.Tz = "America/Los_Angeles"){
    current.tz <- attr(timestamps[1],"tzone")
    raw <- as.POSIXct(strptime(
      timestamps,
      format = "%Y-%m-%d %H:%M:%S",
      tz ="GMT"),
      tz = "GMT")
    ts <- format(raw, tz = changeTo.Tz, usetz = TRUE)
    return(ts)
  }
fixTZ <- 
  function(data, 
           tzinput= "America/Los_Angeles"){
    data$created_at <- 
      strptime(data$created_at,
               "%Y-%m-%d %H:%M:%S",
               tz="GMT")
    data$created_at <- 
      as.POSIXct(extraInfoDaily$created_at)
    data$created_at <- 
      changeTZ(data$created_at, 
               tzinput)
  }

# Scripts to get statecode

# precise is based on geotags
getPreciseStateCodes <- function(inputTweets){
  stateCodes <- inputTweets %>% 
    filter(country_code == 'US') %>%
    filter(place_type == 'city') %>% 
    select(place_full_name) %>% 
    sapply(., function(x){substr(x, nchar(x) -1, nchar(x))} )
  t <- left_join(inputTweets,
                 inputTweets %>% 
                   filter(country_code == 'US') %>%
                   filter(place_type == 'city') %>%
                   mutate(preciseStateCodes = stateCodes) %>%
                   select(status_id, preciseStateCodes)) 
  # get rid of anything except 50 states + DC
  t[which(
    !t$preciseStateCodes %in%US_StateCode),]$preciseStateCodes <- NA
  return(t)
}

# reg ex is based on the location field.
getRegExStateCode <- function(data, checkStateCode){
  # data[grep("Alabama|ala|Montgomery|Birmingham", data$location, ignore.case = TRUE), "state"] <- "AL"
  data[grep("Alabama|Montgomery|Birmingham", data$location, ignore.case = TRUE), "state"] <- "AL"
  data[grep("Alaska|Juneau|Anchorage", data$location, ignore.case = TRUE), "state"] <- "AK"
  data[grep("Arizona|Mesa|Phoenix|Scottsdale|Tucson", data$location, ignore.case = TRUE), "state"] <- "AZ"
  data[grep("Arkansas|Little Rock", data$location, ignore.case = TRUE), "state"] <- "AR"
  data[grep("California|Oakland|Fresno|Long Beach|Los Angeles|San Jose|SoCal|San Fernando Valley|San Diego|San Francisco|SF|Sacramento|Palm Springs|Southern California", data$location, ignore.case = TRUE), "state"] <- "CA"
  data[grep("Colorado|Denver|Colorado Springs|Fort Collins|Lakewood", data$location, ignore.case = TRUE), "state"] <- "CO"
  data[grep("Connecticut|Hartford|Bridgeport|New Haven", data$location, ignore.case = TRUE), "state"] <- "CT"
  data[grep("Delaware|Dover|Wilmington", data$location, ignore.case = TRUE), "state"] <- "DE"
  data[grep("District of Columbia|D\\.C|Washington DC|Washington D\\.C\\.", data$location, ignore.case = TRUE), "state"] <- "DC"
  data[grep("Georgia|Atlanta|Buford", data$location, ignore.case = TRUE), "state"] <- "GA"
  data[grep("Hawaii|Honolulu", data$location, ignore.case = TRUE), "state"] <- "HI"
  data[grep("Idaho|Boise", data$location, ignore.case = TRUE), "state"] <- "ID"
  data[grep("Illinois|Springfield|Chicago|Chicagoland", data$location, ignore.case = TRUE), "state"] <- "IL"
  data[grep("Indiana|Indianapolis", data$location, ignore.case = TRUE), "state"] <- "IN"
  data[grep("Iowa|Des Moines|Quad-Cities", data$location, ignore.case = TRUE), "state"] <- "IA"
  data[grep("Kansas|Wichita|Topeka", data$location, ignore.case = TRUE), "state"] <- "KS"
  data[grep("Kentucky|Louisville|Frankfort", data$location, ignore.case = TRUE), "state"] <- "KY"
  data[grep("Louisiana|Baton Rouge|New Orleans|Shreveport", data$location, ignore.case = TRUE), "state"] <- "LA"
  data[grep("Maine|Augusta|Portland", data$location, ignore.case = TRUE), "state"] <- "ME"
  data[grep("Maryland|Annapolis|Baltimore", data$location, ignore.case = TRUE), "state"] <- "MD"
  data[grep("Massachusetts|Boston", data$location, ignore.case = TRUE), "state"] <- "MA"
  data[grep("Michigan|Lansing|Detroit|Grand Rapids|Detoit|Flint", data$location, ignore.case = TRUE), "state"] <- "MI"
  data[grep("Minnesota|Minneapolis|St\\. Paul|Saint Paul|St Paul", data$location, ignore.case = TRUE), "state"] <- "MN"
  data[grep("Mississippi|Jackson", data$location, ignore.case = TRUE), "state"] <- "MS"
  data[grep("Florida|Tampa Bay|Miami|Tallahassee|Fort Myers|Miami-Dade|Orlando|Jacksonville|Fort Lauderdale|St\\. Petersburg", data$location, ignore.case = TRUE), "state"] <- "FL"
  data[grep("Missouri|St\\. Louis|St Louis|Kansas City|Jefferson City", data$location, ignore.case = TRUE), "state"] <- "MO"
  data[grep("Montana|Helena|Billings", data$location, ignore.case = TRUE), "state"] <- "MT"
  data[grep("Nebraska|Lincoln|Omaha", data$location, ignore.case = TRUE), "state"] <- "NE"
  data[grep("Nevada|Las Vegas|Carson City|Reno", data$location, ignore.case = TRUE), "state"] <- "NV"
  data[grep("New Hampshire|Concord", data$location, ignore.case = TRUE), "state"] <- "NH"
  data[grep("New Mexico|Santa Fe|Albuquerque", data$location, ignore.case = TRUE), "state"] <- "NM"
  data[grep("North Carolina|Raleigh|Charlotte", data$location, ignore.case = TRUE), "state"] <- "NC"
  data[grep("North Dakota|Fargo|Bismarck", data$location, ignore.case = TRUE), "state"] <- "ND"
  data[grep("New Jersey|Trenton|Newark", data$location, ignore.case = TRUE), "state"] <- "NJ"
  data[grep("New York|NYC|New York State|Albany|Brooklyn|Long Island|Buffalo", data$location, ignore.case = TRUE), "state"] <- "NY"
  data[grep("Ohio|Columbus|Cleveland|Buckeye State|Cincinnati", data$location, ignore.case = TRUE), "state"] <- "OH"
  data[grep("Oklahoma|Oklahoma City|Tulsa", data$location, ignore.case = TRUE), "state"] <- "OK"
  data[grep("Oregon|Salem|Portland", data$location, ignore.case = TRUE), "state"] <- "OR"
  data[grep("Pennsylvania|Harrisburg|Philadelphia|Pittsburgh", data$location, ignore.case = TRUE), "state"] <- "PA"
  data[grep("Rhode Island|Providence", data$location, ignore.case = TRUE), "state"] <- "RI"
  data[grep("South Carolina|Columbia|Myrtle Beach", data$location, ignore.case = TRUE), "state"] <- "SC"
  data[grep("South Dakota|Pierre|Souix Falls", data$location, ignore.case = TRUE), "state"] <- "SD"
  data[grep("Tennessee|Chattanooga|Nashville|Memphis|Knoxville", data$location, ignore.case = TRUE), "state"] <- "TN"
  data[grep("Texas|El Paso|Austin|San Antonio|Dallas|Houston|Fort Worth|Arlington", data$location, ignore.case = TRUE), "state"] <- "TX"
  data[grep("Utah|The Beehive State|Salt Lake City", data$location, ignore.case = TRUE), "state"] <- "UT"
  data[grep("Vermont|Montpelier|Burlington", data$location, ignore.case = TRUE), "state"] <- "VT"
  data[grep("Virginia|Richmond|Virginia Beach", data$location, ignore.case = TRUE), "state"] <- "VA"
  data[grep("Washington|Seattle|Olympia|Bellevue|Everett", data$location, ignore.case = TRUE), "state"] <- "WA"
  data[grep("Morgantown|West Virginia|Charleston", data$location, ignore.case = TRUE), "state"] <- "WV"
  data[grep("Wisconsin|Milwaukee|UW-Madison|Madison", data$location, ignore.case = TRUE), "state"] <- "WI"
  data[grep("Wyoming|Cody|Cheyenne", data$location, ignore.case = TRUE), "state"] <- "WY"
  
  if(checkStateCode == T){
    data[grep(" AL", data$location, ignore.case = FALSE), "state"] <- "AL"
    data[grep(" AK", data$location, ignore.case = FALSE), "state"] <- "AK"
    data[grep(" AZ", data$location, ignore.case = FALSE), "state"] <- "AZ"
    data[grep(" AR", data$location, ignore.case = FALSE), "state"] <- "AR"
    data[grep(" CA", data$location, ignore.case = FALSE), "state"] <- "CA"
    data[grep(" CO", data$location, ignore.case = FALSE), "state"] <- "CO"
    data[grep(" CT", data$location, ignore.case = FALSE), "state"] <- "CT"
    data[grep(" DE", data$location, ignore.case = FALSE), "state"] <- "DE"
    data[grep(" DC", data$location, ignore.case = FALSE), "state"] <- "DC"
    data[grep("D\\.C\\.", data$location, ignore.case=TRUE), "state"] <- "DC"
    data[grep(" FL", data$location, ignore.case = FALSE), "state"] <- "FL"
    data[grep(" GA", data$location, ignore.case = FALSE), "state"] <- "GA"
    data[grep(" HI", data$location, ignore.case = FALSE), "state"] <- "HI"
    data[grep(" ID", data$location, ignore.case = FALSE), "state"] <- "ID"
    data[grep(" IL", data$location, ignore.case = FALSE), "state"] <- "IL"
    data[grep(" IN", data$location, ignore.case = FALSE), "state"] <- "IN"
    data[grep(" IA", data$location, ignore.case = FALSE), "state"] <- "IA"
    data[grep(" KS", data$location, ignore.case = FALSE), "state"] <- "KS"
    data[grep(" KY", data$location, ignore.case = FALSE), "state"] <- "KY"
    data[grep(" LA", data$location, ignore.case = FALSE), "state"] <- "LA"
    data[grep(" ME", data$location, ignore.case = FALSE), "state"] <- "ME"
    data[grep(" MD", data$location, ignore.case = FALSE), "state"] <- "MD"
    data[grep(" MA", data$location, ignore.case = FALSE), "state"] <- "MA"
    data[grep(" MI", data$location, ignore.case = FALSE), "state"] <- "MI"
    data[grep(" MN", data$location, ignore.case = FALSE), "state"] <- "MN"
    data[grep(" MS", data$location, ignore.case = FALSE), "state"] <- "MS"
    data[grep(" MO", data$location, ignore.case = FALSE), "state"] <- "MO"
    data[grep(" MT", data$location, ignore.case = FALSE), "state"] <- "MT"
    data[grep(" NE", data$location, ignore.case = FALSE), "state"] <- "NE"
    data[grep(" NV", data$location, ignore.case = FALSE), "state"] <- "NV"
    data[grep(" NH", data$location, ignore.case = FALSE), "state"] <- "NH"
    data[grep(" NM", data$location, ignore.case = FALSE), "state"] <- "NM"
    data[grep(" ND", data$location, ignore.case = FALSE), "state"] <- "ND"
    data[grep(" NJ", data$location, ignore.case = FALSE), "state"] <- "NJ"
    data[grep(" NY", data$location, ignore.case = FALSE), "state"] <- "NY"
    data[grep(" NC", data$location, ignore.case = FALSE), "state"] <- "NC"
    data[grep(" OH", data$location, ignore.case = FALSE), "state"] <- "OH"
    data[grep(" OK", data$location, ignore.case = FALSE), "state"] <- "OK"
    data[grep(" OR", data$location, ignore.case = FALSE), "state"] <- "OR"
    data[grep(" PA", data$location, ignore.case = FALSE), "state"] <- "PA"
    data[grep(" RI", data$location, ignore.case = FALSE), "state"] <- "RI"
    data[grep(" SC", data$location, ignore.case = FALSE), "state"] <- "SC"
    data[grep(" SD", data$location, ignore.case = FALSE), "state"] <- "SD"
    data[grep(" TN", data$location, ignore.case = FALSE), "state"] <- "TN"
    data[grep(" TX", data$location, ignore.case = FALSE), "state"] <- "TX"
    data[grep(" UT", data$location, ignore.case = FALSE), "state"] <- "UT"
    data[grep(" VT", data$location, ignore.case = FALSE), "state"] <- "VT"
    data[grep(" VA", data$location, ignore.case = FALSE), "state"] <- "VA"
    data[grep(" WA", data$location, ignore.case = FALSE), "state"] <- "WA"
    data[grep(" WV", data$location, ignore.case = FALSE), "state"] <- "WV"
    data[grep(" WI", data$location, ignore.case = FALSE), "state"] <- "WI"
    data[grep(" WY", data$location, ignore.case = FALSE), "state"] <- "WY"
    
    data[grep("^AL$", data$location, ignore.case = FALSE), "state"] <- "AL"
    data[grep("^AK$", data$location, ignore.case = FALSE), "state"] <- "AK"
    data[grep("^AZ$", data$location, ignore.case = FALSE), "state"] <- "AZ"
    data[grep("^AR$", data$location, ignore.case = FALSE), "state"] <- "AR"
    data[grep("^CA$", data$location, ignore.case = FALSE), "state"] <- "CA"
    data[grep("^CO$", data$location, ignore.case = FALSE), "state"] <- "CO"
    data[grep("^CT$", data$location, ignore.case = FALSE), "state"] <- "CT"
    data[grep("^DE$", data$location, ignore.case = FALSE), "state"] <- "DE"
    data[grep("^DC$", data$location, ignore.case = FALSE), "state"] <- "DC"
    data[grep("^FL$", data$location, ignore.case = FALSE), "state"] <- "FL"
    data[grep("^GA$", data$location, ignore.case = FALSE), "state"] <- "GA"
    data[grep("^HI$", data$location, ignore.case = FALSE), "state"] <- "HI"
    data[grep("^ID$", data$location, ignore.case = FALSE), "state"] <- "ID"
    data[grep("^IL$", data$location, ignore.case = FALSE), "state"] <- "IL"
    data[grep("^IN$", data$location, ignore.case = FALSE), "state"] <- "IN"
    data[grep("^IA$", data$location, ignore.case = FALSE), "state"] <- "IA"
    data[grep("^KS$", data$location, ignore.case = FALSE), "state"] <- "KS"
    data[grep("^KY$", data$location, ignore.case = FALSE), "state"] <- "KY"
    data[grep("^LA$", data$location, ignore.case = FALSE), "state"] <- "LA"
    data[grep("^ME$", data$location, ignore.case = FALSE), "state"] <- "ME"
    data[grep("^MD$", data$location, ignore.case = FALSE), "state"] <- "MD"
    data[grep("^MA$", data$location, ignore.case = FALSE), "state"] <- "MA"
    data[grep("^MI$", data$location, ignore.case = FALSE), "state"] <- "MI"
    data[grep("^MN$", data$location, ignore.case = FALSE), "state"] <- "MN"
    data[grep("^MS$", data$location, ignore.case = FALSE), "state"] <- "MS"
    data[grep("^MO$", data$location, ignore.case = FALSE), "state"] <- "MO"
    data[grep("^MT$", data$location, ignore.case = FALSE), "state"] <- "MT"
    data[grep("^NE$", data$location, ignore.case = FALSE), "state"] <- "NE"
    data[grep("^NV$", data$location, ignore.case = FALSE), "state"] <- "NV"
    data[grep("^NH$", data$location, ignore.case = FALSE), "state"] <- "NH"
    data[grep("^NM$", data$location, ignore.case = FALSE), "state"] <- "NM"
    data[grep("^ND$", data$location, ignore.case = FALSE), "state"] <- "ND"
    data[grep("^NJ$", data$location, ignore.case = FALSE), "state"] <- "NJ"
    data[grep("^NY$", data$location, ignore.case = FALSE), "state"] <- "NY"
    data[grep("^NC$", data$location, ignore.case = FALSE), "state"] <- "NC"
    data[grep("^OH$", data$location, ignore.case = FALSE), "state"] <- "OH"
    data[grep("^OK$", data$location, ignore.case = FALSE), "state"] <- "OK"
    data[grep("^OR$", data$location, ignore.case = FALSE), "state"] <- "OR"
    data[grep("^PA$", data$location, ignore.case = FALSE), "state"] <- "PA"
    data[grep("^RI$", data$location, ignore.case = FALSE), "state"] <- "RI"
    data[grep("^SC$", data$location, ignore.case = FALSE), "state"] <- "SC"
    data[grep("^SD$", data$location, ignore.case = FALSE), "state"] <- "SD"
    data[grep("^TN$", data$location, ignore.case = FALSE), "state"] <- "TN"
    data[grep("^TX$", data$location, ignore.case = FALSE), "state"] <- "TX"
    data[grep("^UT$", data$location, ignore.case = FALSE), "state"] <- "UT"
    data[grep("^VT$", data$location, ignore.case = FALSE), "state"] <- "VT"
    data[grep("^VA$", data$location, ignore.case = FALSE), "state"] <- "VA"
    data[grep("^WA$", data$location, ignore.case = FALSE), "state"] <- "WA"
    data[grep("^WV$", data$location, ignore.case = FALSE), "state"] <- "WV"
    data[grep("^WI$", data$location, ignore.case = FALSE), "state"] <- "WI"
    data[grep("^WY$", data$location, ignore.case = FALSE), "state"] <- "WY"
  }
  
  
  #fixing exceptions
  data[grep("Washington D\\.C\\.", data$location, ignore.case = TRUE), "state"] <- "DC"
  data[grep("Washington D\\.C", data$location, ignore.case = TRUE), "state"] <- "DC"
  data[grep("District of Columbia", data$location, ignore.case = TRUE), "state"] <- "DC"
  data[grep("Manchester UK", data$location, ignore.case = TRUE), "state"] <- NA
  data[grep("Los Angeles Barbados", data$location, ignore.case = TRUE), "state"] <- NA
  data[grep("Midway Ga.", data$location, ignore.case = TRUE), "state"] <- "GA"
  data[grep("Kenosha/Racine Wis.", data$location, ignore.case = TRUE), "state"] <- "WI"
  data[grep("Arkansas", data$location, ignore.case = TRUE), "state"] <- "AR"
  data[grep("Raynham", data$location, ignore.case = TRUE), "state"] <- "MA"
  data[grep("Inyo County", data$location, ignore.case = TRUE), "state"] <- "CA"
  data[grep("NC and Canada", data$location, ignore.case = TRUE), "state"] <- "NC"
  data[grep("Pennsylvania Ave\\.", data$location, ignore.case = TRUE), "state"] <- "DC"
  data[grep("Stanford Ky", data$location, ignore.case = TRUE), "state"] <- "KY"
  
  # more exceptions
  data[grep("British Columbia", data$location, ignore.case = TRUE), "state"] <- NA
  data[grep("Gold Coast", data$location, ignore.case = TRUE), "state"] <- NA
  data[grep("Birmingham, England", data$location, ignore.case = TRUE), "state"] <- NA
  data[grep("Birmingham, UK", data$location, ignore.case = TRUE), "state"] <- NA
  data[grep("Richmond B.C.", data$location, ignore.case = TRUE), "state"] <- NA
  data[grep("Jerusalem", data$location, ignore.case = TRUE), "state"] <- NA
  
  names(data)[
    names(data) == 'state'] <- 
    'regExStateCodes'
  return(data)
}


# if there are country codes NOT in 
# ISO_3166_1$Alpha_2
fixCountryIssue <- function(inputTweets){
  countryIssue <- 
    which(!(inputTweets$country_code %in% 
              ISO_3166_1$Alpha_2))
  inputTweets$country_code[countryIssue] <- NA
  return(inputTweets)
}
