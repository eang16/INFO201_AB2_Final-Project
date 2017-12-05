library(shiny)
library(dplyr)
library(leaflet)
library(ggplot2)
library(plotly)
source("salariesbyregion.R")
source("salariesbymajor.R")
source('salariesbytype.R')

salariesbyregion <- read.csv("data/salaries-by-region.csv", stringsAsFactors = FALSE)

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
          layout(title = 'Average Salaries by Region', yaxis = list(title = 'Average Salaries ($)'))
    })
  
  # Salaries by Individual Major Chart
  output$distPlot <- renderPlotly({
    # Filter data
    chart.data <- salariesbymajor %>% 
      filter(Undergraduate.Major == input$major) 

    plot_ly(
      x = c("Starting Median Salary", "Mid Career Median Salary", "Salary Increase"),
      y = c(chart.data[1,2], chart.data[1,3], chart.data[1,4]),
      type = "bar") %>% 
      layout(
        title = "Salaries by Individual Majors",
        xaxis = list(title= input$major, categoryorder = "array", categoryarray = chart.data[,2:4]),
        yaxis = list(title = "Salary ($)", range = c(0, 110000)))
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
      width = 600,
      height = 700,
      hoverinfo = 'text',
      text = ~paste(paste('Major:', chart2.data$Undergraduate.Major),
                    paste('Starting Salary: $', chart2.data$Starting.Median.Salary, sep = ""), sep = "<br />")
    ) %>% 
      layout(
        title = "Starting Salaries by Majors",
        xaxis = list(title = "Major", categoryarray = chart2.data$Starting.Median.Salary, categoryorder = "array"),
        yaxis = list(title = "Starting Salary ($)", range = c((min(chart2.data$Starting.Median.Salary) - 1000), (max(chart2.data$Starting.Median.Salary)+1000))),
        autosize = F, margin = m
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
      width = 600,
      height = 700,
      hoverinfo = 'text',
      text = ~paste(paste('Major:', chart3.data$Undergraduate.Major),
                    paste('Mid-Career Salary: $', chart3.data$Mid.Career.Median.Salary, sep = ""), sep = "<br />")
    ) %>% 
      layout(
        title = "Mid Career Salaries by Major",
        xaxis = list(title = "Major", categoryarray = chart3.data$Mid.Career.Median.Salary, categoryorder = "array"),
        yaxis = list(title = "Mid-Career Salary ($)", range = c((min(chart3.data$Mid.Career.Median.Salary) - 1000), (max(chart3.data$Mid.Career.Median.Salaryy)+1000))),
        autosize = F, margin = m
      )
  })
  
  # Mid Career Median Salary By All Majors Chart
  output$distPlot4 <- renderPlotly({
    chart4.data <- salariesbymajor %>% filter(is.na(Percent.change.from.Starting.to.Mid.Career.Salary) == FALSE) %>% 
      filter(Percent.change.from.Starting.to.Mid.Career.Salary > input$range3[1] & Percent.change.from.Starting.to.Mid.Career.Salary < input$range3[2]) %>% 
      arrange(Percent.change.from.Starting.to.Mid.Career.Salary)
    
    plot_ly(
      y = ~chart4.data$Percent.change.from.Starting.to.Mid.Career.Salary,
      x = ~chart4.data$Undergraduate.Major,
      type = "bar",
      width = 600,
      height = 700,
      hoverinfo = 'text',
      text = ~paste(paste('Major:', chart4.data$Undergraduate.Major),
                    paste('Percentage Change: ', chart4.data$Percent.change.from.Starting.to.Mid.Career.Salary, sep = ""), sep = "<br />")
    ) %>% 
      layout(
        title = "Percentage Change by Major",
        xaxis = list(title = "Major", categoryarray = chart4.data$Percent.change.from.Starting.to.Mid.Career.Salary, categoryorder = "array"),
        yaxis = list(title = "Percentage Change (%)", range = c((min(chart4.data$Percent.change.from.Starting.to.Mid.Career.Salary) - 5), (max(chart4.data$Percent.change.from.Starting.to.Mid.Career.Salary)+5))),
        autosize = F, margin = m
      )
  })
  
  #Average salaries by type of college bar graph
  output$barplot <- renderPlotly({
    chart.data <- salary.type.data %>%
      filter(School.Type == input$type) %>% 
      arrange_(input$salary)
    selectedSalary <- reactive({
      if("Starting.Median.Salary" %in% input$salary) return (chart.data$Starting.Median.Salary)
      if("Mid.Career.Median.Salary" %in% input$salary) return (chart.data$Mid.Career.Median.Salary)
    })
    plot_ly(x = ~chart.data$School.Name, 
            y = ~selectedSalary(), 
            type = 'bar', 
            width = 1000,
            height = 800,
            hoverinfo = 'text',
            text = ~paste(paste('College:', chart.data$School.Name),
                          paste('Salary: $', selectedSalary(), sep = ""), sep = "<br />")) %>%
      layout(title = 'Average Salaries by Type of College',
             autosize = F, 
             xaxis = list(size = 5, title = 'Colleges by Type', tickangle = 60, categoryarray = input$salary, categoryorder = "array"),
             yaxis = list(size = 5, title = 'Salary ($)'), 
             margin = list(t = 50, b = 500, l = 50, r = 150, pad = 4))
  })
}

