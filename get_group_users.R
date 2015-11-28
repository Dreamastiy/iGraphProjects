library("RCurl") 
library("jsonlite")
library("stringr") 

# Шаблон запроса подписчиков сообщества
url <- "http://api.vk.com/method/groups.getMembers?group_id=dixyclub&fields=sex,bdate,city,country" 

# Шаблон запроса друзей аккаунта
url2 <- "http://api.vk.com/method/friends.get?user_id="

group.count <- fromJSON(resp)$response$count

get_all_users <- function(query, gc) {
     d <- data.frame()
     end <- as.integer(gc / 1000)
     for (i in 1:end){
          resp <- getURL(paste0(query, "&offset=", i * 1000))
          Sys.sleep(0.34)
          d <- rbind(d, fromJSON(resp)$response$users)          
     }
     d
}

l <- get_all_users(url, group.count)

d <- integer()
x <- 1
for (x in 1:30){
     resp <- getURL(paste0(url2, l$uid[x]))
     Sys.sleep(0.34)
     d <- c(d, intersect(fromJSON(resp)$response, l$uid))
}
