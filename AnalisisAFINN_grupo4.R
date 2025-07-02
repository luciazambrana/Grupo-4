library(rvest)
library(dplyr)
library(stringr)
library(tibble)
library(tidyverse)
library(readxl)
library(tidytext)
library(stopwords)
library(lubridate) 
library(ggplot2)   
library(tidyr)     
library(readr)

noticias <- read_excel("C:/Users/lucia/Downloads/noticias.xlsx")
View(noticias)

# pasar texto a miniscula
noticias$cuerpo <- tolower(noticias$cuerpo)
noticias$titulo <- tolower(noticias$titulo)
# Verifico
head(noticias$cuerpo, 1)
head(noticias$titulo, 1)

# '[[:punct:]]'para busca cualquier signo de puntuación.
noticias$cuerpo <- gsub('[[:punct:]]', ' ', noticias$cuerpo)
noticias$titulo <- gsub('[[:punct:]]', ' ', noticias$titulo)

# Removuevo numeros
noticias$cuerpo <- gsub('[0-9]', ' ', noticias$cuerpo)
noticias$titulo <- gsub('[0-9]', ' ', noticias$titulo)

#verifico
head(noticias$cuerpo, 1)
head(noticias$titulo, 1)

# Reemplazo espacios en blanco 
noticias$cuerpo <- gsub("\\s+", " ", noticias$cuerpo)
noticias$titulo <- gsub("\\s+", " ", noticias$titulo)

# Remuevor espacios en blanco al inicio y al final
noticias$cuerpo <- trimws(noticias$cuerpo)
noticias$titulo <- trimws(noticias$titulo)

# verifico
head(noticias$cuerpo, 1)
head(noticias$titulo, 1)

# stopwords en español
stopwords_es <- stopwords::stopwords("es", source = "snowball")

# combinamos titulo y cuerpo en una sola columna de texto
noticias_combinadas <- noticias %>%
mutate(texto_completo = paste(titulo, cuerpo, sep = " "))

# tokenizo la  columna
noticias_tokenizadas <- noticias_combinadas %>%
select(medio, url, fecha, texto_completo) %>%
unnest_tokens(word, texto_completo) 

# eliminamos las stopwords
noticias_final <- noticias_tokenizadas %>%
anti_join(data.frame(word = stopwords_es), by = "word")

#verifico
noticias_final %>%
count(word, sort = TRUE) %>%
head(20)

# aplico stopwords
stopwords_es <- c(stopwords_es,"dnda","ciento", "mil", "según", "app","redes", "dna","copyright","apn", "autor", "condicionesprivacidad", "miembro", "sa", "derechos", "reservados", "mes", "gda", "expediente", "mj", "diario", "diarios", "dirección", "prohibida", "rl", "reproducción", "secciones", "revistas", "descargá", "meses", "año", "aires", "rem", "bcra", "banco", "sigaut", "gravina", "c", "t", "camilo", "tiscornia", "consultoras", "monetario", "interanual", "mensual", "melisa", "sala", "alberto", "fernandez", "públicos", "fmi", "privados", "martín", "Martín", "guzmán", "trimestre", "trimestral", "alcohólicas", "doce", "si", "picada", "informó", "ayer", "hoy", "mañana", "mauricio", "macri", "blanco", "mate", "metropolitana", "prat", "gay", "jefe", "sergio", "massa", "cristina", "kirchner", "asesores", "gabriel", "caamaño", "consultora", "lcg", "vez", "cada", "semana") # Puedes agregar otras palabras que consideres irrelevantes

# Junto tabla tokenizada y la nueva lista de stopwords
noticias_final <- noticias_tokenizadas %>%
anti_join(data.frame(word = stopwords_es), by = "word")

# Verifico
noticias_final %>%
count(word, sort = TRUE) %>%
head(20)

#creacion de bigrams
bigrams_df <- noticias_combinadas %>%
unnest_tokens(
input = texto_completo,
output = bigram,
token = "ngrams",
    n = 2)

#Separo el bigram en dos columnas
bigrams_separados <- bigrams_df %>%
separate(bigram, c("palabra1", "palabra2"), sep = " ")

# stopwords en bigramas
bigrams_filtrados <- bigrams_separados %>%
filter(!palabra1 %in% stopwords_es) %>%
filter(!palabra2 %in% stopwords_es)

#unimos columnas
bigrams_final <- bigrams_filtrados %>%
unite(bigram, palabra1, palabra2, sep = " ")

# veo bigrams más comunes por cada medio
top_bigrams_medio <- bigrams_final %>%
count(medio, bigram, sort = TRUE) %>%
group_by(medio) %>% 
slice_head(n = 20)
print(top_bigrams_medio, n = 40)

#Extraigo año de la columna 'fecha'
# esta en formato 'YYYY-MM', ym()
noticias_año <- noticias_final %>%
mutate(fecha_formato = ym(fecha)) %>%
mutate(año = year(fecha_formato)) %>%
select(-fecha_formato)
print(unique(noticias_año$año))

#Diccionario AFINN
afinn <- read_csv("C:/Users/lucia/Downloads/afinn.csv")
View(afinn)

# cruzo palabras con el diccionario AFINN
palabras_con_afinn <- noticias_año %>%
inner_join(afinn, by = c("word" = "Palabra"))

# Aisgnamos puntuacuon con la columna 'Puntuacion'
sentimiento_total_por_año <- palabras_con_afinn %>%
group_by(medio, año) %>%
summarise(puntaje_total = sum(Puntuacion)) %>%
ungroup()

#verifico
print(sentimiento_total_por_año)

# Calculo puntaje total y normalizo por medio y año
sentimiento_normalizado_por_año <- palabras_con_afinn %>%
  group_by(medio, año) %>%
summarise(
  puntaje_total = sum(Puntuacion),
  conteo_bigramas = n(), 
  .groups = 'drop') %>%
#creamos columna nueva
mutate(puntaje_normalizado = puntaje_total / conteo_bigramas)

#verificamos
print(sentimiento_normalizado_por_año)

#grafico con ggplot
ggplot(sentimiento_normalizado_por_año, aes(x = año, y = puntaje_normalizado, color = medio, group = medio)) +
  geom_line(size = 1.2) + geom_point(size = 3) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  
scale_color_manual(
    values = c("La Nación" = "darkblue", "Pagina12" = "red")) +
labs(
    title = "Evolucion del analisis de sentimiento (AFINN)",
    x = "Año",
    y = "Puntaje de Sentimiento Normalizado", 
    color = "Medio") +
theme_minimal() +
scale_x_continuous(breaks = unique(sentimiento_normalizado_por_año$año)) +
#mayor legibilidad
theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Cargo tabla inflacion para realizar ambos graficos
inflacion_periodo16_23 <- read_excel("C:/Users/lucia/Downloads/inflacion_periodo16-23.xlsx")
View(inflacion_periodo16_23)
colnames(inflacion_periodo16_23) <- c(
  "Año", "Inflacion", "ENE", "FEB", "MAR", "ABR", "MAY", "JUN",
  "JUL", "AGO", "SEP", "OCT", "NOV", "DIC")
library(ggplot2)

# data frame con variable de gobierno
inflacion_plot <- inflacion_periodo16_23 %>%
  mutate(
    Inflacion = as.numeric(gsub(",", ".", gsub("%", "", Inflacion))),
    Año = as.numeric(Año),
    Gobierno = ifelse(Año < 2020, "Macri", "Fernández")
  ) %>%
  filter(Año >= 2016 & Año <= 2023)

#1er capa grafico de barras, inflacion
factor_transformacion <- max(inflacion_plot$Inflacion) / max(sentimiento_normalizado_por_año$puntaje_normalizado, na.rm = TRUE)
ggplot() +
geom_col(
data = inflacion_plot,
aes(x = Año, y = Inflacion / factor_transformacion, fill = Gobierno), 
alpha = 0.6,
position = position_dodge(width = 0.9)) +

# CAPA 2: Gráfico de líneas para afinn normalizado
  geom_line(
    data = sentimiento_normalizado_por_año,
    aes(x = año, y = puntaje_normalizado, color = medio, group = medio),
    size = 1.5
  ) +
  geom_point(
 data = sentimiento_normalizado_por_año,
   aes(x = año, y = puntaje_normalizado, color = medio),
   size = 4) +
  scale_fill_manual(values = c("Macri" = "gold", "Fernández" = "deepskyblue")) +
  scale_color_manual(
  values = c("La Nación" = "darkblue", "Pagina12" = "red")) +
  scale_y_continuous(name = "Puntaje AFINN (Normalizado)",
  sec.axis = sec_axis(~ . * factor_transformacion, name = "Inflación Anual (%)")) + scale_x_continuous(
   name = "Año",
  breaks = unique(inflacion_plot$Año)) +
  #títulos y tema
   labs(title = "Inflación Anual y Análisis de Sentimiento",
   color = "Medio",
   fill = "Presidencia") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),legend.position = "bottom")

