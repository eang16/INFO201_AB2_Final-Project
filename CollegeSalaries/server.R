# Load libraries
library(shiny)
library(dplyr)
library(leaflet)
library(plotly)
library(htmltools)


# Source R scripts
source("./scripts/salariesbyregion.R")
source("./scripts/salariesbymajor.R")
source('./scripts/salariesbytype.R')


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
  output$regionbar <- renderPlotly({
    makeRegionChart(average.salary.by.region, input$salaries)
    })
  
  # Salaries by Individual Major Chart
  output$distPlot <- renderPlotly({
    makeEachMajorChart(salariesbymajor, input$major)
  })
  
  # Starting Median Salary By All Majors Chart
  output$distPlot2 <- renderPlotly({
    makeMajorGraph(salariesbymajor, "Starting.Median.Salary", input$range1, "Starting Salaries by Majors", "Starting Salary", "$", TRUE, 1000, m)
  })
  
  # Mid Career Median Salary By All Majors Chart
  output$distPlot3 <- renderPlotly({
    makeMajorGraph(salariesbymajor, "Mid.Career.Median.Salary", input$range2, "Mid Career Salaries by Majors", "Mid Career Salary", "$", TRUE, 1000, m)
  })
  
  # Mid Career Median Salary By All Majors Chart
  output$distPlot4 <- renderPlotly({
    makeMajorGraph(salariesbymajor, "Percent.change.from.Starting.to.Mid.Career.Salary", input$range3, "Percentage Change by Major", "Percentage Change", "%", FALSE, 5, m)
  })
  
  #Average salaries by type of college bar graph
  output$barplot <- renderPlotly({
    makeTypeChart(salary.type.data, input$type, input$salary)
  })
}

