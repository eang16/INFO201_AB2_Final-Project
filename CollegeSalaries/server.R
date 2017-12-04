library(shiny)
library(dplyr)
library(leaflet)
library(ggplot2)
library(plotly)
source("salariesbyregion.R")
source("salariesbymajor.R")

salariesbyregion <- read.csv("data/salaries-by-region.csv", stringsAsFactors = FALSE)
salariesbymajor<-read.csv("data/degrees-that-pay-back.csv", stringsAsFactors = FALSE)

# Margin for Salaries by Major graphs
m <- list(
  l = 50,
  r = 50,
  b = 500,
  t = 50,
  pad = 4
)

shinyServer <- function(input, output, session) {
  # Salaries by Region Map
  output$selectSchool <- renderUI({
    regionschool <- salariesbyregion %>%
      filter(Region %in% input$regionInput )
    selectizeInput(
      'schoolInput', label = h4("Search School"), choices = regionschool$School.Name
    )
  })
  filteredData <- reactive({
    salariesbyregion %>%
      filter(Region %in% input$regionInput) %>%
      filter(School.Name %in% input$schoolInput)
  })
  
  output$regionmap <- renderLeaflet({
    selected.region <- salariesbyregion %>%
      filter(Region %in% input$regionInput)

    region.labels <- sprintf(paste(paste("School:", selected.region$School.Name),
                            paste("Starting Median Salary:", selected.region$Starting.Median.Salary),
                            paste("Mid Career Median Salary:", selected.region$Mid.Career.Median.Salary),
                            sep = "<br />")) %>%
                      lapply(htmltools::HTML)
    
    leaflet(selected.region) %>%
      addTiles() %>%
      addMarkers(lng = ~Longitude, lat = ~Latitude, label = region.labels, clusterOptions = markerClusterOptions())
  })

  observeEvent(input$schoolInput,{
    selected.school <- salariesbyregion %>%
      filter(School.Name %in% input$schoolInput)

    school.labels <- sprintf(paste(paste("School:", selected.school$School.Name),
                                   paste("Starting Median Salary:", selected.school$Starting.Median.Salary),
                                   paste("Mid Career Median Salary:", selected.school$Mid.Career.Median.Salary),
                                   sep = "<br />")) %>%
                     lapply(htmltools::HTML)

    leafletProxy("regionmap") %>%
      addTiles() %>%
      clearMarkers() %>%      
      addCircleMarkers(data = filteredData(), lng = ~Longitude, lat = ~Latitude, label = school.labels) #%>%
  })
  
  # Average Salaries by Region Chart
  output$selectSalary <- renderUI({
  selectInput('salaries', label = h4('Select Salary'),
              choices = c("Average Starting Salary" = "Average.Starting.Salary", "Average Mid Career Salary" = "Average.Mid.Career.Salary"),
              selected = '1')
  })

  output$regionbar <- renderPlotly({
    selectedSalary <- reactive({
      if("Average.Starting.Salary" %in% input$salaries) return (average.salary.by.region$Average.Starting.Salary)
      if("Average.Mid.Career.Salary" %in% input$salaries) return(average.salary.by.region$Average.Mid.Career.Salary)
    })
    plot_ly(data = average.salary.by.region, 
            x = ~Region, 
            y = selectedSalary(), 
            type = 'bar', 
            hoverinfo = 'text',
            text = ~paste(paste('Region: ', average.salary.by.region$Region), paste('Average Salary: $', selectedSalary()), sep = "<br />")) %>%
          layout(title = 'Average Salaries by Region', yaxis = list(title = 'Average Salaires ($)'))
    })
  
  # Salaries by Individual Major Chart
  output$distPlot <- renderPlotly({
    # Filter data
    chart.data <- salariesbymajor %>% 
      filter(Undergraduate.Major == input$major) 
    
    # Make chart
    plot_ly(
      x = colnames(chart.data[,2:4]),
      y = c(chart.data[1,2], chart.data[1,3], chart.data[1,4]),
      type = "bar") %>% 
      layout(
        xaxis = list(chart.data[,2:4], categoryorder = "array", categoryarray = chart.data[,2:4]),
        yaxis = list(range = c(0, 110000)))
  })
  
  # Starting Median Salary By All Majors Chart
  output$distPlot2 <- renderPlotly({
    chart2.data <- salariesbymajor %>% filter(is.na(Starting.Median.Salary) == FALSE) %>% 
      filter(Starting.Median.Salary > input$range1[1] & Starting.Median.Salary < input$range1[2]) %>% 
      arrange(Starting.Median.Salary)
    plot_ly(
      y = ~chart2.data$Starting.Median.Salary,
      x = ~chart2.data$Undergraduate.Major,
      type = "bar",
      hoverinfo = 'text',
      text = ~paste(paste('Major:', chart2.data$Undergraduate.Major),
                    paste('Starting Salary: $', chart2.data$Starting.Median.Salary, sep = ""), sep = "<br />")
    ) %>% 
      layout(
        title = "Starting Salaries by Majors",
        xaxis = list(title = "Major", categoryarray = chart2.data$Starting.Median.Salary, categoryorder = "array"),
        yaxis = list(title = "Starting Salary ($)", range = c(0, 110000)),
        autosize = F, width = 600, height = 700, margin = m
      )
  })
  
  # Mid Career Median Salary By All Majors Chart
  output$distPlot3 <- renderPlotly({
    chart3.data <- salariesbymajor %>% filter(is.na(Mid.Career.Median.Salary) == FALSE) %>% 
      filter(Mid.Career.Median.Salary > input$range2[1] & Mid.Career.Median.Salary < input$range2[2]) %>% 
      arrange(Mid.Career.Median.Salary)
    
    plot_ly(
      y = ~chart3.data$Mid.Career.Median.Salary,
      x = ~chart3.data$Undergraduate.Major,
      type = "bar",
      hoverinfo = 'text',
      text = ~paste(paste('Major:', chart3.data$Undergraduate.Major),
                    paste('Mid-Career Salary: $', chart3.data$Mid.Career.Median.Salary, sep = ""), sep = "<br />")
    ) %>% 
      layout(
        title = "Mid Career Salaries by Major",
        xaxis = list(title = "Major", categoryarray = chart3.data$Mid.Career.Median.Salary, categoryorder = "array"),
        yaxis = list(title = "Mid-Career Salary ($)", range = c(0, 110000)),
        autosize = F, width = 600, height = 700, margin = m
      )
  })
}
