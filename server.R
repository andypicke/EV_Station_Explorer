#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(leaflet)
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
  
  
  # choropleth of total # stations per state (type chosen by user)
  output$states_ev_map <- leaflet::renderLeaflet({
    leaflet() %>%
      #  addTiles() %>% # adds OpenStretMap basemap
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
  
  
} #---------- server function
#------------------------------------------------------------

