#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#Question1

library(shiny)
library(tidyverse)
library(plotly)
library(rsconnect)
library(RCurl)

#rsconnect::setAccountInfo(name='kelloggjohnd',token='010443207F3D4D7316A966D2BD13989F',secret='<SECRET>')

#needed to load data from github so the shiny app would work on the webpage

data <- read.csv('https://raw.githubusercontent.com/charleyferrari/CUNY_DATA608/master/lecture3/data/cleaned-cdc-mortality-1999-2010-2.csv')

cause <- "Neoplasms"

question1 <- data %>%
    filter(Year == 2010, ICD.Chapter == cause)%>%
    select(State, Crude.Rate)


ui <-fluidPage(   
    titlePanel("Neoplasms by State"),    
    
    mainPanel(
        h3("Use the following to compare mortality rates from Neoplasms across the US States for the year 2010"),
        plotlyOutput('plot1'),
        verbatimTextOutput('event1'),
        plotlyOutput('plot2')
    )
)
server <- function(input, output) {
    
    output$plot1 <- renderPlotly({
        plot_ly(data, x = ~question1$Crude.Rate, y = ~question1$State, type = 'bar', text = text)%>%
            layout(title = "2010 Neoplasms Report",
                   xaxis = list(title = ""),
                   yaxis = list(title = "",
                                categoryorder = "total descending",
                                categoryorder = ~question1$Crude.Rate))
    })
    output$event1 <- renderPrint({
        d <- event_data("plotly_hover")
        if (is.null(d)) "Hover on a bar to see State Data!" else d
    })
    output$plot2 <- renderPlotly({
        plot_ly(data, x = ~question1$State, y = ~question1$Crude.Rate, type = 'scatter', mode = "markers")%>%
            layout(title = paste('2010 Neoplasms Scatter Report'),
                   xaxis = list(title = 'State'),
                   yaxis = list(title = 'Rate'),
                   dragmode = "select")
                   })
}
    
shinyApp(ui, server, options = list(height = 540, width = 960))
