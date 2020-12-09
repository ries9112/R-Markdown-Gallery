# Import packages
library(pacman)
p_load('pins','tidyverse','DT','ggforce','gganimate','ggthemes','ggpubr','plotly','webshot')
# install phantomJS to take screenshot
webshot::install_phantomjs()

# Pull data
board_register("https://raw.githubusercontent.com/predictcrypto/pins/master/","hitBTC_orderbooks_github")
# Only keep main cryptocurrencies
cryptodata <- select(filter(pin_get("hitBTC_orderbooks_github", "hitBTC_orderbooks_github"), 
                            symbol == 'ETH'),
                     pair, symbol, ask_1_price, date_time_utc)
# Arrange from latest to earliest data collected
cryptodata <- arrange(cryptodata, desc(date_time_utc))

# Take screenshot of data
webshot("https://cryptocurrencyresearch.org/explore-data.html#data-preview", "data_preview.png")

# Make chart
crypto_chart <- ggplot(data = cryptodata, 
                       aes(x = date_time_utc, y = ask_1_price)) + 
                # show points as a line
                geom_line() + 
                # Add trend line
                stat_smooth() +
                # Add labels
                xlab('Date Time (UTC)') +
                ylab('Price ($)') +
                ggtitle(paste('Price Change Over Time -', cryptodata$symbol),
                        subtitle = paste('Most recent data collected on:',
                                   max(cryptodata$date_time_utc, na.rm=T), '(UTC)')) + 
                # Add theme
                theme_economist()
# make the interactive chart
interactive_chart <- ggplotly(crypto_chart)

# Add additional elements
crypto_chart <- crypto_chart + 
                stat_cor() +
                geom_mark_ellipse(aes(filter = ask_1_price == max(ask_1_price),
                                      label = date_time_utc,
                                      description = paste0('Price spike to $', ask_1_price))) +
                  # Now the same to circle the minimum price:
                geom_mark_ellipse(aes(filter = ask_1_price == min(ask_1_price),
                                      label = date_time_utc,
                                      description = paste0('Price drop to $', ask_1_price)))
# Create environment
env <- list2env(list(interactive_chart = interactive_chart,
                     crypto_chart = crypto_chart), parent.frame())
