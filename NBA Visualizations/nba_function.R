library(httr)
library(jsonlite)

#Function for getting the data from url
api_nba<-function(modified_url){
  nba1<-readLines(modified_url)
  nb<-fromJSON(nba1)
  nba_df<-nb$resultSets$rowSet[[1]]
  colnames(nba_df)<-nb$resultSets$headers[[1]]
  nba_df<-as.data.frame(nba_df)
  return(nba_df)
}

#Function for cleaning the dataset
cleaning<-function(data){
  data[, c("TEAM_ID", "PLAYER_ID")]<-apply(data[, c("TEAM_ID", "PLAYER_ID")], 2, as.character)
  data$TEAM_ABBREVIATION<-as.factor(data$TEAM_ABBREVIATION)
  data$COLLEGE<-as.factor(data$COLLEGE)
  data$COUNTRY<-as.factor(data$COUNTRY)
  data[,19:23]<-round(data[,19:23]*100, 0)
  data$PLAYER_ID<-NULL
  data$TEAM_ID<-NULL
  data$PLAYER_HEIGHT<-NULL
  return(data)
}

preseason<-modify_url(url="https://stats.nba.com/stats/leaguedashplayerbiostats",
                     query=list(PerMode ="Totals", LeagueID ="",
                                Season ="2017-18", SeasonType ="Pre Season"))

regular<-modify_url(url="https://stats.nba.com/stats/leaguedashplayerbiostats",
                      query=list(PerMode ="Totals", LeagueID ="",
                                 Season ="2017-18", SeasonType ="Regular Season"))

playoffs<-modify_url(url="https://stats.nba.com/stats/leaguedashplayerbiostats",
                    query=list(PerMode ="Totals", LeagueID ="",
                               Season ="2017-18", SeasonType ="Playoffs"))


# preseason<-api_nba(preseason)
# regular<-api_nba(regular)
# playoffs<-api_nba(playoffs)


# write.csv(preseason, "preseason.csv", row.names = F)
# write.csv(regular, "regular.csv", row.names = F)
# write.csv(playoffs, "playoffs.csv", row.names = F)

preseason<-read.csv("preseason.csv", stringsAsFactors = F)
regular<-read.csv("regular.csv", stringsAsFactors = F)
playoffs<-read.csv("playoffs.csv", stringsAsFactors = F)

preseason<-cleaning(preseason)
regular<-cleaning(regular)
playoffs<-cleaning(playoffs)

