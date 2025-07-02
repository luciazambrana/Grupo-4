
## script de lucia ##

library(rvest)
library(dplyr)
library(stringr)
library(purrr)
library(tibble)
library(tidyverse)
library(readxl)
library(tidytext)
library(stopwords)

noticias <- read_excel("~/C. de datos para Econ. y Negocios/Clases/econ-520/proyectos/proyecto final/noticias_inflacion_3_.xlsx")
View(noticias)

# pasar texto a miniscula
noticias$cuerpo <- tolower(noticias$cuerpo)
noticias$titulo <- tolower(noticias$titulo)
# Para verificar, puedes ver la primera fila
head(noticias$cuerpo, 1)
head(noticias$titulo, 1)

# '[[:punct:]]' es una clase de caracteres que busca cualquier signo de puntuación.
noticias$cuerpo <- gsub('[[:punct:]]', ' ', noticias$cuerpo)
noticias$titulo <- gsub('[[:punct:]]', ' ', noticias$titulo)

# Remover números
noticias$cuerpo <- gsub('[0-9]', ' ', noticias$cuerpo)
noticias$titulo <- gsub('[0-9]', ' ', noticias$titulo)

# Para verificar, puedes ver cómo quedó el texto
head(noticias$cuerpo, 1)
head(noticias$titulo, 1)

# Reemplazar espacios en blanco por un solo espacio
noticias$cuerpo <- gsub("\\s+", " ", noticias$cuerpo)
noticias$titulo <- gsub("\\s+", " ", noticias$titulo)

# Remover espacios en blanco al inicio y al final de cada texto
noticias$cuerpo <- trimws(noticias$cuerpo)
noticias$titulo <- trimws(noticias$titulo)

# Para verificar
head(noticias$cuerpo, 1)
head(noticias$titulo, 1)

# 1. Obtener la lista de stopwords en español
stopwords_es <- stopwords::stopwords("es", source = "snowball")

# Primero, combina el título y el cuerpo en una sola columna de texto
noticias_combinadas <- noticias %>%
  mutate(texto_completo = paste(titulo, cuerpo, sep = " "))

# Ahora, tokeniza la nueva columna
noticias_tokenizadas <- noticias_combinadas %>%
  select(medio, url, fecha, texto_completo) %>% # Selecciona las columnas que necesitas
  unnest_tokens(word, texto_completo) # Tokeniza la columna combinada

# 2. Eliminar las stopwords de tu tabla tokenizada
noticias_final <- noticias_tokenizadas %>%
  anti_join(data.frame(word = stopwords_es), by = "word")

# Para verificar, puedes ver las palabras más frecuentes después de la limpieza
# Deberías ver palabras con más significado, no artículos o preposiciones.
noticias_final %>%
  count(word, sort = TRUE) %>%
  head(20)

#eliminamos palabra "ciento" del analisis, agregar "ciento" a la lista de stopwords
stopwords_es <- c(stopwords_es,"dnda","ciento", "mil", "según", "app","redes", "dna","copyright","apn", "autor", "condicionesprivacidad", "miembro", "sa", "derechos", "reservados", "mes", "gda", "expediente", "mj", "diario", "diarios", "dirección", "prohibida", "rl", "reproducción", "secciones", "revistas", "descargá", "meses", "año", "aires", "rem", "bcra", "banco", "sigaut", "gravina", "c", "t", "camilo", "tiscornia", "consultoras", "monetario", "interanual", "mensual", "melisa", "sala", "alberto", "fernandez", "públicos", "fmi", "privados", "martín", "Martín", "guzmán", "trimestre", "trimestral", "alcohólicas", "doce", "si", "picada", "informó", "ayer", "hoy", "mañana", "mauricio", "macri", "blanco", "mate", "metropolitana", "prat", "gay", "jefe", "sergio", "massa", "cristina", "kirchner", "asesores", "gabriel", "caamaño", "consultora", "lcg", "vez", "cada", "semana") # Puedes agregar otras palabras que consideres irrelevantes

# Ahora, vuelve a ejecutar el paso de limpieza de stopwords
# Usando tu tabla tokenizada y la nueva lista de stopwords
noticias_final <- noticias_tokenizadas %>%
  anti_join(data.frame(word = stopwords_es), by = "word")

# Vuelve a verificar las palabras más frecuentes
noticias_final %>%
  count(word, sort = TRUE) %>%
  head(20)

#creacion de bigrams
# Aquí, la tabla de entrada es 'noticias_combinadas'
# Y la columna de texto a tokenizar es 'texto_completo'
bigrams_df <- noticias_combinadas %>%
  unnest_tokens(
    input = texto_completo,
    output = bigram,
    token = "ngrams",
    n = 2)

# 2. Separar el bigram en dos columnas: word1 y word2
bigrams_separados <- bigrams_df %>%
  separate(bigram, c("word1", "word2"), sep = " ")

# 3. Eliminar stopwords de ambas palabras del bigram
# 'stopwords_es' es el objeto que creaste con la lista de stopwords.
bigrams_filtrados <- bigrams_separados %>%
  filter(!word1 %in% stopwords_es) %>%
  filter(!word2 %in% stopwords_es)

# 4. Volver a unir las palabras en un bigram
bigrams_final <- bigrams_filtrados %>%
  unite(bigram, word1, word2, sep = " ")

# 5. Contar los bigrams más comunes por cada medio
# Esto te mostrará los contextos más usados en La Nación vs. Página/12
top_bigrams_medio <- bigrams_final %>%
  count(medio, bigram, sort = TRUE) %>%
  group_by(medio) %>% # <-- ESTE COMANDO ES CLAVE PARA AGRUPAR
  slice_head(n = 20) # Muestra los 20 más frecuentes para cada grupo (medio)
view(top_bigrams_medio)
# Para ver los resultados de ambos medios, simplemente imprime la tabla
top_bigrams_medio_40 <-print(top_bigrams_medio, n = 40)

## Gráfico 

library(ggplot2)
library(forcats)

# Ordeneno en una tabla por frecuencia  

top_bigrams_medio_40 <- top_bigrams_medio_40 %>%
  group_by(medio) %>%
  mutate(bigram = fct_reorder(bigram, n)) %>%
  ungroup()

view(top_bigrams_medio_40)

## CREACION DEL GRAFICO

ggplot(top_bigrams_medio_40, aes(x = bigram, y = n, fill = medio)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ medio, scales = "free_y") +
  coord_flip() +
  labs(
    title = "Frecuencia de bigramas por medio",
    x = "Bigramas",
    y = "Frecuencia"
  ) +
  theme_minimal() 

## SACO DEL EJE (x,y) los nombres, quedan feos

ggplot(top_bigrams_medio_40, aes(x = bigram, y = n, fill = medio)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ medio, scales = "free_y") +
  coord_flip() +
  labs(
    title = "Frecuencia de bigramas por medio",
    x = NULL,
    y = NULL
  ) +
  theme_minimal()

## Mismo grafico, pero tratando de usar una frecuencia relativa, grafico del tipo histograma

top_bigrams_medio_40 <- top_bigrams_medio_40 %>%
  group_by(medio) %>%
  mutate(
    frecuencia_relativa = n / sum(n),
    bigram_ordenado = fct_reorder(bigram, frecuencia_relativa)
  ) %>%
  ungroup()


ggplot(top_bigrams_medio_40, aes(x = bigram_ordenado, y = frecuencia_relativa, fill = medio)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ medio, scales = "free_y") +
  coord_flip() +
  labs(
    title = "Frecuencia de bigramas por medio",
    x = NULL,
    y = NULL
  ) +
  theme_minimal()
 



