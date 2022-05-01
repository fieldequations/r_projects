library(tidyverse)
library(nycflights13)

flights %>% 
  group_by(dest)

as.data.frame(flights)

df <- tibble(
  x = runif(5),
  y = rnorm(5)
)
df
df[1,2]
df[1]

df <- data.frame(abc = 1, xyz = "a")
df$x
df$xpa = "134"
df$x
df
dft <- as_tibble(df)
dft
dft[,"xyz"]
df[,"xyz"]
df[,c("abc","xyz")]
dft[,c("abc","xyz")]

#Exercise 10.4

annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
annoying$`1`
annoying[["1"]]
annoying %>% ggplot() + geom_point(aes("1","2"),position = "jitter")
annoying$"3" = 