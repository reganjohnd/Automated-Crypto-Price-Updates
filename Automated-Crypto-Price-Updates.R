library(httr)
library(data.table)
library(jsonlite)
library(readxl)
library(mailR)

### Read subscription and contact details from Excel - this could easily be
### read from a database

### data format:
## Subscription Details
#name: chr [1:7] "Regan-John Daniels"...
#$ coin_fullName: chr [1:7] "EOS" "Bitcoin" "Ripple" "Bitcoin" ...
# $ coin_symbol: chr [1:7] "EOS" "BTC" "XRP" "BTC" ...
# $ frequency: num [1:7] 1 2 2 2 1 2 1
str(subscription_details) <- read_xlsx(file.path('C:/Users/Roger/Documents', 'test.xlsx'), sheet = 1)
contact_details <- read_xlsx(file.path('C:/Users/Roger/Documents', 'test.xlsx'), sheet = 2)

### Extract list of cryptocurrency prices that need to be used
input_coins <- unique(subscription_details$coin_symbol)

### Extract list of subscribers
subscribers <- unique(subscription_details$name)

### connect to Coinbase through their API to get the cryptocurrency prices
raw.result <- lapply(paste0('https://api.coinbase.com/v2/prices/',input_coins,'-USD/buy'), GET)

### transform raw data from API call into dataframe
prices <- data.frame(data.base = NA, data.currency = NA, data.amount = NA)
subject <- 'Crypto Daily Update'
for(i in 1: length(raw.result)){
  
  prices <- rbind(prices,as.data.frame(fromJSON(rawToChar(raw.result[[i]]$content))))
  if(i == length(raw.result)) {prices <- prices[-1,]}
}

for(i in 1:length(subscribers)){
  ### get cryptocurrencies and email for respective subscriber
  subscriber_coins <- subscription_details[subscription_details$name == subscribers[i], 'coin_symbol']
  subscriber_email <- contact_details[contact_details$name == subscribers[i], 'email']
  
  ### Create body of the email 
  for(j in 1 : nrow(subscriber_coins)){
    tmp <- paste0(subscriber_coins[j, 1], ': $', prices[prices$data.base == subscriber_coins$coin_symbol[j], 'data.amount'])
    if(j == 1){body <- paste0('Good morning, ', subscribers[j], '\n\n', tmp)}
    if(j > 1) {body <- paste0(body, '\n', tmp)}
  }
  
  ### Send email to respective subscriber
  send.mail(from = "Data Squared <datasquared20@gmail.com>",
            to = paste0('<', subscriber_email, '>'), #'<reganjohndaniels@gmail.com>'
            #replyTo = c("Reply to someone else <reganjohndaniels@gmail.com>"),
            subject = subject,
            body = body,
            smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = "datasquared20@gmail.com", passwd = "ReganjohnD1", ssl = TRUE),
            authenticate = TRUE,
            send = TRUE)
}
