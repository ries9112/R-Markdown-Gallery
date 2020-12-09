# Load package (not on CRAN yet so load from GitHub repo)
p_load_gh("martinctc/parallaxr") 

# Character vector of all MD files
all_md_str <- list.files(path = "documents/parallax", pattern=".md", full.names = TRUE)

# Loop through each MD file, parse, and return a single tibble
md_tibble <- purrr::map_dfr(all_md_str, parse_md) # Return a tibble with row-binding

# Output HTML file
generate_scroll_doc(path = "documents/parallax/output.html",
                    inputs = md_tibble)
