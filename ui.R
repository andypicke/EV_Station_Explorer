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
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot")
  )
  
) # fluidPage

