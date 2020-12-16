# Import packages
library(pacman)
p_load('pins','tidyverse','DT','ggforce','gganimate','ggthemes','ggpubr',
       'plotly','revealjs','xaringan','knitr','rmarkdown','tinytex','tufte',
       'bookdown')

# Pull data - first register pins board to establish connection
board_register("https://raw.githubusercontent.com/predictcrypto/pins/master/","hitBTC_orderbooks_github")
# Only keep main cryptocurrencies BTC and ETH
cryptodata <- select(filter(pin_get("hitBTC_orderbooks_github", "hitBTC_orderbooks_github"), 
                            symbol == 'ETH' | symbol == 'BTC'),
                     pair, symbol, ask_1_price, date_time_utc)
# Arrange data from latest to earliest
cryptodata <- arrange(cryptodata, desc(date_time_utc))

# Create one dataset for ETH and one for BTC
eth_data <- filter(cryptodata, symbol == 'ETH')
btc_data <- filter(cryptodata, symbol == 'BTC')

# Make chart
eth_chart <- ggplot(data = eth_data, 
                       aes(x = date_time_utc, y = ask_1_price)) + 
                # show points as a line
                geom_line() + 
                # Add trend line
                stat_smooth() +
                # Add labels
                xlab('Date Time (UTC)') +
                ylab('Price ($)') +
                ggtitle(paste('Price Change Over Time -', eth_data$symbol),
                        subtitle = paste('Most recent data collected on:',
                                   max(eth_data$date_time_utc, na.rm=T), '(UTC)')) + 
                # Add theme
                theme_economist()

# Make the chart interactive
interactive_chart <- ggplotly(eth_chart)

# Add additional elements
eth_chart <- eth_chart + 
                stat_cor() +
                geom_mark_ellipse(aes(filter = ask_1_price == max(ask_1_price),
                                      label = date_time_utc,
                                      description = paste0('Price spike to $', ask_1_price))) +
                  # Now the same to circle the minimum price:
                geom_mark_ellipse(aes(filter = ask_1_price == min(ask_1_price),
                                      label = date_time_utc,
                                      description = paste0('Price drop to $', ask_1_price)))
# Save image
ggsave('eth_chart.png', plot = eth_chart)

