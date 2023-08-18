#
# load_process_data.R
#
# This script loads/processes/saves data for use in EV_Station_Explorer Shiny app
#
#
#
#


library(dplyr)


# Load data for all EV stations previously downloaded from AFDC API
data_date <- "2023-08-08"
fname <- paste0(data_date,'_Elec_Stations_US_All_df')
ev <- readRDS(paste0('./data/',fname))


# Code to download US states shapefile using tigris and save

# states_map <- tigris::states() %>% 
#   janitor::clean_names() %>% 
#   mutate(statefp = as.numeric(statefp)) %>% 
#   filter(statefp < 60,
#          !statefp %in% c(2, 15)) %>% 
#   rmapshaper::ms_simplify()
# 
# saveRDS(states_map, file.path(".","data","states_map") )
# states_map <- readRDS(file.path(".","data","states_map"))


# Count # stations by state

# all stations
state_counts_total <- 
  ev %>% 
  count(state, name = "n_total") %>% 
  as_tibble()

# publics stations only
state_counts_public <- 
  ev %>% 
  filter(access_code == 'public') %>% 
  count(state, name = "n_public") %>% 
  as_tibble()

# private stations only
state_counts_private <- 
  ev %>% 
  filter(access_code == 'private') %>% 
  count(state, name = "n_private") %>% 
  as_tibble()

# join counts into single df
state_counts_df <- state_counts_total %>% 
  left_join(state_counts_public) %>% 
  left_join(state_counts_private)

saveRDS(state_counts_df, file.path(".","data","state_counts_df") )

