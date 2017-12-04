library(shiny)
library(leaflet)
library(shinythemes)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = shinytheme("flatly"), 
  navbarPage("Salaries by Regions, Majors and Type of Colleges",
          # Panel 1: Introduction   
           tabPanel("Introduction", 
                 h4("About Our Project"),
                 p("Our project provides the users with an overview of salaries based on colleges in the US. Users can examine the salaries based on 
                   region, major or the type of college with the map and charts."),
                 h4("Dataset"),
                 p("The dataset is accessed from", a("here", href = "https://www.kaggle.com/wsj/college-salaries"),
                    ". It is obtained from the Wall Street Journal based on data from Payscale, Inc."),
                 h4("Our Audience"),
                 p("Our target audience is mainly high school and college students who are considering salaries as one of the factors when they apply for schools or majors. 
                    Some of them might be interested to know about their potential future salaries based on different types of colleges, regions and majors.
                    Also, some of them might be interested to compare salaries between where they come from and the other regions."),
                 p("Some questions that could be answered through our project are:"),
                 p("1. Which major has the highest/lowest starting/mid career median salary?"),
                 p("2. Which type of college has the highest/lowest starting/ mid career median salary?"),
                 p("3. Which region has the highest/lowest starting/mid career median salary?"),
                 h4("Project Creators"),
                 p("Zihui Zhang, Nancy Shih, Meini Fan, Eshin Ang")

           ),
           # Panel 2: Salaries By Region Map
           tabPanel("Salaries By Region Map",
                    sidebarLayout(
                      sidebarPanel(
                        checkboxGroupInput("regionInput", label = h4("Select Region"), 
                                           choices = list("California" = "California",
                                                          "Western" = "Western", 
                                                          "Midwestern" = "Midwestern",
                                                          "Southern" = "Southern",
                                                          "Northeastern" = "Northeastern"),
                                           selected = c("California","Western", "Midwestern", "Southern","Northeastern")),
                        uiOutput("selectSchool")
                        
                      ),
                      mainPanel(
                        p("The map shows the location of colleges in the US. Users can hover over the college\'s location to view the college\'s name, 
                          starting median salary and mid career median salary.  
                          On the sidebar panel, users have the option to select the desired regions and select a specific school located in the chosen regions. 
                          Additionally, users can search for specific college\'s name in the search box. 
                          The purple circle marker represents the chosen college."),
                        leafletOutput("regionmap") 
                      )
                    )
           ),
           # Panel 3:  Average Salaries By Region Chart
           tabPanel("Average Salaries By Region Chart",
                    sidebarLayout(
                      sidebarPanel(
                        uiOutput("selectSalary")
                      ),
                        mainPanel(
                          p("The bar graph shows the average salaries by each region. 
                            Users have the option to select either the average starting median salary or the average mid career median salary 
                            and compare the average salaries between the regions."),
                          plotlyOutput("regionbar") 
                        )
                      
                    )
           ),
          # Panel 4: Salaries by Individual Major Chart
          tabPanel("Salaries by Individual Major Chart",
                   sidebarLayout(
                     sidebarPanel(
                       selectInput("major", h4("Select Major"), 
                                   choices = list("Accounting" = "Accounting",
                                                  "Aerospace Engineering" = "Aerospace Engineering",
                                                  "Agriculture" = "Agriculture",
                                                  "Anthropology" = "Anthropology",
                                                  "Architecture" = "Architecture",
                                                  "Art History" = "Art History",
                                                  "Biology" = "Biology",
                                                  "Business Management" = "Business Management",
                                                  "Chemical Engineering" = "Chemical Engineering",
                                                  "Chemistry" = "Chemistry",
                                                  "Civil Engineering" = "Civil Engineering",
                                                  "Communications" = "Communications",
                                                  "Computer Engineering" = "Computer Engineering",
                                                  "Computer Science" = "Computer Science",
                                                  "Construction" = "Construction",
                                                  "Criminal Justice" = "Criminal Justice",
                                                  "Drama" = "Drama",
                                                  "Economics" = "Economics",
                                                  "Education" = "Education",
                                                  "Electrical Engineering" = "Electrical Engineering",
                                                  "English" = "English",
                                                  "Film" = "Film",
                                                  "Finance" = "Finance",
                                                  "Forestry" = "Forestry",
                                                  "Geography" = "Geography",
                                                  "Geology" = "Geology",
                                                  "Graphic Design" = "Graphic Design",
                                                  "Health Care Administration" = "Health Care Administration",
                                                  "History" = "History",
                                                  "Hospitality & Tourism" = "Hospitality & Tourism",
                                                  "Industrial Engineering" = "Industrial Engineering",
                                                  "Information Technology (IT)" = "Information Technology (IT)",
                                                  "Interior Design" = "Interior Design",
                                                  "International Relations" = "International Relations",
                                                  "Journalism" = "Journalism",
                                                  "Management Info Systems" = "Management Info Systems",
                                                  "Marketing" = "Marketing",
                                                  "Math" = "Math",
                                                  "Mechanical Engineering" = "Mechanical Engineering",
                                                  "Music" = "Music",
                                                  "Nursing" = "Nursing",
                                                  "Nutrition" = "Nutrition",
                                                  "Philosophy" = "Philosophy",
                                                  "Physician Assistant" = "Physician Assistant",
                                                  "Physics" = "Physics",
                                                  "Political Science" = "Political Science",
                                                  "Psychology" = "Psychology",
                                                  "Religion" = "Religion",
                                                  "Sociology" = "Sociology",
                                                  "Spanish" = "Spanish"
                                   ))),
                     mainPanel(p("introduction of this page"), plotlyOutput("distPlot")
                     ))), 
          
          # Panel 5: Salaires by All Majors Chart
          tabPanel("Salaires by All Majors Chart", 
                   sidebarLayout(sidebarPanel(
                     
                     sliderInput("range1",
                                 h4("Range of Starting Salary:"),
                                 min = 0,
                                 max = 110000,
                                 value = c(0, 110000)
                     ),
                     
                     sliderInput("range2",
                                 h4("Range of Mid Career Salary:"),
                                 min = 0,
                                 max = 110000,
                                 value = c(0, 110000))
                   ),
                   mainPanel(
                     p("introduction of this page"),
                     plotlyOutput("distPlot2"), 
                     plotlyOutput("distPlot3")
                     
                   )
                   ))
)
))
