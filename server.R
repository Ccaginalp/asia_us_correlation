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
                                  100 * cor(df$Asia_chg, df$US_chg_lead1, use = "pairwise.complete.obs")))
        }
        tickers <- c("^GSPC", "^HSI")
        getSymbols(tickers, 
                   from = "2010-01-01", 
                   to = "2020-03-01",
                   warnings = FALSE,
                   auto.assign = TRUE)
        clean_name_us <- str_replace_all(index_info[2], "[^[:alnum:]]", "")
        clean_name_asia <- str_replace_all(index_info[2], "[^[:alnum:]]", "")
        common_df <- merge(get(clean_name_us), get(clean_name_asia)) %>% 
            as.data.frame() %>% 
            na.omit()
        common_df <- common_df[, c(4, 10)]
        colnames(common_df) <- c("US", "Asia")
        common_df <- common_df %>% na.omit()
        common_df$US_chg <- (common_df$US - lag(common_df$US, 1)) / lag(common_df$US, 1) * 100
        common_df$Asia_chg <- (common_df$Asia - lag(common_df$Asia, 1)) / lag(common_df$Asia, 1) * 100
        common_df$US_chg_lead1 <- (lead(common_df$US, 1) - common_df$US) / common_df$US * 100
        common_df <- common_df %>% na.omit()
        common_df$date <- rownames(common_df)
        common_df$month <- month(common_df$date)
        common_df$year <- year(common_df$date)
        cor_df <- ddply(common_df, .(year, month), cor_func)
        cor_df$Date <- as.Date(paste(cor_df$year, cor_df$month, 15, sep = "-"), format = "%Y-%m-%d")
        cor_df %>% 
            ggplot() +
            geom_line(aes(Date, Cor))
    })
    
    output$ChartIndexUS <- renderPlot({
        tickers <- c("^GSPC", "^HSI")
        getSymbols(tickers, 
                   from = "2010-01-01", 
                   to = "2020-03-01",
                   warnings = FALSE,
                   auto.assign = TRUE)
        clean_name_us <- str_replace_all(index_info[2], "[^[:alnum:]]", "")
        chart_Series(get(clean_name_us),
                     name = clean_name_us)

        # # generate bins based on input$bins from ui.R
        # x    <- faithful[, 2]
        # bins <- seq(min(x), max(x), length.out = input$bins + 1)
        # 
        # # draw the histogram with the specified number of bins
        # hist(x, breaks = bins, col = 'darkgray', border = 'white')

    })
    
    output$ChartIndexAsia <- renderPlot({
        tickers <- c("^GSPC", "^HSI")
        getSymbols(tickers, 
                   from = "2010-01-01", 
                   to = "2020-03-01",
                   warnings = FALSE,
                   auto.assign = TRUE)
        clean_name_asia <- str_replace_all(index_info[2], "[^[:alnum:]]", "")
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
