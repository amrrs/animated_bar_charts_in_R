library(tidyverse)
library(janitor)

gdp <- read_csv("./data/GDP_Data.csv")

#select required columns

gdp <- gdp %>% select(3:15) 

#filter only country rows

gdp <- gdp[1:217,]

gdp_long <- gdp %>% 
  mutate_at(vars(contains("YR")),as.numeric) %>% 
  gather(year,gpd,3:13) %>% 
  janitor::clean_names() %>% 
  mutate(year = as.numeric(stringr::str_sub(year,1,4)))

write_csv(gdp_long,"./data/gdp_tidy.csv")

