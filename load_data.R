
#library(dplyr)

data_date <- "2023-08-08"
fname <- paste0(data_date,'_Elec_Stations_US_All_df')

ev <- readRDS(paste0('./data/',fname))

states_map <- readRDS(file.path(".","data","states_map") )

state_counts_df <- readRDS(file.path(".","data","state_counts_df") )
