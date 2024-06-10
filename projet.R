if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}

data <- read.csv("data.csv")

View(data)

print(class(data))

print(length(data))

data_clear <- data %>% distinct(id_arbre, clc_secteur, clc_quartier, .keep_all = TRUE)
