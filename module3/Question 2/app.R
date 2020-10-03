#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#Question 2

library(shiny)
library(tidyverse)
library(plotly)
library(rsconnect)
library(RCurl)

#rsconnect::setAccountInfo(name='kelloggjohnd',token='010443207F3D4D7316A966D2BD13989F',secret='<SECRET>')


data <- read.csv('https://raw.githubusercontent.com/charleyferrari/CUNY_DATA608/master/lecture3/data/cleaned-cdc-mortality-1999-2010-2.csv')

working_data <- data %>% 
    group_by(ICD.Chapter, Year) %>% 
    mutate(National.Ave = sum(Deaths)*1e5/sum(Population))

working_data_wide <- working_data %>% spread(State,ICD.Chapter)

State <- working_data$State
Chapter <- working_data$ICD.Chapter

ui <- fluidPage(

    titlePanel("Mortality Rate per Year by State"),

    mainPanel(
        h3("Use the following to compare each ICD Chapter across all states."),
        h5("NOTE: The top visual has fixed axes while the bottom visual will zoom based on the data"),
        plotlyOutput('Plot1'),
        plotlyOutput('Plot2')
    ),
        
    fluidRow( 
        
        column(3,
    h4("Select State"),
        selectInput(inputId = "State",label ='States', choices = State, selected = "AL")
    
        ),
        column(3,
               h4("Select Category"),
        selectInput(inputId = "Chapter", label ='Chapters', choices = Chapter, selected = "Neoplasms")),
        )
    )

server <- function(input, output){

    observeEvent(input$Chapter,{
        dataset <-working_data[which(working_data$State == input$State & working_data$ICD.Chapter == input$Chapter),]
        output$Plot1 <- renderPlotly({
            plot_ly(dataset, x = ~Year, y = ~Crude.Rate, name = input$State, type = 'scatter', mode = 'markers')%>%
                layout(title = paste("Mortality vs Year, Fixed axis"),
                       xaxis = list(title = 'Year'),
                       yaxis = list(title = 'Deaths per 100,000', range = c(0,500)),
                       dragmode =  "select",
                       plot_bgcolor = "white")%>%
                add_trace(y = ~dataset$National.Ave, name = 'National Average',type = 'scatter', mode = 'markers')
                          
        })
        output$Plot2 <- renderPlotly({

            plot_ly(dataset, x = ~Year, y = ~Crude.Rate, name = input$State, type = 'scatter', mode = 'markers')%>%
                layout(title = paste("Mortality vs Year, Zoomed Axis"),
                       xaxis = list(title = 'Year'),
                       yaxis = list(title = 'Deaths per 100,000'),
                       dragmode =  "select",
                       plot_bgcolor = "white")%>%
                add_trace(y = ~dataset$National.Ave, name = 'National Average',type = 'scatter', mode = 'markers')
            })
    })
}

shinyApp(ui, server)
