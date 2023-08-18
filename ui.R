#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


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
      )
    ) #sidebarPanel
    ,
    
    
    # 
    mainPanel(
      tabsetPanel(
        tabPanel("About",h5(about_text)),
        tabPanel("US Map",
                 textOutput("result"),
                 textOutput('test'),
                 tabPanel("Map", leaflet::leafletOutput("states_ev_map")),
        ),
        tabPanel("Individual State",
                 h3("This tab will contain map of data by county for a specific state"))
      )
    ) # mainPanel
    
  ) # sidebarLayout
) # fluidPage
