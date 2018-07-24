library(shinydashboard)
shinyUI(dashboardPage(
  skin = 'purple',
  dashboardHeader(title = "Managing Soccer Through Analytics",
                  titleWidth = 350),
  dashboardSidebar(
      sidebarMenu(
        menuItem("About", tabName = "About", icon = icon("sitemap")),
          menuItem("Goals", tabName = "Goals", icon = icon("signal")),
          menuItem("Player", tabName = "Player", icon = icon("male"))
      )
  ),
  dashboardBody(
    tabItems(
      
      ########### ABOUT - TAB 1 - Goals  ###########
      tabItem(tabName = "About",
                tabsetPanel(
                  tabPanel("Description",
                           fluidRow(
                             box( width = 8,
                                  h4("From: ",tags$a(href="https://www.kaggle.com/secareanualin/football-events/home", "Kaggle Overview")),
                             h2("Context"),
                              p("Most publicly available football (soccer) statistics are limited to aggregated data such as Goals, Shots, Fouls, Cards. When assessing performance or building predictive models, this simple aggregation, without any context, can be misleading. For example, a team that produced 10 shots on target from long range has a lower chance of scoring than a club that produced the same amount of shots from inside the box. However, metrics derived from this simple count of shots will similarly asses the two teams."),
                              p("A football game generates much more events and it is very important and interesting to take into account the context in which those events were generated. This dataset should keep sports analytics enthusiasts awake for long hours as the number of questions that can be asked is huge."),
                              h2("Content"),
                              p("This dataset is a result of a very tiresome effort of webscraping and integrating different data sources. The central element is the text commentary. All the events were derived by reverse engineering the text commentary, using regex. Using this, I was able to derive 11 types of events, as well as the main player and secondary player involved in those events and many other statistics. In case I've missed extracting some useful information, you are gladly invited to do so and share your findings. The dataset provides a granular view of 9,074 games, totaling 941,009 events from the biggest 5 European football (soccer) leagues: England, Spain, Germany, Italy, France from 2011/2012 season to 2016/2017 season as of 25.01.2017. There are games that have been played during these seasons for which I could not collect detailed data. Overall, over 90% of the played games during these seasons have event data."),
                              p("The dataset is organized in 3 files:"),
                             tags$ol(
                               tags$li(tags$b("events.csv"), "- contains event data about each game. Text commentary was scraped from: bbc.com, espn.com and onefootball.com"),
                               tags$li(tags$b("ginf.csv"), "- ginf.csv - contains metadata and market odds about each game. odds were collected from oddsportal.com"), 
                               tags$li(tags$b("dictionary.txt "), "- dictionary.txt contains a dictionary with the textual description of each categorical variable coded with integers")
                             )       
                             
                                    
                                    
                                    
                            ))))
              ),
      tabItem(tabName = "Goals",
              tabsetPanel(
                
                
                ###########  GOALS - TAB 1 - Goals  ###########
                tabPanel("Goals",
                         fluidRow(
                           tabBox(
                             # The id lets us use input$tabset1 on the server to find the current tab
                             id = "tabset1", height = "250px", width = "300px",
                             tabPanel("Goals For", htmlOutput("goalsFor")),
                             tabPanel("Goals Against", htmlOutput("goalsAgainst"))))),
                
                
                ###########  GOALS - TAB 2 - Win Rate  ###########
                tabPanel("Win Rate",
                         fluidRow(
                           tabBox(
                             id = "tabset2", height = "250px", width = "300px",
                             tabPanel("Goals For", htmlOutput("winRateVSgoalsFor")),
                             tabPanel("Goals Against", htmlOutput("winRateVSgoalsAgainst"))))),
                
                
                ###########  GOALS - TAB 3 - League / Situation  ###########
                tabPanel("League / Situation",
                         fluidRow(
                             tabBox(
                               id = "tabset3", height = "250px",
                               tabPanel("Goals For / Against", 
                                        htmlOutput("goalsForPerLeagueNSituation"),
                                        htmlOutput("goalsAgainstPerLeagueNSituation")),
                               tabPanel("Goals as %", 
                                        htmlOutput("goalsForCombo1"),
                                        htmlOutput("goalsForCombo2"))),
                             tabBox(
                               side = 'right', height = '200px',
                                 selectizeInput("leagueChoice",
                                                "Select League to Display",
                                                leagueChoice),
                                 selectizeInput("situationChoice",
                                                "Select Situation to Display",
                                                situationChoice))),
                         fluidRow(
                           column(width=6), # Buffer column
                           tabBox(
                              tabPanel("Goals to win rate",
                                       htmlOutput("goalsPerTypeVWinRate"))))))),
      tabItem(tabName = "Player",
              tabsetPanel(
                
                
                ###########  PLAYER - TAB 1 - Goals  ###########
                tabPanel("Top Players",
                         fluidRow(
                           tabBox(
                             # The id lets us use input$tabset1 on the server to find the current tab
                             id = "tabset3", height = "250px", width = "300px",
                             tabPanel("Goals", htmlOutput("topGoalScorers")),
                             tabPanel("Assists", htmlOutput("topAssists")))))))#tabItem
    )#tabItems
  )#dashboardBody
))#dashboardBodyPage)shiyUI