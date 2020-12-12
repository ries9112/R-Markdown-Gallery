library(pacman)
# Load package (not on CRAN yet so load from GitHub repo)
p_load_gh("martinctc/parallaxr") 
p_load('ggplot2')

# Character vector of all MD files
all_md_str <- list.files(path = "documents/parallax", pattern=".md", full.names = TRUE)

# Loop through each MD file, parse, and return a single tibble
md_tibble <- purrr::map_dfr(all_md_str, parse_md) # Return a tibble with row-binding

# Make a copy of the image of the chart before rendering
#file.copy('crypto_chart.png','documents/parallax/crypto_chart.png', overwrite = T)

# Make new chart
crypto_chart_parallax_eth <- ggplot(data = eth_data, 
                       aes(x = date_time_utc, y = ask_1_price)) + 
  # show points as a line
  geom_line() +
  # Add trend line
  stat_smooth(size=0.3) +
  # Add labels
  xlab('Date Time (UTC)') +
  ylab('Price ($)') + ggtitle('Ethereum Price $')
# Save image
ggsave("documents/parallax/crypto_chart_eth.png",   
       width = 5,
       height = 5,
       units = c("cm"))
# Now for BTC
crypto_chart_parallax_btc <- ggplot(data = btc_data, 
                                    aes(x = date_time_utc, y = ask_1_price)) + 
  # show points as a line
  geom_line() +
  # Add trend line
  stat_smooth(size=0.3) +
  # Add labels
  xlab('Date Time (UTC)') +
  ylab('Price ($)') + ggtitle('Bitcoin Price $')
# Save image
ggsave("documents/parallax/crypto_chart_btc.png",   
       width = 5,
       height = 5,
       units = c("cm"))

# Output HTML file
generate_scroll_doc(path = "documents/parallax/output.html",
                    inputs = md_tibble)
