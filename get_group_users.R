library("RCurl") # Библиотека для генерации запросов к API
library("jsonlite") # Библиотека для обработки JSON
library("stringr") # Библиотека для работы с текстом

# Шаблон запроса подписчиков сообщества
url <- "http://api.vk.com/method/groups.getMembers?group_id=dixyclub&fields=sex,bdate,city,country" 

# Шаблон запроса подписчиков аккаунта
url2 <- "https://api.vk.com/method/users.getFollowers?user_id="

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


