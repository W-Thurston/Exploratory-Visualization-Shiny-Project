library(shinydashboard)
shinyUI(dashboardPage(
  skin = 'purple',
  dashboardHeader(title = "How do teams win?"),
  dashboardSidebar(
      sidebarMenu(
          menuItem("Goals", tabName = "Goals", icon = icon("sitemap")),
          menuItem("Team", tabName = "team", icon = icon("users")),
          menuItem("Player", tabName = "player", icon = icon("male")),
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
                tabPanel("Goals",
                         fluidRow(
                             htmlOutput("goals")
                         ),
                         fluidRow(
                           htmlOutput("goals20")
                         )
                  ),
                tabPanel("League / Situation",
                         fluidRow(
                           box(
                             selectizeInput("leagueChoice",
                                            "Select League to Display",
                                            leagueChoice),
                             selectizeInput("situationChoice",
                                            "Select Situation to Display",
                                            situationChoice)
                           )
                         ),
                         fluidRow(
                             htmlOutput("goalsForPerLeagueNSituation")
                         ),
                         fluidRow(
                           
                             htmlOutput("goalsAgainstPerLeagueNSituation")
                           
                         )
                         
                ),
                tabPanel("Win Rate",
                         fluidRow(
                           htmlOutput("winRateVSgoalsFor")
                         ),
                         fluidRow(
                           htmlOutput("winRateVSgoalsAgainst")
                         )
                         
                )
              )
              
              
      )
    )
  )
))