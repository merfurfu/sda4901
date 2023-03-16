#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#packages
library(shiny)
library(dplyr)
library(readr)
library(tidyverse)
library(plotly)

#Load data
url <- "https://raw.githubusercontent.com/merfurfu/sda4901/main/mastersurveyedit.csv"
survey <- read.csv(url)

# we only want 9 relevant variables
survey <- survey %>%
  dplyr::select(Age, 
                Pre...AV.confidence, 
                Post...AV.confidence, 
                Pre...AV.security, 
                Post...AV.security, 
                Pre...AV.dependability, 
                Post...AV.dependability,
                Pre...AV.Trust,
                Post...AV.Trust  )

# Define UI for random distribution app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Perceptions of AV before and after interaction"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select the random distribution type ----
      #radioButtons("dist", "Distribution type:",
      #             c("Normal" = "norm",
      #               "Uniform" = "unif",
      #               "Log-normal" = "lnorm",
      #               "Exponential" = "exp")),
      
      # br() element to introduce extra vertical spacing ----
     # br(),
      
     
      # Input: Slider for the number of observations to generate ----
      # sliderInput("n",
      #            "Number of observations:",
      #            value = 500,
      #            min = 1,
      #            max = 1000)
     
     selectInput(inputId = "pre",
                 label = "Pre", 
                 choices = c(
                             "Confidence" = "Pre...AV.confidence",
                             "Security" = "Pre...AV.security",
                             "Dependability" = "Pre...AV.dependability",
                             "Trust" = "Pre...AV.Trust"),
                 selected = "Pre..Trust"),
     
     selectInput(inputId = "post",
                 label = "Post", 
                 choices = c(
                   "Confidence" = "Post...AV.confidence",
                   "Security" = "Post...AV.security",
                   "Dependability" = "Post...AV.dependability",
                   "Trust" = "Post...AV.Trust"),
                 selected = "Trust"),
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Pre Plot",plotlyOutput("pre_plot")),
                  tabPanel("Post Plot", plotlyOutput("post_plot"))
                  #tabPanel("Table", tableOutput("table"))
      )
      
    )
  )
)

# Define server logic for random distribution app ----
server <- function(input, output) {
  
  # Reactive expression to generate the requested distribution ----
  # This is called whenever the inputs change. The output functions
  # defined below then use the value computed from this expression
  pre <- reactive({
    survey[,input$pre]
  
  })
  
  post <- reactive({
    survey[,input$post]
    
  })
  
  # Generate a plot of the data ----
  # Also uses the inputs to build the plot label. Note that the
  # dependencies on the inputs and the data reactive expression are
  # both tracked, and all expressions are called in the sequence
  # implied by the dependency graph.
  output$pre_plot <- renderPlotly({
    plot_ly(survey, x = pre()) %>% 
      add_histogram()
    
  })
  
  
  # Generate a summary of the data ----
  #output$summary <- renderPrint({
  #  summary(d())
  #})
  
  # Generate an HTML table view of the data ----
  output$post_plot <- renderPlotly({
  plot_ly(survey, x = post()) %>% 
    add_histogram()
  })
  
}

# Create Shiny app ----
shinyApp(ui, server)
