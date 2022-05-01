library(tidyverse)
library(nycflights13)

airlines
airports
planes
weather
flights

View(airports)
View(flights)

# Exercise 13.3.3.1
# add a surrogate key to flights
flights_plus <- flights %>% 
  mutate(key = 1:length(flights$month))

flights_plus$key
select(flights_plus,key,origin,dest)

# Exercise 13.3.3.2

library(Lahman)
glimpse(Batting)
# key = playerID, yearID, stint

library(babynames)
glimpse(babynames)
# key = year, sex, name

library(nasaweather)
glimpse(atmos)
keytest <- atmos %>% 
  count(lat,long,year,month)

max(keytest$n)

# key = lat, long, year, month

library(fueleconomy)

glimpse(vehicles)

vehicles %>% 
  count(id) %>% 
  select(n) %>% 
  max()

vehicles %>% 
  count(make,model,year,class,trans,drive,cyl,displ,fuel) %>% 
  select(n) %>% 
  max()

# only id seems to fit the bill here

glimpse(diamonds)

diamonds %>% 
  count(carat,cut,color,clarity,depth,table,price,x,y,z) %>% 
  select(n) %>% 
  max() # even with all the fields, the max = 5

# have to add one here

diamonds %>% 
  mutate(id = row_number())

# Exercise 13.4.6.1

delays <- flights %>% 
  group_by(dest) %>% 
  summarise(avg_delay = mean(dep_delay,na.rm = TRUE)) %>% 
  inner_join(airports,by = c("dest" = "faa"))

View(delays)

airports %>% 
  semi_join(flights, c("faa" = "dest")) %>% 
  left_join(delays,c("faa" = "dest")) %>% 
  ggplot(aes(lon.x, lat.x, colour = avg_delay,size = avg_delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

# Exercise 13.4.6.2
# add orig and dest to flights

delays <- flights %>% 
  group_by(dest) %>% 
  summarise(avg_delay = mean(dep_delay,na.rm = TRUE)) %>% 
  inner_join(airports,by = c("dest" = "faa"))

View(delays)

flights_plus <- flights %>%  
  left_join(select(airports,c(faa,dest_lat = lat,dest_lon = lon)), by = c("dest" = "faa")) %>% 
  left_join(select(airports,c(faa,orig_lat = lat,orig_lon = lon)),by = c("origin" = "faa")) 

# Exercise 13.4.6.3
# Is there a relationship between the age of a plane and its delays

planes

flights_planes <- flights %>% 
  left_join(select(planes,c(tailnum,plane_year = year)),by = "tailnum") 

flights_planes %>% 
  group_by(plane_year) %>% 
  summarise(mean = mean(arr_delay, na.rm = TRUE),n = n()) %>% 
  ggplot() +
  geom_line(aes(plane_year,mean))

flights_planes %>% 
  group_by(plane_year) %>% 
  summarise(n = n()) %>% 
  ggplot() +
  geom_line(aes(plane_year,n))

# Exercise 13.4.6.4
# What weather conditions make it more likely to see a delay

unique(weather$origin)

weather
flights_weather <- flights %>% 
  left_join(weather, by = c("origin","year","month","day","hour"))%>% 
  mutate(delay_bin = cut_width(dep_delay,5))

glimpse(flights_weather)

flights_weather %>% 
  group_by(delay_bin) %>% 
  summarise()

flights_weather %>% 
  ggplot() +
  geom_point(aes(dep_delay,wind_speed, colour = visib))

june13th <- filter(flights_weather,year == 2013, month == 6, day == 13)

View(june13th)

View(june13th %>% 
  count(delay_bin))

# Exercise 13.5.1.1

no_tailnum <- flights %>% 
  anti_join(planes,by="tailnum") 

View(no_tailnum %>% 
  count(tailnum,sort = TRUE))


no_tailnum <- mutate(no_tailnum,is_nmq = (substr(tailnum,1,1) == "N" & substr(tailnum,5,6) == "MQ")) 

no_tailnum %>% 
  count(carrier)

22558 + 25397

# 47955 of the 52000 flights with no tailnum were from two carriers - AA and MQ

no_tailnum %>% 
  filter(is_nmq == FALSE) %>% 
  count(carrier)

# Exercise 13.5.1.2
# flights with planes that have flown at least 100 flights

# use tailnum to find how many flights each plane has flown

flights_100 <- flights %>% 
  count(tailnum) %>% 
  filter(n >= 100) %>% 
  select(tailnum) 

flights %>% 
  semi_join(flights_100,by = "tailnum")

# Exercise 13.5.1.3

common
vehicles

vehicles %>% 
  semi_join(common, by = c("make","model"))

# Exercise 13.5.1.4

top_48 <- flights %>% 
  group_by(year,month,day,hour) %>% 
  summarise(mean_delay = mean(dep_delay, na.rm = TRUE)) %>% 
  arrange(desc(mean_delay))

top_48 <- head(top_48,48)

top_48 <- top_48 %>% 
  left_join(weather,by = c("year","month","day","hour"))

top_48 %>% 
  ggplot(aes(mean_delay,humid, colour = visib)) +
  geom_point()

# Exercise 13.5.1.5

anti_join(flights, airports, by = c("dest" = "faa")) %>% 
  count(dest)

# this tells you the four destinations not in the airports dataset

anti_join(airports, flights, by = c("faa" = "dest")) %>% 
  count(name)

# this tells you all the airports in airports that didn't have a flight to them according to the flights dataset

# Exercise 13.5.1.6

flights %>% 
  group_by(tailnum,carrier) %>% 
  summarise(n = n()) %>% 
  arrange(tailnum,carrier) %>% 
  group_by(tailnum) %>% 
  summarise(n = n()) %>%
  arrange(desc(n)) %>% 
  filter(n > 1)

# so no, there are 17 planes that are flown by more than one carrier  
  
  