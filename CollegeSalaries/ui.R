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
                    p("The map shows the location of colleges in the US. Users can hover over the college\'s location to view the college\'s name, 
                          starting median salary and mid career median salary.  
                      On the sidebar panel, users have the option to select the desired regions and select a specific school located in the chosen regions. 
                      Additionally, users can search for specific college\'s name in the search box. 
                      The purple circle marker represents the chosen college."),
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
                        leafletOutput("regionmap") 
                      )
                    )
           ),
           # Panel 3:  Average Salaries By Region Chart
           tabPanel("Average Salaries By Region Chart",
                    p("The bar graph shows the average salaries by each region. 
                            Users have the option to select either the average starting median salary or the average mid career median salary 
                      and compare the average salaries between the regions."),
                    p("Based on the chart, California has the highest average starting and mid career salaries among all regions,
                      whereas the Midwestern region has the lowest. Overall, all the regions have average starting salaries above
                      $40,000 and average mid career salaries above $75,000."),
                    
                    sidebarLayout(
                      sidebarPanel(
                        uiOutput("selectSalary")
                      ),
                        mainPanel(
                          plotlyOutput("regionbar") 
                        )
                      
                    )
           ),
          # Panel 4: Salaries by Individual Major Chart
          tabPanel("Salaries by Individual Major Chart",
                   p("This chart displays the Starting Median Salary, Mid Career Median Salary and the 
                      Salary increase from Starting to Mid Career of each major. The major displayed can be selected by the drop down menu. 
                     Hovering over each bar will display the salary of the major."),
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
                     mainPanel(plotlyOutput("distPlot")
                     ))), 
          
          # Panel 5: Salaires by All Majors Chart
          tabPanel("Salaries by All Majors Chart", 
                   p("This page displays three charts. The first chart shows the Starting Median Salary 
                     for all majors in the dataset; the second chart shows the Mid Career Median Salary 
                     for all majors in the dataset; and the third chart shows the percentage increase 
                     for all majors in the dataset. All charts are displayed in the ascending order. The 
                     range of the charts can be adjusted with the sliders on the sidebar panel. Users can 
                     drag to zoom in into an area of interest and double-click to return to the original chart.
                     Hovering over bars will display the detailed information."),
                   
                   p("For Starting Median Salary, the Physician Assistant major returns the highest salary of $74,300, whereas 
                     the Spanish major returns the lowest of $34,000."),
                  
                   p("For Mid-Career Median Salary, the Chemical Engineering major returns the highest salary of $107,000,
                     whereas the Education major returns the lowest salary of $52,000."),
                   
                   p("For the percentage increase, the International Relations major has the highest percentage salary increase
                     of 97.8%, whereas the Physician Assistant major has the lowest percentage salary increase of 23.4%"),
                   
                   sidebarLayout(
                     
                     sidebarPanel(
                     
                     sliderInput("range1",
                                 h4("Range of Starting Salary:"),
                                 min = 30000,
                                 max = 75000,
                                 value = c(30000, 75000)
                     ),
                     
                     br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),
                     
                     sliderInput("range2",
                                 h4("Range of Mid Career Salary:"),
                                 min = 50000,
                                 max = 110000,
                                 value = c(50000, 110000)
                     ),
                     
                     br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),
                     
                     sliderInput("range3",
                                 h4("Range of Percentage Change:"),
                                 min = 0,
                                 max = 100,
                                 value = c(0, 100))
                     
                   ),
                   mainPanel(
                     plotlyOutput("distPlot2"), 
                     plotlyOutput("distPlot3"),
                     plotlyOutput("distPlot4")
                   )
                   )),
          tabPanel('Salaries by Type of College Chart',
                   p('The bar graph shows the average salaries by type of colleges. Users can 
                                 select what type of colleges they want to see on the sidebar panel. The graph will list the 
                     colleges of that certain type and will show the average salaries for those colleges. 
                     Users can also select whether they want to see average starting salaries or average mid-career 
                     salaries. From the graph, the user can compare the salaries for colleges of a certain 
                     type or compare the salaries for colleges of different types. Users can 
                     drag to zoom in into an area of interest and double-click to return to the original chart.
                     Hovering over bars will display the detailed information.'),
                   p('For Engineering schools, CIT has the highest starting salary ($75,500) and MIT has the highest mid career
                      salary ($126,000), whereas Tennessee Technological University has the lowest starting and mid career salary ($46,200 and $80,000).'),
                   p('For Party schools, University of Illinois - Urbana Champagne has the highest starting and mid career salary ($52,900 and $96,100), 
                     whereas University of Alabama - Tuscaloosa has the lowest starting salary ($41,300) and Florida State University has
                     the lowest mid career salary ($73,000).'),
                   p('For Liberal Arts schools, Amherst College has the highest starting salary ($54,500) and Colorado College has the lowest ($38,500), 
                     whereas Bucknell University has the highest mid career salary ($110,000) and Evergreen State College has the lowest ($63,900).'),
                   p('For Ivy League schools, Princeton has the highest starting salary ($66,500) and Brown has the lowest ($56,200), whereas
                    Dartmouth has the highest mid career salary ($134,000) and Columbia University has the lowest ($107,000).'),
                   p('For State schools, University of California - Berkeley has the highest starting and mid career salary ($59,900 and $112,000), whereas
                      Morehead State University has the lowest starting salary ($34,800) and Black Hills State University has the lowest mid-career salary ($43,900).'),
                   sidebarLayout(sidebarPanel(
                     selectInput('type', 
                                 h4("Select Type of College"), 
                                 choices = list("Engineering" = "Engineering","Party" = "Party",
                                                                                      "Liberal Arts" = "Liberal Arts", "Ivy League" = "Ivy League", 
                                                                                      "State" = "State")),
                     selectInput('salary', 
                                 h4("Select Salary"), 
                                 choices = list('Starting Median Salary' = 'Starting.Median.Salary',
                                                                               'Mid-Career Median Salary' = 'Mid.Career.Median.Salary')),
                     
                     br(),br(),
                     
                     h4("Definitions of Types of Colleges"),
                     p(strong("Engineering"), ": Schools (public or private) that grant more than 50 percent of their 
                       undergraduate degrees in math, sciences, computer science, and engineering and engineering technology majors."),
                     p(strong("Party"), ": Schools with the highest percentage of students who said that alcohol and drugs are common on their campuses, that they don't 
                        spend too many hours studying each day, and that fraternities and sororities are very active on campus."),
                     p(strong("Liberal Arts"), ": Schools that graduate fewer STEM (science, technology, engineering and math) and pre-professional majors, focusing instead on humanities, 
                       arts, and communication programs."),
                     p(strong("Ivy League"), ": Schools in the Ivy League have traditionally been known as the most elite colleges in America. These schools, which include some of the oldest colleges 
                       in the country, also have some of the most famous names."),
                     p(strong("State"), ": Public colleges funded by or associated with the state government."),
                     p("Source:", a("PayScale", href = "https://www.payscale.com/college-salary-report/best-schools-by-type"))
                     
                     ),
                     mainPanel(
                               plotlyOutput('barplot')))
          )
)
))
