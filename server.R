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

source('./load_process_data.R')

dat_to_map <- states_map %>% 
  left_join(state_counts, by = c("stusps" = "state"))


# Define server logic required to draw a histogram
function(input, output, session) {
  
  
  output$result <- renderText({
    paste("You chose to plot: ", input$states_var)})
  
  
  pal_ev <- leaflet::colorNumeric(palette = "viridis",
                                  domain = dat_to_map$n)
  
  output$states_ev_map <- leaflet::renderLeaflet({
    leaflet() %>% 
      #  addTiles() %>% # adds OpenStretMap basemap
      addPolygons(data = dat_to_map,
                  weight = 1,
                  color = "black",
                  popup = paste(dat_to_map$name, "<br>",
                                " EV Stations: ", dat_to_map$n, "<br>"),
                  fillColor = ~pal_ev(n),
                  fillOpacity = 0.6) %>% 
      addLegend(data = dat_to_map,
                pal = pal_ev,
                values = ~n,
                opacity = 1,
                title = "# EV Stations <br>
            Per State"
      )
  })
  
  #  states_ev_map
  
  
} # server function


