#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyquant)
library(stringr)
library(tidyverse)
library(lubridate)
library(plyr)
options("getSymbols.warning4.0"=FALSE)
options("getSymbols.yahoo.warning"=FALSE)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$CorrChart <- renderPlot({
        cor_func <- function(df){
            return(data.frame(Cor = 100 * cor(df$Asia_chg, df$US_chg, use = "pairwise.complete.obs") - 
                                  100 * cor(df$Asia_chg, df$US_chg_lag1, use = "pairwise.complete.obs")))
        }
        if (input$USIndex == "S&P 500"){
            us_ticker <- "^GSPC"
        } else if (input$USIndex == "Nasdaq"){
            us_ticker <- "^IXIC"
        } else if (input$USIndex == "Dow"){
            us_ticker <- "^DJI"
        }
        if (input$AsiaIndex == "Hang Seng Index"){
            asia_ticker <- "^HSI"
        } else if (input$AsiaIndex == "Shanghai"){
            asia_ticker <- "000001.SS"
        }
        tickers <- c(us_ticker, asia_ticker)
        getSymbols(tickers, 
                   from = "2010-01-01", 
                   to = "2021-09-30",
                   warnings = FALSE,
                   auto.assign = TRUE)
        clean_name_us <- str_replace_all(tickers[1], "[^[:alnum:]]", "")
        clean_name_asia <- str_replace_all(tickers[2], "\\^", "")
        common_df <- merge(get(clean_name_us), get(clean_name_asia)) %>% 
            as.data.frame() %>% 
            na.omit()
        common_df <- common_df[, c(4, 10)]
        colnames(common_df) <- c("US", "Asia")
        common_df <- common_df %>% na.omit()
        common_df$US_chg <- (common_df$US - lag(common_df$US, 1)) / lag(common_df$US, 1) * 100
        common_df$Asia_chg <- (common_df$Asia - lag(common_df$Asia, 1)) / lag(common_df$Asia, 1) * 100
        common_df$US_chg_lag1 <- (lag(common_df$US, 1) - lag(common_df$US, 2)) / lag(common_df$US, 1) * 100
        common_df <- common_df %>% na.omit()
        common_df$date <- rownames(common_df)
        common_df$month <- month(common_df$date)
        common_df$year <- year(common_df$date)
        common_df <- common_df %>% 
            filter(year >= input$year[1],
                   year <= input$year[2])
        cor_df <- ddply(common_df, .(year, month), cor_func)
        cor_df$Date <- as.Date(paste(cor_df$year, cor_df$month, 15, sep = "-"), format = "%Y-%m-%d")
        annote_df <- data.frame(xpos = c(-Inf, -Inf),
                                ypos = c(Inf, -Inf),
                                annotateText = c("Higher y-axis readings leans toward Asia leading",
                                                 "Lower y-axis leans toward US leading"),
                                hjustvar = c(-1, -1),
                                vjustvar = c(-1, 1))
        cor_df %>% 
            ggplot() +
            geom_line(aes(Date, Cor)) +
            geom_line(aes(Date, 0), size = 1.5) +
            geom_smooth(aes(Date, Cor)) +
            geom_text(data = cor_df[1, ],
                      aes(Date, Cor),
                      vjust = -15,
                      hjust = -0.5,
                      label = "Higher y-axis readings lean toward Asia leading") +
            geom_text(data = cor_df[1, ],
                      aes(Date, Cor),
                      vjust = 15,
                      hjust = -0.5,
                      label = "Lower y-axis readings lean toward US leading")
    })
    
    output$ChartIndexUS <- renderPlot({
        if (input$USIndex == "S&P 500"){
            us_ticker <- "^GSPC"
        } else if (input$USIndex == "Nasdaq"){
            us_ticker <- "^IXIC"
        } else if (input$USIndex == "Dow"){
            us_ticker <- "^DJI"
        }
        if (input$AsiaIndex == "Hang Seng Index"){
            asia_ticker <- "^HSI"
        } else if (input$AsiaIndex == "Shanghai"){
            asia_ticker <- "000001.SS"
        }
        tickers <- c(us_ticker, asia_ticker)
        getSymbols(tickers, 
                   from = "2001-01-01", 
                   to = "2021-09-30",
                   warnings = FALSE,
                   auto.assign = TRUE)
        clean_name_us <- str_replace_all(tickers[1], "\\^", "")
        chart_Series(get(clean_name_us),
                     name = clean_name_us)

    })
    
    output$ChartIndexAsia <- renderPlot({
        if (input$USIndex == "S&P 500"){
            us_ticker <- "^GSPC"
        } else if (input$USIndex == "Nasdaq"){
            us_ticker <- "^IXIC"
        } else if (input$USIndex == "Dow"){
            us_ticker <- "^DJI"
        }
        if (input$AsiaIndex == "Hang Seng Index"){
            asia_ticker <- "^HSI"
        } else if (input$AsiaIndex == "Shanghai"){
            asia_ticker <- "000001.SS"
        }
        tickers <- c(us_ticker, asia_ticker)
        getSymbols(tickers, 
                   from = "2010-01-01", 
                   to = "2021-09-30",
                   warnings = FALSE,
                   auto.assign = TRUE)
        clean_name_asia <- str_replace_all(tickers[2], "\\^", "")
        chart_Series(get(clean_name_asia),
                     name = clean_name_asia)
        
        # # generate bins based on input$bins from ui.R
        # x    <- faithful[, 2]
        # bins <- seq(min(x), max(x), length.out = input$bins + 1)
        # 
        # # draw the histogram with the specified number of bins
        # hist(x, breaks = bins, col = 'darkgray', border = 'white')
        
    })
    

})
