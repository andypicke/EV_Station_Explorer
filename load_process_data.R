
library(dplyr)

data_date <- "2023-08-08"
fname <- paste0(data_date,'_Elec_Stations_US_All_df')
ev <- readRDS(paste0('./data/',fname))

state_counts <- 
  ev %>% count(state) %>% 
  arrange(desc(n)) %>% 
  as_tibble()

states_map <- tigris::states() %>% 
  janitor::clean_names() %>% 
  mutate(statefp = as.numeric(statefp)) %>% 
  filter(statefp < 60,
         !statefp %in% c(2, 15)) %>% 
  rmapshaper::ms_simplify()
