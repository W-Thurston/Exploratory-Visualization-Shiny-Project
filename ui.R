library(shinydashboard)
shinyUI(dashboardPage(
  skin = 'purple',
  dashboardHeader(title = "Managing Soccer Through Analytics",
                  titleWidth = 350),
  dashboardSidebar(
      sidebarMenu(
          menuItem("Goals", tabName = "Goals", icon = icon("sitemap")),
          menuItem("Player", tabName = "Player", icon = icon("male")),
          menuItem("Data", tabName = "data", icon = icon("database"))
      )
      # selectizeInput("selected",
      #                "Select Items to Display",
      #                ychoice1)
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "Goals",
              tabsetPanel(
                
                
                ###########  TAB 1 - Goals  ###########
                tabPanel("Goals",
                         fluidRow(
                           tabBox(
                             # The id lets us use input$tabset1 on the server to find the current tab
                             id = "tabset1", height = "250px", width = "300px",
                             tabPanel("Goals For", htmlOutput("goalsFor")),
                             tabPanel("Goals Against", htmlOutput("goalsAgainst"))
                           )
                         )
                  ),
                
                
                ###########  TAB 2 - Win Rate  ###########
                tabPanel("Win Rate",
                         fluidRow(
                           tabBox(
                             id = "tabset2", height = "250px", width = "300px",
                             tabPanel("Goals For", htmlOutput("winRateVSgoalsFor")),
                             tabPanel("Goals Against", htmlOutput("winRateVSgoalsAgainst"))
                           )
                         )
                ),
                
                
                ###########  TAB 3 - League / Situation  ###########
                tabPanel("League / Situation",
                         fluidRow(
                             tabBox(
                               id = "tabset3", height = "250px",
                               tabPanel("Goals For / Against", 
                                        htmlOutput("goalsForPerLeagueNSituation"),
                                        htmlOutput("goalsAgainstPerLeagueNSituation")
                                      ),
                               tabPanel("Goals as %", 
                                        htmlOutput("goalsForCombo1"),
                                        htmlOutput("goalsForCombo2"))
                             ),
                             tabBox(
                               side = 'right', height = '200px',
                                 selectizeInput("leagueChoice",
                                                "Select League to Display",
                                                leagueChoice),
                                 selectizeInput("situationChoice",
                                                "Select Situation to Display",
                                                situationChoice)
                              )
                         ),
                         fluidRow(
                           column(width=6), # Buffer column
                           tabBox(
                              tabPanel("Goals to win rate",
                                       htmlOutput("goalsPerTypeVWinRate"))
                              )
                           ) # fluidRow
                ) # tabPanel
              )#tabsetPanel
      ),#tabItem
      tabItem(tabName = "Player",
              tabsetPanel(
                
                
                ###########  TAB 1 - Goals  ###########
                tabPanel("Top Goalscorers",
                         fluidRow(
                           tabBox(
                             tabPanel("Stats",
                                      htmlOutput("topGoalScorers")
                                      
                              )#tabPanel
                           )#tabBox
                         )#fluidRow
                )#tabPanel
              ) #tabsetPanel
      )#tabItem
    )#tabItems
  )#dashboardBody
))#dashboardBodyPage)shiyUI