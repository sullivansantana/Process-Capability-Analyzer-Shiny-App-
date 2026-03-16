# Install libraries
library(shiny)
library(shinydashboard)
library(plotly)
library(ggplot2)

# Define UI
ui <- dashboardPage(
  # Header
  dashboardHeader(title = "Process Capability Analyzer"),
  
  # Sidebar
  dashboardSidebar(
    fileInput("file", "Upload CSV File"),
    uiOutput("varselect"),
    numericInput("lsl", "Lower Spec Limit (LSL)", value = NA),
    numericInput("usl", "Upper Spec Limit (USL)", value = NA),
    sliderInput(
      "bins",
      "Number of bins:",
      min = 10,
      max = 100,
      value = 40
    )
  ),
  
  # Body
  dashboardBody(
    fluidRow(
      # We use a tabBox to create the "How to" and "Dashboard" tabs
      tabBox(
        title = "Navigation",
        id = "tabset1", 
        width = 12,
        
        # TAB 1: Instructions
        tabPanel("How to use", 
                 icon = icon("info-circle"),
                 tags$ol(
                   tags$li("Upload a CSV file in the sidebar."),
                   tags$li("Select the variable you wish to analyze from the dropdown."),
                   tags$li("Define your Lower Spec Limit (LSL) and Upper Spec Limit (USL).", 
                           span(style="color: #d9534f; font-weight: bold;", 
                                "(For the sample file, use LSL: 47 and USL: 53)")),
                   tags$li("Click the 'Dashboard' tab to see your results.")
                 )
        ),
        
        # TAB 2: Results
        tabPanel("Dashboard", 
                 icon = icon("chart-bar"),
                 # Process Capabilities KPIs row inside the tab
                 fluidRow(
                   valueBoxOutput("mean_box", width = 3),
                   valueBoxOutput("sd_box", width = 3),
                   valueBoxOutput("cp_box", width = 3),
                   valueBoxOutput("cpk_box", width = 3)
                 ),
                 # Histogram row inside the tab
                 fluidRow(
                   box(
                     title = "Process Distribution",
                     width = 12,
                     plotlyOutput("hist")
                   )
                 )
        )
      )
    )
  )
)

# Define Server Logic (Remains the same as your original script)
server <- function(input, output, session) {
  # Load data
  data <- reactive({
    req(input$file)
    read.csv(input$file$datapath)
  })
  
  # Variable Selector
  output$varselect <- renderUI({
    req(data())
    selectInput(
      "var",
      "Select Variable",
      names(data())
    )
  })
  
  # Selected Variable
  process_data <- reactive({
    req(input$var)
    data()[[input$var]]
  })
  
  # Metrics Calculation
  metrics <- reactive({
    req(input$lsl, input$usl)
    x <- process_data()
    mu <- mean(x, na.rm = TRUE)
    sigma <- sd(x, na.rm = TRUE)
    Cp <- (input$usl - input$lsl) / (6 * sigma)
    Cpk <- min(
      (input$usl - mu) / (3 * sigma),
      (mu - input$lsl) / (3 * sigma)
    )
    list(mean = mu, sd = sigma, cp = Cp, cpk = Cpk)
  })
  
  # Value Boxes Logic
  output$mean_box <- renderValueBox({
    valueBox(round(metrics()$mean, 3), "Process Mean", icon = icon("chart-line"), color = "blue")
  })
  output$sd_box <- renderValueBox({
    valueBox(round(metrics()$sd, 3), "Standard Deviation", icon = icon("wave-square"), color = "purple")
  })
  output$cp_box <- renderValueBox({
    valueBox(round(metrics()$cp, 3), "Cp", icon = icon("gauge"), color = "green")
  })
  output$cpk_box <- renderValueBox({
    valueBox(
      round(metrics()$cpk, 3), "Cpk", icon = icon("bullseye"),
      color = ifelse(metrics()$cpk > 1.33, "green", "red")
    )
  })
  
  # Plot Histogram
  output$hist <- renderPlotly({
    req(input$lsl, input$usl)
    x <- process_data()
    p <- ggplot(data.frame(x), aes(x)) +
      geom_histogram(bins = input$bins, fill = "steelblue", color = "white") +
      geom_vline(xintercept = input$lsl, color = "red", linetype = "dashed", size = 1) +
      geom_vline(xintercept = input$usl, color = "red", linetype = "dashed", size = 1) +
      theme_minimal() +
      labs(x = "Measurement", y = "Frequency")
    
    ggplotly(p)
  })
}

# RUN APP
shinyApp(ui, server)