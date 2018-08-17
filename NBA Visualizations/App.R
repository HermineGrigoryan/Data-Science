library(ggplot2)
library(RColorBrewer)
library(shiny)
library(plyr)
library(dplyr)
library(shinydashboard)
library(DT)
source("nba_function.R")

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "teams", 
            fluidRow(
              column(width = 3,
                     box(width=35, selectInput(inputId = "data", label="Select Season Type:",
                                               choices = c("Preseason" = "preseason", "Regular Season" = "regular", 
                                                           "Playoffs" = "playoffs"),
                                               selected = "playoffs")),
                     box(width=35, selectInput(inputId = "first", label="X axis",
                                               choices = c("Games Played" = "GP", "Points" = "PTS",
                                                           "Rebounds" = "REB", "Assists" = "AST"),
                                               selected = "PTS")),
                     box(width=35, sliderInput(inputId = "number", label="Choose the maximum number of teams:",
                                               min=1, max=16, value=10)),
                     box(width=35, radioButtons(inputId = "icons", label = "Choose the palette of the barplot:",
                                                choices = c("Palette 1"="Set1",
                                                            "Palette 2"="Paired",
                                                            "Palette 3"="Accent",
                                                            "Palette 4"="Spectral"),
                                                selected = "Set1"))),
              column(width = 8,
                     box(width=45, plotOutput("barplot1"))))),
    tabItem(tabName = "players", 
            fluidRow(
              column(width = 3,
                     box(width=35, selectInput(inputId = "data2", label="Select Season Type:",
                                               choices = c("Preseason" = "preseason", "Regular Season" = "regular", 
                                                           "Playoffs" = "playoffs"),
                                               selected = "playoffs")),
                     box(width=35, selectInput(inputId = "first2", label="X axis",
                                               choices = c("Games Played" = "GP", "Points" = "PTS",
                                                           "Rebounds" = "REB", "Assists" = "AST",
                                                           "Offensive Rebound %" = "OREB_PCT",
                                                           "Defensive Rebound %" = "DREB_PCT",
                                                           "True Shot %" = "TS_PCT",
                                                           "Assist %" = "AST_PCT"),
                                               
                                               selected = "PTS")),
                     box(width=35, sliderInput(inputId = "number2", label="Choose the maximum number of players:",
                                               min=1, max=20, value=10)),
                     box(width=35, radioButtons(inputId = "icons2", label = "Choose the palette of the barplot:",
                                                choices = c("Palette 1"="Set1",
                                                            "Palette 2"="Paired",
                                                            "Palette 3"="Accent",
                                                            "Palette 4"="Spectral"),
                                                selected = "Set1"))),
              column(width = 8,
                     box(width=45, plotOutput("barplot2"))))),
    tabItem(tabName = "table",
    fluidRow(
      column(width=3,
                    conditionalPanel(
                      'input.dataset === "preseason"',
                      box(width=35, checkboxGroupInput("show_vars1", "Columns in Preseason to show:",
                                         names(preseason), selected = c("PLAYER_NAME", "TEAM_ABBREVIATION", "AGE", 
                                                                        "PLAYER_HEIGHT_INCHES", "PLAYER_WEIGHT", "COLLEGE")))
                    ),
                    conditionalPanel(
                      'input.dataset === "regular"',
                      box(width=35, checkboxGroupInput("show_vars2", "Columns in Regular Season to show:",
                                         names(regular), selected = c("PLAYER_NAME", "TEAM_ABBREVIATION", "AGE", 
                                                                      "PLAYER_HEIGHT_INCHES", "PLAYER_WEIGHT", "COLLEGE")))
                    ),
                    conditionalPanel(
                      'input.dataset === "playoffs"',
                      box(width=35, checkboxGroupInput("show_vars3", "Columns in Playoffs to show:",
                                         names(playoffs), selected = c("PLAYER_NAME", "TEAM_ABBREVIATION", "AGE", 
                                                                       "PLAYER_HEIGHT_INCHES", "PLAYER_WEIGHT", "COLLEGE"))))),
      column(width=8, 
             tabsetPanel(
               id = 'dataset',
               tabPanel("preseason", DT::dataTableOutput("mytable1")),
               tabPanel("regular", DT::dataTableOutput("mytable2")),
               tabPanel("playoffs", DT::dataTableOutput("mytable3"))
             )))),
    tabItem(tabName = "glossary", h1("You can find here the meanings of some variables:"),
    fluidRow(
      valueBox(
        value = tags$p("GP - Games Played", style = "font-size: 50%;"),
        subtitle = tags$p("The number of games played"),
        width = 2,
        color="purple",
        icon = icon("angellist")
      ),
      valueBox(
        value = tags$p("PTS - Points", style = "font-size: 50%;"), 
        subtitle = "The number of points scored",
        color="yellow",
        width = 2,
        icon = icon("bug")
      ),
      valueBox(
        value = tags$p("AST - Assists", style = "font-size: 50%;"),
        subtitle = "Assists - passes that lead directly to a made basket", 
        color="yellow",
        width = 3,
        icon = icon("star")),
      valueBox(
        value = tags$p("USG_PCT - Usage Percent", style = "font-size: 50%;"),
        subtitle = "The percentage of team plays used by a player when he is on the floor", 
        color="maroon",
        width = 3,
        icon = icon("table")),
      valueBox(
        value = tags$p("NET_RATING", style = "font-size: 50%;"),
        subtitle = "Measures a team's point differential per 100 possessions. On player 
        level this statistic is the team's point differential per 100 possessions while he is on court.", 
        color="navy",
        width = 3,
        icon = icon("table")),
      valueBox(
        value = tags$p("TS_PCT - True Shot Percent", style = "font-size: 50%;"),
        subtitle = "A shooting percentage that factors in the value of three-point field goals and free 
        throws in addition to conventional two-point field goals", 
        width = 3,
        color="purple",
        icon = icon("car")
      ),
      valueBox(
        value = tags$p("AST_PCT - Assist Percent", style = "font-size: 50%;"),
        subtitle = "The percentage of teammate field goals a player assisted on while he was on the floor", 
        width = 3,
        color="light-blue",
        icon = icon("star")
      ),
      valueBox(
        value = tags$p("REB - Rebounds", style = "font-size: 50%;"),
        subtitle = "The number of total rebounds a player or team has collected on 
      either offense or defense", 
        width = 2,
        color="aqua",
        icon = icon("dribbble")
      ),  
      valueBox(
        value = tags$p("OREB_PCT - Offensive Rebound Percent", style = "font-size: 50%;"),
        subtitle = "The percentage of available offensive rebounds a player or 
        team obtains while on the floor", 
        width = 4,
        color="maroon",
        icon = icon("dribbble")
      ), 
      valueBox(
        value = tags$p("DREB_PCT - Defensive Rebound Percent", style = "font-size: 50%;"),
        subtitle = "The percentage of available defensive rebounds a player or team 
        obtains while on the floor", 
        width = 4,
        color="navy",
        icon = icon("bell")
      )
    ))
))


ui <- dashboardPage(skin="purple",
                    dashboardHeader(title = "NBA Visualizations"),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Teams", tabName = "teams", icon = icon("users")),
                        menuItem("Players", tabName = "players", icon = icon("male")),
                        menuItem("Tables", tabName = "table", icon = icon("table")),
                        menuItem("Glossary", tabName = "glossary", icon = icon("book")),
                        valueBox(
                          value = tags$p("Data", style = "font-size: 50%;"),
                          subtitle =helpText(tags$div(class="header", checked=NA,
                                                      tags$p("The data was taken from"),
                                                      tags$a(href="https://stats.nba.com/players/bio/?Season=2017-18&SeasonType=Playoffs&sort=PTS&dir=1&PerMode=Totals", "HERE"))), 
                          width = 12,
                          color="black")
                      )),
                    body
)


tema<-theme(panel.background = element_rect(fill="white"),
            panel.grid = element_line(color="purple", size=0.08),
            title = element_text(face="italic", size=15),
            axis.text = element_text(face = "italic", size=12))


server<-function(input, output){
  output$barplot1<-renderPlot({
    
    dat<-get(input$data)
    
    nba<-dat %>%
      group_by_at("TEAM_ABBREVIATION") %>%
      summarise_at(input$first, sum) %>%
      arrange_at(input$first, funs(desc(.))) %>%
      head(input$number)
    
    ggplot(data=nba, aes_string(paste0("reorder(", "TEAM_ABBREVIATION", ",", input$first, ")"), input$first))+
      geom_bar(stat="identity", aes_string(fill="TEAM_ABBREVIATION"))+
      coord_flip()+
      scale_fill_manual(values =colorRampPalette(brewer.pal(8, input$icons))(16))+
      scale_y_continuous(breaks=seq(0,max(nba[,input$first])+10, round_any(max(nba[,input$first]), 10)/10))+
      theme(legend.position = "none")+
      labs(title=paste0("Top ", input$number, " Teams with Highest ", input$first), 
           x=(paste0("Team  Abbreviation")), y=as.character(input$first))+tema
  })
  output$barplot2<-renderPlot({
    
    dat2<-get(input$data2)
    
    nba2<-dat2 %>%
      arrange_at(input$first2, funs(desc(.))) %>%
      head(input$number2)
    
    ggplot(data=nba2, aes_string(paste0("reorder(", "PLAYER_NAME", ",", input$first2, ")"), input$first2))+
      geom_bar(stat="identity", color="white", aes_string(fill="TEAM_ABBREVIATION"))+
      coord_flip()+
      scale_fill_manual("Teams", values =colorRampPalette(brewer.pal(8, input$icons2))(20))+
      scale_y_continuous(breaks=seq(0,max(nba2[,input$first2])+10, round_any(max(nba2[,input$first2]), 10)/10))+
      theme(legend.position = "bottom")+
      labs(title=paste0("Top ", input$number2, " Players with Highest ", input$first2), 
           x=(paste0("Player Name")), y=as.character(input$first2))+tema
  })
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(preseason[, input$show_vars1, drop = FALSE])
  })
  
  output$mytable2 <- DT::renderDataTable({
    DT::datatable(regular[, input$show_vars2, drop = FALSE])
  })
  
  output$mytable3 <- DT::renderDataTable({
    DT::datatable(playoffs[, input$show_vars3, drop = FALSE])
  })
}

shinyApp(ui=ui, server=server)

