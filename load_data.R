#
# load_data.R 
#
# A script to load data for the EV_Station_Explorer Shiny app
#
# Data are downloaded/processed in load_process_data.R
#
#
#


states_map <- readRDS(file.path(".","data","states_map") )

state_counts_df <- readRDS(file.path(".","data","state_counts_df") )

state_county_counts_df <- readRDS(file.path(".","data","state_county_counts_df") )