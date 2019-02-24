# Load packages
library(pageviews)
library(dplyr)


# We extract data from yesterday, and exclude special pages
top <- top_articles(project = "es.wikipedia", start = Sys.Date() - 1) %>%
  filter(!grepl(":", article)) %>%
  head(n)

# Number of articles
n <- 7

# Build the tweet
top$article <- gsub("_", " ", top$article)
tuit <- paste0("Top ", n, " Wikipedia de ayer [visitas]: ",
               top$article[1], " [", top$views[1], "]")
for(i in 2:n) tuit <- paste0(tuit, ", ", top$article[i], " [", top$views[i], "]")
tuit <- paste0(tuit, ".")

# Connect with Twitter (see details at https://danielredondo.com/posts/20190224_botwikipedia/)
library("rtweet")
token <- create_token(
  app = "nombre de la aplicación",
  consumer_key = "XXX",
  consumer_secret = "XXX",
  access_token = "XXX",
  access_secret = "XXX")

# Post the tweet
post_tweet(tuit)

# We save the tweet in a .csv file
write(tuit, paste0("RUTA/Archive/tuit_", Sys.Date() - 1, ".csv"))
