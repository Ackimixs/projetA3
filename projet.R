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

if (!require(pROC)) {
  install.packages("pROC")
  library(pROC)
}

if (!require(caret)) {
  install.packages("caret")
  library(caret)
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

get_summary_stats <- function(x) {
  statistiques <- c(
    moyenne = mean(x, na.rm = TRUE),
    variance = var(x, na.rm = TRUE),
    ecart_type = sd(x, na.rm = TRUE),
    mediane = median(x, na.rm = TRUE),
    etendue = range(x, na.rm = TRUE),
    minimum = min(x, na.rm = TRUE),
    maximum = max(x, na.rm = TRUE),
    quartiles = quantile(x, na.rm = TRUE)
  )
  
  return(summary_stats)
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
filtered_data <- filtered_data %>% filter(!is.na(fk_pied))
filtered_data <- filtered_data %>% filter(!is.na(fk_port))
filtered_data <- filtered_data %>% filter(!is.na(fk_situation))
filtered_data <- filtered_data %>% filter(!(fk_arb_etat != "en place" & age_estim == 0))

# Set default value to NA
filtered_data$tronc_diam[is.na(filtered_data$tronc_diam)] <- 0

filtered_data$haut_tronc[is.na(filtered_data$haut_tronc)] <- 0

filtered_data$haut_tot[is.na(filtered_data$haut_tot)] <- filtered_data$haut_tronc

filtered_data$clc_quartier[is.na(filtered_data$clc_quartier)] <- "hors ville"

filtered_data$dte_abattage[is.na(filtered_data$dte_abattage)] <- 0

filtered_data$dte_plantation[is.na(filtered_data$dte_plantation)] <- 0

filtered_data$feuillage[is.na(filtered_data$feuillage)] <- "nsp"

# filtered_data$fk_revetement[is.na(filtered_data$fk_revetement)] <- max_revetement[which.max(max_revetement$n), 1]
filtered_data$fk_revetement[is.na(filtered_data$fk_revetement)] <- "non"

# filtered_data$fk_revetement[is.na(filtered_data$fk_revetement)] <- max_revetement[which.max(max_revetement$n), 1]
filtered_data$fk_revetement[is.na(filtered_data$fk_revetement)] <- "non"

filtered_data$clc_nbr_diag[is.na(filtered_data$clc_nbr_diag)] <- 0

filtered_data$fk_prec_estim[is.na(filtered_data$fk_prec_estim)] <- 0

filtered_data$villeca[is.na(filtered_data$villeca)] <- "casq"

filtered_data$fk_arb_etat[filtered_data$fk_arb_etat == "non essouché"] <- "abattu"
filtered_data$fk_arb_etat[filtered_data$fk_arb_etat == "essouché"] <- "supprimé"

# valeur abberante
filtered_data <- filtered_data %>% filter(!(fk_arb_etat == "en place" & dte_abattage != 0))

filtered_data <- filtered_data %>% filter(haut_tot >= haut_tronc)

filtered_data <- filtered_data %>% filter(age_estim < 300)

filtered_data <- filtered_data %>% filter(!(tronc_diam != 0 & haut_tronc == 0))

filtered_data <- filtered_data %>% filter(!(haut_tronc != 0 & tronc_diam == 0))


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


# Summary stats
x <- filtered_data$fk_prec_estim

statistiques <- c(
  moyenne = mean(x, na.rm = TRUE),
  variance = var(x, na.rm = TRUE),
  ecart_type = sd(x, na.rm = TRUE),
  mediane = median(x, na.rm = TRUE),
  minimum = min(x, na.rm = TRUE),
  maximum = max(x, na.rm = TRUE),
  quartiles = quantile(x, na.rm = TRUE)
)

print(statistiques)


# Variable bivarié
summary_by_quartier <- filtered_data %>%
  group_by(clc_quartier) %>%
  summarise(
    moyenne_age = mean(age_estim, na.rm = TRUE),
    variance_age = var(age_estim, na.rm = TRUE),
    ecart_type_age = sd(age_estim, na.rm = TRUE),
    mediane_age = median(age_estim, na.rm = TRUE),
    minimum_age = min(age_estim, na.rm = TRUE),
    maximum_age = max(age_estim, na.rm = TRUE),
    Q1_age = quantile(age_estim, 0.25, na.rm = TRUE),
    Q3_age = quantile(age_estim, 0.75, na.rm = TRUE)
  )

print(summary_by_quartier)

summary_by_quartier <- filtered_data %>%
  group_by(clc_quartier) %>%
  summarise(
    moyenne_ht = mean(haut_tot, na.rm = TRUE),
    variance_ht = var(haut_tot, na.rm = TRUE),
    ecart_type_ht = sd(haut_tot, na.rm = TRUE),
    mediane_ht = median(haut_tot, na.rm = TRUE),
    minimum_ht = min(haut_tot, na.rm = TRUE),
    maximum_ht = max(haut_tot, na.rm = TRUE),
    Q1_ht = quantile(haut_tot, 0.25, na.rm = TRUE),
    Q3_ht = quantile(haut_tot, 0.75, na.rm = TRUE)
  )

print(summary_by_quartier)

# Recode des valeurs de fk_stadedev
filtered_data <- filtered_data %>%
  mutate(
    stade_dev_code = case_when(
      fk_stadedev == "jeune" ~ 1,
      fk_stadedev == "adulte" ~ 2,
      fk_stadedev == "senescent" ~ 3,
      fk_stadedev == "vieux" ~ 4,
      TRUE ~ 0  # Par défaut, toutes les autres valeurs non spécifiées seront codées comme 0
    )
  )

# Recode des valeurs de fk_stadedev
filtered_data <- filtered_data %>%
  mutate(
    etat_arbre_id = case_when(
      fk_arb_etat == "en place" ~ 1,
      fk_arb_etat == "abattu" ~ 2,
      fk_arb_etat == "supprimé" ~ 3,
      fk_arb_etat == "remplacé" ~ 4,
      TRUE ~ 0
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
#vector_data$etat_arbre_id <- as.numeric(factor(vector_data$fk_arb_etat))
vector_data$style_taille_id <- as.numeric(factor(vector_data$fk_port))
vector_data$etat_pied_id <- as.numeric(factor(vector_data$fk_pied))
vector_data$situation_id <- as.numeric(factor(vector_data$fk_situation))
vector_data$revetement_id <- as.numeric(factor(vector_data$fk_revetement))
vector_data$nom_id <- as.numeric(factor(vector_data$nomfrancais))
vector_data$ville_id <- as.numeric(factor(vector_data$villeca))
vector_data$feuille_id <- as.numeric(factor(vector_data$feuillage))
vector_data$remarquable_id <- as.numeric(factor(vector_data$remarquable))
# vector_data$dte_abattage[vector_data$dte_abattage != 0] <- as.numeric(as.POSIXct(vector_data$dte_abattage[vector_data$dte_abattage != 0]))
# vector_data$dte_plantation[vector_data$dte_plantation != 0] <- as.numeric(as.POSIXct(vector_data$dte_plantation[vector_data$dte_plantation != 0]))
# vector_data$dte_abattage <- as.numeric(vector_data$dte_abattage)
# vector_data$dte_plantation <- as.numeric(vector_data$dte_plantation)

# Vide la database de tout les qualitatif(tout est censé avoir un vecteur a la place sauf unitile)----

vector_data <- vector_data %>% select(-c(created_date, created_user, commentaire_environnement, fk_nomtech, nomlatin, CreationDate, Creator, EditDate, Editor, GlobalID, id_arbre,
                                             last_edited_date, last_edited_user, src_geo, clc_quartier,clc_secteur, fk_arb_etat, fk_stadedev, fk_port , fk_pied, fk_situation, fk_revetement,
                                             villeca ,nomfrancais, feuillage, remarquable, dte_plantation, dte_abattage))

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



# Regression ---
# Split 80 - 20 train / test

train_set <- vector_data[1:round(0.8 * nrow(vector_data)),]
test_set <- vector_data[(round(0.8 * nrow(vector_data)) + 1):nrow(vector_data),]

# Predict age from haut_tronc and tronc_diam
lm_1 <- lm(age_estim ~ haut_tronc + tronc_diam + haut_tot + quartier_id + secteur_id, data = train_set)

# Print summary of linear model
print(summary(lm_1))

# Predict on test set using linear model
pred_lm <- predict(lm_1, test_set)

# Create a data frame for plotting
lm_data <- data.frame(actual = test_set$age_estim, predicted = pred_lm)

# Plot actual vs. predicted values
ggplot(lm_data, aes(x = actual, y = predicted)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, color = "red") +
  labs(title = "Linear Model: Actual vs Predicted", x = "Actual Values", y = "Predicted Values") +
  theme_minimal()

# Calculate and print the mean squared error for linear model
mse_lm <- mean(sqrt((test_set$age_estim - pred_lm)^2))
print(paste("Root Mean Squared Error (Linear Model):", mse_lm))

# Calculate and print the coefficient of determination R^2 for linear model
rss_lm <- sum((test_set$age_estim - pred_lm)^2)
tss_lm <- sum((test_set$age_estim - mean(test_set$age_estim))^2)
r2_lm <- 1 - rss_lm/tss_lm
print(paste("R-squared (Linear Model):", r2_lm))

aba_set <- vector_data

aba_set$etat_arbre_id[aba_set$etat_arbre_id == 1] <- 0

aba_set$etat_arbre_id[aba_set$etat_arbre_id != 0] <- 1

# Generalized Linear Model
glm_1 <- glm(etat_arbre_id ~ age_estim + tronc_diam + haut_tot + haut_tronc + clc_nbr_diag + stade_dev_code + quartier_id + secteur_id + stade_dev_code + style_taille_id + etat_pied_id + situation_id + revetement_id, data = aba_set, family = binomial)
# glm_1 <- glm(etat_arbre_id ~ age_estim + tronc_diam, data = aba_set, family = binomial)

# Print summary of generalized linear model
print(summary(glm_1))

# Predict on the dataset using generalized linear model
pred_glm <- predict(glm_1, aba_set, type = "response")

# Convert predictions to binary (0 or 1) based on a threshold of 0.5
pred_glm_class <- ifelse(pred_glm > 0.5, 1, 0)

# Actual values
actual <- aba_set$etat_arbre_id

# Confusion matrix calculation
TP <- sum(pred_glm_class == 1 & actual == 1) # True Positives
TN <- sum(pred_glm_class == 0 & actual == 0) # True Negatives
FP <- sum(pred_glm_class == 1 & actual == 0) # False Positives
FN <- sum(pred_glm_class == 0 & actual == 1) # False Negatives

# Print confusion matrix
conf_matrix <- matrix(c(TP, FP, FN, TN), nrow = 2, byrow = TRUE,
                      dimnames = list('Predicted' = c('Positive', 'Negative'),
                                      'Actual' = c('Positive', 'Negative')))

print("Confusion Matrix:")
print(conf_matrix)

# Optionally, you can calculate and print accuracy, precision, recall, and F1 score
accuracy <- (TP + TN) / (TP + TN + FP + FN)
precision <- TP / (TP + FP)
recall <- TP / (TP + FN)
f1_score <- 2 * precision * recall / (precision + recall)

cat("Accuracy:", accuracy, "\n")
cat("Precision:", precision, "\n")
cat("Recall:", recall, "\n")
cat("F1 Score:", f1_score, "\n")


# View(data_pearson)

# Convertir la matrice en format long
data_pearson_long <- melt(data_pearson)

# Vérifier les noms des colonnes après melt
str(data_pearson_long)

# Vérifier les colonnes et renommer si nécessaire
names(data_pearson_long) <- c("Variable1", "Variable2", "Coefficient")

# Créer la mosaïque avec les couleurs correspondant aux coefficients de Pearson
pearson_plot <- ggplot(data_pearson_long, aes(x = Variable1, y = Variable2, fill = Coefficient)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0, 
                       limit = c(-1, 1), space = "Lab", 
                       name = "Coefficient\nde Pearson") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Mosaïque des coefficients de Pearson",
       x = "Variables",
       y = "Variables")

# Afficher la mosaïque
print(pearson_plot)



# Carte des arbres remarquables et non remarquables ----

# Assurez-vous que 'remarquable_id' est correctement codé en binaire (0 pour non remarquable, 1 pour remarquable)
data_no_write <- data_no_write %>%
  mutate(remarquable_id = as.factor(remarquable_id))

# Créer une carte avec les arbres colorés en fonction de leur caractère remarquable
map_plot <- ggplot(data_no_write, aes(x = X, y = Y)) +
  geom_point(aes(color = remarquable_id), size = 2) +
  scale_color_manual(values = c("1" = "grey", "2" = "blue"), 
                     labels = c("Non remarquable", "Remarquable"), 
                     name = "Type d'arbre") +
  theme_minimal() +
  labs(title = "Carte des arbres remarquables et non remarquables",
       x = "Position géographique X",
       y = "Position géographique Y")

# Afficher la carte
print(map_plot)


write.csv(filtered_data, "filtered_data.csv")
write.csv(vector_data, "vectorised_data.csv")
write.csv(data_pearson, "data_pearson.csv")

# Liste des variables qualitatives
qualitative_vars <- c("clc_quartier", "clc_secteur", "fk_arb_etat", "fk_stadedev", "fk_port", "fk_pied", "fk_situation", "fk_revetement", "feuillage", "remarquable")

# Boucle pour créer des tableaux croisés, effectuer des tests du chi2 et générer des mosaicplots
for (var1 in qualitative_vars) {
  for (var2 in qualitative_vars) {
    if (var1 != var2) {
      table_croisee <- table(data[[var1]], data[[var2]])
      test_chi2 <- chisq.test(table_croisee)
      print(paste("Test chi2 pour", var1, "et", var2))
      print(test_chi2)
      mosaicplot(table_croisee, main = paste("Mosaicplot de", var1, "et", var2), shade = TRUE, legend = TRUE)
      
      # Demander à l'utilisateur d'appuyer sur Entrée pour continuer
      readline(prompt = "Appuyez sur Entrée pour passer à la paire suivante...")
    }
  }
}

