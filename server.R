shinyServer(function(input, output){
  
  # Tab 1 ####
  # subtab 1 ####
  output$goalsFor <- renderGvis({
    group_by(events, league, event_team) %>%
      summarise(., number_of_goals = sum(is_goal) , winrate = mean(event_team_winrate)) %>%
      arrange(., desc(number_of_goals)) %>%
      gvisComboChart(., xvar="event_team", yvar = c('number_of_goals', 'winrate'),
                     options=list(title="Goals For and Win Rate",
                                  titleTextStyle="{color:'black',
                                  fontSize:12}",
                                  curveType="function", 
                                  pointSize=5,
                                  seriesType="bars",
                                  series="[{type:'bars', 
                                  targetAxisIndex:0,
                                  color:'blue'}, 
                                  {type:'line', 
                                  targetAxisIndex:1,
                                  color:'black'}]",
                                  vAxes="[{title:'Number of Goals',
                                  textStyle:{color: 'blue'},
                                  textPosition: 'out',
                                  minValue:0}, 
                                  {title:'Win Rate (%)',
                                  textStyle:{color: 'black'},
                                  textPosition: 'out',
                                  minValue:0,
                                  maxValue:1}]",
                                  hAxes="[{title:'Team',
                                  textPosition: 'out'}]",
                                  width='auto',height='700'
                                  
                     ), 
                     chartid="twoaxiscombochart"
      )
  })
  # subtab 2 ####
  output$goalsAgainst <- renderGvis({
    group_by(events, league, opponent) %>%
      summarise(., number_of_goals = sum(is_goal) , winrate = mean(opponent_winrate)) %>%
      arrange(., desc(number_of_goals)) %>%
      gvisComboChart(., xvar="opponent", yvar = c('number_of_goals', 'winrate'),
                     options=list(title="Goals Against and Win Rate",
                                  titleTextStyle="{color:'black',
                                  fontSize:12}",
                                  curveType="function", 
                                  pointSize=5,
                                  seriesType="bars",
                                  series="[{type:'bars', 
                                  targetAxisIndex:0,
                                  color:'blue'}, 
                                  {type:'line', 
                                  targetAxisIndex:1,
                                  color:'black'}]",
                                  vAxes="[{title:'Number of Goals',
                                  textStyle:{color: 'blue'},
                                  textPosition: 'out',
                                  minValue:0}, 
                                  {title:'Win Rate (%)',
                                  textStyle:{color: 'black'},
                                  textPosition: 'out',
                                  minValue:0,
                                  maxValue:1}]",
                                  hAxes="[{title:'Team',
                                  textPosition: 'out'}]",
                                  width='auto',height='700'
                                  
                     ), 
                     chartid="twoaxiscombochart1"
      )
  })
  # Tab 2 ####
  # subtab 1 ####
  output$winRateVSgoalsFor<- renderGvis({
    group_by(events, league, event_team) %>%
      summarise(., goalsfor = sum(is_goal) , winR = mean(event_team_winrate)) %>%
      left_join(.,group_by(events, league, opponent) %>%
                  summarise(., goalsagainst = sum(is_goal)), by=c('league','event_team'='opponent')) %>%
      gvisBubbleChart(.,idvar = 'event_team'  , xvar='goalsfor',yvar='winR',colorvar = 'league',sizevar = 'goalsagainst',
                      options= list(title="Is Win Rate affected by Goals For",width = "auto",height = "700",
                                    hAxes="[{title:'Goals For',textPosition: 'out',viewWindow:{min:0, max:240}}]",
                                    vAxes="[{title:'Win Rate (%)',viewWindow:{min:0, max:1}}]",
                                    bubble="{textStyle:{color: 'none',
                                    fontSize:0}}"))
    }) 
  # subtab 2 ####
  output$winRateVSgoalsAgainst   <- renderGvis({
    group_by(events, league, opponent) %>%
      summarise(., goalsagainst = sum(is_goal) , winR = mean(opponent_winrate)) %>%
      left_join(.,group_by(events, league, event_team) %>%
                  summarise(., goalsfor = sum(is_goal) ), by=c('league','opponent'='event_team')) %>%
      gvisBubbleChart(.,idvar = 'opponent'  , xvar='goalsagainst',yvar='winR',colorvar = 'league',sizevar = 'goalsfor',
                      options= list(title="Is Win Rate affected by Goals Against",width = "auto",height = "700",
                                    hAxes="[{title:'Goals Against',textPosition: 'out',viewWindow:{min:0, max:240}}]",
                                    vAxes="[{title:'Win Rate (%)',viewWindow:{min:0, max:1}}]",
                                    bubble="{textStyle:{color: 'none',
                                    fontSize:0}}"))
    }) 
  
  
  # Tab 3 ####
  # subtab 1.1 ####
  output$goalsForPerLeagueNSituation <- renderGvis({
    group_by(events, league, event_team, situation) %>%
      summarise(., number_of_goals = sum(is_goal) ) %>%
      filter(., situation != 'NA', league == input$leagueChoice, situation == input$situationChoice) %>%
      arrange(., desc(number_of_goals)) %>%
      gvisColumnChart(., xvar="event_team", yvar="number_of_goals",
                      options= list(title=paste("'Goals Scored For' per Team in ",as.character(input$leagueChoice)," during ",as.character(input$situationChoice)), legend='none',width = "auto",
                                    height = "400",hAxes="[{title:'Team',textPosition: 'out'}]",
                                    vAxes="[{title:'Number of Goals'}]"))
  }) 
  # subtab 1.2 ####
  output$goalsAgainstPerLeagueNSituation <- renderGvis({
    group_by(events, league, opponent, situation) %>%
      summarise(., number_of_goals = sum(is_goal) ) %>%
      filter(., situation != 'NA', league == input$leagueChoice, situation == input$situationChoice) %>%
      arrange(., desc(number_of_goals)) %>%
      gvisColumnChart(., xvar="opponent", yvar="number_of_goals",
                      options= list(title=paste("'Goals Scored Against' per Team in ",as.character(input$leagueChoice)," during ",as.character(input$situationChoice)), legend='none',width = "auto",
                                    height = "400",hAxes="[{title:'Team',textPosition: 'out'}]",
                                    vAxes="[{title:'Number of Goals'}]"))
  }) 
  # subtab 1 Column 2  ####
  output$goalsPerTypeVWinRate <- renderGvis({
    group_by(events, event_team, situation) %>%
      summarise(., number_of_goals = sum(is_goal) ) %>%
      left_join(.,group_by(events, event_team) %>%
                  summarise(., winr = mean(event_team_winrate)), by=c('event_team')) %>%
      filter(., situation != 'NA', situation == input$situationChoice) %>%
      arrange(., desc(number_of_goals)) %>%
      gvisBubbleChart(.,idvar = 'event_team'  , xvar='number_of_goals',yvar='winr',
                      options= list(title="Win Rate v Type of Goal Total",width = "auto",height = "400",
                                    sizeAxis = '{minValue: 0,  maxSize: 10}',
                                    hAxes="[{title:'Goals For',textPosition: 'out'}]",
                                    vAxes="[{title:'Win Rate'}]",
                                    bubble="{textStyle:{color: 'none',
                                    fontSize:0}}"))
    })
  
  # subtab 2.1 ####
  output$goalsForCombo1 <- renderGvis({
    group_by(events, league, event_team, situation) %>%
      summarise(., number_of_goals = sum(is_goal) ) %>%
      left_join(.,group_by(events, league, event_team) %>%
                summarise(., goalsfor = sum(is_goal) ), by=c('league','event_team')) %>%
      filter(., situation != 'NA', league == input$leagueChoice, situation == input$situationChoice) %>%
      arrange(., desc(goalsfor)) %>%
      gvisComboChart(., xvar="event_team", yvar = c('goalsfor', 'number_of_goals'),
                   options=list(title=paste("'Goals Scored For' per Team in ",as.character(input$leagueChoice)," during ",as.character(input$situationChoice)),
                                legend='none',
                                titleTextStyle="{color:'black',
                                  fontSize:12}",
                                curveType="function", 
                                pointSize=5,
                                seriesType="bars",
                                series="[{type:'bars', 
                                targetAxisIndex:0,
                                color:'blue'}, 
                                {type:'bars', 
                                targetAxisIndex:1,
                                color:'black'}]",
                                vAxes="[{title:'Number of Goals',
                                textStyle:{color: 'blue'},
                                textPosition: 'out',
                                minValue:0,
                                maxValue:240}, 
                                {textStyle:{color: 'black'},
                                textPosition: 'out',
                                minValue:0,
                                maxValue:240}]",
                                hAxes="[{title:'League',
                                textPosition: 'out'}]",
                                width='auto',height='400'
                                
                   ), 
                   chartid="twoaxiscombochart2"
    )
  })
  # subtab 2.2 ####
  output$goalsForCombo2 <- renderGvis({
    group_by(events, league, opponent, situation) %>%
      summarise(., number_of_goals = sum(is_goal) ) %>%
      left_join(.,group_by(events, league, opponent) %>%
                  summarise(., goalsagainst = sum(is_goal) ), by=c('league','opponent')) %>%
      filter(., situation != 'NA', league == input$leagueChoice, situation == input$situationChoice) %>%
      arrange(., desc(goalsagainst)) %>%
      gvisComboChart(., xvar="opponent", yvar = c('goalsagainst', 'number_of_goals'),
                     options=list(title=paste("'Goals Scored Against' per Team in ",as.character(input$leagueChoice)," during ",as.character(input$situationChoice)),
                                  legend='none',
                                  titleTextStyle="{color:'black',
                                  fontSize:12}",
                                  curveType="function", 
                                  pointSize=5,
                                  seriesType="bars",
                                  series="[{type:'bars', 
                                  targetAxisIndex:0,
                                  color:'blue'}, 
                                  {type:'bars', 
                                  targetAxisIndex:1,
                                  color:'black'}]",
                                  vAxes="[{title:'Number of Goals',
                                  textStyle:{color: 'blue'},
                                  textPosition: 'out',
                                  minValue:0,
                                  maxValue:240}, 
                                  {
                                  textStyle:{color: 'black'},
                                  textPosition: 'out',
                                  minValue:0,
                                  maxValue:240}]",
                                  hAxes="[{title:'League',
                                  textPosition: 'out'}]",
                                  width='auto',height='400'
                                  
                     ), 
                     chartid="twoaxiscombochart3"
      )
  })
  
  # Players ####
  ##### Tab 1 ###
  ##### subtab 1 ###
  output$topGoalScorers <- renderGvis({
    events[events$is_goal,] %>%
      group_by(player) %>%
      summarize(goals = n()) %>%
      arrange(desc(goals)) %>%
      head(25) %>%
      gvisBarChart(., xvar="player", yvar="goals",
                 options= list(title="Top Goalscorers", legend='none',width = "auto",
                               height = "800",hAxes="[{title:'Number of Goals',textPosition: 'out'}]",
                               vAxes="[{title:'Players'}]"))
      
  })
  
  ##### subtab 2 ###
  output$topAssists <- renderGvis({
    events[which(events$is_goal & !is.na(events$player2)), ] %>%
      group_by(player2) %>%
      summarize(assists = n()) %>%
      arrange(desc(assists)) %>%
      head(25) %>%
      gvisBarChart(., xvar="player2", yvar="assists",
                   options= list(title="Top Assists", legend='none',width = "auto",
                                 height = "800",hAxes="[{title:'Number of Assists',textPosition: 'out'}]",
                                 vAxes="[{title:'Players'}]"))
    
  })
  output$goalsToAssists <- renderGvis({
    events[events$is_goal,] %>%
      group_by(player) %>%
      summarize(goals = n()) %>%
      arrange(desc(goals)) %>%
      head(25) %>%
      left_join(., events[which(events$is_goal & !is.na(events$player2)), ] %>%
                  group_by(player2) %>%
                  summarize(assists = n()) %>%
                  arrange(desc(assists)) %>%
                  head(25), by=c('player'='player2')) %>%
      replace_na(.,list(goals = 0, assists = 0)) %>%
      gvisBubbleChart(.,idvar = 'player'  , xvar='assists',yvar='goals',
                      options= list(title="Goals v. Assists",width = "auto",height = "700",
                                    hAxes="[{title:'Assists',textPosition: 'out'}]",
                                    vAxes="[{title:'Goals'}]",
                                    bubble="{textStyle:{color: 'none',
                                    fontSize:0}}"))
  })
  
})