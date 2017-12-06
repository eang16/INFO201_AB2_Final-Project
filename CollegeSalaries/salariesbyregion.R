library(dplyr)
library(leaflet)
library(htmltools)
#read data
salariesbyregion <- read.csv("data/salaries-by-region.csv", stringsAsFactors = FALSE)

# Convert starting salaries to numeric
salariesbyregion$Starting.Median.Salary <- gsub("[$]", "", salariesbyregion$Starting.Median.Salary)
salariesbyregion$Starting.Median.Salary <- gsub(",", "", salariesbyregion$Starting.Median.Salary)

# Convert mid career salaries to numeric
salariesbyregion$Mid.Career.Median.Salary <- gsub("[$]", "", salariesbyregion$Mid.Career.Median.Salary)
salariesbyregion$Mid.Career.Median.Salary <- gsub(",", "", salariesbyregion$Mid.Career.Median.Salary)

# Compute average starting and mid career salary of each region
average.salary.by.region <- group_by(salariesbyregion, Region) %>%
  summarise(Average.Starting.Salary = round(mean(as.numeric(Starting.Median.Salary)), 2)
            ,Average.Mid.Career.Salary = round(mean(as.numeric(Mid.Career.Median.Salary)), 2))

# Function that makes the region salary chart
makeRegionChart <- function(datas, salary){
  selectedSalary <- reactive({
    if("Average.Starting.Salary" %in% salary) return (datas$Average.Starting.Salary)
    if("Average.Mid.Career.Salary" %in% salary) return(datas$Average.Mid.Career.Salary)
  })
  plot_ly(data = datas, 
          x = ~Region, 
          y = selectedSalary(), 
          type = 'bar', 
          hoverinfo = 'text',
          text = ~paste(paste('Region: ', datas$Region), paste('Average Salary: $', selectedSalary()), sep = "<br />")) %>%
    layout(title = 'Average Salaries by Region', yaxis = list(title = 'Average Salaries ($)'))
}
