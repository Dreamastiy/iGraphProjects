library("RCurl") 
library("jsonlite")
library("stringr") 
library("igraph")

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

l.sub <- as.numeric(na.omit(l$uid[sample(group.count, 100)]))


d <- data.frame(Person1 = integer(), Person2 = integer() )
x <- 1
for (x in 1:length(l.sub)){
     resp <- getURL(paste0(url2, l.sub[x]))
     Sys.sleep(0.34)
     resp.both <- intersect(fromJSON(resp)$response, l$uid) #l.sub
     d <- rbind(d,     
                cbind(rep(l$uid[x],
                          length(resp.both)),
                      resp.both)
                )     
}

vk.network <- graph.data.frame(d, 
                               directed = T)

E(vk.network)$color <- 'black'
E(vk.network)$width <- 1
V(vk.network)$size <- 5
V(vk.network)$color <- 'red'
t <- layout.kamada.kawai(vk.network)
plot(vk.network, 
     edge.curved = T),
     layout = t)


