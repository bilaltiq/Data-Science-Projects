# scrape Emily Dickinson poems from Wikipedia
# first, get list of URLs of Dickinson poem pages
# then, scrape text on each relevant page

library(tidyverse) 
library(rvest)
library(robotstxt)

# check that we have permission to scrape
paths_allowed("https://en.wikipedia.org")

# website that contains table with links to many of Dickinson's poems
url_edlist <- "https://en.wikipedia.org/wiki/List_of_Emily_Dickinson_poems"

# pull URL directly (don't use table node)
# used CSS selectorGadget to identify "td a" as relevant selector
# html_attr() pulls specific attributes; in this case, we want the href
# which provides the URL
ed_urls <- read_html(url_edlist) %>%
  html_elements("td a") %>%
  html_attr('href')

# this time we want to title attribute to pull the title directly
ed_titles <- read_html(url_edlist) %>%
  html_elements("td a") %>%
  html_attr('title')

## use ldply so get poem text into data frame 
ed_text <- plyr::ldply(.data = ed_urls
                      , .fun = function(url){
                        tryCatch(
                          # This is what I want to do...
                          {(url %>%               
                           read_html() %>%
                           html_elements("div p") %>%   
                           html_text2())[1]
                          },
                          # ... but if an error occurs, set to Missing and keep going 
                          error=function(error_message) {
                            return("Missing")
                          }
                        )
                      })

# add first line (often used as title) and remove poems missing the text (n=30 missing)
DickinsonPoems <- ed_text %>%
  # the title pulled in starts with "s:" so the title starts at the 3rd character
  mutate(title = str_sub(ed_titles,start=3)) %>%
  select(title, text=V1) %>%
  filter(text != "Missing")

head(DickinsonPoems)

# save dataframe in RDS file for future use
saveRDS(DickinsonPoems, file = "DickinsonPoems.Rds")
