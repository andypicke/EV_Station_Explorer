#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(
  
  # Application title
  titlePanel("EV Charging Station Explorer"),
  
  # 
  sidebarLayout(
    shiny::sidebarPanel(
      shiny::selectInput(inputId =  "states_var",
                         label = "Variable To Plot",
                         choices = c("Total Stations", "Public Stations", "Private Stations")
      )
    ) #sidebarPanel
    ,
    
    # Show a plot of the generated distribution
    mainPanel(
      shiny::tabsetPanel(
        tabPanel("About"),
        shiny::tabPanel("US Map",
                        shiny::textOutput("result"),
                        shiny::tabPanel("Map", leaflet::leafletOutput("states_ev_map")),
        ),
        tabPanel("Individual State")
      )
    ) # mainPanel
    
  ) # sidebarLayout
) # fluidPage
