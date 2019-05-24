# Social Media Election Monitor 2018

This is the code that ran the "Monitoring the Election 2018" Twitter monitor.

This repository contains all the R code we use to analyze the Twitter data our group collected concerning the 2018 election every 24 hours. We also include the code we use to build our online portal.

Please see http://monitoringtheelection.us for more details about this project.



## Getting Started

Running this code requires a user to have a Twitter scrapper and MySQL database setup. This code focuses entirely on pulling data from a MySQL database every 24 hours, analyzing and backing up this data, and updating a website visualizing certain anlytics.


### Prerequisites

The specific Twitter scrapper and MySQL database structure we use in this project was developed by Nailen Matschke. The R code to pull data from MySQL *only* works with the Nailen's MySQL database structure.

### Tracked words

The monitor we set up for 2018 tracked the following keywords over five issue categories

| Category            | Keywords                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|---------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Election Day Voting | provisional ballot, voting machine, ballot                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| Voter Fraud         | election fraud, election manipulation, illegal voters, illegal votes,  dead voters, noncitizen voting, noncitizen votes, illegal voting,  illegal vote, illegal ballot, illegal ballots, dirty voter rolls, vote illegally,  voting illegally, voter intimidation, voter suppression, rigged election,  vote rigging, voter fraud, voting fraud, vote buying, vote flipping,  flipped votes, voter coercion, ballot stuffing, ballot box stuffing,  ballot destruction, voting machine tampering, rigged voting machines,  voter impersonation, election integrity, election rigging, duplicate voting,  duplicate vote, ineligible voting, ineligible vote |
| Remote Voting       | absentee ballot, mail ballot, vote by mail, voting by mail, early voting                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| Voter ID            | voter identification, voting identification, voter id                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| Polling Places      | polling place line, precinct line, pollworker, poll worker      

## R Code

The R code is designed to run every 24 hours. In each time period, you run dailyScript.R, which runs all the scripts on a set of Twitter data from a minimum status id.

This code is divided into the following sections.

0. Load packages and set required values. The parameters that need to be included in these scripts include
```
* MySQL database login info
* Twitter token (to get extra Twitter data)
* Dropbox token (to upload backups)
```
1. Pull data from a MySQL database.
2. Supplement the Twitter data by
```
* Pulling additinal data from the Twitter Rest API
* Running geolocation scripts
```
3. Backup the daily data in an rds format and upload to dropbox.
4. Calculate certain metrics on the day's worth of Twitter data.
5. Update the website.

## Website

This is the website where we display the daily metrics. The url is http://njadamscohen.github.io

## Author
Nicholas J. Adams-Cohen
