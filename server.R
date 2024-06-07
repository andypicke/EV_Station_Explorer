#-------------------------------------------------------------
#
# This is the server logic of a Shiny web application. 
# https://andypicke.shinyapps.io/EV_Station_Explorer/
#
#
# Andy Pickering
# andypicke@gmail.com
#
#-------------------------------------------------------------


library(shiny)
library(dplyr)
library(leaflet)
library(tigris) # get shapefiles for US states and counties
options(tigris_use_cache = TRUE)
library(sf)
source('load_data.R')


# pivoting to longer format allows easier plotting based on selectInput
state_counts_df_long <- state_counts_df %>% 
  tidyr::pivot_longer(cols = starts_with('n_'),
                      names_to = 'total_type',
                      values_to = 'n')

# join the state count data to the sf states geometry
dat_to_map_all <- states_map %>% 
  left_join(state_counts_df_long, by = c("stusps" = "state"))

# count stations by state
state_county_counts_df_long <- state_county_counts_df %>% 
  tidyr::pivot_longer(cols = starts_with('n_'),
                      names_to = 'total_type',
                      values_to = 'n')


#------------------------------------------------------------
# Define server logic 
#------------------------------------------------------------
function(input, output, session) {
  
  
  output$result <- renderText({
    paste("You chose to plot: ", input$states_var)
  })
  
  # filter data for choropleth based on selectInput
  dat_to_map <- reactive({
      dat_to_map_all %>%
        filter(total_type == input$states_var)
    })
  
  # create color palette for choropleth based on chosen data to plot
  pal_ev <- reactive({
    leaflet::colorNumeric(palette = "viridis",
                          domain = dat_to_map()$n)
  })
  
  
  # choropleth of total # stations per state (type of station chosen by user)
  output$states_ev_map <- leaflet::renderLeaflet({
    leaflet() %>%
      addTiles() %>% # adds OpenStretMap basemap
      addPolygons(data = dat_to_map(),
                  weight = 1,
                  color = "black",
                  popup = paste(dat_to_map()$name, "<br>",
                                " EV Stations: ", dat_to_map()$n, "<br>"),
                  fillColor = ~pal_ev()(n),
                  fillOpacity = 0.6) %>%
      addLegend(data = dat_to_map(),
                pal = pal_ev(),
                values = ~n,
                opacity = 1,
                title = "# EV Stations <br> Per State")
  }) #  states_ev_map

  
  
  #-----------------------------------------------------------
  # choropleth of stations/county for specific state
  
  
  # download the state & county shapefile for selected state
  counties_sf <- reactive({
    tigris::counties(input$wh_state,cb = TRUE)
  })
  
  # filter data for choropleth based on selectInput
  dat_single_state <- reactive({
    state_county_counts_df_long %>%
      filter(state == input$wh_state) %>% 
      filter(total_type == input$states_var) 
  })

  # join ev counts data to county shapefile for 1 state
  dat_to_map_single_state <- reactive({
    counties_sf() %>% 
      left_join(dat_single_state(), by = c("NAMELSAD" = "county"))
  })
    
  # create color palette for choropleth based on chosen data to plot
  pal_ev_single_state <- reactive({
    leaflet::colorNumeric(palette = "viridis",
                          domain = dat_to_map_single_state()$n)
  })


  # choropleth for single state (ev station counts by county)
  output$single_state_ev_map <- leaflet::renderLeaflet({
    leaflet() %>%
      addTiles() %>% # adds OpenStretMap basemap
      addPolygons(data = dat_to_map_single_state(),
                  weight = 1,
                  color = "black",
                  popup = paste(dat_to_map_single_state()$NAME, "<br>",
                                " EV Stations: ", dat_to_map_single_state()$n, "<br>"),
                  fillColor = ~pal_ev_single_state()(n),
                  fillOpacity = 0.6) %>%
      addLegend(data = dat_to_map_single_state(),
                pal = pal_ev_single_state(),
                values = ~n,
                opacity = 1,
                title = "# EV Stations <br> Per County")
  }) #
  
  
    
  
  
  
  
  
  
} #---------- server function
#------------------------------------------------------------

