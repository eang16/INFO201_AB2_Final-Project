# Load library
library(dplyr)

# Read in the data source for salary information of majors
data<-read.csv("data/degrees-that-pay-back.csv", stringsAsFactors = FALSE)

# Select desired columns 
salariesbymajor <- data %>% 
  mutate(increase = Mid.Career.Median.Salary - Starting.Median.Salary) %>% 
  select(Undergraduate.Major, Starting.Median.Salary, Mid.Career.Median.Salary, increase, Percent.change.from.Starting.to.Mid.Career.Salary)

# Margin for Salaries by Major graphs
m <- list(
  l = 50,
  r = 50,
  b = 500,
  t = 50,
  pad = 4
)

# Function that make the bar chart for salary information for individual major.
makeEachMajorChart <- function(data, major){
  chart.data <- data %>% 
    filter(Undergraduate.Major == major) 
  plot_ly(
    x = c("Starting Median Salary", "Mid Career Median Salary", "Salary Increase"),
    y = c(chart.data[1,2], chart.data[1,3], chart.data[1,4]),
    type = "bar") %>% 
    layout(
      title = "Salaries by Individual Majors",
      xaxis = list(title= major, categoryorder = "array", categoryarray = chart.data[,2:4]),
      yaxis = list(title = "Salary ($)", range = c(0, 110000)))
}

# Function that make bar charts for salary information for all majors
makeMajorGraph <- function(data, colname, range, titles, ylab, sign, sign.at.front, diff, margins){
              if(sign.at.front){
                hover <- paste(ylab, ': ', sign, sep = '')
              } else {
                hover <- paste(ylab, ': ', sep = '')
              }
  
              chart.data <- data %>% filter(is.na(data[,colname]) == FALSE) %>% 
                filter(data[,colname] > range[1] & data[,colname] < range[2]) %>% 
                arrange_(colname)
              
              plot_ly(
                y = ~chart.data[,colname],
                x = ~chart.data$Undergraduate.Major,
                type = "bar",
                width = 800,
                height = 700,
                hoverinfo = 'text',
                text = ~paste(paste('Major:', chart.data$Undergraduate.Major),
                              paste(hover, chart.data[,colname], sep = ''), sep = "<br />")
              ) %>% 
                layout(
                  title = titles,
                  xaxis = list(title = "Major", categoryarray = chart.data[,colname], categoryorder = "array"),
                  yaxis = list(title = paste(ylab, " (", sign, ")", sep = ""), range = c((min(chart.data[,colname]) - diff), (max(chart.data[,colname])+diff))),
                  autosize = F, margin = margins
                )

}