library(tidyverse)
library(gganimate)
theme_set(theme_minimal())

gdp_tidy <- read_csv("./data/gdp_tidy.csv")


gdp_formatted <- gdp_tidy %>%
  group_by(year) %>%
  # The * 1 makes it possible to have non-integer ranks while sliding
  mutate(rank = rank(-value),
         Value_rel = value/value[rank==1],
         Value_lbl = paste0(" ",round(value/1e9))) %>%
  group_by(country_name) %>% 
  filter(rank <=10) %>%
  ungroup()

p <- ggplot(gdp_formatted,aes(-rank,Value_rel, fill = country_name)) +
  geom_col(width = 0.8, position="identity") +
  coord_flip(clip = "off") + 
  geom_text(aes(-rank,y=0,label = country_name,hjust=0), color = "white") + #country label
  geom_text(aes(-rank,y=Value_rel,label = Value_lbl, hjust=0)) + # value label
   
  
  theme(legend.position = 1 c "none",axis.title = element_blank()) +
  
  labs(title='GDP per Year : {closest_state}',
       subtitle = 'Top Countries', x = "", y = "GDP in billion USD",
       caption = "Data Source: World Bank ") +
  theme_void() +
  theme( # remove the vertical grid lines
    panel.grid.major.y = element_blank() ,
    # explicitly set the horizontal lines (or they will disappear too)
    panel.grid.major.x = element_line( size=.1, color="grey" ) 
  ) + 
  
  transition_states(year, transition_length = 4, state_length = 1) +
  #ease_aes('cubic-in-out') +
  view_follow(fixed_x = TRUE)

 

ggplot(gdp_formatted,aes(-rank,log1p(Value_rel), fill = country_name)) +
     geom_col(width = 0.8, position="identity") +
 # scale_y_log10() +
     coord_flip() + 
    geom_text(aes(-rank,y=0,label = country_name,hjust=0),color = "white") +  #country label
   geom_text(aes(-rank,y=Value_rel,label = Value_lbl, hjust=0)) + # value label
  theme_minimal() +

  theme_void() +
  theme( # remove the horizontal grid lines
    panel.grid.major.y = element_blank() ,
    # explicitly set the horizontal lines (or they will disappear too)
    panel.grid.major.x = element_line( size=.1, color="grey" ) ,
    legend.position = "none",axis.title = element_blank()
  ) + 
  
  
    labs(title='GDP per Year {closest_state}',
                  subtitle = 'Top Countries', x = "", y = "GDP in billion USD",
                   caption = "Sources: World Bank ") +
  
     transition_states(year, transition_length = 4, state_length = 1) +
     #ease_aes('cubic-in-out') +
     view_follow(fixed_x = TRUE)


#this works weell for now

ggplot(gdp_formatted, aes(rank, group = country_name,
fill = as.factor(country_name), color = as.factor(country_name))) +
geom_tile(aes(y = value/2,
height = value,
width = 0.9), alpha = 0.8, color = NA) +
geom_text(aes(y = 0, label = paste(country_name, " ")), color = "white", hjust = -0.24) +
geom_text(aes(y=value,label = Value_lbl, hjust=0)) +
coord_flip(clip = "off", expand = FALSE) +
scale_y_continuous(labels = scales::comma) +

scale_x_reverse() +
guides(color = FALSE, fill = FALSE) +
labs(title='{closest_state}', x = "", y = "GDP in billion USD",
caption = "Sources: World Bank") +
theme_void() +
theme(
axis.ticks=element_blank(),# remove the vertical grid lines
panel.grid.major.y = element_blank() ,
# explicitly set the horizontal lines (or they will disappear too)
panel.grid.major.x = element_line( size=.1, color="grey" )
) +
transition_states(year, transition_length = 4, state_length = 1) +
view_follow(fixed_x = TRUE) +
ease_aes('cubic-in-out') 

