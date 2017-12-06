# Read in the data source for salary information of college types
salary.type.data <- read.csv('./data/salaries-by-college-type.csv', stringsAsFactors = FALSE)

# Convert starting salaries to numeric
salary.type.data$Starting.Median.Salary <- gsub('[$]', '', salary.type.data$Starting.Median.Salary)
salary.type.data$Starting.Median.Salary <- as.numeric(gsub(',', '', salary.type.data$Starting.Median.Salary))

# Convert mid career salaries to numeric
salary.type.data$Mid.Career.Median.Salary <- gsub('[$]', '', salary.type.data$Mid.Career.Median.Salary)
salary.type.data$Mid.Career.Median.Salary <- as.numeric(gsub(',', '', salary.type.data$Mid.Career.Median.Salary))

# Function to make the chart of salary information of college types
makeTypeChart <- function(data, type, salary){
  chart.data <- data %>%
    filter(School.Type == type) %>% 
    arrange_(salary)
  selectedSalary <- reactive({
    if("Starting.Median.Salary" %in% salary) return (chart.data$Starting.Median.Salary)
    if("Mid.Career.Median.Salary" %in% salary) return (chart.data$Mid.Career.Median.Salary)
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
           xaxis = list(size = 5, title = 'Colleges by Type', tickangle = 60, categoryarray = salary, categoryorder = "array"),
           yaxis = list(size = 5, title = 'Salary ($)'), 
           margin = list(t = 50, b = 500, l = 50, r = 150, pad = 4))

}