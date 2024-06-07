#-------------------------------------------------------------
#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# https://andypicke.shinyapps.io/EV_Station_Explorer/
#
# Andy Pickering
# andypicke@gmail.com
#
#-------------------------------------------------------------


library(shiny)
library(leaflet)
source('load_data.R') # script loads data on EV charging stations that has already been downloaded


# About text
about_text <- "This Shiny app visualizes data on electric vehicle charging 
stations from the AFDC database. <br> It creates a choropleth map of the 
US for a variable selected by the user." 


# Define UI for application that draws a histogram
fluidPage(
  
  # Application title
  titlePanel("EV Charging Station Explorer"),
  
  # 
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "states_var",
                  label = "Variable To Plot",
                  choices = c("Total Stations" = "n_total",
                              "Public Stations" = "n_public",
                              "Private Stations" = "n_private")
      ),
      selectInput(inputId = "wh_state", # Choose state to plot in "Indivdual State" tab
                  label = "State To Plot",
                  choices = unique(state_county_counts_df$state),
                  selected = "CO"
      )
    ) #sidebarPanel
    ,
    
    
    # 
    mainPanel(
      tabsetPanel(
        tabPanel("About",h5(htmltools::HTML(about_text))),
        tabPanel("US Map",
                 textOutput("result"),
                 textOutput('test'),
                 tabPanel("Map", leaflet::leafletOutput("states_ev_map")),
        ),
        tabPanel("Individual State",
                 h3("# Stations/county for a specific state"),
                 leafletOutput("single_state_ev_map"))
      )
    ) # mainPanel
    
  ) # sidebarLayout
) # fluidPage
