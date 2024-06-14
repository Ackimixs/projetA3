# ------------------------- ESPACE CODE KILLIAN -----------------------------
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

if (!require(reshape2)) {
  install.packages("reshape2")
  library(reshape2)
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
filtered_data <- filtered_data %>% 
  filter(!is.na(age_estim)) %>% 
  filter(!is.na(X) | !is.na(Y)) %>%
  filter(!is.na(clc_secteur)) %>%
  filter(!is.na(haut_tot) | !is.na(haut_tronc) | !is.na(tronc_diam)) %>%
  filter(!is.na(nomfrancais)) %>%
  filter(!is.na(fk_stadedev)) %>%
  filter(!is.na(fk_pied)) %>%
  filter(!is.na(fk_port)) %>%
  filter(!is.na(fk_situation)) %>%
  filter(!(fk_arb_etat != "en place" & age_estim == 0))

# Count the max occurence of each column
max_revetement = filtered_data %>% count(fk_revetement)
max_remarquable = filtered_data %>% count(remarquable)

# Set default value to NA
filtered_data$tronc_diam[is.na(filtered_data$tronc_diam)] <- 0

filtered_data$haut_tronc[is.na(filtered_data$haut_tronc)] <- 0

filtered_data$haut_tot[is.na(filtered_data$haut_tot)] <- filtered_data$haut_tronc

filtered_data <- filtered_data %>% filter(!(tronc_diam != 0 & haut_tronc == 0))

filtered_data$clc_quartier[is.na(filtered_data$clc_quartier)] <- "hors ville"

filtered_data$dte_abattage[is.na(filtered_data$dte_abattage)] <- 0

filtered_data$dte_plantation[is.na(filtered_data$dte_plantation)] <- 0

filtered_data$feuillage[is.na(filtered_data$feuillage)] <- "nsp"

filtered_data$fk_revetement[is.na(filtered_data$fk_revetement)] <- max_revetement[which.max(max_revetement$n), 1]

filtered_data$remarquable[is.na(filtered_data$remarquable)] <- max_remarquable[which.max(max_remarquable$n), 1]

filtered_data$clc_nbr_diag[is.na(filtered_data$clc_nbr_diag)] <- 0

filtered_data$fk_prec_estim[is.na(filtered_data$fk_prec_estim)] <- 0

filtered_data$villeca[is.na(filtered_data$villeca)] <- "casq"

filtered_data$fk_arb_etat[filtered_data$fk_arb_etat == "non essouché"] <- "abattu"
filtered_data$fk_arb_etat[filtered_data$fk_arb_etat == "essouché"] <- "supprimé"

# valeur abberante
filtered_data <- filtered_data %>% filter(!(fk_arb_etat == "en place" & dte_abattage != 0))

filtered_data <- filtered_data %>% filter(haut_tot >= haut_tronc)

filtered_data <- filtered_data %>% filter(age_estim < 300)

filtered_data <- filtered_data %>% filter(!(haut_tronc > 0 & tronc_diam == 0))

data_2 <- filtered_data %>% filter((haut_tronc == 0 & tronc_diam > 0))


data_2 <- filtered_data %>% filter(dte_plantation != 0 & !is.na(last_edited_date))

data_2 <- data_2 %>% filter(ymd_hms(data_2$dte_plantation) + years(data_2$age_estim) < ymd_hms(data_2$last_edited_date))

filtered_data <- filtered_data %>% filter(!(OBJECTID %in% data_2$OBJECTID))



count_na_data <- filtered_data %>% select(-c(created_date, created_user, commentaire_environnement, fk_nomtech, nomlatin, CreationDate, Creator, EditDate, Editor, GlobalID, id_arbre, OBJECTID,
                                             last_edited_date, last_edited_user, src_geo))

countNa(count_na_data)

data_2 <- data %>% filter(fk_arb_etat != "EN PLACE")

l = nrow(data_2)

print(nrow(filter(data_2, data_2$age_estim == 0)) / l * 100)
print(nrow(filter(data_2, data_2$dte_abattage == "")) / l * 100)
#Vecterisation----
# Recode des valeurs de fk_stadedev
filtered_data <- filtered_data %>%
  mutate(
    stade_dev_code = case_when(
      fk_stadedev %in% c("jeune", "Jeune") ~ 1,
      fk_stadedev %in% c("adulte", "Adulte") ~ 2,
      fk_stadedev == "senescent" ~ 3,
      fk_stadedev == "vieux" ~ 4,
      fk_stadedev == "non renseigné" ~ 0,
      TRUE ~ 0  # Par défaut, toutes les autres valeurs non spécifiées seront codées comme 0
    )
  )


filtered_data$quartier_id <- as.numeric(factor(filtered_data$clc_quartier))
filtered_data$secteur_id <- as.numeric(factor(filtered_data$clc_secteur))
filtered_data$etat_arbre_id <- as.numeric(factor(filtered_data$fk_arb_etat))
#filtered_data$stade_dev_id <- as.numeric(factor(filtered_data$fk_stadedev))
filtered_data$style_taille_id <- as.numeric(factor(filtered_data$fk_port))
filtered_data$etat_pied_id <- as.numeric(factor(filtered_data$fk_pied))
filtered_data$situation_id <- as.numeric(factor(filtered_data$fk_situation))
filtered_data$revetement_id <- as.numeric(factor(filtered_data$fk_revetement))
filtered_data$nom_id <- as.numeric(factor(filtered_data$nomfrancais))
filtered_data$ville_id <- as.numeric(factor(filtered_data$villeca))
filtered_data$feuille_id <- as.numeric(factor(filtered_data$feuillage))
filtered_data$remarquable_id <- as.numeric(factor(filtered_data$remarquable))


#Vide la database de tout les qualitatif(tout est censé avoir un vecteur a la place sauf unitile)----

data_no_write <- filtered_data %>% select(-c(created_date, created_user, commentaire_environnement, fk_nomtech, nomlatin, CreationDate, Creator, EditDate, Editor, GlobalID, id_arbre, 
                                             last_edited_date, last_edited_user, src_geo, clc_quartier,clc_secteur, fk_arb_etat, fk_stadedev, fk_port , fk_pied, fk_situation, fk_revetement,
                                             dte_plantation, dte_abattage, villeca ,nomfrancais, feuillage, remarquable))


#pearson univarié----

# Initialiser un dataframe vide pour stocker les coefficients de corrélation
data_pearson <- data.frame(matrix(NA, nrow = ncol(data_no_write), ncol = ncol(data_no_write)))

# Nommer les colonnes et les lignes du dataframe avec les noms des colonnes de data_no_write
for (i in 1:ncol(data_no_write)){
  colnames(data_pearson) <- names(data_no_write) 
}
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


# Créer le modèle linéaire
model <- lm(stade_dev_code ~ haut_tronc, data = data_pearson)

# Extraire les coefficients
coefficients <- coef(model)
intercept <- coefficients[1]
slope <- coefficients[2]

# Tracer le graphique avec des points remplis
plot(data_pearson$haut_tronc, data_pearson$stade_dev_code, col='blue', pch=19, main='Graphique Age vs Stade de Développement', xlab='Age estimé', ylab='Stade de développement')

# Ajouter la ligne de régression
abline(model, col='red')

# Afficher le coefficient directeur (pente) sur le graphique
text(x = min(data_pearson$haut_tronc), y = max(data_pearson$stade_dev_code), 
     labels = paste("Pente:", round(slope, 2)), pos = 4, col = 'red')

#CHI2----
# Liste des variables qualitatives
qualitative_vars <- c("clc_quartier", "fk_arb_etat", "fk_stadedev", "fk_port", "fk_pied", "fk_situation", "fk_revetement", "feuillage", "remarquable")

# Boucle pour créer des tableaux croisés, effectuer des tests du chi2 et générer des mosaicplots
for (var1 in qualitative_vars) {
  for (var2 in qualitative_vars) {
    if (var1 != var2) {
      table_croisee <- table(filtered_data[[var1]], filtered_data[[var2]])
      test_chi2 <- chisq.test(table_croisee)
      print(paste("Test chi2 pour", var1, "et", var2))
      print(test_chi2)
      mosaicplot(table_croisee, main = paste("Mosaicplot de", var1, "et", var2), 
                 shade = TRUE, 
                 legend = TRUE)
      
      # Demander à l'utilisateur d'appuyer sur Entrée pour continuer
      readline(prompt = "Appuyez sur Entrée pour passer à la paire suivante...")
    }
  }
}



#careau couleur----

# Charger les packages nécessaires
if (!require("reshape2")) install.packages("reshape2")
if (!require("ggplot2")) install.packages("ggplot2")
library(reshape2)
library(ggplot2)



# Calculer la matrice des coefficients de Pearson
data_pearson <- cor(data_no_write, method = "pearson")

# Convertir la matrice en format long
data_pearson_long <- melt(data_pearson)

# Renommer les colonnes pour plus de clarté
names(data_pearson_long) <- c("Variable1", "Variable2", "Coefficient")

# Créer la heatmap avec les couleurs correspondant aux coefficients de Pearson
pearson_plot <- ggplot(data_pearson_long, aes(x = Variable1, y = Variable2, fill = Coefficient)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0, 
                       limit = c(-1, 1), space = "Lab", 
                       name = "Coefficient\nde Pearson") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.text.y = element_text(angle = 45, hjust = 1)) +
  labs(title = "Heatmap des coefficients de Pearson",
       x = "Variables",
       y = "Variables")

# Afficher la heatmap
print(pearson_plot)
























#Age Bivariée----


n_combinations <- choose(n_cols, 2)
# Calculer le nombre de colonnes de data_no_write
n_cols <- ncol(data_no_write)

# Initialiser un dataframe vide pour stocker les coefficients de corrélation
data_age_bi <- data.frame(age_estim = rep(NA, n_combinations), stringsAsFactors = FALSE)

# Initialisation d'un compteur pour les noms de lignes
name_counter <- 1

# Initialisation d'une liste pour stocker les noms des combinaisons
combination_names <- vector("character", length = n_combinations)

# Boucle imbriquée pour parcourir les colonnes du dataframe
for (i in 1:n_cols) {
  for (j in 1:n_cols) {
    # Condition pour éviter les combinaisons répétées et les auto-combinaisons
    if (j > i) {
      # Création du nom de la combinaison
      combination_name <- paste(colnames(data_no_write)[i], colnames(data_no_write)[j], sep = " et ")
      # Ajout du nom de la combinaison à la liste
      combination_names[name_counter] <- combination_name
      # Afficher la combinaison
      cat("Combinaison", name_counter, ":", combination_name, "\n")
      # Incrémentation du compteur
      name_counter <- name_counter + 1
    }
  }
}

# Assigner les noms des combinaisons comme noms de lignes de data_age_bi
rownames(data_age_bi) <- combination_names




# Afficher le dataframe
print(data_age_bi)


p <- 0
# Boucle imbriquée pour parcourir les colonnes du dataframe
for (i in 1:n_cols) {
  for (j in 1:n_cols) {
    # Condition pour éviter les combinaisons répétées et les auto-combinaisons
    if (j > i) {
      # Vérification que les colonnes ne sont pas identiques
      if (!all(data_no_write[, i] == data_no_write[, j])) {
        # Ajustement du modèle de régression multiple
        model <- lm(data_no_write$age_estim ~ data_no_write[, i] + data_no_write[, j])
        # Résumé du modèle
        model_summary <- summary(model)
        # Extraire les p-valeurs pour chaque coefficient
        p_values <- model_summary$coefficients[, "Pr(>|t|)"]
        # Extraire les valeurs de R-squared et Adjusted R-squared
        r_squared <- model_summary$r.squared
        adjusted_r_squared <- model_summary$adj.r.squared
        
        # Affichage des résultats
        #cat("Combinaison de colonnes:", colnames(data_no_write)[i], "&", colnames(data_no_write)[j], "\n")
        #cat("P-valeurs des coefficients:\n", p_values, "\n")
        #cat("R-squared:", r_squared, "\n")
        #cat("Adjusted R-squared:", adjusted_r_squared, "\n")
        # Conditions pour imprimer l'état du modèle
        if (all(p_values < 0.05) & r_squared > 0.8 & adjusted_r_squared > 0.8) {
          cat("Bon\n")
          data_age_bi[p,1] <- "Bon"
        } else if (all(p_values < 0.1) & r_squared > 0.1 & adjusted_r_squared > 0.1) {
          cat("Moyen\n")
          data_age_bi[p,1] <- "Moyen"
        } else {
          cat("Nul\n")
          data_age_bi[p,1] <- "Nul"
        }
      } 
      else {
        cat("Les colonnes", colnames(data_no_write)[i], "et", colnames(data_no_write)[j], "sont identiques.\n")
      }
      p <- p+1
    }
  }
}
View(data_age_bi)