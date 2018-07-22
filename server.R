shinyServer(function(input, output){
  # gvisGeoChart(state_stat, "state.name", input$selected,
  #              options=list(region="US", displayMode="regions", 
  #                           resolution="provinces",
  #                           width="auto", height="auto"))
  
  output$matches <- renderGvis({
      gvisComboChart(ratio_table, xvar="league", yvar = c(input$ychoice1, input$ychoice2),
                     options=list(title="Hello World",
                                  titleTextStyle="{color:'red',
                                  fontName:'Courier',
                                  fontSize:16}",
                                  curveType="function", 
                                  pointSize=9,
                                  seriesType="bars",
                                  series="[{type:'bars', 
                                  targetAxisIndex:0,
                                  color:'00bfff'}, 
                                  {type:'bars', 
                                  targetAxisIndex:1,
                                  color:'3cb371'}]",
                                  vAxes="[{
                                  textStyle:{color: '00bfff'},
                                  textPosition: 'out',
                                  minValue:0}, 
                                  {textStyle:{color: '3cb371'},
                                  textPosition: 'out',
                                  minValue:0}]",
                                  hAxes="[{title:'League',
                                  textPosition: 'out'}]",
                                  width='auto',height='auto'
                                  
                     ), 
                     chartid="twoaxiscombochart"
      )
  })
  # Tab 1 ####
  # Row 1 ####
  output$goals <- renderGvis({
    group_by(events, league, event_team) %>%
      summarise(., sum = sum(is_goal)) %>%
      arrange(., desc(sum)) %>%
      gvisColumnChart(., xvar="event_team", yvar="sum",
                      options= list(title="Number of Goals Scored For", legend='none',width = "auto",
                                    height = "500",hAxes="[{title:'Team',textPosition: 'out'}]",
                                    vAxes="[{title:'Number of Goals'}]"))
  })
  # Row 2 ####
  output$goals20 <- renderGvis({
    group_by(events, league, opponent) %>%
      summarise(., sum = sum(is_goal)) %>%
      arrange(., desc(sum)) %>%
      gvisColumnChart(., xvar="opponent", yvar="sum",
                      options= list(title="Number of Goals Scored Against", legend='none',width = "auto",
                                    height = "500",hAxes="[{title:'Team',textPosition: 'out'}]",
                                    vAxes="[{title:'Number of Goals'}]"))
  })
  
  # Tab 2 ####
  # Row 1 ####
  output$goalsForPerLeagueNSituation <- renderGvis({
    group_by(events, league, event_team, situation) %>%
      summarise(., sum = sum(is_goal)) %>%
      filter(., situation != 'NA', league == input$leagueChoice, situation == input$situationChoice) %>%
      arrange(., desc(sum)) %>%
      gvisColumnChart(., xvar="event_team", yvar="sum",
                      options= list(title=paste("Goals Scored Against per Team in: ",as.character(input$leagueChoice)," by ",as.character(input$situationChoice)), legend='none',width = "auto",
                                    height = "500",hAxes="[{title:'Team',textPosition: 'out'}]",
                                    vAxes="[{title:'Number of Goals'}]"))
  }) 
  # Row 2 ####
  output$goalsAgainstPerLeagueNSituation <- renderGvis({
    group_by(events, league, opponent, situation) %>%
      summarise(., sum = sum(is_goal)) %>%
      filter(., situation != 'NA', league == input$leagueChoice, situation == input$situationChoice) %>%
      arrange(., desc(sum)) %>%
      gvisColumnChart(., xvar="opponent", yvar="sum",
                      options= list(title=paste("Goals Scored Against per Team in: ",as.character(input$leagueChoice)," by ",as.character(input$situationChoice)), legend='none',width = "auto",
                                    height = "500",hAxes="[{title:'Team',textPosition: 'out'}]",
                                    vAxes="[{title:'Number of Goals'}]"))
  }) 
  # Tab 3 ####
  # Row 1 ####
  output$winRateVSgoalsAgainst   <- renderGvis({
    group_by(events, league, event_team) %>%
      summarise(., goalsfor = sum(is_goal), winR = mean(winrate)) %>%
      left_join(.,group_by(events, league, opponent) %>%
                  summarise(., goalsagainst = sum(is_goal)), by=c('league','event_team'='opponent')) %>%
      gvisBubbleChart(.,idvar = 'event_team'  , xvar='goalsagainst',yvar='winR',colorvar = 'league',sizevar = 'goalsfor',
                      options= list(title="Is Win Rate affected by Goals For and Against",width = "auto",height = "800",
                                    hAxes="[{title:'Goals Against',textPosition: 'out',viewWindow:{min:0, max:240}}]",
                                    vAxes="[{title:'Win Rate'}]",
                                    bubble="{textStyle:{color: 'none',
                                fontSize:0}}"))
  }) 
  # Row 2 ####
  output$winRateVSgoalsFor<- renderGvis({
    group_by(events, league, event_team) %>%
      summarise(., goalsfor = sum(is_goal), winR = mean(winrate)) %>%
      left_join(.,group_by(events, league, opponent) %>%
                summarise(., goalsagainst = sum(is_goal)), by=c('league','event_team'='opponent')) %>%
    gvisBubbleChart(.,idvar = 'event_team'  , xvar='goalsfor',yvar='winR',colorvar = 'league',sizevar = 'goalsagainst',
                    options= list(title="Is Win Rate affected by Goals For and Against",width = "auto",height = "800",
                                  hAxes="[{title:'Goals For',textPosition: 'out',viewWindow:{min:0, max:240}}]",
                                  vAxes="[{title:'Win Rate'}]",
                                  bubble="{textStyle:{color: 'none',
                                  fontSize:0}}"))
  }) 
  
  
})