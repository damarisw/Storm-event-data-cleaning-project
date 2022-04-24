#The code identifies my working directory and sets it to where i want to save and fetch it.
getwd()
setwd("C:/Users/wanyo/Desktop")

#The code loads the tidyverse package
library(tidyverse)

#Import the csv file.
Storm <- read.csv("StormEvents_details-ftp_v1.0_d1995_c20210803.csv")

#Creating a subset of the data frame.
Storm_New <-select(Storm,BEGIN_YEARMONTH, BEGIN_DAY,BEGIN_TIME,END_YEARMONTH,END_DAY,END_TIME,BEGIN_DATE_TIME,END_DATE_TIME,EPISODE_ID,EVENT_ID,STATE,STATE_FIPS,CZ_NAME,CZ_TYPE,CZ_FIPS,EVENT_TYPE,SOURCE,BEGIN_LAT,BEGIN_LON,END_LAT,END_LON)

#Arranging the data by beginning year and month.
arrange(Storm_New,BEGIN_YEARMONTH)

#Changing state and country names to title case.
str_to_title(Storm_New$STATE)

#Limiting the events listed by county FIPS to "c" 
Storm_New %>%
  filter(CZ_TYPE =="C") %>%
  select(-c(CZ_TYPE))

#Pad the state and county FIPS with "o" at the beginning.
str_pad(Storm_New$STATE_FIPS, width = 5, side = "left", pad = "0")
str_pad(Storm_New$CZ_FIPS, width = 5, side = "left", pad = "0")
unite(Storm_New,"FIPS", c("STATE_FIPS", "CZ_FIPS") )

#Rename all column names to lower case
rename_all(Storm_New,tolower)

#Creating a data frame that comes with the base R on US states.
us_state_info <- data.frame(state=state.name, region = state.region, area = state.area)

#Creating a data frame with the number of events per state and then merge.
NewTable <- data.frame(table(Storm_New$STATE))
head(NewTable)

NewTable1 <-rename(NewTable,c("state"="Var1"))

us_state_info1 <-(mutate_all(us_state_info,toupper))

merged <-merge(x=NewTable1,y = us_state_info1,by.x ="state", by.y= "state")

#Creating a plot.
library(ggplot2)
storm_plot <- ggplot(merged,aes(x = area, y= Freq)) +
  geom_point(aes(color =region)) +
  coord_flip()
  labs(x = " Land area (square miles)",
       y =" # of storm events in 1995")
storm_plot







