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
setwd("C:/Users/inesr/OneDrive/Documentos/Gapminder_data_project")

# website = read_html("https://www.ft.com/")
# headline = html_text(html_nodes(website,'.js-teaser-heading-link'))
# outlet = "Financial Times"
# ft <- data.frame( outlet, headline)

# website = read_html("https://news.sky.com/business")
# #headline = xml_find_first (website,'.sdc-site-tile__headline-link')
# headline = html_text(html_nodes(website,'.sdc-site-tile__headline-link'))
# outlet = "Sky News"
# sky <- data.frame( outlet, headline)
# 
# website = read_html("https://www.thetimes.co.uk/")
# #headline = html_text(html_nodes(website,'.js-tracking'))
# headline = html_text(html_nodes(website,'.Item-strapline , .u-showOnWide'))
# outlet = "The Times"
# times <- data.frame( outlet, headline)
# #times = times %>% distinct(headline, .keep_all = TRUE)
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
# 
# df_news = rbind(sky,guardian, times)
# 
# #View(df_news)
# 
# write.csv(df_news, "output.csv")


# Load data ---------------------------------------------------------------

files <- list.files(pattern="pdf$", full.names=TRUE)
text <- data.frame(Document = files,
                          text = sapply(files, function(x) 
                            paste0(pdf_text(x), collapse = ' ')))  

text <- text$text

text = pdf_text("donald-trump.pdf")
text = pdf_text("3._José_Mujica,_Civilization_Against_Freedom,_2013.pdf")

text = pdf_text("Churchill_Beaches_Speech.pdf")
text = pdf_text("George W. Bush - 911 Address to the Nation.pdf")

#text <- df_news$headline

# Load the data as a corpus
docs <- Corpus(VectorSource(text))

# inspect(docs)

#Transformation is performed using tm_map() function to replace, for example, special characters from the text.
#Replacing â/â, â@â and â|â with space:

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

# docs <- make_plural(docs, keep.original = FALSE, irregular = lexicon::pos_df_irregular_nouns)
# docs <- Corpus(VectorSource(docs))

#cleaning text
# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove your own stop word
# specify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("can", "even", "many","let", "like", "jose", "ago","often", "still", "upon",
                                  "may",  "shall","says", "take", "takes","will", "appendix","full","read","story", 
                                  "also","yet", "group","polit","must", "perhaps","jos","one", "am",
                                  "come", "mujica", "accounts", "annotated", "applause", "washingtonpost", "whether",
                                  "utm", "com", "ahomepage", "https", "pagina", "copyright", "eidenmuller",
                                  "ted", "fstory", "www", "news", "just", "almost" )) 
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

set.seed(1234)

wordcloud(words = d$word, freq = d$freq, min.freq = 3, randorandom.color = FALSE,
          max.words=5000, random.order=FALSE, 
          colors=brewer.pal(9, "Dark2"))

wordcloud(words = d$word, freq = d$freq, min.freq = 3,
          max.words=4000, random.order=FALSE, rot.per=0.7, 
          colors=brewer.pal(8, "Dark2")) 
# dev.off()




#top 10 words bar chart
mostc = d %>% 
  group_by(word) %>% 
  summarise(freq=sum(freq)) %>% 
  arrange(desc( freq))
mostc$word = factor(mostc$word,levels = mostc$word)

mostc[1:10,] %>% 
  ggplot(aes(x=word,y=freq,fill=word))+
  geom_bar(colour="black",stat="identity")+
  xlab("")+ylab("")+ggtitle("Top 10 words - speech 1")+
  guides(fill="none")+theme(plot.title = element_text(hjust = 0.5)) + theme_economist()


# Sentiment analysis ------------------------------------------------------
text = pdf_text("Churchill_Beaches_Speech.pdf")
text = pdf_text("George W. Bush - 911 Address to the Nation.pdf")

data = as.vector(text)
#headlines = as.vector(df_news$headline)

#extracts sentiments
sentiment = extract_sentiment_terms(data) 

#scores each sentence (0= no sentiment)
sentiment2 = sentiment(data)

#classifies sentiments between positive / negative / neutral
sentiment2$type = ifelse (sentiment2$sentiment <0, "negative", 
                          (ifelse(sentiment2$sentiment ==0,"neutral","positive")))

a=left_join(sentiment, sentiment2)

a$negative = as.character(a$negative)
a$neutral = as.character(a$neutral)
a$positive = as.character(a$positive)

# pivot_table = prop.table(table(a$type))

#bush and churchill data
chur = data.frame(prop.table(table(a$type)))
chur$author = "1 speech"
bush = data.frame(prop.table(table(a$type)))
bush$author = "2 speech"
# a = unique(a$sentence)
df = rbind(chur, bush)

df %>% 
  ggplot(aes(x=Var1,y=Freq, fill = Var1))+
  geom_bar(colour="black",stat="identity")+
  xlab("")+ylab("")+ facet_grid(.~author)+
  guides(fill="none")+theme(plot.title = element_text(hjust = 0.5)) + theme_economist()



#Polatirity analysis
docs2 = get_sentences(text)
docs2 %>%   sentiment_by(by=NULL ) %>%  highlight()


write.csv(sentiment2, "sentiment2.csv")
write.csv(a, "sentiment.csv")

# Extract sentiments (positiive or negtaive) with bing lexicon
## tidytext package: get_sentiments




# divide tweets in 2 dataframes according to positive or negative sentiment
positive = subset(a, type == 'positive')
negative = subset(a, type == 'negative')
dim(positive); dim(negative)


#### for negative tweets
#### Carry out preprocessing

corpus <- Corpus(VectorSource(positive$sentence))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeWords, stopwords('english'))
#corpus <- tm_map(corpus, stemDocument)
corpus <- tm_map(corpus, removeWords, c("can", "says","holdings", "take", "takes","will", "appendix","full","read","story", "hsbc","group","accounts")) 

myDtm <- DocumentTermMatrix(corpus)

findFreqTerms(myDtm, lowfreq=100)

sparse = removeSparseTerms(myDtm, 0.97) # keeps a matrix 97% sparse
sparse = as.data.frame(as.matrix(sparse))
colnames(sparse) = make.names(colnames(sparse))


freqWords_neg = colSums(sparse)
freqWords_neg = freqWords_neg[order(freqWords_neg, decreasing = T)]
head(freqWords_neg)

wordcloud(freq = as.vector(freqWords_neg), words = names(freqWords_neg),random.order = FALSE,
          random.color = FALSE, colors = brewer.pal(9, 'Accent')[4:9])



# Exploring book text with tidy text --------------------------------------

# install.packages("widyr")
library(janeaustenr)
library(tidytext) ##one row per line coversion
library(dplyr)
library(stringr)
library(ggplot2)
library(wordcloud)
library(reshape2)
library(igraph)
library(ggraph)
library(widyr)
library(tidyr)


#Text of news
news = data.frame("text"=as.vector(df_news$headline), 
                  "outlet"=df_news$outlet, 
                  "line_num"=1:length(df_news$headline), stringsAsFactors = F)

##token can be a singe word, co-occuring words (n-grams), paras
## one token per row

news = news %>% unnest_tokens(word,text)
#head(news)

data("stop_words")#remove the commonly occuring words

news=news %>% anti_join(stop_words,by="word")


#Most common textual words

mostc=news %>% dplyr::count(word,sort = TRUE)

mostc$word = factor(mostc$word,levels = mostc$word)

#top 10 words
ggplot(data=mostc[1:10,],aes(x=word,y=n,fill=word))+
  geom_bar(colour="black",stat="identity")+
  xlab("Common words")+ylab("N count")+ggtitle("Top 10 words")+
  guides(fill=FALSE)+theme(plot.title = element_text(hjust = 0.5))

# Extract sentiments (positiive or negtaive) with bing lexicon
## tidytext package: get_sentiments

news_senti = news %>% inner_join(get_sentiments("bing"),by="word")%>% 
  dplyr::count(outlet,  sentiment)%>% 
  spread(sentiment,n,fill=0) %>% 
  mutate(net_sentiment=positive-negative)

ggplot(news_senti, aes(outlet,net_sentiment))+
  geom_col(show.legend = FALSE) +
  geom_line(aes(y=mean(net_sentiment)),color="blue")+
  xlab("150 words")+ylab("Values")+ggtitle("Net Sentiment")
