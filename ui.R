#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Correlation between US and Asian stock markets"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("year",
                        "Years pictured:",
                        min = 2010,
                        max = 2022,
                        value = c(2011, 2022)),
            selectInput("USIndex",
                        "US Index",
                        c("S&P 500", "Nasdaq", "Dow"),
                        selected = "S&P 500"),
            selectInput("AsiaIndex",
                        "Asian Index",
                        c("Hang Seng Index", "Shanghai"),
                        selected = "Hang Seng Index")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("CorrChart"),
            plotOutput("ChartIndexUS"),
            plotOutput("ChartIndexAsia")
        )
    )
))
