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

print(nrow(filtered_data))

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

filtered_data <- filtered_data %>% filter(!is.na(X) | !is.na(Y))
filtered_data <- filtered_data %>% filter(!is.na(fk_arb_etat))
filtered_data <- filtered_data %>% filter(!is.na(clc_secteur))
filtered_data <- filtered_data %>% filter(!is.na(haut_tot) | !is.na(haut_tronc) | !is.na(tronc_diam))

# Count the max occurence of each column
max_revetement = data %>% count(fk_revetement)
max_remarquable = data %>% count(remarquable)
max_fk_pied = data %>% count(fk_pied)
max_fk_port = data %>% count(fk_port)
max_fk_situation = data %>% count(fk_situation)

for (i in 1:nrow(filtered_data)) {
  # Check for ages
  # the last edit date is 2/23/2024 10:27:42 AM
  last_edit_date <- as.Date("2018-02-23")
  if (filtered_data$fk_arb_etat[i] == "en place") {
    if (!is.na(filtered_data$dte_plantation[i])) {
      if (is.na(filtered_data$age_estim[i])) {
        filtered_data$age_estim[i] <- as.numeric(last_edit_date - as.Date(filtered_data$dte_plantation[i], "%Y")) %% 365
      }
    }
    else {
      if (!is.na(filtered_data$age_estim[i])) {
        filtered_data$dte_plantation[i] <- format(as.Date(ymd(last_edit_date) - years(filtered_data$age_estim[i]), "%Y"), "%Y/%m/%d %H:%M:%S+00")
      }
    }
  }
  else {
    filtered_data$age_estim[i] <- 0
    filtered_data$dte_plantation[i] <- format(last_edit_date, "%Y/%m/%d %H:%M:%S+00")
  }
  
  # default value of villeca
  if (is.na(filtered_data$villeca[i])) {
    if (!is.na(filtered_data$clc_quartier[i])){
      filtered_data$villeca[i] <- "ville"
    }
    else {
      filtered_data$villeca[i] <- "casq"
    }
  }
}

filtered_data <- filtered_data %>% filter(!is.na(nomfrancais))

filtered_data <- filtered_data %>% filter(!is.na(fk_revetement))

filtered_data <- filtered_data %>% filter(!is.na(tronc_diam))

filtered_data <- filtered_data %>% filter(haut_tot >= haut_tronc)

filtered_data$tronc_diam[is.na(filtered_data$tronc_diam)] <- 0

filtered_data$haut_tronc[is.na(filtered_data$haut_tronc)] <- 0

filtered_data$haut_tot[is.na(filtered_data$haut_tot)] <- filtered_data$haut_tronc

filtered_data$clc_quartier[is.na(filtered_data$clc_quartier)] <- "hors ville"

filtered_data$dte_abattage[is.na(filtered_data$dte_abattage)] <- 0

filtered_data$feuillage[is.na(filtered_data$feuillage)] <- "nsp"

filtered_data$fk_pied[is.na(filtered_data$fk_pied)] <- max_fk_pied[which.max(max_fk_pied$n), 1]

filtered_data$fk_port[is.na(filtered_data$fk_port)] <- max_fk_port[which.max(max_fk_port$n), 1]

filtered_data$fk_revetement[is.na(filtered_data$fk_revetement)] <- max_revetement[which.max(max_revetement$n), 1]

filtered_data$remarquable[is.na(filtered_data$remarquable)] <- max_remarquable[which.max(max_remarquable$n), 1]

filtered_data$fk_situation[is.na(filtered_data$fk_situation)] <- max_fk_situation[which.max(max_fk_situation$n), 1]

filtered_data$clc_nbr_diag[is.na(filtered_data$clc_nbr_diag)] <- 0

filtered_data$fk_prec_estim[is.na(filtered_data$fk_prec_estim)] <- 0

# Remplissage des valeurs manquantes de fk_stadedev en fonction de age_estim
filtered_data <- filtered_data %>%
  mutate(
    fk_stadedev = case_when(
      is.na(fk_stadedev) | fk_stadedev == "" ~ case_when(
        age_estim > 100 ~ "senescent",
        age_estim >= 80 ~ "vieux",
        age_estim > 40 ~ "adulte",
        age_estim <= 40 ~ "jeune",
        TRUE ~ "non renseigné"  # Valeur par défaut si l'âge n'est pas disponible
      ),
      TRUE ~ fk_stadedev  # Conserver les valeurs existantes si elles ne sont pas manquantes
    )
  )

# Recode des valeurs de fk_stadedev
filtered_data <- filtered_data %>%
  mutate(
    stade_dev_code = case_when(
      fk_stadedev %in% c("jeune", "Jeune") ~ 1,
      fk_stadedev %in% c("adulte", "Adulte") ~ 2,
      fk_stadedev == "senescent" ~ 3,
      fk_stadedev == "vieux" ~ 4,
      is.na(fk_stadedev) | fk_stadedev == "" ~ 0,
      TRUE ~ 0  # Par défaut, toutes les autres valeurs non spécifiées seront codées comme 0
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

filtered_data$quartier_id <- as.numeric(factor(filtered_data$clc_quartier))
filtered_data$secteur_id <- as.numeric(factor(filtered_data$clc_secteur))
filtered_data$etat_arbre_id <- as.numeric(factor(filtered_data$fk_arb_etat))
filtered_data$style_taille_id <- as.numeric(factor(filtered_data$fk_port))
filtered_data$etat_pied_id <- as.numeric(factor(filtered_data$fk_pied))
filtered_data$situation_id <- as.numeric(factor(filtered_data$fk_situation))
filtered_data$revetement_id <- as.numeric(factor(filtered_data$fk_revetement))
filtered_data$nom_id <- as.numeric(factor(filtered_data$nomfrancais))
filtered_data$ville_id <- as.numeric(factor(filtered_data$villeca))
filtered_data$feuille_id <- as.numeric(factor(filtered_data$feuillage))
filtered_data$remarquable_id <- as.numeric(factor(filtered_data$remarquable))

# Vide la database de tout les qualitatif(tout est censé avoir un vecteur a la place sauf unitile)----

filtered_data <- filtered_data %>% select(-c(created_date, created_user, commentaire_environnement, fk_nomtech, nomlatin, CreationDate, Creator, EditDate, Editor, GlobalID, id_arbre, OBJECTID,
                                             last_edited_date, last_edited_user, src_geo, clc_quartier,clc_secteur, fk_arb_etat, fk_stadedev, fk_port , fk_pied, fk_situation, fk_revetement,
                                             dte_plantation, dte_abattage, villeca ,nomfrancais, feuillage, remarquable))


data_no_write <- filtered_data

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
