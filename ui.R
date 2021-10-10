#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)
library(shinydashboard)

# Define UI for application that draws a histogram
dashboardPage(skin = 'blue',
              dashboardHeader(title = "Correlation between US and Asian stock markets", titleWidth = 280),
              dashboardSidebar(width = 280,  
                               sidebarMenu(
                                   menuItem("Welcome!", tabName = "intro", icon = icon("th")),
                                   menuItem("Correlation plot over time", tabName = "corplot", icon = icon("th")),
                                   menuItem("Credits", tabName = "credit", icon = icon("th"))
                               )),
              dashboardBody(
                  tabItems(
                      # First tab content
                      tabItem(tabName = "intro",
                              fluidPage(
                                  title = "Welcome to the app!",
                                  mainPanel(
                                      p("Welcome to the app! This app was created to track the correlation 
                                        between United States and Asian financial market movements. Due to the 
                                        extreme time difference and the short hours during which the markets are 
                                        generally open, there is essentially zero overlap. This means that in 
                                        comparing U.S. markets to Asian markets on the same day, the Asian 
                                        trading session occurred first, and the U.S. thereafter. If one compares 
                                        the Asian trading session to the US day before it, this leads to the 
                                        opposite case, i.e. the Asian session immediately following the U.S. 
                                        close. See the two cases below (Asia on the right, U.S. on the left)."),
                                      br(),
                                      img(src = "SameDayComparison.png"),
                                      br(),
                                      img(src = "DiffDayComparison.png"),
                                      br(),
                                      br(),
                                      p("The relevant question is whether the U.S. markets lead the Asian markets 
                                        or vice versa, and it can be answered via these comparisons. We can first 
                                        examine the correlation between same-day trades (first picture) to see how 
                                        strong the relationship is between U.S. trading later on a given day, i.e. 
                                        August 17, and the already-closed Asian markets. We can secondly examine 
                                        the correlation between U.S. markets on a given day, i.e. August 17, and 
                                        the movement of Asian markets in the subsequent session (evening August 17 
                                        U.S. time, or August 18 Asia time)."),
                                      br(),
                                      br(),
                                      p("We then compare these correlations on a monthly basis to see which is larger. 
                                        If the first is larger, this is an indication that Asian markets lead. In 
                                        the opposite case, it is indicated that U.S. markets actually lead. We can 
                                        plot this over time to see how the relationship evolves over time.")
                                  )
                              )),
                      # Second tab content
                      tabItem(tabName = "corplot",
                              pageWithSidebar(
                                  headerPanel('Correlation plot over time'),
                                  sidebarPanel(
                                      sliderInput("year",
                                                  "Years pictured:",
                                                  min = 2000,
                                                  max = 2022,
                                                  value = c(2011, 2022)),
                                      selectInput("USIndex",
                                                  "US Index",
                                                  c("S&P 500", "Nasdaq", "Dow"),
                                                  selected = "S&P 500"),
                                      selectInput("AsiaIndex",
                                                  "Asian Index",
                                                  sort(c("China", "Hong Kong", "Shenzhen", "Taiwan", "Singapore",
                                                         "Australia", "New Zealand", "Malaysia", "Japan", 
                                                         "South Korea")),
                                                  selected = "China")
                                  ),
                                  mainPanel(
                                      p("Comparison Chart below:"),
                                      plotOutput("CorrChart"),
                                      p("U.S. market chart below:"),
                                      plotOutput("ChartIndexUS"),
                                      p("Asian market chart below:"),
                                      plotOutput("ChartIndexAsia")
                                  )
                              )
                      ),
                      tabItem(tabName = "credit",
                              fluidPage(headerPanel('Credits'),
                                   mainPanel(
                                       p("Thanks to tidyquant package for integrated API for stock quotes."),
                                       p("Thanks to Yahoo Finance for API stock quote data."),
                                       p("Thanks to R and Shiny for making interactive apps possible!")
                                   )
                                   )
                              )
                  )
              )
)

# 
# shinyUI(fluidPage(
# 
#     # Application title
#     titlePanel("Correlation between US and Asian stock markets"),
# 
#     # Sidebar with a slider input for number of bins
#     sidebarLayout(
#         sidebarPanel(
#             sliderInput("year",
#                         "Years pictured:",
#                         min = 2000,
#                         max = 2022,
#                         value = c(2011, 2022)),
#             selectInput("USIndex",
#                         "US Index",
#                         c("S&P 500", "Nasdaq", "Dow"),
#                         selected = "S&P 500"),
#             selectInput("AsiaIndex",
#                         "Asian Index",
#                         sort(c("China", "Hong Kong", "Shenzhen", "Taiwan", "Singapore",
#                           "Australia", "New Zealand", "Malaysia", "Japan", 
#                           "South Korea")),
#                         selected = "China")
#         ),
# 
#         # Show a plot of the generated distribution
#         mainPanel(
#             plotOutput("CorrChart"),
#             plotOutput("ChartIndexUS"),
#             plotOutput("ChartIndexAsia")
#         )
#     )
# ))
