library(rvest)
library(stringr)
library(ggplot2)
library(tidyr)
library(dplyr)


scrap <- function(urls){
  df <- c()
  for (i in 1:length(urls)) {
    a <- read_html(urls[i])
    b <- html_node(a, css=".wisbb_statsTable")
    c <- html_table(a)
    df[i] <- c
  }
  data <- rbind_list(df)
}

clean <- function(data){
  col <- data$first
  club <- str_extract_all(col, "[A-Z]{2,}", simplify = T)
  club <- ifelse(club == "", NA, club)
  name<-str_remove_all(col, "[0-9]")
  names<-str_remove_all(name, "[A-Z]\\.")
  name<-str_remove_all(name, "[A-Z]{2,}")
  name<-str_remove_all(name, "\\,")
  name <- str_replace_all(name, pattern="\r|\n|\t", " ")
  name <- sapply(strsplit(name, split = " "), 
                 function(x) {paste(unique(trimws(x)), collapse = ' ') } )
  
  names_clubs <- as.data.frame(cbind(name, club))
  colnames(names_clubs) <- c("Names", "Clubs")
  data <- cbind(names_clubs, data)
  data$first <- NULL
  data
}


urls_1 <- paste("https://www.foxsports.com/soccer/stats?competition=2&season=20170&category=STANDARD&pos=0&team=0&isOpp=0&sort=3&sortOrder=0&page=", 1:12)
urls_2 <- paste("https://www.foxsports.com/soccer/stats?competition=2&season=20170&category=DISCIPLINE&pos=0&team=0&isOpp=0&sort=5&sortOrder=0&page=", 1:12)
urls_3 <- paste("https://www.foxsports.com/soccer/stats?competition=2&season=20170&category=CONTROL&pos=0&team=0&isOpp=0&sort=3&sortOrder=0&page=", 1:12)
url_4 <- "https://www.foxsports.com/soccer/stats?competition=2&season=20170&category=GOALKEEPING"
urls_5 <- paste("https://www.foxsports.com/soccer/stats?competition=2&season=20160&category=STANDARD&pos=0&team=0&isOpp=0&sort=3&sortOrder=0&page=", 1:11)

data_1 <- scrap(urls_1)
colnames(data_1)[1] <- "first"
standard <- clean(data_1)

data_2 <- scrap(urls_2)
colnames(data_2)[1] <- "first"
discipline <- clean(data_2)

data_3 <- scrap(urls_3)
colnames(data_3)[1] <- "first"
control <- clean(data_3)

data_4 <- scrap(url_4)
colnames(data_4)[1] <- "first"
goalkeeping <- clean(data_4)

data_5 <- scrap(urls_5)
colnames(data_5)[1] <- "first"
standard2016 <- clean(data_5)

write.csv(standard, "standard2017.csv", row.names = F)
write.csv(discipline, "discipline.csv", row.names = F)
write.csv(control, "control.csv", row.names = F)
write.csv(goalkeeping, "goalkeeping.csv", row.names = F)
write.csv(standard2016, "standard2016.csv", row.names = F)