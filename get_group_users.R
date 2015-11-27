library("RCurl") # Библиотека для генерации запросов к API
library("jsonlite") # Библиотека для обработки JSON
library("stringr") # Библиотека для работы с текстом

# Шаблон запроса подписок аккаунта
url <- "https://api.vk.com/method/users.getSubscriptions?user_id=" 

# Шаблон запроса подписчиков аккаунта
url2 <- "https://api.vk.com/method/users.getFollowers?user_id="
