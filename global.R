library(shiny)
library(dplyr)
library(data.table)
library(googleVis)
library(ggplot2)
library(formattable)

# Read in data ####
events <- fread('../football-events/events.csv')
matches <- fread('../football-events/ginf.csv')

# Get the data we want into 1 dataframe ####
events <- left_join(events, matches[,c('id_odsp','league','season')], by = "id_odsp")
events = select(events, -text)
events <- events[events$season>2014 & events$season < 2017,]
matches <- matches[matches$season>2014 & matches$season < 2017,]


# Changing data types of events table ####

events$is_goal       <- as.logical(events$is_goal)
events$bodypart      <- as.factor(events$bodypart)
events$assist_method <- as.factor(events$assist_method)
events$id_odsp       <- as.factor(events$id_odsp)
events$league        <- as.factor(events$league)
events$season        <- as.factor(events$season)
events$event_type    <- as.factor(events$event_type)
events$event_type2   <- as.factor(events$event_type2)
events$side          <- as.factor(events$side)
events$shot_place    <- as.factor(events$shot_place)
events$shot_outcome  <- as.factor(events$shot_outcome)
events$location      <- as.factor(events$location)
events$situation     <- as.factor(events$situation)

# Event Columns to factors ####
levels(events$league)        <- c('Bundesliga','Premier League','Ligue 1','Serie A','La Liga')
levels(events$event_type)    <- c("Attempt","Corner",'Foul','Yellow card','Second yellow card','Red card','Substitution','Free kick won','Offside','Hand ball','Penalty conceded')
levels(events$event_type2)   <- c("Key Pass","Failed through ball","Sending off","Own goal")
levels(events$side)          <- c("Home", "Away")
levels(events$shot_place)    <- c("Bit too high","Blocked","Bottom left corner","Bottom right corner","Centre of the goal",
                                  "High and wide","Hits the bar","Misses to the left","Misses to the right","Too high",
                                  "Top centre of the goal","Top left corner","Top right corner")
levels(events$shot_outcome)  <- c("On target","Off target","Blocked","Hit the bar")
levels(events$location)      <- c("Attacking half","Defensive half","Centre of the box","Left wing","Right wing",
                                  "Difficult angle and long range","Difficult angle on the left","Difficult angle on the right",
                                  "Left side of the box","Left side of the six yard box","Right side of the box",
                                  "Right side of the six yard box","Very close range","Penalty spot","Outside the box","Long range",
                                  "More than 35 yards","More than 40 yards","Not recorded")
levels(events$bodypart)      <- c("right foot","left foot","head")
levels(events$assist_method) <- c("None","Pass","Cross","Headed pass","Through ball")
levels(events$situation)     <- c("Open play","Set piece","Corner","Free kick")

# Match Columns to factors ####
matches$league <- as.factor(matches$league)
matches$season <- as.factor(matches$season)
levels(matches$league) <- c('Bundesliga','Premier League','Ligue 1','Serie A','La Liga')

matches = mutate(matches, hwin = ifelse(fthg>ftag,1,0), awin = ifelse(fthg<ftag,1,0))
matches = select(matches, -c("odd_h","odd_d","odd_a","odd_over","odd_under","odd_bts","odd_bts_n"))


# Calculating Win Rate ####
hRec = group_by(matches, league, ht, hwin) %>%
  count(., awin)
aRec = group_by(matches, league, at, hwin) %>%
  count(., awin) 

aRec$temp = aRec$awin
aRec$awin = aRec$hwin
aRec$hwin = aRec$temp
aRec = select(aRec, -temp)


wRec = left_join(group_by(matches, league, ht, hwin) %>%
                   count(., awin),
                 aRec,
                 by= c('league','ht'='at','hwin','awin')
)

wRec = mutate(wRec, sum = n.x + n.y, type= ifelse( hwin == 1 & awin == 0, 'W', ifelse( hwin == 0 & awin == 1, 'L', 'D') ))
a = group_by(wRec, league, ht) %>%
  summarise(., total = sum(sum))
b = select(filter(ungroup(wRec), type=='W'), -c('hwin','awin','n.y','n.x','type'))
a = left_join(b, a, by=c('league','ht')) 
a = mutate(a, winrate=sum/total)

events = left_join(left_join(events, a, by=c('league','event_team'='ht')),a,by=c('league','opponent'='ht'))

names(events) = c("id_odsp","id_event","sort_order","time","event_type","event_type2","side","event_team",  
                  "opponent","player","player2","player_in","player_out","shot_place","shot_outcome","is_goal",      
                  "location","bodypart","assist_method","situation","fast_break","league","season",
                  "event_team_wins", "event_team_total_games", "event_team_winrate",
                  "opponent_wins", "opponent_total_games", "opponent_winrate")


# Taking only teams that were in both 2015 and 2016 ####
events = mutate(events, number_of_season = ifelse(events$event_team_total_games > 50, 2,1))
events = filter(events, number_of_season > 1)

####

# Defining Variables ####
yearChoice = c(2015,2016)
leagueChoice =  c(levels(events$league))
leagueColor = c('red','blue','green','yellow','orange')
situationChoice = c("Open play", "Set piece", "Corner")


