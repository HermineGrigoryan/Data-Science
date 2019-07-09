library(rtweet)
library(stringr)

#downloading the datasets and cleaning them
create_token(
  consumer_key = "KEY",
  consumer_secret = "SECRET",
  access_token = "TOKEN",
  access_secret = "SECRET")


aquman1<-search_tweets("Aquaman", n=1500, include_rts=F, 
                       lang="en", since="2018-07-20", until="2018-07-22")

aquaman<-aquman1[, "text"]
colnames(aquaman)<-"Reviews"

aquaman$Reviews<-str_remove_all(aquaman$Reviews, pattern = "http[^[:space:]]*")
aquaman$Reviews<-str_remove_all(aquaman$Reviews, pattern = "@[a-zA-Z0-9]*")
aquaman$Reviews<-str_remove_all(aquaman$Reviews, pattern = "#[a-zA-Z0-9]*")

beasts1<-search_tweets("Fantastic Beasts", n=1500, include_rts=F, 
                       lang="en", since="2018-07-20", until="2018-07-22")

beasts<-beasts1[, "text"]
colnames(beasts)<-"Reviews"

beasts$Reviews<-str_remove_all(beasts$Reviews, pattern = "http[^[:space:]]*")
beasts$Reviews<-str_remove_all(beasts$Reviews, pattern = "@[a-zA-Z0-9]*")
beasts$Reviews<-str_remove_all(beasts$Reviews, pattern = "#[a-zA-Z0-9]*")

#write.csv(aquaman, file="Aquaman.csv", row.names = F)
#write.csv(beasts, file="Beasts.csv", row.names = F)
