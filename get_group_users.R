library("RCurl") 
library("jsonlite")
library("stringr") 
library("igraph")

# Шаблон запроса подписчиков сообщества
url <- "http://api.vk.com/method/groups.getMembers?group_id=dixyclub&fields=sex,bdate,city,country" 

# Шаблон запроса друзей аккаунта
url2 <- "http://api.vk.com/method/friends.get?user_id="

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

group.count <- fromJSON(getURL(url))$response$count

l <- get_all_users(url, group.count)

l.sub <- as.numeric(na.omit(l$uid[sample(group.count, 100)]))

d <- data.frame(Person1 = integer(), Person2 = integer() )
x <- 1
for (x in 1:length(l.sub)){
     resp <- getURL(paste0(url2, l.sub[x]))
     Sys.sleep(0.34)
     resp.both <- intersect(fromJSON(resp)$response, l$uid) #l.sub
     d <- rbind(d,     
                cbind(rep(l.sub[x],
                          length(resp.both)),
                      resp.both)
                )     
}


names(d) <- c('uid', 'uid2')

d_uid <- data.frame(uid = unique(c(d$uid, d$uid2)))
d_names <- l[, c('uid' ,'first_name', 'last_name')]
test <- merge(d_uid, d_names, by = 'uid', all.x = T, sort = F)
test$fullname <- paste0(test$first_name, "_", test$last_name)

vk.network <- graph.data.frame(d, 
                               directed = T)
vk.for.names <- vk.network

names <- as.numeric(V(vk.for.names)$name)
names <- data.frame(uid = names)
names.graph <- merge(d_uid, test, by = 'uid', all.x = T, sort = F)

V(vk.for.names)$name == test$uid

E(vk.network)$color <- hsv(0,0,0,alpha = 0.2)
E(vk.network)$width <- 1
E(vk.network)$arrow.size <- 0.1
V(vk.network)$size <- 3
V(vk.network)$color <- 'pink'
V(vk.network)$name <- test$fullname # names.graph$fullname
# t <- layout.kamada.kawai(vk.network)
t <- layout.fruchterman.reingold(vk.network)
plot(vk.network, 
     edge.curved = T,
     layout = t)
