if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}

data <- read.csv("data.csv")

View(data)

print(class(data))

print(length(data))

data_clear <- data %>% distinct(id_arbre, clc_secteur, clc_quartier, .keep_all = TRUE)

plot(data_clear$haut_tot) #pas de valeur aberante
plot(data_clear$haut_tronc) #pas de valeur aberante
plot(data_clear$tronc_diam) #a verif
plot(data_clear$age_estim) #valeur aberante a 2000 ans objectid:11971
plot(data_clear$fk_prec_estim) #a verif 
plot(data_clear$clc_nbr_diag) #une valeur aberante


hist(data_clear$haut_tot)
hist(data_clear$haut_tronc)
hist(data_clear$tronc_diam)
hist(data_clear$age_estim)
hist(data_clear$fk_prec_estim)
hist(data_clear$clc_nbr_diag)

filtered_data <-  subset(data_clear, data_clear$OBJECTID != 11971) #on creer une nouvelle dataframe sans la valeur a 2000ans puis on reprint les plotet hist pour verifier

plot(filtered_data$age_estim) 
hist(filtered_data$age_estim)



filtered_data$quartier_id <- as.numeric(factor(filtered_data$clc_quartier))
filtered_data$secteur_id <- as.numeric(factor(filtered_data$clc_secteur))
filtered_data$etat_arbre_id <- as.numeric(factor(filtered_data$fk_arb_etat))
filtered_data$stade_dev_id <- as.numeric(factor(filtered_data$fk_stadedev))
filtered_data$style_taille_d <- as.numeric(factor(filtered_data$fk_port))
filtered_data$etat_pied_id <- as.numeric(factor(filtered_data$fk_pied))
filtered_data$dituation_id <- as.numeric(factor(filtered_data$fk_situation))
filtered_data$revetement_id <- as.numeric(factor(filtered_data$fk_revetement))
filtered_data$nom_id <- as.numeric(factor(filtered_data$nomfrancais))
filtered_data$ville_id <- as.numeric(factor(filtered_data$villeca))
filtered_data$feuille_id <- as.numeric(factor(filtered_data$feuillage))









































