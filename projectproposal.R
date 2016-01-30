require(sqldf)
require(ggplot2)
require(maps)

# read in files (1370 MB)
hometowns <- read.csv("~/Desktop/R/DataIncubator/user_hometown.csv")
personalities <- read.csv("~/Desktop/R/DataIncubator/big5.csv")
demographics <- read.csv("~/Desktop/R/DataIncubator/demog.csv")
currlocation <- read.csv("~/Desktop/R/DataIncubator/user_current_location.csv")

# Extract USA
usa <- sqldf("SELECT * FROM currlocation WHERE country = 'United States'")

# 1. Distribution of data by city
usCities <- sqldf("SELECT usa.city, count(1) as nUsers 
                  FROM usa 
                  GROUP BY usa.city 
                  ORDER BY count(1) DESC")
citiesByAnswers <- cumsum(usCities$nUsers[-1])
qplot(1:length(citiesByAnswers),citiesByAnswers, geom='line', 
      xlab="Cities (sorted by # of responses)",
      ylab="Cumulatitive responses",
      main="Distribution of MPP data by city")

# 2. Coverage by State in US
answersByState = sqldf("SELECT state, count(1) as n_answers FROM usa GROUP BY state")
states_map <- map_data("state")

ggplot(answersByState, aes(map_id = state)) +
  geom_map(aes(fill = n_answers), map = states_map) +
  expand_limits(x = states_map$long, y = states_map$lat) +
  scale_fill_distiller(palette = "GnBu") +
  xlab("") +
  ylab("") +
  ggtitle("Personality coverage by state") +
  scale_y_continuous(breaks=NULL) +
  scale_x_continuous(breaks=NULL) +
  theme(panel.grid.minor=element_blank(), panel.grid.major=element_blank())
