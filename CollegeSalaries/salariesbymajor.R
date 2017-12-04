library(dplyr)

# Read data
salariesbymajor<-read.csv("data/degrees-that-pay-back.csv", stringsAsFactors = FALSE)

# Select desired columns 
salariesbymajor <- salariesbymajor %>% 
  mutate(increase = Mid.Career.Median.Salary - Starting.Median.Salary) %>% 
  select(Undergraduate.Major, Starting.Median.Salary, Mid.Career.Median.Salary, increase)
