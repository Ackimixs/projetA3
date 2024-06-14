# Installation et chargement de dplyr si nécessaire

if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}

if(!require(ggplot2)){
  install.packages("tidyverse")
  library(ggplot2)
}

if (!require(lubridate)) {
  install.packages("lubridate")
  library(lubridate)
}

data <- read.csv("data.csv")

# Copy the array to compare both at the end
filtered_data <- data

# Count the number to Na for each col
countNa <- function(data) {
  has_na = FALSE
  for (i in 1:ncol(data)) {
    if (sum(is.na(data[,i])) > 0) {
      has_na = TRUE
      print(paste("Column", colnames(data)[i], "has", sum(is.na(data[,i])), "NA values"))
    }
  }
  if (!has_na) {
    print("No NA values found")
  }
}

# function to convert every value to lowercase if its character
convertToLower <- function(data) {
  for (i in 1:ncol(data)) {
    if (is.character(data[,i])) {
      data[,i] <- tolower(data[,i])
    }
  }
  return (data)
}

filtered_data <- convertToLower(filtered_data)

# Convert every empty string or space to NA
filtered_data <- replace(filtered_data, filtered_data == "", NA)
filtered_data <- replace(filtered_data, filtered_data == " ", NA)

# Remove NA value
filtered_data <- filtered_data %>% filter(!is.na(age_estim))

filtered_data <- filtered_data %>% filter(!is.na(X) | !is.na(Y))

filtered_data <- filtered_data %>% filter(!is.na(clc_secteur))

filtered_data <- filtered_data %>% filter(!is.na(haut_tot) | !is.na(haut_tronc) | !is.na(tronc_diam))

filtered_data <- filtered_data %>% filter(!is.na(nomfrancais))

filtered_data <- filtered_data %>% filter(!is.na(fk_stadedev))

filtered_data <- filtered_data %>% filter(haut_tot >= haut_tronc)

filtered_data <- filtered_data %>% filter(age_estim < 300)

filtered_data <- filtered_data %>% filter(!is.na(fk_pied))

filtered_data <- filtered_data %>% filter(!is.na(fk_port))

filtered_data <- filtered_data %>% filter(!is.na(fk_situation))

# Count the max occurence of each column
max_revetement = filtered_data %>% count(fk_revetement)
max_remarquable = filtered_data %>% count(remarquable)

# Set default value to NA
filtered_data$tronc_diam[is.na(filtered_data$tronc_diam)] <- 0

filtered_data$haut_tronc[is.na(filtered_data$haut_tronc)] <- 0

filtered_data$haut_tot[is.na(filtered_data$haut_tot)] <- filtered_data$haut_tronc

filtered_data$clc_quartier[is.na(filtered_data$clc_quartier)] <- "hors ville"

filtered_data$dte_abattage[is.na(filtered_data$dte_abattage)] <- 0

filtered_data$dte_plantation[is.na(filtered_data$dte_plantation)] <- 0

filtered_data$feuillage[is.na(filtered_data$feuillage)] <- "nsp"

filtered_data$fk_revetement[is.na(filtered_data$fk_revetement)] <- max_revetement[which.max(max_revetement$n), 1]

filtered_data$remarquable[is.na(filtered_data$remarquable)] <- max_remarquable[which.max(max_remarquable$n), 1]

filtered_data$clc_nbr_diag[is.na(filtered_data$clc_nbr_diag)] <- 0

filtered_data$fk_prec_estim[is.na(filtered_data$fk_prec_estim)] <- 0

filtered_data$villeca[is.na(filtered_data$villeca)] <- "casq"

count_na_data <- filtered_data %>% select(-c(created_date, created_user, commentaire_environnement, fk_nomtech, nomlatin, CreationDate, Creator, EditDate, Editor, GlobalID, id_arbre, OBJECTID,
                                             last_edited_date, last_edited_user, src_geo))

countNa(count_na_data)

# Recode des valeurs de fk_stadedev
filtered_data <- filtered_data %>%
  mutate(
    stade_dev_code = case_when(
      fk_stadedev == "jeune" ~ 1,
      fk_stadedev == "adulte" ~ 2,
      fk_stadedev == "senescent" ~ 3,
      fk_stadedev == "vieux" ~ 4,
    )
  )

# Histogramme pour la quantité d'arbres en fonction du quartier
hist_quartier <- ggplot(filtered_data, aes(x = clc_quartier)) +
  geom_bar(fill = "steelblue") +
  theme_minimal() +
  labs(title = "Quantité d'arbres par Quartier",
       x = "Quartier",
       y = "Nombre d'arbres")

# Afficher l'histogramme
print(hist_quartier)

# Histogramme pour la quantité d'arbres en fonction du secteur
hist_secteur <- ggplot(filtered_data, aes(x = clc_secteur)) +
  geom_bar(fill = "darkgreen") +
  theme_minimal() +
  labs(title = "Quantité d'arbres par Secteur",
       x = "Secteur",
       y = "Nombre d'arbres")

# Afficher l'histogramme
print(hist_secteur)

# Histogramme pour la quantité d'arbres en fonction de la situation (ville ou périphérie)
hist_situation <- ggplot(filtered_data, aes(x = villeca)) +
  geom_bar(fill = "darkred") +
  theme_minimal() +
  labs(title = "Quantité d'arbres en fonction de la situation",
       x = "Situation (ville ou périphérie)",
       y = "Nombre d'arbres")

# Afficher l'histogramme
print(hist_situation)

vector_data <- filtered_data

vector_data$quartier_id <- as.numeric(factor(vector_data$clc_quartier))
vector_data$secteur_id <- as.numeric(factor(vector_data$clc_secteur))
vector_data$etat_arbre_id <- as.numeric(factor(vector_data$fk_arb_etat))
vector_data$style_taille_id <- as.numeric(factor(vector_data$fk_port))
vector_data$etat_pied_id <- as.numeric(factor(vector_data$fk_pied))
vector_data$situation_id <- as.numeric(factor(vector_data$fk_situation))
vector_data$revetement_id <- as.numeric(factor(vector_data$fk_revetement))
vector_data$nom_id <- as.numeric(factor(vector_data$nomfrancais))
vector_data$ville_id <- as.numeric(factor(vector_data$villeca))
vector_data$feuille_id <- as.numeric(factor(vector_data$feuillage))
vector_data$remarquable_id <- as.numeric(factor(vector_data$remarquable))

# Vide la database de tout les qualitatif(tout est censé avoir un vecteur a la place sauf unitile)----

vector_data <- vector_data %>% select(-c(created_date, created_user, commentaire_environnement, fk_nomtech, nomlatin, CreationDate, Creator, EditDate, Editor, GlobalID, id_arbre, OBJECTID,
                                         last_edited_date, last_edited_user, src_geo, clc_quartier,clc_secteur, fk_arb_etat, fk_stadedev, fk_port , fk_pied, fk_situation, fk_revetement,
                                         dte_plantation, dte_abattage, villeca ,nomfrancais, feuillage, remarquable))

data_no_write <- vector_data

#pearson----

# Initialiser un dataframe vide pour stocker les coefficients de corrélation
data_pearson <- data.frame(matrix(NA, nrow = ncol(data_no_write), ncol = ncol(data_no_write)))

# Nommer les colonnes et les lignes du dataframe avec les noms des colonnes de data_no_write
colnames(data_pearson) <- names(data_no_write)
rownames(data_pearson) <- names(data_no_write)

for (i in 1:ncol(data_no_write)) {
  for (j in 1:ncol(data_no_write)) {
    # Calculer le coefficient de corrélation de Pearson entre les colonnes
    cor_pearson <- cor(data_no_write[, i], data_no_write[, j], method = "pearson")
    data_pearson[i, j] <- cor_pearson
    
    #if (is.na(cor_pearson)){}
    #else{
    #if (cor_pearson > 0.5){
    #if(1 > cor_pearson ){
    cat(names(data_no_write)[i], "et", names(data_no_write)[j], "->",cor_pearson, "\n")
    #}
    #}
    #else{
    #if(cor_pearson < -0.5){
    #if(-1 < cor_pearson){
    # cat(names(data_no_write)[i], "et", names(data_no_write)[j], "->",cor_pearson, "\n")
    # }
    # }
    #} 
    #}
  }
}

print(data_pearson)


write.csv(filtered_data, "filtered_data.csv")
write.csv(vector_data, "vectorised_data.csv")

#  Répartition des arbres suivant leur stade de développement ----

# Création d'un data frame avec les colonnes pertinentes
data_plot <- data_no_write %>%
  select(X, Y, stade_dev_code)

# Recoder stade_dev_code en facteur avec des labels
data_plot <- data_plot %>%
  mutate(stade_dev = factor(stade_dev_code, 
                            levels = c(1, 2, 3, 4, 0),
                            labels = c("jeune", "adulte", "senescent", "vieux", "non renseigné")))

# Création du scatter plot
ggplot(data_plot, aes(x = X, y = Y, color = stade_dev)) +
  geom_point(size = 3) +  # Vous pouvez ajuster la taille des points
  scale_color_manual(values = c("jeune" = "green", "non renseigné" = "grey", "adulte" = "orange", "senescent" = "yellow", "vieux" = "red")) +
  labs(title = "Localisation des arbres suivant leur stade de développement",
       x = "Coordonnée X",
       y = "Coordonnée Y",
       color = "Stade de développement") +
  theme_minimal()

