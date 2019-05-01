# Load packages
library(dplyr)
library(pageviews)

# Number of articles
n <- 15

# We extract data from yesterday, and exclude special pages
top <- top_articles(project = "es.wikipedia", start = Sys.Date() - 1) %>%
  filter(!grepl(":", article)) %>%
  head(n)
top$article <- gsub("_", " ", top$article)

# Build the tweet
tuit <- paste0("Top ", n, " Wikipedia de ayer [visitas]: ", top$article[1], " [", top$views[1], "]")
for(i in 2:n) tuit <- paste0(tuit, ", ", top$article[i], " [", top$views[i], "]")
tuit <- paste0(tuit, ".")

tuit
nchar(tuit)

while(nchar(tuit) > 280) {
  # If it doesn´t fit in 280 characters, we lower n until it fits
  n <- n - 1
  
  # We extract data from yesterday, and exclude special pages
  top <- top_articles(project = "es.wikipedia", start = Sys.Date() - 1) %>%
    filter(!grepl(":", article)) %>%
    head(n)
  top$article <- gsub("_", " ", top$article)
  
  # Build the tweet
  tuit <- paste0("Top ", n, " Wikipedia de ayer [visitas]: ", top$article[1], " [", top$views[1], "]")
  for(i in 2:n) tuit <- paste0(tuit, ", ", top$article[i], " [", top$views[i], "]")
  tuit <- paste0(tuit, ".")
  print(n)
}

# Conect with Twitter (see details at https://danielredondo.com/posts/20190224_botwikipedia/)
library("rtweet")
token <- create_token(
  app = "nombre de la aplicación",
  consumer_key = "XXXX",
  consumer_secret = "XXXXX",
  access_token = "XXXXX",
  access_secret = "XXXXX")

# Post the tweet
post_tweet(tuit)

# We save the tweet in a .csv file
write(tuit, paste0("RUTA/Archive/tuit_", Sys.Date() - 1, ".csv"))