#-------------------------------------------------------------
# load_process_data.R
#
# This script loads/processes/saves data for use in EV_Station_Explorer Shiny app
#
# https://andypicke.shinyapps.io/EV_Station_Explorer/
#
# Andy Pickering
# andypicke@gmail.com
# 
#
#-------------------------------------------------------------


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


#----------------------------------
# Count # stations by state
#----------------------------------

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



#----------------------------------
# Count # stations by county for each state
#----------------------------------

# need to join zip in ev data to county in shapefile data
zips <- readr::read_csv(file.path(".","data","zip_code_database.csv"),
                        show_col_types = FALSE) %>% 
  select(zip, primary_city, county)

# join zips to ev df to add county names
ev <- ev %>% 
  left_join(zips, by = "zip") 


state_county_counts_total <- ev %>% 
  group_by(state, county) %>% 
  summarise(n_total = n())

state_county_counts_public <- ev %>% 
  filter(access_code == 'public') %>% 
  group_by(state, county) %>% 
  summarise(n_public = n())

state_county_counts_private <- ev %>% 
  filter(access_code == 'private') %>% 
  group_by(state, county) %>% 
  summarise(n_private = n())

# join counts into single df
state_county_counts_df <- state_county_counts_total %>% 
  left_join(state_county_counts_public) %>% 
  left_join(state_county_counts_private)

saveRDS(state_county_counts_df, file.path(".","data","state_county_counts_df") )

