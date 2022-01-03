# loading the packages:
library(ggthemes)
library(ggplot2)
library(dplyr) # for pipes and the data_frame function
library(rvest) # webscraping
library(stringr) # to deal with strings and to clean up our data
library(tidyr)
library(sentimentr)
library(stringr)
library(base)
library(textclean)
library(pdftools)
library(gridGraphics)
library(gridExtra)
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library(wordcloud2)
setwd("C:/Users/inesr/OneDrive/Documentos/Gapminder_data_project")

# website = read_html("https://www.ft.com/")
# headline = html_text(html_nodes(website,'.js-teaser-heading-link'))
# outlet = "Financial Times"
# ft <- data.frame( outlet, headline)
# 
# website = read_html("https://www.standard.co.uk/")
# headline = html_text(html_nodes(website,'.dUSomO'))
# outlet = "Evening Standard"
# es <- data.frame( outlet, headline)
# 
# website = read_html("https://news.sky.com/business")
# #headline = xml_find_first (website,'.sdc-site-tile__headline-link')
# headline = html_text(html_nodes(website,'.sdc-site-tile__headline-link'))
# outlet = "Sky News"
# sky <- data.frame( outlet, headline)
# 
# website = read_html("https://www.thetimes.co.uk/")
# headline = html_text(html_nodes(website,'.js-tracking'))
# headline = html_text(html_nodes(website,'.Item-strapline , .u-showOnWide'))
# outlet = "The Times"
# times <- data.frame( outlet, headline)
# times = times %>% distinct(headline, .keep_all = TRUE)
# 
# website = read_html("https://www.theguardian.com/uk/business")
# headline =html_text(html_nodes(website,'.js-headline-text'))
# outlet = "The Guardian"
# guardian <- data.frame( outlet, headline)
# 
# website = read_html("https://www.nytimes.com/section/business")
# headline = html_text(html_nodes(website,'.e4e4i5l4 , .css-79elbk+ .e1xfvim30'))
# outlet = "NY Times"
# nyt <- data.frame( outlet, headline)


website = read_html("https://www.eldiario.es/")
headline =html_text(html_nodes(website,'.ni-title'))
outlet = "diario.es"
diarioes <- data.frame( outlet, headline)

website = read_html("https://elpais.com/")
headline =html_text(html_nodes(website,'a'))
outlet = "El Comercio"
elcomercio <- data.frame( outlet, headline)

website = read_html("https://elpais.com/")
headline =html_text(html_nodes(website,'.c_t'))
outlet = "El Pais"
elpais <- data.frame( outlet, headline)

website = read_html("https://okdiario.com/")
 headline =html_text(html_nodes(website,'.article-title'))
outlet = "okdiario"
ok_diario <- data.frame( outlet, headline)

website = read_html("https://lne.es/")
headline =html_text(html_nodes(website,'.new__headline'))
outlet = "La Nueva Espana"
lne <- data.frame( outlet, headline)

website = read_html("https://lavanguardia.com/")
headline =html_text(html_nodes(website,'a'))
outlet = "La Vanguardia"
lavanguardia <- data.frame( outlet, headline)


website = read_html("https://elmundo.es/")
headline =html_text(html_nodes(website,'.ue-c-cover-content__link'))
outlet = "El Mundo"
elmundo <- data.frame( outlet, headline)

df_news = rbind(elpais, diarioes, ok_diario, lne, elcomercio, elmundo)

# df_news = rbind(sky,guardian, times, es)
# 
# #View(df_news)
# 
# write.csv(df_news, "output.csv")


# Load data ---------------------------------------------------------------

#text from pdf files
files <- list.files(pattern="pdf$", full.names=TRUE)
text <- data.frame(Document = files,
                          text = sapply(files, function(x) 
                            paste0(pdf_text(x), collapse = ' ')))  

text <- text$text

text = pdf_text("donald-trump.pdf")
text = pdf_text("3._José_Mujica,_Civilization_Against_Freedom,_2013.pdf")

text = pdf_text("Churchill_Beaches_Speech.pdf")
text = pdf_text("George W. Bush - 911 Address to the Nation.pdf")

text = pdf_text("vox.pdf")
text = pdf_text("psoe.pdf")
text = pdf_text("pp.pdf")
text = pdf_text("podemos.pdf")
text = pdf_text("ciudadanos.pdf")

#text from the news
text <- df_news$headline



#canciones sabina
text = pdf_text("sabina.pdf")

# Load the data as a corpus
docs <- Corpus(VectorSource(text))

# inspect(docs)

#Transformation is performed using tm_map() function to replace, for example, special characters from the text.
#Replacing â/â, â@â and â|â with space:
docs <- tm_map(docs , content_transformer(gsub), pattern = "á", replacement = "a", fixed=TRUE)
docs <- tm_map(docs , content_transformer(gsub), pattern = "ó", replacement = "o", fixed=TRUE)
docs <- tm_map(docs , content_transformer(gsub), pattern = "é", replacement = "e", fixed=TRUE)
docs <- tm_map(docs , content_transformer(gsub), pattern = "í", replacement = "i", fixed=TRUE)
docs <- tm_map(docs , content_transformer(gsub), pattern = "ú", replacement = "u", fixed=TRUE)
docs <- tm_map(docs , content_transformer(gsub), pattern = "ñ", replacement = "n", fixed=TRUE)

toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "-")
docs <- tm_map(docs, toSpace, "[^\x01-\x7F]")
docs <- tm_map(docs, toSpace, "[^0-9A-Za-z///' ]")
docs <- tm_map(docs, toSpace, "[0-9]+")
docs <- tm_map(docs , content_transformer(gsub), pattern = "customers", replacement = "customer", fixed=TRUE)
docs <- tm_map(docs , content_transformer(gsub), pattern = "american", replacement = "americans", fixed=TRUE)
docs <- tm_map(docs , content_transformer(gsub), pattern = "americansrhetoric", replacement = "americans", fixed=TRUE)
docs <- tm_map(docs , content_transformer(gsub), pattern = "años", replacement = "año", fixed=TRUE)
docs <- tm_map(docs , content_transformer(gsub), pattern = "anos", replacement = "ano", fixed=TRUE)


# docs <- make_plural(docs, keep.original = FALSE, irregular = lexicon::pos_df_irregular_nouns)
# docs <- Corpus(VectorSource(docs))

#cleaning text
# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removeWords, stopwords("es"))
# Remove your own stop word
# specify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("can", "even", "many","let", "like", "jose", "ago","often", "still", "upon",
                                  "may",  "shall","says", "take", "takes","will", "appendix","full","read","story", 
                                  "also","yet", "group","polit","must", "perhaps","jos","one", "am",
                                  "come", "mujica", "accounts", "annotated", "applause", "washingtonpost", "whether",
                                  "utm", "com", "ahomepage", "https", "pagina", "copyright", "eidenmuller",
                                  "ted", "fstory", "www", "news", "just", "almost","los","las","por","para","quiere",
                                  "okclub", "dar","mas","asi", "ellos","todas","ello","lectura","facil","sera","hace","dice",
                                  "casi","ser","dan","tras")) 
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)

# Text stemming
# docs <- tm_map(docs, stemDocument)

#build document matrix (document matrix contains frequency of the terms)
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
# View(d)
# # findFreqTerms(dtm, lowfreq = 0, highfreq = Inf)
# findFreqTerms(dtm, 20)  # words that show up more than 20 times
# findFreqTerms(dtm, 30)  # words that show up more than 4 and 28?



# Generate Word Cloud -----------------------------------------------------
#with wordcloud2 package
# wordcloud2(d, size = .7, minRotation = -pi/6, maxRotation = -pi/6, 'skyblue')

wordcloud2(d, size = .5, figPath = "sabina.png", backgroundColor = "lightgrey") 

letterCloud(d, word = "sabina",backgroundColor = "skyblue")




