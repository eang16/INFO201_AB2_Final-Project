salary.type.data <- read.csv('./data/salaries-by-college-type.csv', stringsAsFactors = FALSE)

salary.type.data$Starting.Median.Salary <- gsub('[$]', '', salary.type.data$Starting.Median.Salary)
salary.type.data$Starting.Median.Salary <- as.numeric(gsub(',', '', salary.type.data$Starting.Median.Salary))

salary.type.data$Mid.Career.Median.Salary <- gsub('[$]', '', salary.type.data$Mid.Career.Median.Salary)
salary.type.data$Mid.Career.Median.Salary <- as.numeric(gsub(',', '', salary.type.data$Mid.Career.Median.Salary))

